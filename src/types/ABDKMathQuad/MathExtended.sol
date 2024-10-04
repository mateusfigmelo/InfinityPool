// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import {ABDKMathQuad} from "../../../lib/abdk-libraries-solidity/ABDKMathQuad.sol";
import {wrap} from "./Helpers.sol";
import {Quad} from "./ValueType.sol";
import {exp, floor} from "./Math.sol";
import {fromUint256, fromInt256, intoUint256, intoInt256} from "./Casting.sol";
import {POSITIVE_ONE, NEGATIVE_ONE, POSITIVE_ZERO, HALF, POSITIVE_TWO, POSITIVE_INFINITY, NEGATIVE_INFINITY} from "./Constants.sol";
import {
    EXP1MQ_THRESHOLD,
    EXP1MQ_MAXLOG,
    EXP1MQ_C1,
    EXP1MQ_C2,
    EXP1MQ_P7,
    EXP1MQ_P6,
    EXP1MQ_P5,
    EXP1MQ_P4,
    EXP1MQ_P3,
    EXP1MQ_P2,
    EXP1MQ_P1,
    EXP1MQ_P0,
    EXP1MQ_Q7,
    EXP1MQ_Q6,
    EXP1MQ_Q5,
    EXP1MQ_Q4,
    EXP1MQ_Q3,
    EXP1MQ_Q2,
    EXP1MQ_Q1,
    EXP1MQ_Q0,
    EXP1MQ_MINARG,
    FREXP_H128,
    FREXP_L128,
    EXP1MQ_TWO114,
    LOG1PQ_R5,
    LOG1PQ_R4,
    LOG1PQ_R3,
    LOG1PQ_R2,
    LOG1PQ_R1,
    LOG1PQ_R0,
    LOG1PQ_S5,
    LOG1PQ_S4,
    LOG1PQ_S3,
    LOG1PQ_S2,
    LOG1PQ_S1,
    LOG1PQ_S0,
    LOG1PQ_P12,
    LOG1PQ_P11,
    LOG1PQ_P10,
    LOG1PQ_P9,
    LOG1PQ_P8,
    LOG1PQ_P7,
    LOG1PQ_P6,
    LOG1PQ_P5,
    LOG1PQ_P4,
    LOG1PQ_P3,
    LOG1PQ_P2,
    LOG1PQ_P1,
    LOG1PQ_P0,
    LOG1PQ_Q11,
    LOG1PQ_Q10,
    LOG1PQ_Q9,
    LOG1PQ_Q8,
    LOG1PQ_Q7,
    LOG1PQ_Q6,
    LOG1PQ_Q5,
    LOG1PQ_Q4,
    LOG1PQ_Q3,
    LOG1PQ_Q2,
    LOG1PQ_Q1,
    LOG1PQ_Q0,
    LOG1PQ_C2,
    LOG1PQ_C1,
    LOG1PQ_SQRTH,
    LOG1PQ_THRESHOLD
} from "./Constants.sol";
import {FloatBits, QuadPacker} from "src/libraries/internal/SparseFloat.sol";

struct State_exp1mq {
    int8 sign;
    Quad xx;
    Quad px;
    Quad qx;
    int128 e;
    Quad X;
    Quad z;
    Quad y;
    int256 _k;
    int128 k;
    FloatBits.Info temp;
    Quad t1;
}

error KOutOfRange(int256 k);

