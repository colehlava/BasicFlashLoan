require("hardhat-deploy");
require("@nomicfoundation/hardhat-toolbox");
require("@nomicfoundation/hardhat-ethers");
require("dotenv").config();

/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
    solidity: "0.8.28",
    networks: {
        local: {
            url: process.env.LOCAL_ENDPOINT,
            accounts: [process.env.LOCAL_PRIVATE_KEY],
        },
        sepolia: {
            url: process.env.ENDPOINT,
            accounts: [process.env.PRIVATE_KEY],
        },
    },
    namedAccounts: {
        deployer: {
            default: 0,
        },
    },
};
