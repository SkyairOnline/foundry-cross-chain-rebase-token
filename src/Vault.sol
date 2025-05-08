// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {IRebaseToken} from "./interfaces/IRebaseToken.sol";

contract Vault {
    // we need to pass the token address to the constructor
    // create a deposit function that mints tokens to the user equals to the emount of ETH
    // create a redeem function that burns tokens from the user and the user ETH 
    // create a way to add rewards to the vault
    IRebaseToken private immutable i_rebaseToken;

    error Vault__RedeemFailed();

    event Deposit(address indexed user, uint256 amount);
    event Redeem(address indexed user, uint256 amount);

    constructor(IRebaseToken _rebaseToken) {
        i_rebaseToken = _rebaseToken;
    }

    receive() external payable {}

    /**
     * @notice Allows users to deposit ETH into the vault and mint RebaseTokens in return
     */
    function deposit() external payable {
        // we need to use the amiunt of ETH the user has sent to mint tokens to the user
        i_rebaseToken.mint(msg.sender, msg.value);
        emit Deposit(msg.sender, msg.value);
    }

    /**
     * @notice Allows users to redeem their RebaseTokens for ETH
     * @param _amount The amount of RebaseTokens to redeem
     */
    function redeem(uint256 _amount) external {
        // we need to burn the tokens from the user and send them ETH
        i_rebaseToken.burn(msg.sender, _amount);
        (bool success,) =payable(msg.sender).call{value: _amount}("");
        if (!success) {
            revert Vault__RedeemFailed();
        }
        emit Redeem(msg.sender, _amount);
    }

    function getRebaseTokenAddress() external view returns (address) {
        return address(i_rebaseToken);
    }
}