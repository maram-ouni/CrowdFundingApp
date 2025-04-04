const Tx        =   require('ethereumjs-tx').Transaction;
const {Web3  }    =   require('web3');
const moment    =   require('moment-timezone');
const CryptoJS  = require("crypto-js");
const axios     = require("axios");
const nodemailer = require('nodemailer');

const CampModel         = require("../../models/campDetailsModel");
const UserDetailsModel  = require("../../models/userDetailsModel");

const { validationResult } = require("express-validator");
require('dotenv').config();


///////////////////////////
//Web3 and contract setup
///////////////////////////
const alchemyApiKey = process.env.ALCHEMY_API_KEY;


const rpcURL = `https://eth-sepolia.g.alchemy.com/v2/${alchemyApiKey}`;

const web3 = new Web3(rpcURL);

const CTVToken = require('../../build/contracts/CollectiveToken.json');

const ctv_contract_address = process.env.ctv_contract_address;

const ctvabi = CTVToken.abi;

const ctv_contract = new web3.eth.Contract(ctvabi,ctv_contract_address);

////////////////////////////////////
// Account addresses & Private keys
////////////////////////////////////

//Main account with which contract is deployed

const account_address_1 = process.env.account_1;

// Main private key - token generation
const crypto = require('crypto');

// Générer une paire de clés RSA
const { privateKey, publicKey } = crypto.generateKeyPairSync('rsa', {
    modulusLength: 2048,
});

// Exporter les clés au format PEM
const privateKeyPem = privateKey.export({ type: 'pkcs1', format: 'pem' });
const publicKeyPem = publicKey.export({ type: 'pkcs1', format: 'pem' });

console.log('Private Key:', privateKeyPem);
console.log('Public Key:', publicKeyPem);

// Si vous voulez convertir la clé privée en Buffer
const privateKey1 = Buffer.from(privateKeyPem, 'utf-8'); // Utilisez 'utf-8' pour convertir une chaîne de caractères en Buffer
console.log('Private Key as Buffer:', privateKey1);

// const privateKey1 = Buffer.from(process.env.privateKey_1,'hex');


const getUserDetails = async (req,res)=>{
    try{
      
      const userData = await UserDetailsModel.find({username:req.decoded.username});
      if(userData.length>0){
        res.status(200).json({
          msg:"User is a valid registered Collective user",
          result:true,
          userData:userData[0],
          userAuthData:req.decoded
        })
      }
      else{
        res.status(404).json({
          error:"User doesn't exist",
          result:false
        })
      }
    }catch(err){
      return res.status(500).json({
        msg:"Failed to fetch user data.",
        result:false,
        err
      });
    }
}


