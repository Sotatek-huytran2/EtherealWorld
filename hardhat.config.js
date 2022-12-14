require("@nomicfoundation/hardhat-toolbox");
require('@openzeppelin/hardhat-upgrades');
// require("@nomiclabs/hardhat-waffle");
require("@nomiclabs/hardhat-ethers");
require("@nomiclabs/hardhat-etherscan");
// require("@nomiclabs/hardhat-truffle5");
require("hardhat-abi-exporter");
require("hardhat-contract-sizer");

require("dotenv").config();

require("dotenv").config();
require('solidity-coverage');

/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  contractSizer: {
    alphaSort: true,
    runOnCompile: true,
    disambiguatePaths: false,
  },
  solidity: {
    version: "0.8.9",
    settings: {
      optimizer: {
        enabled: true,
        runs: 100,
      },
    },
  },
  networks: {
    testnet: {
      url: "https://data-seed-prebsc-2-s1.binance.org:8545/",
      accounts: [process.env.PRIVATE_KEY],
    },
    bsc_mainnet: {
      url: "https://bsc-dataseed.binance.org/",
      chainId: 56,
      accounts: [process.env.PRIVATE_KEY],
    },
    mumbai: {
      url: `https://speedy-nodes-nyc.moralis.io/95b315e4271ce6f77d201815/polygon/mumbai/`,
      //url: `https://polygon-mumbai.g.alchemy.com/v2/zQw1WUC-FZSIsL1zGs9kYeGIbq7WJcET/`,
      chainId: 80001,
      accounts: [process.env.PRIVATE_KEY],
    },
    rinkeby: {
      url: `https://rinkeby.infura.io/v3/${process.env.RINKEBY_INFURA_KEY}`,
      chainId: 4,
      accounts: [process.env.PRIVATE_KEY],
    }
  },
  etherscan: {
    apiKey: process.env.ETHEREUM_API_KEY,
  },
};


// EtherealWorlds: 0x2fC08690B969c98326FC7D5a9dDbd71592cf0079
// SpecialEtherealWorlds: 0x01baA1Aa0E8257C4D24F1BfF604464a24393BA7E
// EtherealFragments: 0x73E8Dc0c5e5FBDb6D98c3A4Ed849bf217CEAA47F