const hre = require("hardhat");

async function main() {

    const [deployer] = await hre.ethers.getSigners();
    console.log("Deploying contracts with the account:", deployer.address);

    // const balance = await deployer.getBalance();
    // console.log(`Deployer balance: ${hre.ethers.utils.formatEther(balance)} ETH`);

    // Constants
    // const aaveLoanPoolAddress = "0xa97AB312Ae36614016DC648ECF478Eaea3588d06";
    // const aaveLoanPoolAddress = "0xc4dCB5126a3AfEd129BC3668Ea19285A9f56D15D";
    const aaveLoanPoolAddress = "0x0496275d34753a48320ca58103d5220d394ff77f";

    try {
        // Compile the contracts
        console.log(`Compiling contract...`);
        await hre.run('compile');

        // Deploy the contract
        console.log(`Deploying contract...`);
        const contractFactory = await hre.ethers.getContractFactory("BasicFlashLoan");
        const myContract = await contractFactory.deploy(aaveLoanPoolAddress, { gasLimit: 5000000 });

        // console.log(myContract); // Check if this is a contract instance

        await myContract.deployed();
        console.log(`Contract deployed to: ${myContract.address}`);

    } catch (error) {
        console.error("Deployment failed:", error);
    }
}

// Handle async errors
main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
});

