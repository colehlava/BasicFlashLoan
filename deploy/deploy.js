module.exports = async ({ getNamedAccounts, deployments }) => {
    const { deploy } = deployments;
    const { deployer } = await getNamedAccounts();

    console.log("Deployer address:", deployer);

    // Aave PoolAddressesProvider for Sepolia
    // const poolAddressesProvider = "0x0496275d34753a48320ca58103d5220d394ff77f";
    const poolAddressesProvider = "0x012bAC54348C0E635dCAc9D5FB99f06F24136C9A";

    // Deploy BasicFlashLoan
    const deployment = await deploy("BasicFlashLoan", {
        from: deployer,
        args: [poolAddressesProvider], // Constructor argument
        log: true, // Log the deployment details
    });

    console.log(`BasicFlashLoan deployed at: ${deployment.address}`);
};

