const { ethers } = require("ethers");
const wallet = ethers.Wallet.createRandom();
console.log("Private Key:", wallet.privateKey);
