// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import {Vault, IPermit2, IERC20} from "src/periphery/Vault.sol";
import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract Token is ERC20 {
    constructor(string memory name_, string memory symbol_) ERC20(name_, symbol_) {}

    function mint(address to, uint256 amount) external {
        _mint(to, amount);
    }
}

contract VaultTest is Test {
    event Deposit(address indexed token, address indexed to, uint256 amount);
    event DepositETH(address indexed to, uint256 amount);
    event Withdraw(address indexed token, address indexed from, uint256 amount);
    event WithdrawETH(address indexed from, uint256 amount);
    event Approval(address indexed token, address indexed owner, address indexed spender, uint256 amount);

    Vault vault;
    Token token;

    function setUp() public {
        vault = new Vault();
        token = new Token("Test Token", "TEST");
        token.mint(address(this), 100 ether);
    }

    function testDeposit() public {
        uint256 balanceBefore = token.balanceOf(address(this));
        token.approve(address(vault), 100 ether);
        vault.depositERC20(IERC20(token), address(this), 100 ether, false, 0, 0, bytes(""));
        uint256 balanceAfter = token.balanceOf(address(this));
        assertEq(balanceBefore - balanceAfter, 100 ether);
        assertEq(token.balanceOf(address(vault)), 100 ether);
        assertEq(vault.deposits(address(this), address(token)), 100 ether);
    }

    function testEmitsDeposit() public {
        token.approve(address(vault), 100 ether);
        vm.expectEmit(true, true, true, true);
        emit Deposit(address(token), address(this), 100 ether);
        vault.depositERC20(IERC20(token), address(this), 100 ether, false, 0, 0, bytes(""));
    }

    function testWithdraw() public {
        token.approve(address(vault), 100 ether);
        vault.depositERC20(IERC20(token), address(this), 100 ether, false, 0, 0, bytes(""));
        uint256 tokenBalanceBefore = token.balanceOf(address(this));
        vault.withdrawERC20(IERC20(token), address(this), address(this), 100 ether);
        assertEq(token.balanceOf(address(this)), tokenBalanceBefore + 100 ether);
        assertEq(vault.deposits(address(this), address(token)), 0);
    }

    function testEmitsWithdraw() public {
        token.approve(address(vault), 100 ether);
        vault.depositERC20(IERC20(token), address(this), 100 ether, false, 0, 0, bytes(""));
        vm.expectEmit(true, true, true, true);
        emit Withdraw(address(token), address(this), 100 ether);
        vault.withdrawERC20(IERC20(token), address(this), address(this), 100 ether);
    }

    function testWithdrawMoreThanDepositRevert() public {
        token.approve(address(vault), 100 ether);
        vault.depositERC20(IERC20(token), address(this), 100 ether, false, 0, 0, bytes(""));
        uint256 tokenBalanceBefore = token.balanceOf(address(this));
        vm.expectRevert(Vault.NotEnoughDeposit.selector);
        vault.withdrawERC20(IERC20(token), address(this), address(this), 101 ether);
    }

    event Received(address, uint256);

    receive() external payable {
        emit Received(msg.sender, msg.value);
    }
}
