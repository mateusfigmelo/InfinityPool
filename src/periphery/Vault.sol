// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.20;

import {Context} from "@openzeppelin/contracts/utils/Context.sol";
import {Address} from "@openzeppelin/contracts/utils/Address.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {IPermit2} from "src/periphery/interfaces/external/IPermit2.sol";
import {Multicall} from "src/periphery/base/Multicall.sol";
import {PeripheryStorage} from "./base/PeripheryStorage.sol";
import {SafeERC20} from "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";

contract Vault is Multicall, PeripheryStorage {
    using Address for address;
    using Address for address payable;

    event Deposit(address indexed token, address indexed to, uint256 amount);
    event Withdraw(address indexed token, address indexed from, uint256 amount);
    event DepositCollateral(address indexed user, address indexed token0, address indexed token1, bool token, uint256 amount);
    event WithdrawCollateral(address indexed user, address indexed token0, address indexed token1, bool token, uint256 amount);

    error NonExistentToken();
    error VaultERC20InsufficientAllowance(address token, address owner, address spender, uint256 allowance, uint256 needed);
    error NotEnoughDeposit();
    error InavalidToken();

    function __Vault_init(IPermit2 _permit2) internal {
        permit2 = _permit2;
    }
    //vault like functionality
    //this means that periphery contract will end up holding tokens

    function depositERC20(
        IERC20 token,
        address to,
        uint256 amount,
        bool isPermit2, // only applicable for permit2 tokens
        uint256 nonce, // only applicable for permit2 tokens
        uint256 deadline, // only applicable for permit2 tokens
        bytes calldata signature // only applicable for permit2 tokens
    ) external {
        if (isPermit2) {
            if (address(token).code.length == 0) revert NonExistentToken();
            permit2.permitTransferFrom(
                IPermit2.PermitTransferFrom({permitted: IPermit2.TokenPermissions({token: token, amount: amount}), nonce: nonce, deadline: deadline}),
                IPermit2.SignatureTransferDetails({to: address(this), requestedAmount: amount}),
                msg.sender,
                signature
            );
        } else {
            SafeERC20.safeTransferFrom(token, msg.sender, address(this), amount);
        }
        _depositERC20(address(token), to, amount);
    }

    function _depositERC20(address token, address to, uint256 amount) internal {
        deposits[to][token] += amount;
        emit Deposit(token, to, amount);
    }

    function addCollateral(address tokenA, address tokenB, IERC20 token, address user, uint256 amount) external {
        if (user != msg.sender) _spendAllowance(address(token), user, msg.sender, amount);
        (address token0, address token1) = tokenA < tokenB ? (tokenA, tokenB) : (tokenB, tokenA);
        if (deposits[user][address(token)] < amount) revert NotEnoughDeposit();
        deposits[user][address(token)] -= amount;
        emit Withdraw(address(token), user, amount);
        _increaseCollateral(token0, token1, token, user, amount);
    }

    function _increaseCollateral(address token0, address token1, IERC20 token, address user, uint256 amount) internal {
        bool tokenBool;
        if (address(token) == token0) tokenBool = false;
        else if (address(token) == token1) tokenBool = true;
        else revert InavalidToken();
        collaterals[user][token0][token1][tokenBool] += int256(amount);
        emit DepositCollateral(user, token0, token1, tokenBool, amount);
    }

    function _decreaseCollateral(address token0, address token1, IERC20 token, address user, uint256 amount) internal {
        bool tokenBool;
        if (address(token) == token0) tokenBool = false;
        else if (address(token) == token1) tokenBool = true;
        else revert InavalidToken();
        collaterals[user][token0][token1][tokenBool] -= int256(amount);
        emit WithdrawCollateral(user, token0, token1, tokenBool, amount);
    }

    function withdrawERC20(IERC20 token, address onBehalfOf, address to, uint256 amount) external {
        if (msg.sender != onBehalfOf) _spendAllowance(address(token), onBehalfOf, msg.sender, amount);

        if (deposits[onBehalfOf][address(token)] < amount) revert NotEnoughDeposit();
        deposits[onBehalfOf][address(token)] -= amount;
        SafeERC20.safeTransfer(token, to, amount);
        emit Withdraw(address(token), onBehalfOf, amount);
    }

    function _spendAllowance(address token, address owner, address spender, uint256 value) internal {
        uint256 currentAllowance = allowance[owner][token][spender];
        if (currentAllowance < value) revert VaultERC20InsufficientAllowance(token, owner, spender, currentAllowance, value);
        allowance[owner][token][spender] = currentAllowance - value;
    }

    function approveERC20(IERC20 token, address spender, uint256 amount) external {
        allowance[msg.sender][address(token)][spender] = amount;
    }

    function increaseAllowanceERC20(IERC20 token, address spender, uint256 amount) external {
        allowance[msg.sender][address(token)][spender] += amount;
    }
}
