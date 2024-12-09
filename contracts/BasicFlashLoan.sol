// SPDX-License-Identifier: MIT

pragma solidity ^0.8.17;

// import {IFlashLoanSimpleReceiver} from "@aave/core-v3/contracts/flashloan/interfaces/IFlashLoanSimpleReceiver.sol";
import {FlashLoanSimpleReceiverBase} from "@aave/core-v3/contracts/flashloan/base/FlashLoanSimpleReceiverBase.sol";
// import {IPool} from "@aave/core-v3/contracts/interfaces/IPool.sol";
import {IPoolAddressesProvider} from "@aave/core-v3/contracts/interfaces/IPoolAddressesProvider.sol";
// import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {IERC20} from "@aave/core-v3/contracts/dependencies/openzeppelin/contracts/IERC20.sol";

// contract BasicFlashLoan is IFlashLoanSimpleReceiver {
contract BasicFlashLoan is FlashLoanSimpleReceiverBase {

    // Address of the Aave V3 Pool contract
    // address public immutable POOL;

    address public owner;

    constructor(address _pool)
        FlashLoanSimpleReceiverBase(IPoolAddressesProvider(_pool))
    {
        // POOL = _pool;
        owner = msg.sender;
    }

    receive() external payable {}

    /**
     * @dev Main function to initiate a flash loan.
     * @param asset The address of the underlying asset you want to flash borrow.
     * @param amount The amount of the asset to borrow.
     */
    function executeFlashLoan(address asset, uint256 amount) external {
        require(msg.sender == owner, "Caller is not owner");

        // Params can be used to pass arbitrary data to executeOperation
        bytes memory params = ""; 

        // The referralCode is a parameter used by the Aave ecosystem.
        // For most integrators, it can be set to 0.
        uint16 referralCode = 0;

        // Initiate the flash loan
        // IPool(POOL).flashLoanSimple(
        POOL.flashLoanSimple(
            address(this),  // receiverAddress
            asset,          // asset to borrow
            amount,         // amount to borrow
            params,         // arbitrary params
            referralCode    // referral code
        );
    }

    /**
     * @dev This is the callback function Aave calls after transferring the flash borrowed amount.
     *      Perform your operations here and then repay the loan + premium.
     *
     * @param asset The address of the underlying asset being flash-borrowed.
     * @param amount The amount of asset borrowed.
     * @param premium The fee for the flash loan.
     * @param initiator The address that initiated the flash loan (should be this contract).
     * @param params Arbitrary parameters passed from the flash loan initiation.
     */
    function executeOperation(
        address asset,
        uint256 amount,
        uint256 premium,
        address initiator,
        bytes calldata params
    ) external override returns (bool) {
        // require(msg.sender == POOL, "Caller must be the Aave Pool");
        require(msg.sender == address(POOL), "Caller must be the Aave Pool");
        require(initiator == address(this), "Initiator must be this contract");

        // -------------------------------------------
        // CUSTOM LOGIC GOES HERE
        // -------------------------------------------

        // After operations, repay the flash loan + premium
        uint256 amountOwing = amount + premium;
        // IERC20(asset).approve(POOL, amountOwing);
        IERC20(asset).approve(address(POOL), amountOwing);

        return true;
    }

    /**
     * @dev Helper function to withdraw tokens from this contract back to the owner.
     *      Only the owner can withdraw tokens.
     */
    function withdrawToken(address token, uint256 amount) external {
        require(msg.sender == owner, "Caller is not owner");
        IERC20(token).transfer(owner, amount);
    }
}

