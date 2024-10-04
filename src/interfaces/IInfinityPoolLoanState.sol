// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import {Quad} from "src/types/ABDKMathQuad/Quad.sol";

struct newLoanCache {
    uint24 binSize;
    uint24 start;
    uint24 stop;
    uint8 token;
    int24 upperTick;
    Quad mid;
    Quad strike;
    Quad q;
    Quad tilterFirst;
    Quad tilterLast;
    Quad offset;
    Quad maturityFraction;
    Quad aliveDays;
    bool oneSided;
    Quad rawInterest;
    Quad needInterest;
    Quad fullInterest;
    Quad inflator;
    uint24 strikeIdx;
    Quad toLiquidity;
    Quad owedToken;
    Quad lentToken;
    Quad yieldToken;
    Quad needToken;
    Quad[] owed;
    Quad[] lent;
    Quad[] minted;
    uint256 gasLast;
}

struct newLoanMainLoopCache {
    uint24 bin;
    Quad owedLiquidity;
    Quad logStrikes;
    Quad logm;
    Quad sqrtStrike;
    Quad rate;
    Quad theta;
    Quad cr;
    Quad oldLent;
    Quad minted;
    Quad virtualOwed;
    Quad newLent;
    Quad lentUsed;
    Quad unitReserve;
}
