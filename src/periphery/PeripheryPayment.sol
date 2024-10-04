// SPDX-License-Identifier: UNLICENSED

import {Vault} from "./Vault.sol";
import {SafeERC20, IERC20} from "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import {IWETH9} from "src/periphery/interfaces/external/IWETH9.sol";
import {IPermit2} from "src/periphery/interfaces/external/IPermit2.sol";

contract PeripheryPayment is Vault {
    function pay(IERC20 token, address payer, address recipient, uint256 value) internal {
        if (address(token) == WETH9 && address(this).balance >= value) {
            // pay with WETH9
            IWETH9(WETH9).deposit{value: value}(); // wrap only what is needed to pay
            IWETH9(WETH9).transfer(recipient, value);
        } else if (payer == address(this)) {
            SafeERC20.safeTransfer(token, recipient, value);
        } else {
            // pull payment
            SafeERC20.safeTransferFrom(token, payer, recipient, value);
        }
    }
    //This contract is not supposed to hold any ETH. This function is to help user get back the leftover ETH at the end of a transactions

    function wrapAndDepositWETH(address to) external payable {
        IWETH9(WETH9).deposit{value: address(this).balance}();
        _depositERC20(WETH9, to, address(this).balance);
    }
}