function expm1(Quad x) pure returns (Quad) {
    State_exp1mq memory state;
    // On purpose, we want ignore NaN handling so that we crash here instead of risking to corrupt the state

    // This function will crash if x is NaN
    state.sign = ABDKMathQuad.sign(x.unwrap());
    if ((state.sign > 0) && (x >= EXP1MQ_THRESHOLD)) return exp(x);
    if (ABDKMathQuad.isInfinity(x.unwrap())) {
        if (state.sign < 0) return NEGATIVE_ONE;
        else return x;
    }

    if (state.sign == 0) return x;

    if (x > EXP1MQ_MAXLOG) return POSITIVE_INFINITY;

    if (x < EXP1MQ_MINARG) return NEGATIVE_ONE;

    state.xx = EXP1MQ_C1 + EXP1MQ_C2;
    state.px = fromInt256(floor(HALF + (x / state.xx)));
    state._k = intoInt256(state.px);
    if (!((state._k >= type(int128).min) && (state._k <= type(int128).max))) revert KOutOfRange(state._k);
    state.k = int128(state._k);
    state.X = (x - state.px * EXP1MQ_C1) - state.px * EXP1MQ_C2;

    // Solving stack too deep error
    state.t1 = ((EXP1MQ_P7 * state.X + EXP1MQ_P6) * state.X + EXP1MQ_P5);
    state.px =
        (((((state.t1 * state.X + EXP1MQ_P4) * state.X + EXP1MQ_P3) * state.X + EXP1MQ_P2) * state.X + EXP1MQ_P1) * state.X + EXP1MQ_P0) * state.X;
    state.qx = (
        ((((((state.X + EXP1MQ_Q7) * state.X + EXP1MQ_Q6) * state.X + EXP1MQ_Q5) * state.X + EXP1MQ_Q4) * state.X + EXP1MQ_Q3) * state.X + EXP1MQ_Q2)
            * state.X + EXP1MQ_Q1
    ) * state.X + EXP1MQ_Q0;
    state.xx = state.X * state.X;
    state.qx = state.X + (HALF * state.xx + state.xx * state.px / state.qx);

    state.temp.exponent = state.k;
    state.temp.significand = 1;
    state.px = QuadPacker.repack(state.temp);
    return state.px * state.qx + (state.px - POSITIVE_ONE);
}

function computeHX(bytes16 x) pure returns (bytes8 hx) {
    bytes16 th1 = FREXP_H128 & x;
    // NOTE: Solidity is big endian so the bytes16 to bytes8 casting takes the leftmost bytes
    hx = bytes8(th1);
}

function computeLX(bytes16 x) pure returns (bytes8 lx) {
    bytes16 tl1 = FREXP_L128 & x;
    bytes16 tl2;
    assembly {
        tl2 := shl(64, tl1)
    }
    // NOTE: Solidity is big endian so the bytes16 to bytes8 casting takes the leftmost bytes
    lx = bytes8(tl2);
}

function frexp(Quad xm1signed) pure returns (Quad xx, int128 e) {
    int8 sign = ABDKMathQuad.sign(xm1signed.unwrap());
    Quad xm1 = (sign < 0) ? NEGATIVE_ONE * xm1signed : xm1signed;
    bytes16 x = xm1.unwrap();
    bytes8 hx = computeHX(x);
    bytes8 lx = computeLX(x);
    bytes8 ix = hx & 0x7fffffffffffffff;
    int128 eptr = 0;

    if (ix >= 0x7fff000000000000 || ((ix | lx) == 0)) return (xm1signed, eptr);
    if (ix < 0x0001000000000000) {
        x = (xm1 * EXP1MQ_TWO114).unwrap();
        hx = computeHX(x);
        ix = hx & 0x7fffffffffffffff;
        eptr = -114;
    }

    // This also works
    //        uint128 temp = uint128(uint64(ix >> 48));

    bytes8 temp1;
    assembly {
        temp1 := shr(48, ix)
    }
    uint128 temp = uint128(uint64(temp1));
    eptr = eptr + int128(int128(temp) - 16382);
    hx = (hx & 0x8000ffffffffffff) | 0x3ffe000000000000;
    int128 t1 = int128(uint128(uint64(hx)));
    x = bytes16((x & FREXP_L128) | bytes16(uint128(t1 << 64)));
    Quad xm1_final = wrap(x);
    if (sign < 0) return (NEGATIVE_ONE * xm1_final, eptr);
    else return (xm1_final, eptr);
}

struct LOG1PQ_State {
    Quad xm1;
    int8 sign;
    Quad x;
    Quad xx;
    int128 e;
    Quad z;
    Quad y;
    Quad r;
    Quad s;
    Quad res;
    Quad t1;
    Quad t2;
    Quad t3;
    Quad t4;
    Quad t5;
    Quad t6;
    Quad t7;
    Quad t8;
    Quad t9;
    Quad t10;
    Quad t11;
    Quad t12;
}

