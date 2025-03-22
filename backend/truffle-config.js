require('dotenv').config();
const HDWalletProvider = require('@truffle/hdwallet-provider');

// Récupération des variables d'environnement
const privateKey = process.env.PRIVATE_KEY;
const alchemyApiKey = process.env.ALCHEMY_API_KEY;

// Vérifier si la clé privée est définie
if (!privateKey) {
  throw new Error("⚠️  La clé privée n'est pas définie dans le fichier .env !");
}

// Vérifier si l'API Key Alchemy est définie
if (!alchemyApiKey) {
  throw new Error("⚠️  La clé API Alchemy n'est pas définie dans le fichier .env !");
}

module.exports = {
  networks: {
    development: {
      host: "127.0.0.1", // Localhost
      port: 7545, // Port par défaut de Ganache
      network_id: "*", // Accepte tous les réseaux
    },

    // 🔹 Sepolia Configuration avec Alchemy
    sepolia: {
      provider: () => new HDWalletProvider(
        privateKey, // Clé privée unique
        `https://eth-sepolia.g.alchemy.com/v2/${alchemyApiKey}` // Alchemy
      ),
      network_id: 11155111, // ID de Sepolia
      gas: 5500000,     
      confirmations: 2,    
      timeoutBlocks: 200, 
      skipDryRun: true
    },
  },

  mocha: {
    timeout: 100000
  },

  compilers: {
    solc: {
      version: "0.8.21", // Solidity 0.8.21 (dernière version stable)
      settings: {          
        optimizer: {
          enabled: true, // Optimisation activée pour réduire les frais de gas
          runs: 200
        },
      }
    },
  },
};
