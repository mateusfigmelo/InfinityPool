// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import {ERC20DecimalsMock, ERC20} from "@openzeppelin/contracts/mocks/token/ERC20DecimalsMock.sol";
// mock class using ERC20

contract ERC20Mock is ERC20DecimalsMock {
    constructor(string memory name, string memory symbol, uint8 _decimals, address initialAccount, uint256 initialBalance)
        payable
        ERC20(name, symbol)
        ERC20DecimalsMock(_decimals)
    {
        _mint(initialAccount, initialBalance);
    }

    function mint(address account, uint256 amount) public {
        _mint(account, amount);
    }

    function burn(address account, uint256 amount) public {
        _burn(account, amount);
    }

    function transferInternal(address from, address to, uint256 value) public {
        _transfer(from, to, value);
    }

    function approveInternal(address owner, address spender, uint256 value) public {
        _approve(owner, spender, value);
    }
}