const withdrawAmount = async (req,res)=>{
    try{

        //Input field validation
        const errors = validationResult(req);
        if (!errors.isEmpty()) {
            return res.status(422).json({
                error: errors.array()[0],result:false   
            });
        }

        const owner_address     =   req.body.owner_address;
        const camp_private_key =   req.body.owner_private_key;
        const transfer_address  =   req.decoded.eth_address;
        const amount            =   req.body.amount;


        let bytes  = CryptoJS.AES.decrypt(camp_private_key, process.env.master_key);
        let bytes_key = bytes.toString(CryptoJS.enc.Utf8).slice(2);
        let owner_private_key = Buffer.from(bytes_key,'hex');
        const estGasPrice = await web3.eth.getGasPrice()*2;

        res.status(200).json({
          msg:"Amount withdrawal in-progress",
          result:true,
        });

        ///////////////////////////////////////////////////////////////
        // Transferring ETH(gas) required for the transaction to owner 
        ///////////////////////////////////////////////////////////////

        const txCount = await web3.eth.getTransactionCount(account_address_1);
        if(!txCount){
            return res.status(500).json({
                result:false,
                msg:'There was a problem transferring ETH - gas for the transaction'
            })
        }

        // Build the transaction
        const txObject1 = {
            nonce:    web3.utils.toHex(txCount),
            to:       owner_address,
            value:    web3.utils.toHex(web3.utils.toWei('100000000', 'gwei')),
            gasLimit: web3.utils.toHex(500000),
            gasPrice: web3.utils.toHex(estGasPrice),
        }
    
        // Sign the transaction
        const tx1 = new Tx(txObject1,{chain:3})
        tx1.sign(privateKey1)
    
        const serializedTx1 = tx1.serialize()
        const raw1 = '0x' + serializedTx1.toString('hex')
    
        // Broadcast the transaction
        const sendTransaction = await web3.eth.sendSignedTransaction(raw1);
        if(!sendTransaction){
            return res.status(500).json({
                result:false,
                msg:'There was a problem transferring ETH - gas for the transaction'
            })
        }
        console.log('\nETH transfered for the transaction');



        //////////////////////////////////////////////////////////////
        // Getting approval for the transaction
        //////////////////////////////////////////////////////////////
    
        const ownertxCount = await web3.eth.getTransactionCount(owner_address);
        console.log("Approval txCount : "+ownertxCount);

        // Build the transaction
        const txObject2 = {
        nonce:    web3.utils.toHex(ownertxCount),
        to:       ctv_contract_address,
        gasLimit: web3.utils.toHex(50000),
        gasPrice: web3.utils.toHex(estGasPrice),
        data: ctv_contract.methods.increaseAllowance(owner_address,amount).encodeABI()
        }
    
        // Sign the transaction
        const tx2 = new Tx(txObject2,{chain:3})
        tx2.sign(owner_private_key)
    
        const serializedTx2 = tx2.serialize()
        const raw2 = '0x' + serializedTx2.toString('hex')
    
        // Broadcast the transaction
        const approvalHash = await web3.eth.sendSignedTransaction(raw2);

        if(!approvalHash){
            return res.status(500).json({
                result:false,
                msg:'There was a problem getting approval for transaction'
            })
        }
        
        console.log("\nTransfer approved");



        /////////////////////////////////
        // Transfering CTV between users
        /////////////////////////////////


        const ownertxCountUpdated = await  web3.eth.getTransactionCount(owner_address);
        console.log("Transfer txCount : "+ownertxCountUpdated);

     
        // Build the transaction
        const txObject3 = {  
            nonce:    web3.utils.toHex(ownertxCountUpdated),
            to:       ctv_contract_address,
            gasLimit: web3.utils.toHex(100000),
            gasPrice: web3.utils.toHex(estGasPrice),
            data: ctv_contract.methods.transferFrom(owner_address,transfer_address,amount).encodeABI()
        }

        
        // Sign the transaction2
        const tx3 = new Tx(txObject3,{chain:3})
        tx3.sign(owner_private_key)
        
        const serializedTx3 = tx3.serialize()
        const raw3 = '0x' + serializedTx3.toString('hex')
        
        // Broadcast the transaction
        const finalTransactionHash = await web3.eth.sendSignedTransaction(raw3);
        if(!finalTransactionHash){
            return res.status(500).json({
                result:false,
                msg:'There was a problem transferring CTV between users.'
            })
        }

        console.log(`\nCTV transfered between accounts : ${amount} CTV`);
        
        const userData = await CampModel.findOneAndUpdate({address:owner_address},{amountWithdrawn:true});
        if(userData){
          console.log("Amount withdrawal successful");
        }
        else{
          console.log("Camp doesnt exits!");
        }

      

    }catch(err){
      console.log(err);
      return res.status(500).json({
        msg:"Failed to withdraw amount!",
        result:false,
      });
    }
}


// Support/Help email API

const transporter = nodemailer.createTransport({
    service: 'gmail',
    auth: {
      user: process.env.email_id,
      pass: process.env.email_password
    },
    tls: {
      rejectUnauthorized: false
    }
});


const supportEmail = async(req,res)=>{
    try{
        //Input field validation
        const errors = validationResult(req);
        if (!errors.isEmpty()) {
            return res.status(422).json({
                error: errors.array()[0],result:false   
            });
        }

        let { email_subject,email_message } = req.body;
        let email_sender = req.decoded.email;

        // Using nodemailer to send support email

        const mailOptions = {
          from: email_sender,
          to: 'collectivecfplatform@gmail.com',
          subject: email_sender+" - "+email_subject,
          text: email_sender+" - "+email_message
        };
        
        transporter.sendMail(mailOptions, function(error, info){
          if (error) {
            console.log(error);
            return res.status(500).json({
              msg:"There was a problem sending the email",
              result:false,
              error
            });
          } else {
            return res.status(200).json({
              msg:"Email sent, please wait for the response from our support team",
              result:true
            })
          }
        });

    }
    catch(err){
      console.log(err);
      return res.status(500).json({
        msg:"There was an error sending a message to our team, Please try again.",
        result:false,
      });
    }
}


module.exports = {
    getUserDetails,
    withdrawAmount,
    supportEmail
}