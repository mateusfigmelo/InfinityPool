// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import {console2} from "forge-std/Test.sol";
import {Quad, LibOptQuad, fromUint256, intoUint256} from "src/types/ABDKMathQuad/Quad.sol";
import {UniswapV2ArbCore} from "src/arb/uniswapV2/UniswapV2ArbCore.sol";
import {IERC20Metadata} from "@openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol";

contract UniswapV2ArbTestHelper is UniswapV2ArbCore {
    mapping(address => address) pairAddressToToken0;
    mapping(address => address) pairAddressToToken1;
    mapping(address => mapping(address => Quad)) poolPrices;

    uint256 internal targetAmountToPutBackToUniV2;

    constructor(address infinityPoolsPeripheryAddress) UniswapV2ArbCore(infinityPoolsPeripheryAddress) {}

    function setUniswapPrice(address token0, address token1, Quad price) external {
        poolPrices[token0][token1] = price;
    }

    function getAmount1ToPutBackToUniV2(address token0, uint256 amount0, address token1) public view override returns (uint256) {
        Quad poolPrice = poolPrices[token0][token1];
        Quad quadAmount0 = fromUint256(amount0) / fromUint256(10 ** IERC20Metadata(token0).decimals());
        Quad quadAmount1 = quadAmount0 * poolPrice;
        return intoUint256(quadAmount1 * fromUint256(10 ** IERC20Metadata(token1).decimals()));
    }

    function getAmount0ToPutBackToUniV2(address token0, address token1, uint256 amount1) public view override returns (uint256) {
        Quad poolPrice = poolPrices[token0][token1];
        Quad quadAmount1 = fromUint256(amount1) / fromUint256(10 ** IERC20Metadata(token1).decimals());
        Quad quadAmount0 = quadAmount1 / poolPrice;
        return intoUint256(quadAmount0 * fromUint256(10 ** IERC20Metadata(token0).decimals()));
    }

    function setUniswapV2Tokens(address pairAddress, address token0, address token1) external {
        console2.log("setting tokens for pair address", pairAddress);
        pairAddressToToken0[pairAddress] = token0;
        pairAddressToToken1[pairAddress] = token1;
    }

    function getUniswapV2Tokens(address pairAddress) public view override returns (address, address) {
        console2.log("getting tokens for pair address", pairAddress);
        address token0 = pairAddressToToken0[pairAddress];
        address token1 = pairAddressToToken1[pairAddress];
        require(token0 != address(0), "pool does not exist");
        require(token1 != address(0), "pool does not exist");
        return (token0, token1);
    }
}