function log1p(Quad xm1) pure returns (Quad res) {
    LOG1PQ_State memory state;
    if (xm1 <= NEGATIVE_ONE) return NEGATIVE_INFINITY;
    if (ABDKMathQuad.isInfinity(xm1.unwrap())) return xm1;
    state.sign = ABDKMathQuad.sign(xm1.unwrap());
    if (state.sign == 0) return xm1;

    if (xm1.abs() < LOG1PQ_THRESHOLD) return xm1;

    state.x = xm1 + POSITIVE_ONE;
    if (state.x < POSITIVE_ZERO) return NEGATIVE_INFINITY;
    (state.xx, state.e) = frexp(state.x);
    state.z = POSITIVE_ZERO;
    state.y = POSITIVE_ZERO;

    if ((state.e > 2) || (state.e < -2)) {
        if (state.xx < LOG1PQ_SQRTH) {
            state.e -= 1;
            state.z = state.xx - HALF;
            state.y = HALF * state.z + HALF;
        } else {
            state.z = state.xx - POSITIVE_ONE;
            state.y = HALF * state.xx + HALF;
        }
        state.xx = state.z / state.y;
        state.z = state.xx * state.xx;
        state.r = ((((LOG1PQ_R5 * state.z + LOG1PQ_R4) * state.z + LOG1PQ_R3) * state.z + LOG1PQ_R2) * state.z + LOG1PQ_R1) * state.z + LOG1PQ_R0;
        state.s = (((((state.z + LOG1PQ_S5) * state.z + LOG1PQ_S4) * state.z + LOG1PQ_S3) * state.z + LOG1PQ_S2) * state.z + LOG1PQ_S1) * state.z
            + LOG1PQ_S0;
        state.z = state.xx * (state.z * state.r / state.s) + state.xx + fromInt256(state.e) * (EXP1MQ_C2 + EXP1MQ_C1);
        return state.z;
    }

    if (state.xx < LOG1PQ_SQRTH) {
        state.e -= 1;
        if (state.e != 0) state.xx = POSITIVE_TWO * state.xx - POSITIVE_ONE;
        else state.xx = xm1;
    } else {
        if (state.e != 0) state.xx = state.xx - POSITIVE_ONE;
        else state.xx = xm1;
    }

    state.z = state.xx * state.xx;
    state.t1 = ((LOG1PQ_P12 * state.xx + LOG1PQ_P11) * state.xx + LOG1PQ_P10);
    state.t2 = (state.t1 * state.xx + LOG1PQ_P9);
    state.t3 = (state.t2 * state.xx + LOG1PQ_P8);
    state.t4 = (state.t3 * state.xx + LOG1PQ_P7);
    state.t5 = (state.t4 * state.xx + LOG1PQ_P6);
    state.t6 = (state.t5 * state.xx + LOG1PQ_P5);
    state.t7 = (state.t6 * state.xx + LOG1PQ_P4);
    state.t8 = (state.t7 * state.xx + LOG1PQ_P3);
    state.t9 = (state.t8 * state.xx + LOG1PQ_P2);
    state.t10 = (state.t9 * state.xx + LOG1PQ_P1);
    state.t11 = state.t10 * state.xx;

    state.r = state.t11 + LOG1PQ_P0;
    state.t1 = (state.xx + LOG1PQ_Q11);
    state.t2 = (state.t1 * state.xx + LOG1PQ_Q10);
    state.t3 = (state.t2 * state.xx + LOG1PQ_Q9);
    state.t4 = (state.t3 * state.xx + LOG1PQ_Q8);
    state.t5 = (state.t4 * state.xx + LOG1PQ_Q7);
    state.t6 = (state.t5 * state.xx + LOG1PQ_Q6);
    state.t7 = (state.t6 * state.xx + LOG1PQ_Q5);
    state.t8 = (state.t7 * state.xx + LOG1PQ_Q4);
    state.t9 = (state.t8 * state.xx + LOG1PQ_Q3);
    state.t10 = (state.t9 * state.xx + LOG1PQ_Q2);
    state.t11 = (state.t10 * state.xx + LOG1PQ_Q1);
    state.s = state.t11 * state.xx + LOG1PQ_Q0;
    state.y = state.xx * (state.z * state.r / state.s) + fromInt256(state.e) * LOG1PQ_C2;
    state.z = state.y - HALF * state.z + state.xx + fromInt256(state.e) * LOG1PQ_C1;
    return state.z;
}
