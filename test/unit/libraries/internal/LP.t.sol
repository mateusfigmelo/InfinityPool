// SPDX-License-Identifier: UNLICENSED
// THIS IS AUTO-GENERATED. DO NOT MODIFY.
// GENERATOR SYNTAX
// sbt "project contract" "test:fgRunMain finance.infinitypools.contract.SolidityTestGeneratorApp filepath"
pragma solidity ^0.8.20;

import {console} from "forge-std/console.sol";
import {TUBS} from "src/Constants.sol";
import {POSITIVE_ZERO, fromInt256, fromUint256, intoUint256, Quad, wrap} from "src/types/ABDKMathQuad/Quad.sol";
import {UserPay} from "src/libraries/internal/UserPay.sol";
import {LPTestCore} from "./LPTestCore.sol";

contract LPTest is LPTestCore {
    function testWholeRangePour_whole_range_price_5en01_with_checks() public {
        console.log("whole_range_price_5en01 starting ......");
        testWholeRangePour(
            wrap(0x3ffe0000000000000000000000000000), // price
            fromUint256(1) / fromUint256(100), // quadVar
            fromUint256(1), // liquidityPerTub
            wrap(0x3fff6a0770eaff96e911d1c9d396cfb9), // expected token0 = 1.41417604195848024e+00
            wrap(0x3ffe6a04fa7e42f61eea3b22fb569190), // expected token1 = 7.07069232857502997e-01
            true // do the checks
        );
        console.log("whole_range_price_5en01 testing done.");
    }

    /*
        function testWholeRangePour_whole_range_price_5en01_sans_checks() public {
            console.log("whole_range_price_5en01 starting ......");
            testWholeRangePour(
                wrap(0x3ffe0000000000000000000000000000), // price
                fromUint256(1)/fromUint256(100), // quadVar
                fromUint256(1), // liquidityPerTub
                wrap(0x3fff6a0770eaff96e911d1c9d396cfb9), // expected token0 = 1.41417604195848024e+00
                wrap(0x3ffe6a04fa7e42f61eea3b22fb569190), // expected token1 = 7.07069232857502997e-01
                false // skip the checks
            );
            console.log("whole_range_price_5en01 testing done.");
        }
    */

    function testLimitedRangePour_single_tub_low_end_1_price_5en01_with_checks() public {
        console.log("single_tub_low_end_1_price_5en01 starting ......");
        testLimitedRangePour(
            wrap(0x3ffe0000000000000000000000000000), // price
            fromUint256(1) / fromUint256(100), // quadVar
            0, // startingTub
            1, // stoppingTub
            fromUint256(1), // liquidityPerTub
            POSITIVE_ZERO, // expected token0 = 0e+00
            wrap(0x3fe89277d353d3eb49cc12ff3691a100), // expected token1 = 1.87413798808594682e-07
            true // do the checks
        );
        console.log("single_tub_low_end_1_price_5en01 testing done.");
    }

    /*
        function testLimitedRangePour_single_tub_low_end_1_price_5en01_sans_checks() public {
            console.log("single_tub_low_end_1_price_5en01 starting ......");
            testLimitedRangePour(
                wrap(0x3ffe0000000000000000000000000000), // price
                fromUint256(1)/fromUint256(100), // quadVar
                0, // startingTub
                1, // stoppingTub
                fromUint256(1), // liquidityPerTub
                POSITIVE_ZERO, // expected token0 = 0e+00
                wrap(0x3fe89277d353d3eb49cc12ff3691a100), // expected token1 = 1.87413798808594682e-07
                false // skip the checks
            );
            console.log("single_tub_low_end_1_price_5en01 testing done.");
        }
    */

    function testLimitedRangePour_single_tub_low_end_2_price_5en01_with_checks() public {
        console.log("single_tub_low_end_2_price_5en01 starting ......");
        testLimitedRangePour(
            wrap(0x3ffe0000000000000000000000000000), // price
            fromUint256(1) / fromUint256(100), // quadVar
            11, // startingTub
            12, // stoppingTub
            fromUint256(1), // liquidityPerTub
            POSITIVE_ZERO, // expected token0 = 0e+00
            wrap(0x3fe8a91b931b07d4bfcb8db7d1235700), // expected token1 = 1.97956205067756075e-07
            true // do the checks
        );
        console.log("single_tub_low_end_2_price_5en01 testing done.");
    }

    /*
        function testLimitedRangePour_single_tub_low_end_2_price_5en01_sans_checks() public {
            console.log("single_tub_low_end_2_price_5en01 starting ......");
            testLimitedRangePour(
                wrap(0x3ffe0000000000000000000000000000), // price
                fromUint256(1)/fromUint256(100), // quadVar
                11, // startingTub
                12, // stoppingTub
                fromUint256(1), // liquidityPerTub
                POSITIVE_ZERO, // expected token0 = 0e+00
                wrap(0x3fe8a91b931b07d4bfcb8db7d1235700), // expected token1 = 1.97956205067756075e-07
                false // skip the checks
            );
            console.log("single_tub_low_end_2_price_5en01 testing done.");
        }
    */

    function testLimitedRangePour_single_tub_mid_range_price_5en01_with_checks() public {
        console.log("single_tub_mid_range_price_5en01 starting ......");
        testLimitedRangePour(
            wrap(0x3ffe0000000000000000000000000000), // price
            fromUint256(1) / fromUint256(100), // quadVar
            2048, // startingTub
            2049, // stoppingTub
            fromUint256(1), // liquidityPerTub
            wrap(0x3ff7453e21be8eb93ffa86ecf1e06080), // expected token0 = 4.96280979001086433e-03
            POSITIVE_ZERO, // expected token1 = 0e+00
            true // do the checks
        );
        console.log("single_tub_mid_range_price_5en01 testing done.");
    }

    /*
        function testLimitedRangePour_single_tub_mid_range_price_5en01_sans_checks() public {
            console.log("single_tub_mid_range_price_5en01 starting ......");
            testLimitedRangePour(
                wrap(0x3ffe0000000000000000000000000000), // price
                fromUint256(1)/fromUint256(100), // quadVar
                2048, // startingTub
                2049, // stoppingTub
                fromUint256(1), // liquidityPerTub
                wrap(0x3ff7453e21be8eb93ffa86ecf1e06080), // expected token0 = 4.96280979001086433e-03
                POSITIVE_ZERO, // expected token1 = 0e+00
                false // skip the checks
            );
            console.log("single_tub_mid_range_price_5en01 testing done.");
        }
    */

    function testLimitedRangePour_single_tub_high_end_1_price_5en01_with_checks() public {
        console.log("single_tub_high_end_1_price_5en01 starting ......");
        testLimitedRangePour(
            wrap(0x3ffe0000000000000000000000000000), // price
            fromUint256(1) / fromUint256(100), // quadVar
            4086, // startingTub
            4087, // stoppingTub
            fromUint256(1), // liquidityPerTub
            wrap(0x3fe8a4e612ea9ac36f5268d469ae6700), // expected token0 = 1.95996242641342649e-07
            POSITIVE_ZERO, // expected token1 = 0e+00
            true // do the checks
        );
        console.log("single_tub_high_end_1_price_5en01 testing done.");
    }

    /*
        function testLimitedRangePour_single_tub_high_end_1_price_5en01_sans_checks() public {
            console.log("single_tub_high_end_1_price_5en01 starting ......");
            testLimitedRangePour(
                wrap(0x3ffe0000000000000000000000000000), // price
                fromUint256(1)/fromUint256(100), // quadVar
                4086, // startingTub
                4087, // stoppingTub
                fromUint256(1), // liquidityPerTub
                wrap(0x3fe8a4e612ea9ac36f5268d469ae6700), // expected token0 = 1.95996242641342649e-07
                POSITIVE_ZERO, // expected token1 = 0e+00
                false // skip the checks
            );
            console.log("single_tub_high_end_1_price_5en01 testing done.");
        }
    */

    function testLimitedRangePour_single_tub_high_end_2_price_5en01_with_checks() public {
        console.log("single_tub_high_end_2_price_5en01 starting ......");
        testLimitedRangePour(
            wrap(0x3ffe0000000000000000000000000000), // price
            fromUint256(1) / fromUint256(100), // quadVar
            4095, // startingTub
            4096, // stoppingTub
            fromUint256(1), // liquidityPerTub
            wrap(0x3fe89277d353d3eb49cc12ff3691a100), // expected token0 = 1.87413798808594682e-07
            POSITIVE_ZERO, // expected token1 = 0e+00
            true // do the checks
        );
        console.log("single_tub_high_end_2_price_5en01 testing done.");
    }

    /*
        function testLimitedRangePour_single_tub_high_end_2_price_5en01_sans_checks() public {
            console.log("single_tub_high_end_2_price_5en01 starting ......");
            testLimitedRangePour(
                wrap(0x3ffe0000000000000000000000000000), // price
                fromUint256(1)/fromUint256(100), // quadVar
                4095, // startingTub
                4096, // stoppingTub
                fromUint256(1), // liquidityPerTub
                wrap(0x3fe89277d353d3eb49cc12ff3691a100), // expected token0 = 1.87413798808594682e-07
                POSITIVE_ZERO, // expected token1 = 0e+00
                false // skip the checks
            );
            console.log("single_tub_high_end_2_price_5en01 testing done.");
        }
    */

    function testLimitedRangePour_small_tub_range_low_end_1_price_5en01_with_checks() public {
        console.log("small_tub_range_low_end_1_price_5en01 starting ......");
        testLimitedRangePour(
            wrap(0x3ffe0000000000000000000000000000), // price
            fromUint256(1) / fromUint256(100), // quadVar
            0, // startingTub
            2, // stoppingTub
            fromUint256(1), // liquidityPerTub
            POSITIVE_ZERO, // expected token0 = 0e+00
            wrap(0x3fe99378c3a9fb2f2fed387476368580), // expected token1 = 3.75762335579409788e-07
            true // do the checks
        );
        console.log("small_tub_range_low_end_1_price_5en01 testing done.");
    }

    /*
        function testLimitedRangePour_small_tub_range_low_end_1_price_5en01_sans_checks() public {
            console.log("small_tub_range_low_end_1_price_5en01 starting ......");
            testLimitedRangePour(
                wrap(0x3ffe0000000000000000000000000000), // price
                fromUint256(1)/fromUint256(100), // quadVar
                0, // startingTub
                2, // stoppingTub
                fromUint256(1), // liquidityPerTub
                POSITIVE_ZERO, // expected token0 = 0e+00
                wrap(0x3fe99378c3a9fb2f2fed387476368580), // expected token1 = 3.75762335579409788e-07
                false // skip the checks
            );
            console.log("small_tub_range_low_end_1_price_5en01 testing done.");
        }
    */

    function testLimitedRangePour_small_tub_range_low_end_2_price_5en01_with_checks() public {
        console.log("small_tub_range_low_end_2_price_5en01 starting ......");
        testLimitedRangePour(
            wrap(0x3ffe0000000000000000000000000000), // price
            fromUint256(1) / fromUint256(100), // quadVar
            11, // startingTub
            13, // stoppingTub
            fromUint256(1), // liquidityPerTub
            POSITIVE_ZERO, // expected token0 = 0e+00
            wrap(0x3fe9aa2af77e94438ee950decc09fa80), // expected token1 = 3.96899729003761018e-07
            true // do the checks
        );
        console.log("small_tub_range_low_end_2_price_5en01 testing done.");
    }

    /*
        function testLimitedRangePour_small_tub_range_low_end_2_price_5en01_sans_checks() public {
            console.log("small_tub_range_low_end_2_price_5en01 starting ......");
            testLimitedRangePour(
                wrap(0x3ffe0000000000000000000000000000), // price
                fromUint256(1)/fromUint256(100), // quadVar
                11, // startingTub
                13, // stoppingTub
                fromUint256(1), // liquidityPerTub
                POSITIVE_ZERO, // expected token0 = 0e+00
                wrap(0x3fe9aa2af77e94438ee950decc09fa80), // expected token1 = 3.96899729003761018e-07
                false // skip the checks
            );
            console.log("small_tub_range_low_end_2_price_5en01 testing done.");
        }
    */

    function testLimitedRangePour_small_tub_range_midpoint_price_5en01_with_checks() public {
        console.log("small_tub_range_midpoint_price_5en01 starting ......");
        testLimitedRangePour(
            wrap(0x3ffe0000000000000000000000000000), // price
            fromUint256(1) / fromUint256(100), // quadVar
            2048, // startingTub
            2050, // stoppingTub
            fromUint256(1), // liquidityPerTub
            wrap(0x3ff8446f86562d9faee41e6a74981440), // expected token0 = 9.90099009900990099e-03
            POSITIVE_ZERO, // expected token1 = 0e+00
            true // do the checks
        );
        console.log("small_tub_range_midpoint_price_5en01 testing done.");
    }

    /*
        function testLimitedRangePour_small_tub_range_midpoint_price_5en01_sans_checks() public {
            console.log("small_tub_range_midpoint_price_5en01 starting ......");
            testLimitedRangePour(
                wrap(0x3ffe0000000000000000000000000000), // price
                fromUint256(1)/fromUint256(100), // quadVar
                2048, // startingTub
                2050, // stoppingTub
                fromUint256(1), // liquidityPerTub
                wrap(0x3ff8446f86562d9faee41e6a74981440), // expected token0 = 9.90099009900990099e-03
                POSITIVE_ZERO, // expected token1 = 0e+00
                false // skip the checks
            );
            console.log("small_tub_range_midpoint_price_5en01 testing done.");
        }
    */

    function testLimitedRangePour_small_tub_range_high_end_price_5en01_with_checks() public {
        console.log("small_tub_range_high_end_price_5en01 starting ......");
        testLimitedRangePour(
            wrap(0x3ffe0000000000000000000000000000), // price
            fromUint256(1) / fromUint256(100), // quadVar
            4094, // startingTub
            4096, // stoppingTub
            fromUint256(1), // liquidityPerTub
            wrap(0x3fe99378c3a9fb2f2fed387476368580), // expected token0 = 3.75762335579409788e-07
            POSITIVE_ZERO, // expected token1 = 0e+00
            true // do the checks
        );
        console.log("small_tub_range_high_end_price_5en01 testing done.");
    }

    /*
        function testLimitedRangePour_small_tub_range_high_end_price_5en01_sans_checks() public {
            console.log("small_tub_range_high_end_price_5en01 starting ......");
            testLimitedRangePour(
                wrap(0x3ffe0000000000000000000000000000), // price
                fromUint256(1)/fromUint256(100), // quadVar
                4094, // startingTub
                4096, // stoppingTub
                fromUint256(1), // liquidityPerTub
                wrap(0x3fe99378c3a9fb2f2fed387476368580), // expected token0 = 3.75762335579409788e-07
                POSITIVE_ZERO, // expected token1 = 0e+00
                false // skip the checks
            );
            console.log("small_tub_range_high_end_price_5en01 testing done.");
        }
    */

    function testLimitedRangePour_big_tub_lower_range_price_5en01_with_checks() public {
        console.log("big_tub_lower_range_price_5en01 starting ......");
        testLimitedRangePour(
            wrap(0x3ffe0000000000000000000000000000), // price
            fromUint256(1) / fromUint256(100), // quadVar
            256, // startingTub
            1792, // stoppingTub
            fromUint256(1), // liquidityPerTub
            POSITIVE_ZERO, // expected token0 = 0e+00
            wrap(0x3ffd1e63770a42ea4f7e9e2311893d4f), // expected token1 = 2.79676303864770324e-01
            true // do the checks
        );
        console.log("big_tub_lower_range_price_5en01 testing done.");
    }

    /*
        function testLimitedRangePour_big_tub_lower_range_price_5en01_sans_checks() public {
            console.log("big_tub_lower_range_price_5en01 starting ......");
            testLimitedRangePour(
                wrap(0x3ffe0000000000000000000000000000), // price
                fromUint256(1)/fromUint256(100), // quadVar
                256, // startingTub
                1792, // stoppingTub
                fromUint256(1), // liquidityPerTub
                POSITIVE_ZERO, // expected token0 = 0e+00
                wrap(0x3ffd1e63770a42ea4f7e9e2311893d4f), // expected token1 = 2.79676303864770324e-01
                false // skip the checks
            );
            console.log("big_tub_lower_range_price_5en01 testing done.");
        }
    */

    function testLimitedRangePour_big_tub_almost_whole_range_price_5en01_with_checks() public {
        console.log("big_tub_almost_whole_range_price_5en01 starting ......");
        testLimitedRangePour(
            wrap(0x3ffe0000000000000000000000000000), // price
            fromUint256(1) / fromUint256(100), // quadVar
            512, // startingTub
            3584, // stoppingTub
            fromUint256(1), // liquidityPerTub
            wrap(0x3fff69ea7352a3b1eb832c4e8ad62498), // expected token0 = 1.41373368041576668e+00
            wrap(0x3ffe69caff4d8b2c23ccf02c69d53b4e), // expected token1 = 7.06626871314789432e-01
            true // do the checks
        );
        console.log("big_tub_almost_whole_range_price_5en01 testing done.");
    }

    /*
        function testLimitedRangePour_big_tub_almost_whole_range_price_5en01_sans_checks() public {
            console.log("big_tub_almost_whole_range_price_5en01 starting ......");
            testLimitedRangePour(
                wrap(0x3ffe0000000000000000000000000000), // price
                fromUint256(1)/fromUint256(100), // quadVar
                512, // startingTub
                3584, // stoppingTub
                fromUint256(1), // liquidityPerTub
                wrap(0x3fff69ea7352a3b1eb832c4e8ad62498), // expected token0 = 1.41373368041576668e+00
                wrap(0x3ffe69caff4d8b2c23ccf02c69d53b4e), // expected token1 = 7.06626871314789432e-01
                false // skip the checks
            );
            console.log("big_tub_almost_whole_range_price_5en01 testing done.");
        }
    */

    function testLimitedRangePour_big_tub_upper_range_price_5en01_with_checks() public {
        console.log("big_tub_upper_range_price_5en01 starting ......");
        testLimitedRangePour(
            wrap(0x3ffe0000000000000000000000000000), // price
            fromUint256(1) / fromUint256(100), // quadVar
            2304, // startingTub
            3840, // stoppingTub
            fromUint256(1), // liquidityPerTub
            wrap(0x3ffd1e63770a42ea4f7e9e2311893d4f), // expected token0 = 2.79676303864770324e-01
            POSITIVE_ZERO, // expected token1 = 0e+00
            true // do the checks
        );
        console.log("big_tub_upper_range_price_5en01 testing done.");
    }

    /*
        function testLimitedRangePour_big_tub_upper_range_price_5en01_sans_checks() public {
            console.log("big_tub_upper_range_price_5en01 starting ......");
            testLimitedRangePour(
                wrap(0x3ffe0000000000000000000000000000), // price
                fromUint256(1)/fromUint256(100), // quadVar
                2304, // startingTub
                3840, // stoppingTub
                fromUint256(1), // liquidityPerTub
                wrap(0x3ffd1e63770a42ea4f7e9e2311893d4f), // expected token0 = 2.79676303864770324e-01
                POSITIVE_ZERO, // expected token1 = 0e+00
                false // skip the checks
            );
            console.log("big_tub_upper_range_price_5en01 testing done.");
        }
    */

    function testLimitedRangePour_lower_half_tub_range_price_5en01_with_checks() public {
        console.log("lower_half_tub_range_price_5en01 starting ......");
        testLimitedRangePour(
            wrap(0x3ffe0000000000000000000000000000), // price
            fromUint256(1) / fromUint256(100), // quadVar
            0, // startingTub
            2048, // stoppingTub
            fromUint256(1), // liquidityPerTub
            wrap(0x3ffda8279d5ec542062e32b1ef3321b7), // expected token0 = 4.14213618192038190e-01
            wrap(0x3ffe6a04fa7e42f61eea3b22fb569190), // expected token1 = 7.07069232857502997e-01
            true // do the checks
        );
        console.log("lower_half_tub_range_price_5en01 testing done.");
    }

    /*
        function testLimitedRangePour_lower_half_tub_range_price_5en01_sans_checks() public {
            console.log("lower_half_tub_range_price_5en01 starting ......");
            testLimitedRangePour(
                wrap(0x3ffe0000000000000000000000000000), // price
                fromUint256(1)/fromUint256(100), // quadVar
                0, // startingTub
                2048, // stoppingTub
                fromUint256(1), // liquidityPerTub
                wrap(0x3ffda8279d5ec542062e32b1ef3321b7), // expected token0 = 4.14213618192038190e-01
                wrap(0x3ffe6a04fa7e42f61eea3b22fb569190), // expected token1 = 7.07069232857502997e-01
                false // skip the checks
            );
            console.log("lower_half_tub_range_price_5en01 testing done.");
        }
    */

    function testLimitedRangePour_upper_half_tub_range_price_5en01_with_checks() public {
        console.log("upper_half_tub_range_price_5en01 starting ......");
        testLimitedRangePour(
            wrap(0x3ffe0000000000000000000000000000), // price
            fromUint256(1) / fromUint256(100), // quadVar
            2048, // startingTub
            4096, // stoppingTub
            fromUint256(1), // liquidityPerTub
            wrap(0x3ffefffb13269c8ccf0c8a3aaf940e96), // expected token0 = 9.99962423766442059e-01
            POSITIVE_ZERO, // expected token1 = 0e+00
            true // do the checks
        );
        console.log("upper_half_tub_range_price_5en01 testing done.");
    }

    /*
        function testLimitedRangePour_upper_half_tub_range_price_5en01_sans_checks() public {
            console.log("upper_half_tub_range_price_5en01 starting ......");
            testLimitedRangePour(
                wrap(0x3ffe0000000000000000000000000000), // price
                fromUint256(1)/fromUint256(100), // quadVar
                2048, // startingTub
                4096, // stoppingTub
                fromUint256(1), // liquidityPerTub
                wrap(0x3ffefffb13269c8ccf0c8a3aaf940e96), // expected token0 = 9.99962423766442059e-01
                POSITIVE_ZERO, // expected token1 = 0e+00
                false // skip the checks
            );
            console.log("upper_half_tub_range_price_5en01 testing done.");
        }
    */

    function testWholeRangePour_whole_range_price_9_89999999999999999en01_with_checks() public {
        console.log("whole_range_price_9_89999999999999999en01 starting ......");
        testWholeRangePour(
            wrap(0x3ffefae147ae147ae147ae147ae147ae), // price
            fromUint256(1) / fromUint256(100), // quadVar
            fromUint256(1), // liquidityPerTub
            wrap(0x3fff0147b254d12e10e74c26e1c16932), // expected token0 = 1.00500025339822963e+00
            wrap(0x3ffefd6a11ed66c6f647f139d87639d3), // expected token1 = 9.94949875096962021e-01
            true // do the checks
        );
        console.log("whole_range_price_9_89999999999999999en01 testing done.");
    }

    /*
        function testWholeRangePour_whole_range_price_9_89999999999999999en01_sans_checks() public {
            console.log("whole_range_price_9_89999999999999999en01 starting ......");
            testWholeRangePour(
                wrap(0x3ffefae147ae147ae147ae147ae147ae), // price
                fromUint256(1)/fromUint256(100), // quadVar
                fromUint256(1), // liquidityPerTub
                wrap(0x3fff0147b254d12e10e74c26e1c16932), // expected token0 = 1.00500025339822963e+00
                wrap(0x3ffefd6a11ed66c6f647f139d87639d3), // expected token1 = 9.94949875096962021e-01
                false // skip the checks
            );
            console.log("whole_range_price_9_89999999999999999en01 testing done.");
        }
    */

    function testLimitedRangePour_single_tub_low_end_1_price_9_89999999999999999en01_with_checks() public {
        console.log("single_tub_low_end_1_price_9_89999999999999999en01 starting ......");
        testLimitedRangePour(
            wrap(0x3ffefae147ae147ae147ae147ae147ae), // price
            fromUint256(1) / fromUint256(100), // quadVar
            0, // startingTub
            1, // stoppingTub
            fromUint256(1), // liquidityPerTub
            POSITIVE_ZERO, // expected token0 = 0e+00
            wrap(0x3fe89277d353d3eb49cc12ff3691a100), // expected token1 = 1.87413798808594682e-07
            true // do the checks
        );
        console.log("single_tub_low_end_1_price_9_89999999999999999en01 testing done.");
    }

    /*
        function testLimitedRangePour_single_tub_low_end_1_price_9_89999999999999999en01_sans_checks() public {
            console.log("single_tub_low_end_1_price_9_89999999999999999en01 starting ......");
            testLimitedRangePour(
                wrap(0x3ffefae147ae147ae147ae147ae147ae), // price
                fromUint256(1)/fromUint256(100), // quadVar
                0, // startingTub
                1, // stoppingTub
                fromUint256(1), // liquidityPerTub
                POSITIVE_ZERO, // expected token0 = 0e+00
                wrap(0x3fe89277d353d3eb49cc12ff3691a100), // expected token1 = 1.87413798808594682e-07
                false // skip the checks
            );
            console.log("single_tub_low_end_1_price_9_89999999999999999en01 testing done.");
        }
    */

    function testLimitedRangePour_single_tub_low_end_2_price_9_89999999999999999en01_with_checks() public {
        console.log("single_tub_low_end_2_price_9_89999999999999999en01 starting ......");
        testLimitedRangePour(
            wrap(0x3ffefae147ae147ae147ae147ae147ae), // price
            fromUint256(1) / fromUint256(100), // quadVar
            11, // startingTub
            12, // stoppingTub
            fromUint256(1), // liquidityPerTub
            POSITIVE_ZERO, // expected token0 = 0e+00
            wrap(0x3fe8a91b931b07d4bfcb8db7d1235700), // expected token1 = 1.97956205067756075e-07
            true // do the checks
        );
        console.log("single_tub_low_end_2_price_9_89999999999999999en01 testing done.");
    }

    /*
        function testLimitedRangePour_single_tub_low_end_2_price_9_89999999999999999en01_sans_checks() public {
            console.log("single_tub_low_end_2_price_9_89999999999999999en01 starting ......");
            testLimitedRangePour(
                wrap(0x3ffefae147ae147ae147ae147ae147ae), // price
                fromUint256(1)/fromUint256(100), // quadVar
                11, // startingTub
                12, // stoppingTub
                fromUint256(1), // liquidityPerTub
                POSITIVE_ZERO, // expected token0 = 0e+00
                wrap(0x3fe8a91b931b07d4bfcb8db7d1235700), // expected token1 = 1.97956205067756075e-07
                false // skip the checks
            );
            console.log("single_tub_low_end_2_price_9_89999999999999999en01 testing done.");
        }
    */

    function testLimitedRangePour_single_tub_mid_range_price_9_89999999999999999en01_with_checks() public {
        console.log("single_tub_mid_range_price_9_89999999999999999en01 starting ......");
        testLimitedRangePour(
            wrap(0x3ffefae147ae147ae147ae147ae147ae), // price
            fromUint256(1) / fromUint256(100), // quadVar
            2048, // startingTub
            2049, // stoppingTub
            fromUint256(1), // liquidityPerTub
            wrap(0x3ff7453e21be8eb93ffa86ecf1e06080), // expected token0 = 4.96280979001086433e-03
            POSITIVE_ZERO, // expected token1 = 0e+00
            true // do the checks
        );
        console.log("single_tub_mid_range_price_9_89999999999999999en01 testing done.");
    }

    /*
        function testLimitedRangePour_single_tub_mid_range_price_9_89999999999999999en01_sans_checks() public {
            console.log("single_tub_mid_range_price_9_89999999999999999en01 starting ......");
            testLimitedRangePour(
                wrap(0x3ffefae147ae147ae147ae147ae147ae), // price
                fromUint256(1)/fromUint256(100), // quadVar
                2048, // startingTub
                2049, // stoppingTub
                fromUint256(1), // liquidityPerTub
                wrap(0x3ff7453e21be8eb93ffa86ecf1e06080), // expected token0 = 4.96280979001086433e-03
                POSITIVE_ZERO, // expected token1 = 0e+00
                false // skip the checks
            );
            console.log("single_tub_mid_range_price_9_89999999999999999en01 testing done.");
        }
    */

    function testLimitedRangePour_single_tub_high_end_1_price_9_89999999999999999en01_with_checks() public {
        console.log("single_tub_high_end_1_price_9_89999999999999999en01 starting ......");
        testLimitedRangePour(
            wrap(0x3ffefae147ae147ae147ae147ae147ae), // price
            fromUint256(1) / fromUint256(100), // quadVar
            4086, // startingTub
            4087, // stoppingTub
            fromUint256(1), // liquidityPerTub
            wrap(0x3fe8a4e612ea9ac36f5268d469ae6700), // expected token0 = 1.95996242641342649e-07
            POSITIVE_ZERO, // expected token1 = 0e+00
            true // do the checks
        );
        console.log("single_tub_high_end_1_price_9_89999999999999999en01 testing done.");
    }

    /*
        function testLimitedRangePour_single_tub_high_end_1_price_9_89999999999999999en01_sans_checks() public {
            console.log("single_tub_high_end_1_price_9_89999999999999999en01 starting ......");
            testLimitedRangePour(
                wrap(0x3ffefae147ae147ae147ae147ae147ae), // price
                fromUint256(1)/fromUint256(100), // quadVar
                4086, // startingTub
                4087, // stoppingTub
                fromUint256(1), // liquidityPerTub
                wrap(0x3fe8a4e612ea9ac36f5268d469ae6700), // expected token0 = 1.95996242641342649e-07
                POSITIVE_ZERO, // expected token1 = 0e+00
                false // skip the checks
            );
            console.log("single_tub_high_end_1_price_9_89999999999999999en01 testing done.");
        }
    */

    function testLimitedRangePour_single_tub_high_end_2_price_9_89999999999999999en01_with_checks() public {
        console.log("single_tub_high_end_2_price_9_89999999999999999en01 starting ......");
        testLimitedRangePour(
            wrap(0x3ffefae147ae147ae147ae147ae147ae), // price
            fromUint256(1) / fromUint256(100), // quadVar
            4095, // startingTub
            4096, // stoppingTub
            fromUint256(1), // liquidityPerTub
            wrap(0x3fe89277d353d3eb49cc12ff3691a100), // expected token0 = 1.87413798808594682e-07
            POSITIVE_ZERO, // expected token1 = 0e+00
            true // do the checks
        );
        console.log("single_tub_high_end_2_price_9_89999999999999999en01 testing done.");
    }

    /*
        function testLimitedRangePour_single_tub_high_end_2_price_9_89999999999999999en01_sans_checks() public {
            console.log("single_tub_high_end_2_price_9_89999999999999999en01 starting ......");
            testLimitedRangePour(
                wrap(0x3ffefae147ae147ae147ae147ae147ae), // price
                fromUint256(1)/fromUint256(100), // quadVar
                4095, // startingTub
                4096, // stoppingTub
                fromUint256(1), // liquidityPerTub
                wrap(0x3fe89277d353d3eb49cc12ff3691a100), // expected token0 = 1.87413798808594682e-07
                POSITIVE_ZERO, // expected token1 = 0e+00
                false // skip the checks
            );
            console.log("single_tub_high_end_2_price_9_89999999999999999en01 testing done.");
        }
    */

    function testLimitedRangePour_small_tub_range_low_end_1_price_9_89999999999999999en01_with_checks() public {
        console.log("small_tub_range_low_end_1_price_9_89999999999999999en01 starting ......");
        testLimitedRangePour(
            wrap(0x3ffefae147ae147ae147ae147ae147ae), // price
            fromUint256(1) / fromUint256(100), // quadVar
            0, // startingTub
            2, // stoppingTub
            fromUint256(1), // liquidityPerTub
            POSITIVE_ZERO, // expected token0 = 0e+00
            wrap(0x3fe99378c3a9fb2f2fed387476368580), // expected token1 = 3.75762335579409788e-07
            true // do the checks
        );
        console.log("small_tub_range_low_end_1_price_9_89999999999999999en01 testing done.");
    }

    /*
        function testLimitedRangePour_small_tub_range_low_end_1_price_9_89999999999999999en01_sans_checks() public {
            console.log("small_tub_range_low_end_1_price_9_89999999999999999en01 starting ......");
            testLimitedRangePour(
                wrap(0x3ffefae147ae147ae147ae147ae147ae), // price
                fromUint256(1)/fromUint256(100), // quadVar
                0, // startingTub
                2, // stoppingTub
                fromUint256(1), // liquidityPerTub
                POSITIVE_ZERO, // expected token0 = 0e+00
                wrap(0x3fe99378c3a9fb2f2fed387476368580), // expected token1 = 3.75762335579409788e-07
                false // skip the checks
            );
            console.log("small_tub_range_low_end_1_price_9_89999999999999999en01 testing done.");
        }
    */

    function testLimitedRangePour_small_tub_range_low_end_2_price_9_89999999999999999en01_with_checks() public {
        console.log("small_tub_range_low_end_2_price_9_89999999999999999en01 starting ......");
        testLimitedRangePour(
            wrap(0x3ffefae147ae147ae147ae147ae147ae), // price
            fromUint256(1) / fromUint256(100), // quadVar
            11, // startingTub
            13, // stoppingTub
            fromUint256(1), // liquidityPerTub
            POSITIVE_ZERO, // expected token0 = 0e+00
            wrap(0x3fe9aa2af77e94438ee950decc09fa80), // expected token1 = 3.96899729003761018e-07
            true // do the checks
        );
        console.log("small_tub_range_low_end_2_price_9_89999999999999999en01 testing done.");
    }

    /*
        function testLimitedRangePour_small_tub_range_low_end_2_price_9_89999999999999999en01_sans_checks() public {
            console.log("small_tub_range_low_end_2_price_9_89999999999999999en01 starting ......");
            testLimitedRangePour(
                wrap(0x3ffefae147ae147ae147ae147ae147ae), // price
                fromUint256(1)/fromUint256(100), // quadVar
                11, // startingTub
                13, // stoppingTub
                fromUint256(1), // liquidityPerTub
                POSITIVE_ZERO, // expected token0 = 0e+00
                wrap(0x3fe9aa2af77e94438ee950decc09fa80), // expected token1 = 3.96899729003761018e-07
                false // skip the checks
            );
            console.log("small_tub_range_low_end_2_price_9_89999999999999999en01 testing done.");
        }
    */

    function testLimitedRangePour_small_tub_range_midpoint_price_9_89999999999999999en01_with_checks() public {
        console.log("small_tub_range_midpoint_price_9_89999999999999999en01 starting ......");
        testLimitedRangePour(
            wrap(0x3ffefae147ae147ae147ae147ae147ae), // price
            fromUint256(1) / fromUint256(100), // quadVar
            2048, // startingTub
            2050, // stoppingTub
            fromUint256(1), // liquidityPerTub
            wrap(0x3ff8446f86562d9faee41e6a74981440), // expected token0 = 9.90099009900990099e-03
            POSITIVE_ZERO, // expected token1 = 0e+00
            true // do the checks
        );
        console.log("small_tub_range_midpoint_price_9_89999999999999999en01 testing done.");
    }

    /*
        function testLimitedRangePour_small_tub_range_midpoint_price_9_89999999999999999en01_sans_checks() public {
            console.log("small_tub_range_midpoint_price_9_89999999999999999en01 starting ......");
            testLimitedRangePour(
                wrap(0x3ffefae147ae147ae147ae147ae147ae), // price
                fromUint256(1)/fromUint256(100), // quadVar
                2048, // startingTub
                2050, // stoppingTub
                fromUint256(1), // liquidityPerTub
                wrap(0x3ff8446f86562d9faee41e6a74981440), // expected token0 = 9.90099009900990099e-03
                POSITIVE_ZERO, // expected token1 = 0e+00
                false // skip the checks
            );
            console.log("small_tub_range_midpoint_price_9_89999999999999999en01 testing done.");
        }
    */

    function testLimitedRangePour_small_tub_range_high_end_price_9_89999999999999999en01_with_checks() public {
        console.log("small_tub_range_high_end_price_9_89999999999999999en01 starting ......");
        testLimitedRangePour(
            wrap(0x3ffefae147ae147ae147ae147ae147ae), // price
            fromUint256(1) / fromUint256(100), // quadVar
            4094, // startingTub
            4096, // stoppingTub
            fromUint256(1), // liquidityPerTub
            wrap(0x3fe99378c3a9fb2f2fed387476368580), // expected token0 = 3.75762335579409788e-07
            POSITIVE_ZERO, // expected token1 = 0e+00
            true // do the checks
        );
        console.log("small_tub_range_high_end_price_9_89999999999999999en01 testing done.");
    }

    /*
        function testLimitedRangePour_small_tub_range_high_end_price_9_89999999999999999en01_sans_checks() public {
            console.log("small_tub_range_high_end_price_9_89999999999999999en01 starting ......");
            testLimitedRangePour(
                wrap(0x3ffefae147ae147ae147ae147ae147ae), // price
                fromUint256(1)/fromUint256(100), // quadVar
                4094, // startingTub
                4096, // stoppingTub
                fromUint256(1), // liquidityPerTub
                wrap(0x3fe99378c3a9fb2f2fed387476368580), // expected token0 = 3.75762335579409788e-07
                POSITIVE_ZERO, // expected token1 = 0e+00
                false // skip the checks
            );
            console.log("small_tub_range_high_end_price_9_89999999999999999en01 testing done.");
        }
    */

    function testLimitedRangePour_big_tub_lower_range_price_9_89999999999999999en01_with_checks() public {
        console.log("big_tub_lower_range_price_9_89999999999999999en01 starting ......");
        testLimitedRangePour(
            wrap(0x3ffefae147ae147ae147ae147ae147ae), // price
            fromUint256(1) / fromUint256(100), // quadVar
            256, // startingTub
            1792, // stoppingTub
            fromUint256(1), // liquidityPerTub
            POSITIVE_ZERO, // expected token0 = 0e+00
            wrap(0x3ffd1e63770a42ea4f7e9e2311893d4f), // expected token1 = 2.79676303864770324e-01
            true // do the checks
        );
        console.log("big_tub_lower_range_price_9_89999999999999999en01 testing done.");
    }

    /*
        function testLimitedRangePour_big_tub_lower_range_price_9_89999999999999999en01_sans_checks() public {
            console.log("big_tub_lower_range_price_9_89999999999999999en01 starting ......");
            testLimitedRangePour(
                wrap(0x3ffefae147ae147ae147ae147ae147ae), // price
                fromUint256(1)/fromUint256(100), // quadVar
                256, // startingTub
                1792, // stoppingTub
                fromUint256(1), // liquidityPerTub
                POSITIVE_ZERO, // expected token0 = 0e+00
                wrap(0x3ffd1e63770a42ea4f7e9e2311893d4f), // expected token1 = 2.79676303864770324e-01
                false // skip the checks
            );
            console.log("big_tub_lower_range_price_9_89999999999999999en01 testing done.");
        }
    */

    function testLimitedRangePour_big_tub_almost_whole_range_price_9_89999999999999999en01_with_checks() public {
        console.log("big_tub_almost_whole_range_price_9_89999999999999999en01 starting ......");
        testLimitedRangePour(
            wrap(0x3ffefae147ae147ae147ae147ae147ae), // price
            fromUint256(1) / fromUint256(100), // quadVar
            512, // startingTub
            3584, // stoppingTub
            fromUint256(1), // liquidityPerTub
            wrap(0x3fff012ab4bc75491358a6ab9900be11), // expected token0 = 1.00455789185551607e+00
            wrap(0x3ffefd3016bcaefcfb2aa64346f4e391), // expected token1 = 9.94507513554248456e-01
            true // do the checks
        );
        console.log("big_tub_almost_whole_range_price_9_89999999999999999en01 testing done.");
    }

    /*
        function testLimitedRangePour_big_tub_almost_whole_range_price_9_89999999999999999en01_sans_checks() public {
            console.log("big_tub_almost_whole_range_price_9_89999999999999999en01 starting ......");
            testLimitedRangePour(
                wrap(0x3ffefae147ae147ae147ae147ae147ae), // price
                fromUint256(1)/fromUint256(100), // quadVar
                512, // startingTub
                3584, // stoppingTub
                fromUint256(1), // liquidityPerTub
                wrap(0x3fff012ab4bc75491358a6ab9900be11), // expected token0 = 1.00455789185551607e+00
                wrap(0x3ffefd3016bcaefcfb2aa64346f4e391), // expected token1 = 9.94507513554248456e-01
                false // skip the checks
            );
            console.log("big_tub_almost_whole_range_price_9_89999999999999999en01 testing done.");
        }
    */

    function testLimitedRangePour_big_tub_upper_range_price_9_89999999999999999en01_with_checks() public {
        console.log("big_tub_upper_range_price_9_89999999999999999en01 starting ......");
        testLimitedRangePour(
            wrap(0x3ffefae147ae147ae147ae147ae147ae), // price
            fromUint256(1) / fromUint256(100), // quadVar
            2304, // startingTub
            3840, // stoppingTub
            fromUint256(1), // liquidityPerTub
            wrap(0x3ffd1e63770a42ea4f7e9e2311893d4f), // expected token0 = 2.79676303864770324e-01
            POSITIVE_ZERO, // expected token1 = 0e+00
            true // do the checks
        );
        console.log("big_tub_upper_range_price_9_89999999999999999en01 testing done.");
    }

    /*
        function testLimitedRangePour_big_tub_upper_range_price_9_89999999999999999en01_sans_checks() public {
            console.log("big_tub_upper_range_price_9_89999999999999999en01 starting ......");
            testLimitedRangePour(
                wrap(0x3ffefae147ae147ae147ae147ae147ae), // price
                fromUint256(1)/fromUint256(100), // quadVar
                2304, // startingTub
                3840, // stoppingTub
                fromUint256(1), // liquidityPerTub
                wrap(0x3ffd1e63770a42ea4f7e9e2311893d4f), // expected token0 = 2.79676303864770324e-01
                POSITIVE_ZERO, // expected token1 = 0e+00
                false // skip the checks
            );
            console.log("big_tub_upper_range_price_9_89999999999999999en01 testing done.");
        }
    */

    function testLimitedRangePour_lower_half_tub_range_price_9_89999999999999999en01_with_checks() public {
        console.log("lower_half_tub_range_price_9_89999999999999999en01 starting ......");
        testLimitedRangePour(
            wrap(0x3ffefae147ae147ae147ae147ae147ae), // price
            fromUint256(1) / fromUint256(100), // quadVar
            0, // startingTub
            2048, // stoppingTub
            fromUint256(1), // liquidityPerTub
            wrap(0x3ff74a28c182e7a961070989f761e70c), // expected token0 = 5.03782963178757951e-03
            wrap(0x3ffefd6a11ed66c6f647f139d87639d3), // expected token1 = 9.94949875096962021e-01
            true // do the checks
        );
        console.log("lower_half_tub_range_price_9_89999999999999999en01 testing done.");
    }

    /*
        function testLimitedRangePour_lower_half_tub_range_price_9_89999999999999999en01_sans_checks() public {
            console.log("lower_half_tub_range_price_9_89999999999999999en01 starting ......");
            testLimitedRangePour(
                wrap(0x3ffefae147ae147ae147ae147ae147ae), // price
                fromUint256(1)/fromUint256(100), // quadVar
                0, // startingTub
                2048, // stoppingTub
                fromUint256(1), // liquidityPerTub
                wrap(0x3ff74a28c182e7a961070989f761e70c), // expected token0 = 5.03782963178757951e-03
                wrap(0x3ffefd6a11ed66c6f647f139d87639d3), // expected token1 = 9.94949875096962021e-01
                false // skip the checks
            );
            console.log("lower_half_tub_range_price_9_89999999999999999en01 testing done.");
        }
    */

    function testLimitedRangePour_upper_half_tub_range_price_9_89999999999999999en01_with_checks() public {
        console.log("upper_half_tub_range_price_9_89999999999999999en01 starting ......");
        testLimitedRangePour(
            wrap(0x3ffefae147ae147ae147ae147ae147ae), // price
            fromUint256(1) / fromUint256(100), // quadVar
            2048, // startingTub
            4096, // stoppingTub
            fromUint256(1), // liquidityPerTub
            wrap(0x3ffefffb13269c8ccf0c8a3aaf940e96), // expected token0 = 9.99962423766442059e-01
            POSITIVE_ZERO, // expected token1 = 0e+00
            true // do the checks
        );
        console.log("upper_half_tub_range_price_9_89999999999999999en01 testing done.");
    }

    /*
        function testLimitedRangePour_upper_half_tub_range_price_9_89999999999999999en01_sans_checks() public {
            console.log("upper_half_tub_range_price_9_89999999999999999en01 starting ......");
            testLimitedRangePour(
                wrap(0x3ffefae147ae147ae147ae147ae147ae), // price
                fromUint256(1)/fromUint256(100), // quadVar
                2048, // startingTub
                4096, // stoppingTub
                fromUint256(1), // liquidityPerTub
                wrap(0x3ffefffb13269c8ccf0c8a3aaf940e96), // expected token0 = 9.99962423766442059e-01
                POSITIVE_ZERO, // expected token1 = 0e+00
                false // skip the checks
            );
            console.log("upper_half_tub_range_price_9_89999999999999999en01 testing done.");
        }
    */

    function testWholeRangePour_whole_range_price_9_90099009900990099en01_with_checks() public {
        console.log("whole_range_price_9_90099009900990099en01 starting ......");
        testWholeRangePour(
            wrap(0x3ffefaee41e6a74981446f86562d9faf), // price
            fromUint256(1) / fromUint256(100), // quadVar
            fromUint256(1), // liquidityPerTub
            wrap(0x3fff014466fb76c59d0fe43e0731e4ab), // expected token0 = 1.00494998587853108e+00
            wrap(0x3ffefd7096e31f6f5c8c952cd5b04dd4), // expected token1 = 9.94999613976431194e-01
            true // do the checks
        );
        console.log("whole_range_price_9_90099009900990099en01 testing done.");
    }

    /*
        function testWholeRangePour_whole_range_price_9_90099009900990099en01_sans_checks() public {
            console.log("whole_range_price_9_90099009900990099en01 starting ......");
            testWholeRangePour(
                wrap(0x3ffefaee41e6a74981446f86562d9faf), // price
                fromUint256(1)/fromUint256(100), // quadVar
                fromUint256(1), // liquidityPerTub
                wrap(0x3fff014466fb76c59d0fe43e0731e4ab), // expected token0 = 1.00494998587853108e+00
                wrap(0x3ffefd7096e31f6f5c8c952cd5b04dd4), // expected token1 = 9.94999613976431194e-01
                false // skip the checks
            );
            console.log("whole_range_price_9_90099009900990099en01 testing done.");
        }
    */

    function testLimitedRangePour_single_tub_low_end_1_price_9_90099009900990099en01_with_checks() public {
        console.log("single_tub_low_end_1_price_9_90099009900990099en01 starting ......");
        testLimitedRangePour(
            wrap(0x3ffefaee41e6a74981446f86562d9faf), // price
            fromUint256(1) / fromUint256(100), // quadVar
            0, // startingTub
            1, // stoppingTub
            fromUint256(1), // liquidityPerTub
            POSITIVE_ZERO, // expected token0 = 0e+00
            wrap(0x3fe89277d353d3eb49cc12ff3691a100), // expected token1 = 1.87413798808594682e-07
            true // do the checks
        );
        console.log("single_tub_low_end_1_price_9_90099009900990099en01 testing done.");
    }

    /*
        function testLimitedRangePour_single_tub_low_end_1_price_9_90099009900990099en01_sans_checks() public {
            console.log("single_tub_low_end_1_price_9_90099009900990099en01 starting ......");
            testLimitedRangePour(
                wrap(0x3ffefaee41e6a74981446f86562d9faf), // price
                fromUint256(1)/fromUint256(100), // quadVar
                0, // startingTub
                1, // stoppingTub
                fromUint256(1), // liquidityPerTub
                POSITIVE_ZERO, // expected token0 = 0e+00
                wrap(0x3fe89277d353d3eb49cc12ff3691a100), // expected token1 = 1.87413798808594682e-07
                false // skip the checks
            );
            console.log("single_tub_low_end_1_price_9_90099009900990099en01 testing done.");
        }
    */

    function testLimitedRangePour_single_tub_low_end_2_price_9_90099009900990099en01_with_checks() public {
        console.log("single_tub_low_end_2_price_9_90099009900990099en01 starting ......");
        testLimitedRangePour(
            wrap(0x3ffefaee41e6a74981446f86562d9faf), // price
            fromUint256(1) / fromUint256(100), // quadVar
            11, // startingTub
            12, // stoppingTub
            fromUint256(1), // liquidityPerTub
            POSITIVE_ZERO, // expected token0 = 0e+00
            wrap(0x3fe8a91b931b07d4bfcb8db7d1235700), // expected token1 = 1.97956205067756075e-07
            true // do the checks
        );
        console.log("single_tub_low_end_2_price_9_90099009900990099en01 testing done.");
    }

    /*
        function testLimitedRangePour_single_tub_low_end_2_price_9_90099009900990099en01_sans_checks() public {
            console.log("single_tub_low_end_2_price_9_90099009900990099en01 starting ......");
            testLimitedRangePour(
                wrap(0x3ffefaee41e6a74981446f86562d9faf), // price
                fromUint256(1)/fromUint256(100), // quadVar
                11, // startingTub
                12, // stoppingTub
                fromUint256(1), // liquidityPerTub
                POSITIVE_ZERO, // expected token0 = 0e+00
                wrap(0x3fe8a91b931b07d4bfcb8db7d1235700), // expected token1 = 1.97956205067756075e-07
                false // skip the checks
            );
            console.log("single_tub_low_end_2_price_9_90099009900990099en01 testing done.");
        }
    */

    function testLimitedRangePour_single_tub_mid_range_price_9_90099009900990099en01_with_checks() public {
        console.log("single_tub_mid_range_price_9_90099009900990099en01 starting ......");
        testLimitedRangePour(
            wrap(0x3ffefaee41e6a74981446f86562d9faf), // price
            fromUint256(1) / fromUint256(100), // quadVar
            2048, // startingTub
            2049, // stoppingTub
            fromUint256(1), // liquidityPerTub
            wrap(0x3ff7453e21be8eb93ffa86ecf1e06080), // expected token0 = 4.96280979001086433e-03
            POSITIVE_ZERO, // expected token1 = 0e+00
            true // do the checks
        );
        console.log("single_tub_mid_range_price_9_90099009900990099en01 testing done.");
    }

    /*
        function testLimitedRangePour_single_tub_mid_range_price_9_90099009900990099en01_sans_checks() public {
            console.log("single_tub_mid_range_price_9_90099009900990099en01 starting ......");
            testLimitedRangePour(
                wrap(0x3ffefaee41e6a74981446f86562d9faf), // price
                fromUint256(1)/fromUint256(100), // quadVar
                2048, // startingTub
                2049, // stoppingTub
                fromUint256(1), // liquidityPerTub
                wrap(0x3ff7453e21be8eb93ffa86ecf1e06080), // expected token0 = 4.96280979001086433e-03
                POSITIVE_ZERO, // expected token1 = 0e+00
                false // skip the checks
            );
            console.log("single_tub_mid_range_price_9_90099009900990099en01 testing done.");
        }
    */

    function testLimitedRangePour_single_tub_high_end_1_price_9_90099009900990099en01_with_checks() public {
        console.log("single_tub_high_end_1_price_9_90099009900990099en01 starting ......");
        testLimitedRangePour(
            wrap(0x3ffefaee41e6a74981446f86562d9faf), // price
            fromUint256(1) / fromUint256(100), // quadVar
            4086, // startingTub
            4087, // stoppingTub
            fromUint256(1), // liquidityPerTub
            wrap(0x3fe8a4e612ea9ac36f5268d469ae6700), // expected token0 = 1.95996242641342649e-07
            POSITIVE_ZERO, // expected token1 = 0e+00
            true // do the checks
        );
        console.log("single_tub_high_end_1_price_9_90099009900990099en01 testing done.");
    }

    /*
        function testLimitedRangePour_single_tub_high_end_1_price_9_90099009900990099en01_sans_checks() public {
            console.log("single_tub_high_end_1_price_9_90099009900990099en01 starting ......");
            testLimitedRangePour(
                wrap(0x3ffefaee41e6a74981446f86562d9faf), // price
                fromUint256(1)/fromUint256(100), // quadVar
                4086, // startingTub
                4087, // stoppingTub
                fromUint256(1), // liquidityPerTub
                wrap(0x3fe8a4e612ea9ac36f5268d469ae6700), // expected token0 = 1.95996242641342649e-07
                POSITIVE_ZERO, // expected token1 = 0e+00
                false // skip the checks
            );
            console.log("single_tub_high_end_1_price_9_90099009900990099en01 testing done.");
        }
    */

    function testLimitedRangePour_single_tub_high_end_2_price_9_90099009900990099en01_with_checks() public {
        console.log("single_tub_high_end_2_price_9_90099009900990099en01 starting ......");
        testLimitedRangePour(
            wrap(0x3ffefaee41e6a74981446f86562d9faf), // price
            fromUint256(1) / fromUint256(100), // quadVar
            4095, // startingTub
            4096, // stoppingTub
            fromUint256(1), // liquidityPerTub
            wrap(0x3fe89277d353d3eb49cc12ff3691a100), // expected token0 = 1.87413798808594682e-07
            POSITIVE_ZERO, // expected token1 = 0e+00
            true // do the checks
        );
        console.log("single_tub_high_end_2_price_9_90099009900990099en01 testing done.");
    }

    /*
        function testLimitedRangePour_single_tub_high_end_2_price_9_90099009900990099en01_sans_checks() public {
            console.log("single_tub_high_end_2_price_9_90099009900990099en01 starting ......");
            testLimitedRangePour(
                wrap(0x3ffefaee41e6a74981446f86562d9faf), // price
                fromUint256(1)/fromUint256(100), // quadVar
                4095, // startingTub
                4096, // stoppingTub
                fromUint256(1), // liquidityPerTub
                wrap(0x3fe89277d353d3eb49cc12ff3691a100), // expected token0 = 1.87413798808594682e-07
                POSITIVE_ZERO, // expected token1 = 0e+00
                false // skip the checks
            );
            console.log("single_tub_high_end_2_price_9_90099009900990099en01 testing done.");
        }
    */

    function testLimitedRangePour_small_tub_range_low_end_1_price_9_90099009900990099en01_with_checks() public {
        console.log("small_tub_range_low_end_1_price_9_90099009900990099en01 starting ......");
        testLimitedRangePour(
            wrap(0x3ffefaee41e6a74981446f86562d9faf), // price
            fromUint256(1) / fromUint256(100), // quadVar
            0, // startingTub
            2, // stoppingTub
            fromUint256(1), // liquidityPerTub
            POSITIVE_ZERO, // expected token0 = 0e+00
            wrap(0x3fe99378c3a9fb2f2fed387476368580), // expected token1 = 3.75762335579409788e-07
            true // do the checks
        );
        console.log("small_tub_range_low_end_1_price_9_90099009900990099en01 testing done.");
    }

    /*
        function testLimitedRangePour_small_tub_range_low_end_1_price_9_90099009900990099en01_sans_checks() public {
            console.log("small_tub_range_low_end_1_price_9_90099009900990099en01 starting ......");
            testLimitedRangePour(
                wrap(0x3ffefaee41e6a74981446f86562d9faf), // price
                fromUint256(1)/fromUint256(100), // quadVar
                0, // startingTub
                2, // stoppingTub
                fromUint256(1), // liquidityPerTub
                POSITIVE_ZERO, // expected token0 = 0e+00
                wrap(0x3fe99378c3a9fb2f2fed387476368580), // expected token1 = 3.75762335579409788e-07
                false // skip the checks
            );
            console.log("small_tub_range_low_end_1_price_9_90099009900990099en01 testing done.");
        }
    */

    function testLimitedRangePour_small_tub_range_low_end_2_price_9_90099009900990099en01_with_checks() public {
        console.log("small_tub_range_low_end_2_price_9_90099009900990099en01 starting ......");
        testLimitedRangePour(
            wrap(0x3ffefaee41e6a74981446f86562d9faf), // price
            fromUint256(1) / fromUint256(100), // quadVar
            11, // startingTub
            13, // stoppingTub
            fromUint256(1), // liquidityPerTub
            POSITIVE_ZERO, // expected token0 = 0e+00
            wrap(0x3fe9aa2af77e94438ee950decc09fa80), // expected token1 = 3.96899729003761018e-07
            true // do the checks
        );
        console.log("small_tub_range_low_end_2_price_9_90099009900990099en01 testing done.");
    }

    /*
        function testLimitedRangePour_small_tub_range_low_end_2_price_9_90099009900990099en01_sans_checks() public {
            console.log("small_tub_range_low_end_2_price_9_90099009900990099en01 starting ......");
            testLimitedRangePour(
                wrap(0x3ffefaee41e6a74981446f86562d9faf), // price
                fromUint256(1)/fromUint256(100), // quadVar
                11, // startingTub
                13, // stoppingTub
                fromUint256(1), // liquidityPerTub
                POSITIVE_ZERO, // expected token0 = 0e+00
                wrap(0x3fe9aa2af77e94438ee950decc09fa80), // expected token1 = 3.96899729003761018e-07
                false // skip the checks
            );
            console.log("small_tub_range_low_end_2_price_9_90099009900990099en01 testing done.");
        }
    */

    function testLimitedRangePour_small_tub_range_midpoint_price_9_90099009900990099en01_with_checks() public {
        console.log("small_tub_range_midpoint_price_9_90099009900990099en01 starting ......");
        testLimitedRangePour(
            wrap(0x3ffefaee41e6a74981446f86562d9faf), // price
            fromUint256(1) / fromUint256(100), // quadVar
            2048, // startingTub
            2050, // stoppingTub
            fromUint256(1), // liquidityPerTub
            wrap(0x3ff8446f86562d9faee41e6a74981440), // expected token0 = 9.90099009900990099e-03
            POSITIVE_ZERO, // expected token1 = 0e+00
            true // do the checks
        );
        console.log("small_tub_range_midpoint_price_9_90099009900990099en01 testing done.");
    }

    /*
        function testLimitedRangePour_small_tub_range_midpoint_price_9_90099009900990099en01_sans_checks() public {
            console.log("small_tub_range_midpoint_price_9_90099009900990099en01 starting ......");
            testLimitedRangePour(
                wrap(0x3ffefaee41e6a74981446f86562d9faf), // price
                fromUint256(1)/fromUint256(100), // quadVar
                2048, // startingTub
                2050, // stoppingTub
                fromUint256(1), // liquidityPerTub
                wrap(0x3ff8446f86562d9faee41e6a74981440), // expected token0 = 9.90099009900990099e-03
                POSITIVE_ZERO, // expected token1 = 0e+00
                false // skip the checks
            );
            console.log("small_tub_range_midpoint_price_9_90099009900990099en01 testing done.");
        }
    */

    function testLimitedRangePour_small_tub_range_high_end_price_9_90099009900990099en01_with_checks() public {
        console.log("small_tub_range_high_end_price_9_90099009900990099en01 starting ......");
        testLimitedRangePour(
            wrap(0x3ffefaee41e6a74981446f86562d9faf), // price
            fromUint256(1) / fromUint256(100), // quadVar
            4094, // startingTub
            4096, // stoppingTub
            fromUint256(1), // liquidityPerTub
            wrap(0x3fe99378c3a9fb2f2fed387476368580), // expected token0 = 3.75762335579409788e-07
            POSITIVE_ZERO, // expected token1 = 0e+00
            true // do the checks
        );
        console.log("small_tub_range_high_end_price_9_90099009900990099en01 testing done.");
    }

    /*
        function testLimitedRangePour_small_tub_range_high_end_price_9_90099009900990099en01_sans_checks() public {
            console.log("small_tub_range_high_end_price_9_90099009900990099en01 starting ......");
            testLimitedRangePour(
                wrap(0x3ffefaee41e6a74981446f86562d9faf), // price
                fromUint256(1)/fromUint256(100), // quadVar
                4094, // startingTub
                4096, // stoppingTub
                fromUint256(1), // liquidityPerTub
                wrap(0x3fe99378c3a9fb2f2fed387476368580), // expected token0 = 3.75762335579409788e-07
                POSITIVE_ZERO, // expected token1 = 0e+00
                false // skip the checks
            );
            console.log("small_tub_range_high_end_price_9_90099009900990099en01 testing done.");
        }
    */

    function testLimitedRangePour_big_tub_lower_range_price_9_90099009900990099en01_with_checks() public {
        console.log("big_tub_lower_range_price_9_90099009900990099en01 starting ......");
        testLimitedRangePour(
            wrap(0x3ffefaee41e6a74981446f86562d9faf), // price
            fromUint256(1) / fromUint256(100), // quadVar
            256, // startingTub
            1792, // stoppingTub
            fromUint256(1), // liquidityPerTub
            POSITIVE_ZERO, // expected token0 = 0e+00
            wrap(0x3ffd1e63770a42ea4f7e9e2311893d4f), // expected token1 = 2.79676303864770324e-01
            true // do the checks
        );
        console.log("big_tub_lower_range_price_9_90099009900990099en01 testing done.");
    }

    /*
        function testLimitedRangePour_big_tub_lower_range_price_9_90099009900990099en01_sans_checks() public {
            console.log("big_tub_lower_range_price_9_90099009900990099en01 starting ......");
            testLimitedRangePour(
                wrap(0x3ffefaee41e6a74981446f86562d9faf), // price
                fromUint256(1)/fromUint256(100), // quadVar
                256, // startingTub
                1792, // stoppingTub
                fromUint256(1), // liquidityPerTub
                POSITIVE_ZERO, // expected token0 = 0e+00
                wrap(0x3ffd1e63770a42ea4f7e9e2311893d4f), // expected token1 = 2.79676303864770324e-01
                false // skip the checks
            );
            console.log("big_tub_lower_range_price_9_90099009900990099en01 testing done.");
        }
    */

    function testLimitedRangePour_big_tub_almost_whole_range_price_9_90099009900990099en01_with_checks() public {
        console.log("big_tub_almost_whole_range_price_9_90099009900990099en01 starting ......");
        testLimitedRangePour(
            wrap(0x3ffefaee41e6a74981446f86562d9faf), // price
            fromUint256(1) / fromUint256(100), // quadVar
            512, // startingTub
            3584, // stoppingTub
            fromUint256(1), // liquidityPerTub
            wrap(0x3fff012769631ae09f813ec2be71398a), // expected token0 = 1.00450762433581752e+00
            wrap(0x3ffefd369bb267a5616f4a36442ef792), // expected token1 = 9.94557252433717630e-01
            true // do the checks
        );
        console.log("big_tub_almost_whole_range_price_9_90099009900990099en01 testing done.");
    }

    /*
        function testLimitedRangePour_big_tub_almost_whole_range_price_9_90099009900990099en01_sans_checks() public {
            console.log("big_tub_almost_whole_range_price_9_90099009900990099en01 starting ......");
            testLimitedRangePour(
                wrap(0x3ffefaee41e6a74981446f86562d9faf), // price
                fromUint256(1)/fromUint256(100), // quadVar
                512, // startingTub
                3584, // stoppingTub
                fromUint256(1), // liquidityPerTub
                wrap(0x3fff012769631ae09f813ec2be71398a), // expected token0 = 1.00450762433581752e+00
                wrap(0x3ffefd369bb267a5616f4a36442ef792), // expected token1 = 9.94557252433717630e-01
                false // skip the checks
            );
            console.log("big_tub_almost_whole_range_price_9_90099009900990099en01 testing done.");
        }
    */

    function testLimitedRangePour_big_tub_upper_range_price_9_90099009900990099en01_with_checks() public {
        console.log("big_tub_upper_range_price_9_90099009900990099en01 starting ......");
        testLimitedRangePour(
            wrap(0x3ffefaee41e6a74981446f86562d9faf), // price
            fromUint256(1) / fromUint256(100), // quadVar
            2304, // startingTub
            3840, // stoppingTub
            fromUint256(1), // liquidityPerTub
            wrap(0x3ffd1e63770a42ea4f7e9e2311893d4f), // expected token0 = 2.79676303864770324e-01
            POSITIVE_ZERO, // expected token1 = 0e+00
            true // do the checks
        );
        console.log("big_tub_upper_range_price_9_90099009900990099en01 testing done.");
    }

    /*
        function testLimitedRangePour_big_tub_upper_range_price_9_90099009900990099en01_sans_checks() public {
            console.log("big_tub_upper_range_price_9_90099009900990099en01 starting ......");
            testLimitedRangePour(
                wrap(0x3ffefaee41e6a74981446f86562d9faf), // price
                fromUint256(1)/fromUint256(100), // quadVar
                2304, // startingTub
                3840, // stoppingTub
                fromUint256(1), // liquidityPerTub
                wrap(0x3ffd1e63770a42ea4f7e9e2311893d4f), // expected token0 = 2.79676303864770324e-01
                POSITIVE_ZERO, // expected token1 = 0e+00
                false // skip the checks
            );
            console.log("big_tub_upper_range_price_9_90099009900990099en01 testing done.");
        }
    */

    function testLimitedRangePour_lower_half_tub_range_price_9_90099009900990099en01_with_checks() public {
        console.log("lower_half_tub_range_price_9_90099009900990099en01 starting ......");
        testLimitedRangePour(
            wrap(0x3ffefaee41e6a74981446f86562d9faf), // price
            fromUint256(1) / fromUint256(100), // quadVar
            0, // startingTub
            2048, // stoppingTub
            fromUint256(1), // liquidityPerTub
            wrap(0x3ff746dd68287f35899f20af67dd6000), // expected token0 = 4.98756211208902702e-03
            wrap(0x3ffefd7096e31f6f5c8c952cd5b04dd4), // expected token1 = 9.94999613976431194e-01
            true // do the checks
        );
        console.log("lower_half_tub_range_price_9_90099009900990099en01 testing done.");
    }

    /*
        function testLimitedRangePour_lower_half_tub_range_price_9_90099009900990099en01_sans_checks() public {
            console.log("lower_half_tub_range_price_9_90099009900990099en01 starting ......");
            testLimitedRangePour(
                wrap(0x3ffefaee41e6a74981446f86562d9faf), // price
                fromUint256(1)/fromUint256(100), // quadVar
                0, // startingTub
                2048, // stoppingTub
                fromUint256(1), // liquidityPerTub
                wrap(0x3ff746dd68287f35899f20af67dd6000), // expected token0 = 4.98756211208902702e-03
                wrap(0x3ffefd7096e31f6f5c8c952cd5b04dd4), // expected token1 = 9.94999613976431194e-01
                false // skip the checks
            );
            console.log("lower_half_tub_range_price_9_90099009900990099en01 testing done.");
        }
    */

    function testLimitedRangePour_upper_half_tub_range_price_9_90099009900990099en01_with_checks() public {
        console.log("upper_half_tub_range_price_9_90099009900990099en01 starting ......");
        testLimitedRangePour(
            wrap(0x3ffefaee41e6a74981446f86562d9faf), // price
            fromUint256(1) / fromUint256(100), // quadVar
            2048, // startingTub
            4096, // stoppingTub
            fromUint256(1), // liquidityPerTub
            wrap(0x3ffefffb13269c8ccf0c8a3aaf940e96), // expected token0 = 9.99962423766442059e-01
            POSITIVE_ZERO, // expected token1 = 0e+00
            true // do the checks
        );
        console.log("upper_half_tub_range_price_9_90099009900990099en01 testing done.");
    }

    /*
        function testLimitedRangePour_upper_half_tub_range_price_9_90099009900990099en01_sans_checks() public {
            console.log("upper_half_tub_range_price_9_90099009900990099en01 starting ......");
            testLimitedRangePour(
                wrap(0x3ffefaee41e6a74981446f86562d9faf), // price
                fromUint256(1)/fromUint256(100), // quadVar
                2048, // startingTub
                4096, // stoppingTub
                fromUint256(1), // liquidityPerTub
                wrap(0x3ffefffb13269c8ccf0c8a3aaf940e96), // expected token0 = 9.99962423766442059e-01
                POSITIVE_ZERO, // expected token1 = 0e+00
                false // skip the checks
            );
            console.log("upper_half_tub_range_price_9_90099009900990099en01 testing done.");
        }
    */

    function testWholeRangePour_whole_range_price_1ep00_with_checks() public {
        console.log("whole_range_price_1ep00 starting ......");
        testWholeRangePour(
            wrap(0x3fff0000000000000000000000000000), // price
            fromUint256(1) / fromUint256(100), // quadVar
            fromUint256(1), // liquidityPerTub
            wrap(0x3ffefffb13269c8ccf0c8a3aaf940e96), // expected token0 = 9.99962423766442059e-01
            wrap(0x3ffefffb13269c8ccf0c8a3aaf940e96), // expected token1 = 9.99962423766442059e-01
            true // do the checks
        );
        console.log("whole_range_price_1ep00 testing done.");
    }

    /*
        function testWholeRangePour_whole_range_price_1ep00_sans_checks() public {
            console.log("whole_range_price_1ep00 starting ......");
            testWholeRangePour(
                wrap(0x3fff0000000000000000000000000000), // price
                fromUint256(1)/fromUint256(100), // quadVar
                fromUint256(1), // liquidityPerTub
                wrap(0x3ffefffb13269c8ccf0c8a3aaf940e96), // expected token0 = 9.99962423766442059e-01
                wrap(0x3ffefffb13269c8ccf0c8a3aaf940e96), // expected token1 = 9.99962423766442059e-01
                false // skip the checks
            );
            console.log("whole_range_price_1ep00 testing done.");
        }
    */

    function testLimitedRangePour_single_tub_low_end_1_price_1ep00_with_checks() public {
        console.log("single_tub_low_end_1_price_1ep00 starting ......");
        testLimitedRangePour(
            wrap(0x3fff0000000000000000000000000000), // price
            fromUint256(1) / fromUint256(100), // quadVar
            0, // startingTub
            1, // stoppingTub
            fromUint256(1), // liquidityPerTub
            POSITIVE_ZERO, // expected token0 = 0e+00
            wrap(0x3fe89277d353d3eb49cc12ff3691a100), // expected token1 = 1.87413798808594682e-07
            true // do the checks
        );
        console.log("single_tub_low_end_1_price_1ep00 testing done.");
    }

    /*
        function testLimitedRangePour_single_tub_low_end_1_price_1ep00_sans_checks() public {
            console.log("single_tub_low_end_1_price_1ep00 starting ......");
            testLimitedRangePour(
                wrap(0x3fff0000000000000000000000000000), // price
                fromUint256(1)/fromUint256(100), // quadVar
                0, // startingTub
                1, // stoppingTub
                fromUint256(1), // liquidityPerTub
                POSITIVE_ZERO, // expected token0 = 0e+00
                wrap(0x3fe89277d353d3eb49cc12ff3691a100), // expected token1 = 1.87413798808594682e-07
                false // skip the checks
            );
            console.log("single_tub_low_end_1_price_1ep00 testing done.");
        }
    */

    function testLimitedRangePour_single_tub_low_end_2_price_1ep00_with_checks() public {
        console.log("single_tub_low_end_2_price_1ep00 starting ......");
        testLimitedRangePour(
            wrap(0x3fff0000000000000000000000000000), // price
            fromUint256(1) / fromUint256(100), // quadVar
            11, // startingTub
            12, // stoppingTub
            fromUint256(1), // liquidityPerTub
            POSITIVE_ZERO, // expected token0 = 0e+00
            wrap(0x3fe8a91b931b07d4bfcb8db7d1235700), // expected token1 = 1.97956205067756075e-07
            true // do the checks
        );
        console.log("single_tub_low_end_2_price_1ep00 testing done.");
    }

    /*
        function testLimitedRangePour_single_tub_low_end_2_price_1ep00_sans_checks() public {
            console.log("single_tub_low_end_2_price_1ep00 starting ......");
            testLimitedRangePour(
                wrap(0x3fff0000000000000000000000000000), // price
                fromUint256(1)/fromUint256(100), // quadVar
                11, // startingTub
                12, // stoppingTub
                fromUint256(1), // liquidityPerTub
                POSITIVE_ZERO, // expected token0 = 0e+00
                wrap(0x3fe8a91b931b07d4bfcb8db7d1235700), // expected token1 = 1.97956205067756075e-07
                false // skip the checks
            );
            console.log("single_tub_low_end_2_price_1ep00 testing done.");
        }
    */

    function testLimitedRangePour_single_tub_mid_range_price_1ep00_with_checks() public {
        console.log("single_tub_mid_range_price_1ep00 starting ......");
        testLimitedRangePour(
            wrap(0x3fff0000000000000000000000000000), // price
            fromUint256(1) / fromUint256(100), // quadVar
            2048, // startingTub
            2049, // stoppingTub
            fromUint256(1), // liquidityPerTub
            wrap(0x3ff7453e21be8eb93ffa86ecf1e06080), // expected token0 = 4.96280979001086433e-03
            POSITIVE_ZERO, // expected token1 = 0e+00
            true // do the checks
        );
        console.log("single_tub_mid_range_price_1ep00 testing done.");
    }

    /*
        function testLimitedRangePour_single_tub_mid_range_price_1ep00_sans_checks() public {
            console.log("single_tub_mid_range_price_1ep00 starting ......");
            testLimitedRangePour(
                wrap(0x3fff0000000000000000000000000000), // price
                fromUint256(1)/fromUint256(100), // quadVar
                2048, // startingTub
                2049, // stoppingTub
                fromUint256(1), // liquidityPerTub
                wrap(0x3ff7453e21be8eb93ffa86ecf1e06080), // expected token0 = 4.96280979001086433e-03
                POSITIVE_ZERO, // expected token1 = 0e+00
                false // skip the checks
            );
            console.log("single_tub_mid_range_price_1ep00 testing done.");
        }
    */

    function testLimitedRangePour_single_tub_high_end_1_price_1ep00_with_checks() public {
        console.log("single_tub_high_end_1_price_1ep00 starting ......");
        testLimitedRangePour(
            wrap(0x3fff0000000000000000000000000000), // price
            fromUint256(1) / fromUint256(100), // quadVar
            4086, // startingTub
            4087, // stoppingTub
            fromUint256(1), // liquidityPerTub
            wrap(0x3fe8a4e612ea9ac36f5268d469ae6700), // expected token0 = 1.95996242641342649e-07
            POSITIVE_ZERO, // expected token1 = 0e+00
            true // do the checks
        );
        console.log("single_tub_high_end_1_price_1ep00 testing done.");
    }

    /*
        function testLimitedRangePour_single_tub_high_end_1_price_1ep00_sans_checks() public {
            console.log("single_tub_high_end_1_price_1ep00 starting ......");
            testLimitedRangePour(
                wrap(0x3fff0000000000000000000000000000), // price
                fromUint256(1)/fromUint256(100), // quadVar
                4086, // startingTub
                4087, // stoppingTub
                fromUint256(1), // liquidityPerTub
                wrap(0x3fe8a4e612ea9ac36f5268d469ae6700), // expected token0 = 1.95996242641342649e-07
                POSITIVE_ZERO, // expected token1 = 0e+00
                false // skip the checks
            );
            console.log("single_tub_high_end_1_price_1ep00 testing done.");
        }
    */

    function testLimitedRangePour_single_tub_high_end_2_price_1ep00_with_checks() public {
        console.log("single_tub_high_end_2_price_1ep00 starting ......");
        testLimitedRangePour(
            wrap(0x3fff0000000000000000000000000000), // price
            fromUint256(1) / fromUint256(100), // quadVar
            4095, // startingTub
            4096, // stoppingTub
            fromUint256(1), // liquidityPerTub
            wrap(0x3fe89277d353d3eb49cc12ff3691a100), // expected token0 = 1.87413798808594682e-07
            POSITIVE_ZERO, // expected token1 = 0e+00
            true // do the checks
        );
        console.log("single_tub_high_end_2_price_1ep00 testing done.");
    }

    /*
        function testLimitedRangePour_single_tub_high_end_2_price_1ep00_sans_checks() public {
            console.log("single_tub_high_end_2_price_1ep00 starting ......");
            testLimitedRangePour(
                wrap(0x3fff0000000000000000000000000000), // price
                fromUint256(1)/fromUint256(100), // quadVar
                4095, // startingTub
                4096, // stoppingTub
                fromUint256(1), // liquidityPerTub
                wrap(0x3fe89277d353d3eb49cc12ff3691a100), // expected token0 = 1.87413798808594682e-07
                POSITIVE_ZERO, // expected token1 = 0e+00
                false // skip the checks
            );
            console.log("single_tub_high_end_2_price_1ep00 testing done.");
        }
    */

    function testLimitedRangePour_small_tub_range_low_end_1_price_1ep00_with_checks() public {
        console.log("small_tub_range_low_end_1_price_1ep00 starting ......");
        testLimitedRangePour(
            wrap(0x3fff0000000000000000000000000000), // price
            fromUint256(1) / fromUint256(100), // quadVar
            0, // startingTub
            2, // stoppingTub
            fromUint256(1), // liquidityPerTub
            POSITIVE_ZERO, // expected token0 = 0e+00
            wrap(0x3fe99378c3a9fb2f2fed387476368580), // expected token1 = 3.75762335579409788e-07
            true // do the checks
        );
        console.log("small_tub_range_low_end_1_price_1ep00 testing done.");
    }

    /*
        function testLimitedRangePour_small_tub_range_low_end_1_price_1ep00_sans_checks() public {
            console.log("small_tub_range_low_end_1_price_1ep00 starting ......");
            testLimitedRangePour(
                wrap(0x3fff0000000000000000000000000000), // price
                fromUint256(1)/fromUint256(100), // quadVar
                0, // startingTub
                2, // stoppingTub
                fromUint256(1), // liquidityPerTub
                POSITIVE_ZERO, // expected token0 = 0e+00
                wrap(0x3fe99378c3a9fb2f2fed387476368580), // expected token1 = 3.75762335579409788e-07
                false // skip the checks
            );
            console.log("small_tub_range_low_end_1_price_1ep00 testing done.");
        }
    */

    function testLimitedRangePour_small_tub_range_low_end_2_price_1ep00_with_checks() public {
        console.log("small_tub_range_low_end_2_price_1ep00 starting ......");
        testLimitedRangePour(
            wrap(0x3fff0000000000000000000000000000), // price
            fromUint256(1) / fromUint256(100), // quadVar
            11, // startingTub
            13, // stoppingTub
            fromUint256(1), // liquidityPerTub
            POSITIVE_ZERO, // expected token0 = 0e+00
            wrap(0x3fe9aa2af77e94438ee950decc09fa80), // expected token1 = 3.96899729003761018e-07
            true // do the checks
        );
        console.log("small_tub_range_low_end_2_price_1ep00 testing done.");
    }

    /*
        function testLimitedRangePour_small_tub_range_low_end_2_price_1ep00_sans_checks() public {
            console.log("small_tub_range_low_end_2_price_1ep00 starting ......");
            testLimitedRangePour(
                wrap(0x3fff0000000000000000000000000000), // price
                fromUint256(1)/fromUint256(100), // quadVar
                11, // startingTub
                13, // stoppingTub
                fromUint256(1), // liquidityPerTub
                POSITIVE_ZERO, // expected token0 = 0e+00
                wrap(0x3fe9aa2af77e94438ee950decc09fa80), // expected token1 = 3.96899729003761018e-07
                false // skip the checks
            );
            console.log("small_tub_range_low_end_2_price_1ep00 testing done.");
        }
    */

    function testLimitedRangePour_small_tub_range_midpoint_price_1ep00_with_checks() public {
        console.log("small_tub_range_midpoint_price_1ep00 starting ......");
        testLimitedRangePour(
            wrap(0x3fff0000000000000000000000000000), // price
            fromUint256(1) / fromUint256(100), // quadVar
            2048, // startingTub
            2050, // stoppingTub
            fromUint256(1), // liquidityPerTub
            wrap(0x3ff8446f86562d9faee41e6a74981440), // expected token0 = 9.90099009900990099e-03
            POSITIVE_ZERO, // expected token1 = 0e+00
            true // do the checks
        );
        console.log("small_tub_range_midpoint_price_1ep00 testing done.");
    }

    /*
        function testLimitedRangePour_small_tub_range_midpoint_price_1ep00_sans_checks() public {
            console.log("small_tub_range_midpoint_price_1ep00 starting ......");
            testLimitedRangePour(
                wrap(0x3fff0000000000000000000000000000), // price
                fromUint256(1)/fromUint256(100), // quadVar
                2048, // startingTub
                2050, // stoppingTub
                fromUint256(1), // liquidityPerTub
                wrap(0x3ff8446f86562d9faee41e6a74981440), // expected token0 = 9.90099009900990099e-03
                POSITIVE_ZERO, // expected token1 = 0e+00
                false // skip the checks
            );
            console.log("small_tub_range_midpoint_price_1ep00 testing done.");
        }
    */

    function testLimitedRangePour_small_tub_range_high_end_price_1ep00_with_checks() public {
        console.log("small_tub_range_high_end_price_1ep00 starting ......");
        testLimitedRangePour(
            wrap(0x3fff0000000000000000000000000000), // price
            fromUint256(1) / fromUint256(100), // quadVar
            4094, // startingTub
            4096, // stoppingTub
            fromUint256(1), // liquidityPerTub
            wrap(0x3fe99378c3a9fb2f2fed387476368580), // expected token0 = 3.75762335579409788e-07
            POSITIVE_ZERO, // expected token1 = 0e+00
            true // do the checks
        );
        console.log("small_tub_range_high_end_price_1ep00 testing done.");
    }

    /*
        function testLimitedRangePour_small_tub_range_high_end_price_1ep00_sans_checks() public {
            console.log("small_tub_range_high_end_price_1ep00 starting ......");
            testLimitedRangePour(
                wrap(0x3fff0000000000000000000000000000), // price
                fromUint256(1)/fromUint256(100), // quadVar
                4094, // startingTub
                4096, // stoppingTub
                fromUint256(1), // liquidityPerTub
                wrap(0x3fe99378c3a9fb2f2fed387476368580), // expected token0 = 3.75762335579409788e-07
                POSITIVE_ZERO, // expected token1 = 0e+00
                false // skip the checks
            );
            console.log("small_tub_range_high_end_price_1ep00 testing done.");
        }
    */

    function testLimitedRangePour_big_tub_lower_range_price_1ep00_with_checks() public {
        console.log("big_tub_lower_range_price_1ep00 starting ......");
        testLimitedRangePour(
            wrap(0x3fff0000000000000000000000000000), // price
            fromUint256(1) / fromUint256(100), // quadVar
            256, // startingTub
            1792, // stoppingTub
            fromUint256(1), // liquidityPerTub
            POSITIVE_ZERO, // expected token0 = 0e+00
            wrap(0x3ffd1e63770a42ea4f7e9e2311893d4f), // expected token1 = 2.79676303864770324e-01
            true // do the checks
        );
        console.log("big_tub_lower_range_price_1ep00 testing done.");
    }

    /*
        function testLimitedRangePour_big_tub_lower_range_price_1ep00_sans_checks() public {
            console.log("big_tub_lower_range_price_1ep00 starting ......");
            testLimitedRangePour(
                wrap(0x3fff0000000000000000000000000000), // price
                fromUint256(1)/fromUint256(100), // quadVar
                256, // startingTub
                1792, // stoppingTub
                fromUint256(1), // liquidityPerTub
                POSITIVE_ZERO, // expected token0 = 0e+00
                wrap(0x3ffd1e63770a42ea4f7e9e2311893d4f), // expected token1 = 2.79676303864770324e-01
                false // skip the checks
            );
            console.log("big_tub_lower_range_price_1ep00 testing done.");
        }
    */

    function testLimitedRangePour_big_tub_almost_whole_range_price_1ep00_with_checks() public {
        console.log("big_tub_almost_whole_range_price_1ep00 starting ......");
        testLimitedRangePour(
            wrap(0x3fff0000000000000000000000000000), // price
            fromUint256(1) / fromUint256(100), // quadVar
            512, // startingTub
            3584, // stoppingTub
            fromUint256(1), // liquidityPerTub
            wrap(0x3ffeffc117f5e4c2d3ef3f441e12b854), // expected token0 = 9.99520062223728494e-01
            wrap(0x3ffeffc117f5e4c2d3ef3f441e12b854), // expected token1 = 9.99520062223728494e-01
            true // do the checks
        );
        console.log("big_tub_almost_whole_range_price_1ep00 testing done.");
    }

    /*
        function testLimitedRangePour_big_tub_almost_whole_range_price_1ep00_sans_checks() public {
            console.log("big_tub_almost_whole_range_price_1ep00 starting ......");
            testLimitedRangePour(
                wrap(0x3fff0000000000000000000000000000), // price
                fromUint256(1)/fromUint256(100), // quadVar
                512, // startingTub
                3584, // stoppingTub
                fromUint256(1), // liquidityPerTub
                wrap(0x3ffeffc117f5e4c2d3ef3f441e12b854), // expected token0 = 9.99520062223728494e-01
                wrap(0x3ffeffc117f5e4c2d3ef3f441e12b854), // expected token1 = 9.99520062223728494e-01
                false // skip the checks
            );
            console.log("big_tub_almost_whole_range_price_1ep00 testing done.");
        }
    */

    function testLimitedRangePour_big_tub_upper_range_price_1ep00_with_checks() public {
        console.log("big_tub_upper_range_price_1ep00 starting ......");
        testLimitedRangePour(
            wrap(0x3fff0000000000000000000000000000), // price
            fromUint256(1) / fromUint256(100), // quadVar
            2304, // startingTub
            3840, // stoppingTub
            fromUint256(1), // liquidityPerTub
            wrap(0x3ffd1e63770a42ea4f7e9e2311893d4f), // expected token0 = 2.79676303864770324e-01
            POSITIVE_ZERO, // expected token1 = 0e+00
            true // do the checks
        );
        console.log("big_tub_upper_range_price_1ep00 testing done.");
    }

    /*
        function testLimitedRangePour_big_tub_upper_range_price_1ep00_sans_checks() public {
            console.log("big_tub_upper_range_price_1ep00 starting ......");
            testLimitedRangePour(
                wrap(0x3fff0000000000000000000000000000), // price
                fromUint256(1)/fromUint256(100), // quadVar
                2304, // startingTub
                3840, // stoppingTub
                fromUint256(1), // liquidityPerTub
                wrap(0x3ffd1e63770a42ea4f7e9e2311893d4f), // expected token0 = 2.79676303864770324e-01
                POSITIVE_ZERO, // expected token1 = 0e+00
                false // skip the checks
            );
            console.log("big_tub_upper_range_price_1ep00 testing done.");
        }
    */

    function testLimitedRangePour_lower_half_tub_range_price_1ep00_with_checks() public {
        console.log("lower_half_tub_range_price_1ep00 starting ......");
        testLimitedRangePour(
            wrap(0x3fff0000000000000000000000000000), // price
            fromUint256(1) / fromUint256(100), // quadVar
            0, // startingTub
            2048, // stoppingTub
            fromUint256(1), // liquidityPerTub
            POSITIVE_ZERO, // expected token0 = 0e+00
            wrap(0x3ffefffb13269c8ccf0c8a3aaf940e96), // expected token1 = 9.99962423766442059e-01
            true // do the checks
        );
        console.log("lower_half_tub_range_price_1ep00 testing done.");
    }

    /*
        function testLimitedRangePour_lower_half_tub_range_price_1ep00_sans_checks() public {
            console.log("lower_half_tub_range_price_1ep00 starting ......");
            testLimitedRangePour(
                wrap(0x3fff0000000000000000000000000000), // price
                fromUint256(1)/fromUint256(100), // quadVar
                0, // startingTub
                2048, // stoppingTub
                fromUint256(1), // liquidityPerTub
                POSITIVE_ZERO, // expected token0 = 0e+00
                wrap(0x3ffefffb13269c8ccf0c8a3aaf940e96), // expected token1 = 9.99962423766442059e-01
                false // skip the checks
            );
            console.log("lower_half_tub_range_price_1ep00 testing done.");
        }
    */

    function testLimitedRangePour_upper_half_tub_range_price_1ep00_with_checks() public {
        console.log("upper_half_tub_range_price_1ep00 starting ......");
        testLimitedRangePour(
            wrap(0x3fff0000000000000000000000000000), // price
            fromUint256(1) / fromUint256(100), // quadVar
            2048, // startingTub
            4096, // stoppingTub
            fromUint256(1), // liquidityPerTub
            wrap(0x3ffefffb13269c8ccf0c8a3aaf940e96), // expected token0 = 9.99962423766442059e-01
            POSITIVE_ZERO, // expected token1 = 0e+00
            true // do the checks
        );
        console.log("upper_half_tub_range_price_1ep00 testing done.");
    }

    /*
        function testLimitedRangePour_upper_half_tub_range_price_1ep00_sans_checks() public {
            console.log("upper_half_tub_range_price_1ep00 starting ......");
            testLimitedRangePour(
                wrap(0x3fff0000000000000000000000000000), // price
                fromUint256(1)/fromUint256(100), // quadVar
                2048, // startingTub
                4096, // stoppingTub
                fromUint256(1), // liquidityPerTub
                wrap(0x3ffefffb13269c8ccf0c8a3aaf940e96), // expected token0 = 9.99962423766442059e-01
                POSITIVE_ZERO, // expected token1 = 0e+00
                false // skip the checks
            );
            console.log("upper_half_tub_range_price_1ep00 testing done.");
        }
    */

    function testWholeRangePour_whole_range_price_1_00999999989999999ep00_with_checks() public {
        console.log("whole_range_price_1_00999999989999999ep00 starting ......");
        testWholeRangePour(
            wrap(0x3fff028f5c2887cf0ff4c9fed7b0016f), // price
            fromUint256(1) / fromUint256(100), // quadVar
            fromUint256(1), // liquidityPerTub
            wrap(0x3ffefd7096e38bca7cef17498fa98235), // expected token0 = 9.94999614025705781e-01
            wrap(0x3fff014466fb401610488c825d902a18), // expected token1 = 1.00494998582879469e+00
            true // do the checks
        );
        console.log("whole_range_price_1_00999999989999999ep00 testing done.");
    }

    /*
        function testWholeRangePour_whole_range_price_1_00999999989999999ep00_sans_checks() public {
            console.log("whole_range_price_1_00999999989999999ep00 starting ......");
            testWholeRangePour(
                wrap(0x3fff028f5c2887cf0ff4c9fed7b0016f), // price
                fromUint256(1)/fromUint256(100), // quadVar
                fromUint256(1), // liquidityPerTub
                wrap(0x3ffefd7096e38bca7cef17498fa98235), // expected token0 = 9.94999614025705781e-01
                wrap(0x3fff014466fb401610488c825d902a18), // expected token1 = 1.00494998582879469e+00
                false // skip the checks
            );
            console.log("whole_range_price_1_00999999989999999ep00 testing done.");
        }
    */

    function testLimitedRangePour_single_tub_low_end_1_price_1_00999999989999999ep00_with_checks() public {
        console.log("single_tub_low_end_1_price_1_00999999989999999ep00 starting ......");
        testLimitedRangePour(
            wrap(0x3fff028f5c2887cf0ff4c9fed7b0016f), // price
            fromUint256(1) / fromUint256(100), // quadVar
            0, // startingTub
            1, // stoppingTub
            fromUint256(1), // liquidityPerTub
            POSITIVE_ZERO, // expected token0 = 0e+00
            wrap(0x3fe89277d353d3eb49cc12ff3691a100), // expected token1 = 1.87413798808594682e-07
            true // do the checks
        );
        console.log("single_tub_low_end_1_price_1_00999999989999999ep00 testing done.");
    }

    /*
        function testLimitedRangePour_single_tub_low_end_1_price_1_00999999989999999ep00_sans_checks() public {
            console.log("single_tub_low_end_1_price_1_00999999989999999ep00 starting ......");
            testLimitedRangePour(
                wrap(0x3fff028f5c2887cf0ff4c9fed7b0016f), // price
                fromUint256(1)/fromUint256(100), // quadVar
                0, // startingTub
                1, // stoppingTub
                fromUint256(1), // liquidityPerTub
                POSITIVE_ZERO, // expected token0 = 0e+00
                wrap(0x3fe89277d353d3eb49cc12ff3691a100), // expected token1 = 1.87413798808594682e-07
                false // skip the checks
            );
            console.log("single_tub_low_end_1_price_1_00999999989999999ep00 testing done.");
        }
    */

    function testLimitedRangePour_single_tub_low_end_2_price_1_00999999989999999ep00_with_checks() public {
        console.log("single_tub_low_end_2_price_1_00999999989999999ep00 starting ......");
        testLimitedRangePour(
            wrap(0x3fff028f5c2887cf0ff4c9fed7b0016f), // price
            fromUint256(1) / fromUint256(100), // quadVar
            11, // startingTub
            12, // stoppingTub
            fromUint256(1), // liquidityPerTub
            POSITIVE_ZERO, // expected token0 = 0e+00
            wrap(0x3fe8a91b931b07d4bfcb8db7d1235700), // expected token1 = 1.97956205067756075e-07
            true // do the checks
        );
        console.log("single_tub_low_end_2_price_1_00999999989999999ep00 testing done.");
    }

    /*
        function testLimitedRangePour_single_tub_low_end_2_price_1_00999999989999999ep00_sans_checks() public {
            console.log("single_tub_low_end_2_price_1_00999999989999999ep00 starting ......");
            testLimitedRangePour(
                wrap(0x3fff028f5c2887cf0ff4c9fed7b0016f), // price
                fromUint256(1)/fromUint256(100), // quadVar
                11, // startingTub
                12, // stoppingTub
                fromUint256(1), // liquidityPerTub
                POSITIVE_ZERO, // expected token0 = 0e+00
                wrap(0x3fe8a91b931b07d4bfcb8db7d1235700), // expected token1 = 1.97956205067756075e-07
                false // skip the checks
            );
            console.log("single_tub_low_end_2_price_1_00999999989999999ep00 testing done.");
        }
    */

    function testLimitedRangePour_single_tub_mid_range_price_1_00999999989999999ep00_with_checks() public {
        console.log("single_tub_mid_range_price_1_00999999989999999ep00 starting ......");
        testLimitedRangePour(
            wrap(0x3fff028f5c2887cf0ff4c9fed7b0016f), // price
            fromUint256(1) / fromUint256(100), // quadVar
            2048, // startingTub
            2049, // stoppingTub
            fromUint256(1), // liquidityPerTub
            wrap(0x3fdcb16c818a0872e7e4d17e75000000), // expected token0 = 4.92745870827999616e-11
            wrap(0x3ff746dd67f1cfa8c2476505c622cc90), // expected token1 = 4.98756206235263453e-03
            true // do the checks
        );
        console.log("single_tub_mid_range_price_1_00999999989999999ep00 testing done.");
    }

    /*
        function testLimitedRangePour_single_tub_mid_range_price_1_00999999989999999ep00_sans_checks() public {
            console.log("single_tub_mid_range_price_1_00999999989999999ep00 starting ......");
            testLimitedRangePour(
                wrap(0x3fff028f5c2887cf0ff4c9fed7b0016f), // price
                fromUint256(1)/fromUint256(100), // quadVar
                2048, // startingTub
                2049, // stoppingTub
                fromUint256(1), // liquidityPerTub
                wrap(0x3fdcb16c818a0872e7e4d17e75000000), // expected token0 = 4.92745870827999616e-11
                wrap(0x3ff746dd67f1cfa8c2476505c622cc90), // expected token1 = 4.98756206235263453e-03
                false // skip the checks
            );
            console.log("single_tub_mid_range_price_1_00999999989999999ep00 testing done.");
        }
    */

    function testLimitedRangePour_single_tub_high_end_1_price_1_00999999989999999ep00_with_checks() public {
        console.log("single_tub_high_end_1_price_1_00999999989999999ep00 starting ......");
        testLimitedRangePour(
            wrap(0x3fff028f5c2887cf0ff4c9fed7b0016f), // price
            fromUint256(1) / fromUint256(100), // quadVar
            4086, // startingTub
            4087, // stoppingTub
            fromUint256(1), // liquidityPerTub
            wrap(0x3fe8a4e612ea9ac36f5268d469ae6700), // expected token0 = 1.95996242641342649e-07
            POSITIVE_ZERO, // expected token1 = 0e+00
            true // do the checks
        );
        console.log("single_tub_high_end_1_price_1_00999999989999999ep00 testing done.");
    }

    /*
        function testLimitedRangePour_single_tub_high_end_1_price_1_00999999989999999ep00_sans_checks() public {
            console.log("single_tub_high_end_1_price_1_00999999989999999ep00 starting ......");
            testLimitedRangePour(
                wrap(0x3fff028f5c2887cf0ff4c9fed7b0016f), // price
                fromUint256(1)/fromUint256(100), // quadVar
                4086, // startingTub
                4087, // stoppingTub
                fromUint256(1), // liquidityPerTub
                wrap(0x3fe8a4e612ea9ac36f5268d469ae6700), // expected token0 = 1.95996242641342649e-07
                POSITIVE_ZERO, // expected token1 = 0e+00
                false // skip the checks
            );
            console.log("single_tub_high_end_1_price_1_00999999989999999ep00 testing done.");
        }
    */

    function testLimitedRangePour_single_tub_high_end_2_price_1_00999999989999999ep00_with_checks() public {
        console.log("single_tub_high_end_2_price_1_00999999989999999ep00 starting ......");
        testLimitedRangePour(
            wrap(0x3fff028f5c2887cf0ff4c9fed7b0016f), // price
            fromUint256(1) / fromUint256(100), // quadVar
            4095, // startingTub
            4096, // stoppingTub
            fromUint256(1), // liquidityPerTub
            wrap(0x3fe89277d353d3eb49cc12ff3691a100), // expected token0 = 1.87413798808594682e-07
            POSITIVE_ZERO, // expected token1 = 0e+00
            true // do the checks
        );
        console.log("single_tub_high_end_2_price_1_00999999989999999ep00 testing done.");
    }

    /*
        function testLimitedRangePour_single_tub_high_end_2_price_1_00999999989999999ep00_sans_checks() public {
            console.log("single_tub_high_end_2_price_1_00999999989999999ep00 starting ......");
            testLimitedRangePour(
                wrap(0x3fff028f5c2887cf0ff4c9fed7b0016f), // price
                fromUint256(1)/fromUint256(100), // quadVar
                4095, // startingTub
                4096, // stoppingTub
                fromUint256(1), // liquidityPerTub
                wrap(0x3fe89277d353d3eb49cc12ff3691a100), // expected token0 = 1.87413798808594682e-07
                POSITIVE_ZERO, // expected token1 = 0e+00
                false // skip the checks
            );
            console.log("single_tub_high_end_2_price_1_00999999989999999ep00 testing done.");
        }
    */

    function testLimitedRangePour_small_tub_range_low_end_1_price_1_00999999989999999ep00_with_checks() public {
        console.log("small_tub_range_low_end_1_price_1_00999999989999999ep00 starting ......");
        testLimitedRangePour(
            wrap(0x3fff028f5c2887cf0ff4c9fed7b0016f), // price
            fromUint256(1) / fromUint256(100), // quadVar
            0, // startingTub
            2, // stoppingTub
            fromUint256(1), // liquidityPerTub
            POSITIVE_ZERO, // expected token0 = 0e+00
            wrap(0x3fe99378c3a9fb2f2fed387476368580), // expected token1 = 3.75762335579409788e-07
            true // do the checks
        );
        console.log("small_tub_range_low_end_1_price_1_00999999989999999ep00 testing done.");
    }

    /*
        function testLimitedRangePour_small_tub_range_low_end_1_price_1_00999999989999999ep00_sans_checks() public {
            console.log("small_tub_range_low_end_1_price_1_00999999989999999ep00 starting ......");
            testLimitedRangePour(
                wrap(0x3fff028f5c2887cf0ff4c9fed7b0016f), // price
                fromUint256(1)/fromUint256(100), // quadVar
                0, // startingTub
                2, // stoppingTub
                fromUint256(1), // liquidityPerTub
                POSITIVE_ZERO, // expected token0 = 0e+00
                wrap(0x3fe99378c3a9fb2f2fed387476368580), // expected token1 = 3.75762335579409788e-07
                false // skip the checks
            );
            console.log("small_tub_range_low_end_1_price_1_00999999989999999ep00 testing done.");
        }
    */

    function testLimitedRangePour_small_tub_range_low_end_2_price_1_00999999989999999ep00_with_checks() public {
        console.log("small_tub_range_low_end_2_price_1_00999999989999999ep00 starting ......");
        testLimitedRangePour(
            wrap(0x3fff028f5c2887cf0ff4c9fed7b0016f), // price
            fromUint256(1) / fromUint256(100), // quadVar
            11, // startingTub
            13, // stoppingTub
            fromUint256(1), // liquidityPerTub
            POSITIVE_ZERO, // expected token0 = 0e+00
            wrap(0x3fe9aa2af77e94438ee950decc09fa80), // expected token1 = 3.96899729003761018e-07
            true // do the checks
        );
        console.log("small_tub_range_low_end_2_price_1_00999999989999999ep00 testing done.");
    }

    /*
        function testLimitedRangePour_small_tub_range_low_end_2_price_1_00999999989999999ep00_sans_checks() public {
            console.log("small_tub_range_low_end_2_price_1_00999999989999999ep00 starting ......");
            testLimitedRangePour(
                wrap(0x3fff028f5c2887cf0ff4c9fed7b0016f), // price
                fromUint256(1)/fromUint256(100), // quadVar
                11, // startingTub
                13, // stoppingTub
                fromUint256(1), // liquidityPerTub
                POSITIVE_ZERO, // expected token0 = 0e+00
                wrap(0x3fe9aa2af77e94438ee950decc09fa80), // expected token1 = 3.96899729003761018e-07
                false // skip the checks
            );
            console.log("small_tub_range_low_end_2_price_1_00999999989999999ep00 testing done.");
        }
    */

    function testLimitedRangePour_small_tub_range_midpoint_price_1_00999999989999999ep00_with_checks() public {
        console.log("small_tub_range_midpoint_price_1_00999999989999999ep00 starting ......");
        testLimitedRangePour(
            wrap(0x3fff028f5c2887cf0ff4c9fed7b0016f), // price
            fromUint256(1) / fromUint256(100), // quadVar
            2048, // startingTub
            2050, // stoppingTub
            fromUint256(1), // liquidityPerTub
            wrap(0x3ff743a0eb23fa164f0ec444f3e9f7cf), // expected token0 = 4.93818035827362373e-03
            wrap(0x3ff746dd67f1cfa8c2476505c622cc90), // expected token1 = 4.98756206235263453e-03
            true // do the checks
        );
        console.log("small_tub_range_midpoint_price_1_00999999989999999ep00 testing done.");
    }

    /*
        function testLimitedRangePour_small_tub_range_midpoint_price_1_00999999989999999ep00_sans_checks() public {
            console.log("small_tub_range_midpoint_price_1_00999999989999999ep00 starting ......");
            testLimitedRangePour(
                wrap(0x3fff028f5c2887cf0ff4c9fed7b0016f), // price
                fromUint256(1)/fromUint256(100), // quadVar
                2048, // startingTub
                2050, // stoppingTub
                fromUint256(1), // liquidityPerTub
                wrap(0x3ff743a0eb23fa164f0ec444f3e9f7cf), // expected token0 = 4.93818035827362373e-03
                wrap(0x3ff746dd67f1cfa8c2476505c622cc90), // expected token1 = 4.98756206235263453e-03
                false // skip the checks
            );
            console.log("small_tub_range_midpoint_price_1_00999999989999999ep00 testing done.");
        }
    */

    function testLimitedRangePour_small_tub_range_high_end_price_1_00999999989999999ep00_with_checks() public {
        console.log("small_tub_range_high_end_price_1_00999999989999999ep00 starting ......");
        testLimitedRangePour(
            wrap(0x3fff028f5c2887cf0ff4c9fed7b0016f), // price
            fromUint256(1) / fromUint256(100), // quadVar
            4094, // startingTub
            4096, // stoppingTub
            fromUint256(1), // liquidityPerTub
            wrap(0x3fe99378c3a9fb2f2fed387476368580), // expected token0 = 3.75762335579409788e-07
            POSITIVE_ZERO, // expected token1 = 0e+00
            true // do the checks
        );
        console.log("small_tub_range_high_end_price_1_00999999989999999ep00 testing done.");
    }

    /*
        function testLimitedRangePour_small_tub_range_high_end_price_1_00999999989999999ep00_sans_checks() public {
            console.log("small_tub_range_high_end_price_1_00999999989999999ep00 starting ......");
            testLimitedRangePour(
                wrap(0x3fff028f5c2887cf0ff4c9fed7b0016f), // price
                fromUint256(1)/fromUint256(100), // quadVar
                4094, // startingTub
                4096, // stoppingTub
                fromUint256(1), // liquidityPerTub
                wrap(0x3fe99378c3a9fb2f2fed387476368580), // expected token0 = 3.75762335579409788e-07
                POSITIVE_ZERO, // expected token1 = 0e+00
                false // skip the checks
            );
            console.log("small_tub_range_high_end_price_1_00999999989999999ep00 testing done.");
        }
    */

    function testLimitedRangePour_big_tub_lower_range_price_1_00999999989999999ep00_with_checks() public {
        console.log("big_tub_lower_range_price_1_00999999989999999ep00 starting ......");
        testLimitedRangePour(
            wrap(0x3fff028f5c2887cf0ff4c9fed7b0016f), // price
            fromUint256(1) / fromUint256(100), // quadVar
            256, // startingTub
            1792, // stoppingTub
            fromUint256(1), // liquidityPerTub
            POSITIVE_ZERO, // expected token0 = 0e+00
            wrap(0x3ffd1e63770a42ea4f7e9e2311893d4f), // expected token1 = 2.79676303864770324e-01
            true // do the checks
        );
        console.log("big_tub_lower_range_price_1_00999999989999999ep00 testing done.");
    }

    /*
        function testLimitedRangePour_big_tub_lower_range_price_1_00999999989999999ep00_sans_checks() public {
            console.log("big_tub_lower_range_price_1_00999999989999999ep00 starting ......");
            testLimitedRangePour(
                wrap(0x3fff028f5c2887cf0ff4c9fed7b0016f), // price
                fromUint256(1)/fromUint256(100), // quadVar
                256, // startingTub
                1792, // stoppingTub
                fromUint256(1), // liquidityPerTub
                POSITIVE_ZERO, // expected token0 = 0e+00
                wrap(0x3ffd1e63770a42ea4f7e9e2311893d4f), // expected token1 = 2.79676303864770324e-01
                false // skip the checks
            );
            console.log("big_tub_lower_range_price_1_00999999989999999ep00 testing done.");
        }
    */

    function testLimitedRangePour_big_tub_almost_whole_range_price_1_00999999989999999ep00_with_checks() public {
        console.log("big_tub_almost_whole_range_price_1_00999999989999999ep00 starting ......");
        testLimitedRangePour(
            wrap(0x3fff028f5c2887cf0ff4c9fed7b0016f), // price
            fromUint256(1) / fromUint256(100), // quadVar
            512, // startingTub
            3584, // stoppingTub
            fromUint256(1), // liquidityPerTub
            wrap(0x3ffefd369bb2d40081d1cc52fe282bf3), // expected token0 = 9.94557252482992217e-01
            wrap(0x3fff01276962e43112b9e70714cf7ef7), // expected token1 = 1.00450762428608112e+00
            true // do the checks
        );
        console.log("big_tub_almost_whole_range_price_1_00999999989999999ep00 testing done.");
    }

    /*
        function testLimitedRangePour_big_tub_almost_whole_range_price_1_00999999989999999ep00_sans_checks() public {
            console.log("big_tub_almost_whole_range_price_1_00999999989999999ep00 starting ......");
            testLimitedRangePour(
                wrap(0x3fff028f5c2887cf0ff4c9fed7b0016f), // price
                fromUint256(1)/fromUint256(100), // quadVar
                512, // startingTub
                3584, // stoppingTub
                fromUint256(1), // liquidityPerTub
                wrap(0x3ffefd369bb2d40081d1cc52fe282bf3), // expected token0 = 9.94557252482992217e-01
                wrap(0x3fff01276962e43112b9e70714cf7ef7), // expected token1 = 1.00450762428608112e+00
                false // skip the checks
            );
            console.log("big_tub_almost_whole_range_price_1_00999999989999999ep00 testing done.");
        }
    */

    function testLimitedRangePour_big_tub_upper_range_price_1_00999999989999999ep00_with_checks() public {
        console.log("big_tub_upper_range_price_1_00999999989999999ep00 starting ......");
        testLimitedRangePour(
            wrap(0x3fff028f5c2887cf0ff4c9fed7b0016f), // price
            fromUint256(1) / fromUint256(100), // quadVar
            2304, // startingTub
            3840, // stoppingTub
            fromUint256(1), // liquidityPerTub
            wrap(0x3ffd1e63770a42ea4f7e9e2311893d4f), // expected token0 = 2.79676303864770324e-01
            POSITIVE_ZERO, // expected token1 = 0e+00
            true // do the checks
        );
        console.log("big_tub_upper_range_price_1_00999999989999999ep00 testing done.");
    }

    /*
        function testLimitedRangePour_big_tub_upper_range_price_1_00999999989999999ep00_sans_checks() public {
            console.log("big_tub_upper_range_price_1_00999999989999999ep00 starting ......");
            testLimitedRangePour(
                wrap(0x3fff028f5c2887cf0ff4c9fed7b0016f), // price
                fromUint256(1)/fromUint256(100), // quadVar
                2304, // startingTub
                3840, // stoppingTub
                fromUint256(1), // liquidityPerTub
                wrap(0x3ffd1e63770a42ea4f7e9e2311893d4f), // expected token0 = 2.79676303864770324e-01
                POSITIVE_ZERO, // expected token1 = 0e+00
                false // skip the checks
            );
            console.log("big_tub_upper_range_price_1_00999999989999999ep00 testing done.");
        }
    */

    function testLimitedRangePour_lower_half_tub_range_price_1_00999999989999999ep00_with_checks() public {
        console.log("lower_half_tub_range_price_1_00999999989999999ep00 starting ......");
        testLimitedRangePour(
            wrap(0x3fff028f5c2887cf0ff4c9fed7b0016f), // price
            fromUint256(1) / fromUint256(100), // quadVar
            0, // startingTub
            2048, // stoppingTub
            fromUint256(1), // liquidityPerTub
            POSITIVE_ZERO, // expected token0 = 0e+00
            wrap(0x3ffefffb13269c8ccf0c8a3aaf940e96), // expected token1 = 9.99962423766442059e-01
            true // do the checks
        );
        console.log("lower_half_tub_range_price_1_00999999989999999ep00 testing done.");
    }

    /*
        function testLimitedRangePour_lower_half_tub_range_price_1_00999999989999999ep00_sans_checks() public {
            console.log("lower_half_tub_range_price_1_00999999989999999ep00 starting ......");
            testLimitedRangePour(
                wrap(0x3fff028f5c2887cf0ff4c9fed7b0016f), // price
                fromUint256(1)/fromUint256(100), // quadVar
                0, // startingTub
                2048, // stoppingTub
                fromUint256(1), // liquidityPerTub
                POSITIVE_ZERO, // expected token0 = 0e+00
                wrap(0x3ffefffb13269c8ccf0c8a3aaf940e96), // expected token1 = 9.99962423766442059e-01
                false // skip the checks
            );
            console.log("lower_half_tub_range_price_1_00999999989999999ep00 testing done.");
        }
    */

    function testLimitedRangePour_upper_half_tub_range_price_1_00999999989999999ep00_with_checks() public {
        console.log("upper_half_tub_range_price_1_00999999989999999ep00 starting ......");
        testLimitedRangePour(
            wrap(0x3fff028f5c2887cf0ff4c9fed7b0016f), // price
            fromUint256(1) / fromUint256(100), // quadVar
            2048, // startingTub
            4096, // stoppingTub
            fromUint256(1), // liquidityPerTub
            wrap(0x3ffefd7096e38bca7cef17498fa98235), // expected token0 = 9.94999614025705781e-01
            wrap(0x3ff746dd67f1cfa8c2476505c622cc90), // expected token1 = 4.98756206235263453e-03
            true // do the checks
        );
        console.log("upper_half_tub_range_price_1_00999999989999999ep00 testing done.");
    }

    /*
        function testLimitedRangePour_upper_half_tub_range_price_1_00999999989999999ep00_sans_checks() public {
            console.log("upper_half_tub_range_price_1_00999999989999999ep00 starting ......");
            testLimitedRangePour(
                wrap(0x3fff028f5c2887cf0ff4c9fed7b0016f), // price
                fromUint256(1)/fromUint256(100), // quadVar
                2048, // startingTub
                4096, // stoppingTub
                fromUint256(1), // liquidityPerTub
                wrap(0x3ffefd7096e38bca7cef17498fa98235), // expected token0 = 9.94999614025705781e-01
                wrap(0x3ff746dd67f1cfa8c2476505c622cc90), // expected token1 = 4.98756206235263453e-03
                false // skip the checks
            );
            console.log("upper_half_tub_range_price_1_00999999989999999ep00 testing done.");
        }
    */

    function testWholeRangePour_whole_range_price_1_01000000000000000ep00_with_checks() public {
        console.log("whole_range_price_1_01000000000000000ep00 starting ......");
        testWholeRangePour(
            wrap(0x3fff028f5c28f5c28f5c28f5c28f5c29), // price
            fromUint256(1) / fromUint256(100), // quadVar
            fromUint256(1), // liquidityPerTub
            wrap(0x3ffefd7096e31f6f5c8c952cd5b04dd5), // expected token0 = 9.94999613976431194e-01
            wrap(0x3fff014466fb76c59d0fe43e0731e4ab), // expected token1 = 1.00494998587853108e+00
            true // do the checks
        );
        console.log("whole_range_price_1_01000000000000000ep00 testing done.");
    }

    /*
        function testWholeRangePour_whole_range_price_1_01000000000000000ep00_sans_checks() public {
            console.log("whole_range_price_1_01000000000000000ep00 starting ......");
            testWholeRangePour(
                wrap(0x3fff028f5c28f5c28f5c28f5c28f5c29), // price
                fromUint256(1)/fromUint256(100), // quadVar
                fromUint256(1), // liquidityPerTub
                wrap(0x3ffefd7096e31f6f5c8c952cd5b04dd5), // expected token0 = 9.94999613976431194e-01
                wrap(0x3fff014466fb76c59d0fe43e0731e4ab), // expected token1 = 1.00494998587853108e+00
                false // skip the checks
            );
            console.log("whole_range_price_1_01000000000000000ep00 testing done.");
        }
    */

    function testLimitedRangePour_single_tub_low_end_1_price_1_01000000000000000ep00_with_checks() public {
        console.log("single_tub_low_end_1_price_1_01000000000000000ep00 starting ......");
        testLimitedRangePour(
            wrap(0x3fff028f5c28f5c28f5c28f5c28f5c29), // price
            fromUint256(1) / fromUint256(100), // quadVar
            0, // startingTub
            1, // stoppingTub
            fromUint256(1), // liquidityPerTub
            POSITIVE_ZERO, // expected token0 = 0e+00
            wrap(0x3fe89277d353d3eb49cc12ff3691a100), // expected token1 = 1.87413798808594682e-07
            true // do the checks
        );
        console.log("single_tub_low_end_1_price_1_01000000000000000ep00 testing done.");
    }

    /*
        function testLimitedRangePour_single_tub_low_end_1_price_1_01000000000000000ep00_sans_checks() public {
            console.log("single_tub_low_end_1_price_1_01000000000000000ep00 starting ......");
            testLimitedRangePour(
                wrap(0x3fff028f5c28f5c28f5c28f5c28f5c29), // price
                fromUint256(1)/fromUint256(100), // quadVar
                0, // startingTub
                1, // stoppingTub
                fromUint256(1), // liquidityPerTub
                POSITIVE_ZERO, // expected token0 = 0e+00
                wrap(0x3fe89277d353d3eb49cc12ff3691a100), // expected token1 = 1.87413798808594682e-07
                false // skip the checks
            );
            console.log("single_tub_low_end_1_price_1_01000000000000000ep00 testing done.");
        }
    */

    function testLimitedRangePour_single_tub_low_end_2_price_1_01000000000000000ep00_with_checks() public {
        console.log("single_tub_low_end_2_price_1_01000000000000000ep00 starting ......");
        testLimitedRangePour(
            wrap(0x3fff028f5c28f5c28f5c28f5c28f5c29), // price
            fromUint256(1) / fromUint256(100), // quadVar
            11, // startingTub
            12, // stoppingTub
            fromUint256(1), // liquidityPerTub
            POSITIVE_ZERO, // expected token0 = 0e+00
            wrap(0x3fe8a91b931b07d4bfcb8db7d1235700), // expected token1 = 1.97956205067756075e-07
            true // do the checks
        );
        console.log("single_tub_low_end_2_price_1_01000000000000000ep00 testing done.");
    }

    /*
        function testLimitedRangePour_single_tub_low_end_2_price_1_01000000000000000ep00_sans_checks() public {
            console.log("single_tub_low_end_2_price_1_01000000000000000ep00 starting ......");
            testLimitedRangePour(
                wrap(0x3fff028f5c28f5c28f5c28f5c28f5c29), // price
                fromUint256(1)/fromUint256(100), // quadVar
                11, // startingTub
                12, // stoppingTub
                fromUint256(1), // liquidityPerTub
                POSITIVE_ZERO, // expected token0 = 0e+00
                wrap(0x3fe8a91b931b07d4bfcb8db7d1235700), // expected token1 = 1.97956205067756075e-07
                false // skip the checks
            );
            console.log("single_tub_low_end_2_price_1_01000000000000000ep00 testing done.");
        }
    */

    function testLimitedRangePour_single_tub_mid_range_price_1_01000000000000000ep00_with_checks() public {
        console.log("single_tub_mid_range_price_1_01000000000000000ep00 starting ......");
        testLimitedRangePour(
            wrap(0x3fff028f5c28f5c28f5c28f5c28f5c29), // price
            fromUint256(1) / fromUint256(100), // quadVar
            2048, // startingTub
            2049, // stoppingTub
            fromUint256(1), // liquidityPerTub
            POSITIVE_ZERO, // expected token0 = 0e+00
            wrap(0x3ff746dd68287f35899f20af67dd6000), // expected token1 = 4.98756211208902702e-03
            true // do the checks
        );
        console.log("single_tub_mid_range_price_1_01000000000000000ep00 testing done.");
    }

    /*
        function testLimitedRangePour_single_tub_mid_range_price_1_01000000000000000ep00_sans_checks() public {
            console.log("single_tub_mid_range_price_1_01000000000000000ep00 starting ......");
            testLimitedRangePour(
                wrap(0x3fff028f5c28f5c28f5c28f5c28f5c29), // price
                fromUint256(1)/fromUint256(100), // quadVar
                2048, // startingTub
                2049, // stoppingTub
                fromUint256(1), // liquidityPerTub
                POSITIVE_ZERO, // expected token0 = 0e+00
                wrap(0x3ff746dd68287f35899f20af67dd6000), // expected token1 = 4.98756211208902702e-03
                false // skip the checks
            );
            console.log("single_tub_mid_range_price_1_01000000000000000ep00 testing done.");
        }
    */

    function testLimitedRangePour_single_tub_high_end_1_price_1_01000000000000000ep00_with_checks() public {
        console.log("single_tub_high_end_1_price_1_01000000000000000ep00 starting ......");
        testLimitedRangePour(
            wrap(0x3fff028f5c28f5c28f5c28f5c28f5c29), // price
            fromUint256(1) / fromUint256(100), // quadVar
            4086, // startingTub
            4087, // stoppingTub
            fromUint256(1), // liquidityPerTub
            wrap(0x3fe8a4e612ea9ac36f5268d469ae6700), // expected token0 = 1.95996242641342649e-07
            POSITIVE_ZERO, // expected token1 = 0e+00
            true // do the checks
        );
        console.log("single_tub_high_end_1_price_1_01000000000000000ep00 testing done.");
    }

    /*
        function testLimitedRangePour_single_tub_high_end_1_price_1_01000000000000000ep00_sans_checks() public {
            console.log("single_tub_high_end_1_price_1_01000000000000000ep00 starting ......");
            testLimitedRangePour(
                wrap(0x3fff028f5c28f5c28f5c28f5c28f5c29), // price
                fromUint256(1)/fromUint256(100), // quadVar
                4086, // startingTub
                4087, // stoppingTub
                fromUint256(1), // liquidityPerTub
                wrap(0x3fe8a4e612ea9ac36f5268d469ae6700), // expected token0 = 1.95996242641342649e-07
                POSITIVE_ZERO, // expected token1 = 0e+00
                false // skip the checks
            );
            console.log("single_tub_high_end_1_price_1_01000000000000000ep00 testing done.");
        }
    */

    function testLimitedRangePour_single_tub_high_end_2_price_1_01000000000000000ep00_with_checks() public {
        console.log("single_tub_high_end_2_price_1_01000000000000000ep00 starting ......");
        testLimitedRangePour(
            wrap(0x3fff028f5c28f5c28f5c28f5c28f5c29), // price
            fromUint256(1) / fromUint256(100), // quadVar
            4095, // startingTub
            4096, // stoppingTub
            fromUint256(1), // liquidityPerTub
            wrap(0x3fe89277d353d3eb49cc12ff3691a100), // expected token0 = 1.87413798808594682e-07
            POSITIVE_ZERO, // expected token1 = 0e+00
            true // do the checks
        );
        console.log("single_tub_high_end_2_price_1_01000000000000000ep00 testing done.");
    }

    /*
        function testLimitedRangePour_single_tub_high_end_2_price_1_01000000000000000ep00_sans_checks() public {
            console.log("single_tub_high_end_2_price_1_01000000000000000ep00 starting ......");
            testLimitedRangePour(
                wrap(0x3fff028f5c28f5c28f5c28f5c28f5c29), // price
                fromUint256(1)/fromUint256(100), // quadVar
                4095, // startingTub
                4096, // stoppingTub
                fromUint256(1), // liquidityPerTub
                wrap(0x3fe89277d353d3eb49cc12ff3691a100), // expected token0 = 1.87413798808594682e-07
                POSITIVE_ZERO, // expected token1 = 0e+00
                false // skip the checks
            );
            console.log("single_tub_high_end_2_price_1_01000000000000000ep00 testing done.");
        }
    */

    function testLimitedRangePour_small_tub_range_low_end_1_price_1_01000000000000000ep00_with_checks() public {
        console.log("small_tub_range_low_end_1_price_1_01000000000000000ep00 starting ......");
        testLimitedRangePour(
            wrap(0x3fff028f5c28f5c28f5c28f5c28f5c29), // price
            fromUint256(1) / fromUint256(100), // quadVar
            0, // startingTub
            2, // stoppingTub
            fromUint256(1), // liquidityPerTub
            POSITIVE_ZERO, // expected token0 = 0e+00
            wrap(0x3fe99378c3a9fb2f2fed387476368580), // expected token1 = 3.75762335579409788e-07
            true // do the checks
        );
        console.log("small_tub_range_low_end_1_price_1_01000000000000000ep00 testing done.");
    }

    /*
        function testLimitedRangePour_small_tub_range_low_end_1_price_1_01000000000000000ep00_sans_checks() public {
            console.log("small_tub_range_low_end_1_price_1_01000000000000000ep00 starting ......");
            testLimitedRangePour(
                wrap(0x3fff028f5c28f5c28f5c28f5c28f5c29), // price
                fromUint256(1)/fromUint256(100), // quadVar
                0, // startingTub
                2, // stoppingTub
                fromUint256(1), // liquidityPerTub
                POSITIVE_ZERO, // expected token0 = 0e+00
                wrap(0x3fe99378c3a9fb2f2fed387476368580), // expected token1 = 3.75762335579409788e-07
                false // skip the checks
            );
            console.log("small_tub_range_low_end_1_price_1_01000000000000000ep00 testing done.");
        }
    */

    function testLimitedRangePour_small_tub_range_low_end_2_price_1_01000000000000000ep00_with_checks() public {
        console.log("small_tub_range_low_end_2_price_1_01000000000000000ep00 starting ......");
        testLimitedRangePour(
            wrap(0x3fff028f5c28f5c28f5c28f5c28f5c29), // price
            fromUint256(1) / fromUint256(100), // quadVar
            11, // startingTub
            13, // stoppingTub
            fromUint256(1), // liquidityPerTub
            POSITIVE_ZERO, // expected token0 = 0e+00
            wrap(0x3fe9aa2af77e94438ee950decc09fa80), // expected token1 = 3.96899729003761018e-07
            true // do the checks
        );
        console.log("small_tub_range_low_end_2_price_1_01000000000000000ep00 testing done.");
    }

    /*
        function testLimitedRangePour_small_tub_range_low_end_2_price_1_01000000000000000ep00_sans_checks() public {
            console.log("small_tub_range_low_end_2_price_1_01000000000000000ep00 starting ......");
            testLimitedRangePour(
                wrap(0x3fff028f5c28f5c28f5c28f5c28f5c29), // price
                fromUint256(1)/fromUint256(100), // quadVar
                11, // startingTub
                13, // stoppingTub
                fromUint256(1), // liquidityPerTub
                POSITIVE_ZERO, // expected token0 = 0e+00
                wrap(0x3fe9aa2af77e94438ee950decc09fa80), // expected token1 = 3.96899729003761018e-07
                false // skip the checks
            );
            console.log("small_tub_range_low_end_2_price_1_01000000000000000ep00 testing done.");
        }
    */

    function testLimitedRangePour_small_tub_range_midpoint_price_1_01000000000000000ep00_with_checks() public {
        console.log("small_tub_range_midpoint_price_1_01000000000000000ep00 starting ......");
        testLimitedRangePour(
            wrap(0x3fff028f5c28f5c28f5c28f5c28f5c29), // price
            fromUint256(1) / fromUint256(100), // quadVar
            2048, // startingTub
            2050, // stoppingTub
            fromUint256(1), // liquidityPerTub
            wrap(0x3ff743a0eaedcc861dcdb5e7f74fc800), // expected token0 = 4.93818030899903665e-03
            wrap(0x3ff746dd68287f35899f20af67dd6000), // expected token1 = 4.98756211208902702e-03
            true // do the checks
        );
        console.log("small_tub_range_midpoint_price_1_01000000000000000ep00 testing done.");
    }

    /*
        function testLimitedRangePour_small_tub_range_midpoint_price_1_01000000000000000ep00_sans_checks() public {
            console.log("small_tub_range_midpoint_price_1_01000000000000000ep00 starting ......");
            testLimitedRangePour(
                wrap(0x3fff028f5c28f5c28f5c28f5c28f5c29), // price
                fromUint256(1)/fromUint256(100), // quadVar
                2048, // startingTub
                2050, // stoppingTub
                fromUint256(1), // liquidityPerTub
                wrap(0x3ff743a0eaedcc861dcdb5e7f74fc800), // expected token0 = 4.93818030899903665e-03
                wrap(0x3ff746dd68287f35899f20af67dd6000), // expected token1 = 4.98756211208902702e-03
                false // skip the checks
            );
            console.log("small_tub_range_midpoint_price_1_01000000000000000ep00 testing done.");
        }
    */

    function testLimitedRangePour_small_tub_range_high_end_price_1_01000000000000000ep00_with_checks() public {
        console.log("small_tub_range_high_end_price_1_01000000000000000ep00 starting ......");
        testLimitedRangePour(
            wrap(0x3fff028f5c28f5c28f5c28f5c28f5c29), // price
            fromUint256(1) / fromUint256(100), // quadVar
            4094, // startingTub
            4096, // stoppingTub
            fromUint256(1), // liquidityPerTub
            wrap(0x3fe99378c3a9fb2f2fed387476368580), // expected token0 = 3.75762335579409788e-07
            POSITIVE_ZERO, // expected token1 = 0e+00
            true // do the checks
        );
        console.log("small_tub_range_high_end_price_1_01000000000000000ep00 testing done.");
    }

    /*
        function testLimitedRangePour_small_tub_range_high_end_price_1_01000000000000000ep00_sans_checks() public {
            console.log("small_tub_range_high_end_price_1_01000000000000000ep00 starting ......");
            testLimitedRangePour(
                wrap(0x3fff028f5c28f5c28f5c28f5c28f5c29), // price
                fromUint256(1)/fromUint256(100), // quadVar
                4094, // startingTub
                4096, // stoppingTub
                fromUint256(1), // liquidityPerTub
                wrap(0x3fe99378c3a9fb2f2fed387476368580), // expected token0 = 3.75762335579409788e-07
                POSITIVE_ZERO, // expected token1 = 0e+00
                false // skip the checks
            );
            console.log("small_tub_range_high_end_price_1_01000000000000000ep00 testing done.");
        }
    */

    function testLimitedRangePour_big_tub_lower_range_price_1_01000000000000000ep00_with_checks() public {
        console.log("big_tub_lower_range_price_1_01000000000000000ep00 starting ......");
        testLimitedRangePour(
            wrap(0x3fff028f5c28f5c28f5c28f5c28f5c29), // price
            fromUint256(1) / fromUint256(100), // quadVar
            256, // startingTub
            1792, // stoppingTub
            fromUint256(1), // liquidityPerTub
            POSITIVE_ZERO, // expected token0 = 0e+00
            wrap(0x3ffd1e63770a42ea4f7e9e2311893d4f), // expected token1 = 2.79676303864770324e-01
            true // do the checks
        );
        console.log("big_tub_lower_range_price_1_01000000000000000ep00 testing done.");
    }

    /*
        function testLimitedRangePour_big_tub_lower_range_price_1_01000000000000000ep00_sans_checks() public {
            console.log("big_tub_lower_range_price_1_01000000000000000ep00 starting ......");
            testLimitedRangePour(
                wrap(0x3fff028f5c28f5c28f5c28f5c28f5c29), // price
                fromUint256(1)/fromUint256(100), // quadVar
                256, // startingTub
                1792, // stoppingTub
                fromUint256(1), // liquidityPerTub
                POSITIVE_ZERO, // expected token0 = 0e+00
                wrap(0x3ffd1e63770a42ea4f7e9e2311893d4f), // expected token1 = 2.79676303864770324e-01
                false // skip the checks
            );
            console.log("big_tub_lower_range_price_1_01000000000000000ep00 testing done.");
        }
    */

    function testLimitedRangePour_big_tub_almost_whole_range_price_1_01000000000000000ep00_with_checks() public {
        console.log("big_tub_almost_whole_range_price_1_01000000000000000ep00 starting ......");
        testLimitedRangePour(
            wrap(0x3fff028f5c28f5c28f5c28f5c28f5c29), // price
            fromUint256(1) / fromUint256(100), // quadVar
            512, // startingTub
            3584, // stoppingTub
            fromUint256(1), // liquidityPerTub
            wrap(0x3ffefd369bb267a5616f4a36442ef793), // expected token0 = 9.94557252433717630e-01
            wrap(0x3fff012769631ae09f813ec2be71398a), // expected token1 = 1.00450762433581752e+00
            true // do the checks
        );
        console.log("big_tub_almost_whole_range_price_1_01000000000000000ep00 testing done.");
    }

    /*
        function testLimitedRangePour_big_tub_almost_whole_range_price_1_01000000000000000ep00_sans_checks() public {
            console.log("big_tub_almost_whole_range_price_1_01000000000000000ep00 starting ......");
            testLimitedRangePour(
                wrap(0x3fff028f5c28f5c28f5c28f5c28f5c29), // price
                fromUint256(1)/fromUint256(100), // quadVar
                512, // startingTub
                3584, // stoppingTub
                fromUint256(1), // liquidityPerTub
                wrap(0x3ffefd369bb267a5616f4a36442ef793), // expected token0 = 9.94557252433717630e-01
                wrap(0x3fff012769631ae09f813ec2be71398a), // expected token1 = 1.00450762433581752e+00
                false // skip the checks
            );
            console.log("big_tub_almost_whole_range_price_1_01000000000000000ep00 testing done.");
        }
    */

    function testLimitedRangePour_big_tub_upper_range_price_1_01000000000000000ep00_with_checks() public {
        console.log("big_tub_upper_range_price_1_01000000000000000ep00 starting ......");
        testLimitedRangePour(
            wrap(0x3fff028f5c28f5c28f5c28f5c28f5c29), // price
            fromUint256(1) / fromUint256(100), // quadVar
            2304, // startingTub
            3840, // stoppingTub
            fromUint256(1), // liquidityPerTub
            wrap(0x3ffd1e63770a42ea4f7e9e2311893d4f), // expected token0 = 2.79676303864770324e-01
            POSITIVE_ZERO, // expected token1 = 0e+00
            true // do the checks
        );
        console.log("big_tub_upper_range_price_1_01000000000000000ep00 testing done.");
    }

    /*
        function testLimitedRangePour_big_tub_upper_range_price_1_01000000000000000ep00_sans_checks() public {
            console.log("big_tub_upper_range_price_1_01000000000000000ep00 starting ......");
            testLimitedRangePour(
                wrap(0x3fff028f5c28f5c28f5c28f5c28f5c29), // price
                fromUint256(1)/fromUint256(100), // quadVar
                2304, // startingTub
                3840, // stoppingTub
                fromUint256(1), // liquidityPerTub
                wrap(0x3ffd1e63770a42ea4f7e9e2311893d4f), // expected token0 = 2.79676303864770324e-01
                POSITIVE_ZERO, // expected token1 = 0e+00
                false // skip the checks
            );
            console.log("big_tub_upper_range_price_1_01000000000000000ep00 testing done.");
        }
    */

    function testLimitedRangePour_lower_half_tub_range_price_1_01000000000000000ep00_with_checks() public {
        console.log("lower_half_tub_range_price_1_01000000000000000ep00 starting ......");
        testLimitedRangePour(
            wrap(0x3fff028f5c28f5c28f5c28f5c28f5c29), // price
            fromUint256(1) / fromUint256(100), // quadVar
            0, // startingTub
            2048, // stoppingTub
            fromUint256(1), // liquidityPerTub
            POSITIVE_ZERO, // expected token0 = 0e+00
            wrap(0x3ffefffb13269c8ccf0c8a3aaf940e96), // expected token1 = 9.99962423766442059e-01
            true // do the checks
        );
        console.log("lower_half_tub_range_price_1_01000000000000000ep00 testing done.");
    }

    /*
        function testLimitedRangePour_lower_half_tub_range_price_1_01000000000000000ep00_sans_checks() public {
            console.log("lower_half_tub_range_price_1_01000000000000000ep00 starting ......");
            testLimitedRangePour(
                wrap(0x3fff028f5c28f5c28f5c28f5c28f5c29), // price
                fromUint256(1)/fromUint256(100), // quadVar
                0, // startingTub
                2048, // stoppingTub
                fromUint256(1), // liquidityPerTub
                POSITIVE_ZERO, // expected token0 = 0e+00
                wrap(0x3ffefffb13269c8ccf0c8a3aaf940e96), // expected token1 = 9.99962423766442059e-01
                false // skip the checks
            );
            console.log("lower_half_tub_range_price_1_01000000000000000ep00 testing done.");
        }
    */

    function testLimitedRangePour_upper_half_tub_range_price_1_01000000000000000ep00_with_checks() public {
        console.log("upper_half_tub_range_price_1_01000000000000000ep00 starting ......");
        testLimitedRangePour(
            wrap(0x3fff028f5c28f5c28f5c28f5c28f5c29), // price
            fromUint256(1) / fromUint256(100), // quadVar
            2048, // startingTub
            4096, // stoppingTub
            fromUint256(1), // liquidityPerTub
            wrap(0x3ffefd7096e31f6f5c8c952cd5b04dd5), // expected token0 = 9.94999613976431194e-01
            wrap(0x3ff746dd68287f35899f20af67dd6000), // expected token1 = 4.98756211208902702e-03
            true // do the checks
        );
        console.log("upper_half_tub_range_price_1_01000000000000000ep00 testing done.");
    }

    /*
        function testLimitedRangePour_upper_half_tub_range_price_1_01000000000000000ep00_sans_checks() public {
            console.log("upper_half_tub_range_price_1_01000000000000000ep00 starting ......");
            testLimitedRangePour(
                wrap(0x3fff028f5c28f5c28f5c28f5c28f5c29), // price
                fromUint256(1)/fromUint256(100), // quadVar
                2048, // startingTub
                4096, // stoppingTub
                fromUint256(1), // liquidityPerTub
                wrap(0x3ffefd7096e31f6f5c8c952cd5b04dd5), // expected token0 = 9.94999613976431194e-01
                wrap(0x3ff746dd68287f35899f20af67dd6000), // expected token1 = 4.98756211208902702e-03
                false // skip the checks
            );
            console.log("upper_half_tub_range_price_1_01000000000000000ep00 testing done.");
        }
    */

    function testWholeRangePour_whole_range_price_1_01000000010000000ep00_with_checks() public {
        console.log("whole_range_price_1_01000000010000000ep00 starting ......");
        testWholeRangePour(
            wrap(0x3fff028f5c2963b60ec387ecad6eb6e3), // price
            fromUint256(1) / fromUint256(100), // quadVar
            fromUint256(1), // liquidityPerTub
            wrap(0x3ffefd7096e2b3257b020649995c770b), // expected token0 = 9.94999613927187241e-01
            wrap(0x3fff014466fbad7ddf5606ffec43cc85), // expected token1 = 1.00494998592829841e+00
            true // do the checks
        );
        console.log("whole_range_price_1_01000000010000000ep00 testing done.");
    }

    /*
        function testWholeRangePour_whole_range_price_1_01000000010000000ep00_sans_checks() public {
            console.log("whole_range_price_1_01000000010000000ep00 starting ......");
            testWholeRangePour(
                wrap(0x3fff028f5c2963b60ec387ecad6eb6e3), // price
                fromUint256(1)/fromUint256(100), // quadVar
                fromUint256(1), // liquidityPerTub
                wrap(0x3ffefd7096e2b3257b020649995c770b), // expected token0 = 9.94999613927187241e-01
                wrap(0x3fff014466fbad7ddf5606ffec43cc85), // expected token1 = 1.00494998592829841e+00
                false // skip the checks
            );
            console.log("whole_range_price_1_01000000010000000ep00 testing done.");
        }
    */

    function testLimitedRangePour_single_tub_low_end_1_price_1_01000000010000000ep00_with_checks() public {
        console.log("single_tub_low_end_1_price_1_01000000010000000ep00 starting ......");
        testLimitedRangePour(
            wrap(0x3fff028f5c2963b60ec387ecad6eb6e3), // price
            fromUint256(1) / fromUint256(100), // quadVar
            0, // startingTub
            1, // stoppingTub
            fromUint256(1), // liquidityPerTub
            POSITIVE_ZERO, // expected token0 = 0e+00
            wrap(0x3fe89277d353d3eb49cc12ff3691a100), // expected token1 = 1.87413798808594682e-07
            true // do the checks
        );
        console.log("single_tub_low_end_1_price_1_01000000010000000ep00 testing done.");
    }

    /*
        function testLimitedRangePour_single_tub_low_end_1_price_1_01000000010000000ep00_sans_checks() public {
            console.log("single_tub_low_end_1_price_1_01000000010000000ep00 starting ......");
            testLimitedRangePour(
                wrap(0x3fff028f5c2963b60ec387ecad6eb6e3), // price
                fromUint256(1)/fromUint256(100), // quadVar
                0, // startingTub
                1, // stoppingTub
                fromUint256(1), // liquidityPerTub
                POSITIVE_ZERO, // expected token0 = 0e+00
                wrap(0x3fe89277d353d3eb49cc12ff3691a100), // expected token1 = 1.87413798808594682e-07
                false // skip the checks
            );
            console.log("single_tub_low_end_1_price_1_01000000010000000ep00 testing done.");
        }
    */

    function testLimitedRangePour_single_tub_low_end_2_price_1_01000000010000000ep00_with_checks() public {
        console.log("single_tub_low_end_2_price_1_01000000010000000ep00 starting ......");
        testLimitedRangePour(
            wrap(0x3fff028f5c2963b60ec387ecad6eb6e3), // price
            fromUint256(1) / fromUint256(100), // quadVar
            11, // startingTub
            12, // stoppingTub
            fromUint256(1), // liquidityPerTub
            POSITIVE_ZERO, // expected token0 = 0e+00
            wrap(0x3fe8a91b931b07d4bfcb8db7d1235700), // expected token1 = 1.97956205067756075e-07
            true // do the checks
        );
        console.log("single_tub_low_end_2_price_1_01000000010000000ep00 testing done.");
    }

    /*
        function testLimitedRangePour_single_tub_low_end_2_price_1_01000000010000000ep00_sans_checks() public {
            console.log("single_tub_low_end_2_price_1_01000000010000000ep00 starting ......");
            testLimitedRangePour(
                wrap(0x3fff028f5c2963b60ec387ecad6eb6e3), // price
                fromUint256(1)/fromUint256(100), // quadVar
                11, // startingTub
                12, // stoppingTub
                fromUint256(1), // liquidityPerTub
                POSITIVE_ZERO, // expected token0 = 0e+00
                wrap(0x3fe8a91b931b07d4bfcb8db7d1235700), // expected token1 = 1.97956205067756075e-07
                false // skip the checks
            );
            console.log("single_tub_low_end_2_price_1_01000000010000000ep00 testing done.");
        }
    */

    function testLimitedRangePour_single_tub_mid_range_price_1_01000000010000000ep00_with_checks() public {
        console.log("single_tub_mid_range_price_1_01000000010000000ep00 starting ......");
        testLimitedRangePour(
            wrap(0x3fff028f5c2963b60ec387ecad6eb6e3), // price
            fromUint256(1) / fromUint256(100), // quadVar
            2048, // startingTub
            2049, // stoppingTub
            fromUint256(1), // liquidityPerTub
            POSITIVE_ZERO, // expected token0 = 0e+00
            wrap(0x3ff746dd68287f35899f20af67dd6000), // expected token1 = 4.98756211208902702e-03
            true // do the checks
        );
        console.log("single_tub_mid_range_price_1_01000000010000000ep00 testing done.");
    }

    /*
        function testLimitedRangePour_single_tub_mid_range_price_1_01000000010000000ep00_sans_checks() public {
            console.log("single_tub_mid_range_price_1_01000000010000000ep00 starting ......");
            testLimitedRangePour(
                wrap(0x3fff028f5c2963b60ec387ecad6eb6e3), // price
                fromUint256(1)/fromUint256(100), // quadVar
                2048, // startingTub
                2049, // stoppingTub
                fromUint256(1), // liquidityPerTub
                POSITIVE_ZERO, // expected token0 = 0e+00
                wrap(0x3ff746dd68287f35899f20af67dd6000), // expected token1 = 4.98756211208902702e-03
                false // skip the checks
            );
            console.log("single_tub_mid_range_price_1_01000000010000000ep00 testing done.");
        }
    */

    function testLimitedRangePour_single_tub_high_end_1_price_1_01000000010000000ep00_with_checks() public {
        console.log("single_tub_high_end_1_price_1_01000000010000000ep00 starting ......");
        testLimitedRangePour(
            wrap(0x3fff028f5c2963b60ec387ecad6eb6e3), // price
            fromUint256(1) / fromUint256(100), // quadVar
            4086, // startingTub
            4087, // stoppingTub
            fromUint256(1), // liquidityPerTub
            wrap(0x3fe8a4e612ea9ac36f5268d469ae6700), // expected token0 = 1.95996242641342649e-07
            POSITIVE_ZERO, // expected token1 = 0e+00
            true // do the checks
        );
        console.log("single_tub_high_end_1_price_1_01000000010000000ep00 testing done.");
    }

    /*
        function testLimitedRangePour_single_tub_high_end_1_price_1_01000000010000000ep00_sans_checks() public {
            console.log("single_tub_high_end_1_price_1_01000000010000000ep00 starting ......");
            testLimitedRangePour(
                wrap(0x3fff028f5c2963b60ec387ecad6eb6e3), // price
                fromUint256(1)/fromUint256(100), // quadVar
                4086, // startingTub
                4087, // stoppingTub
                fromUint256(1), // liquidityPerTub
                wrap(0x3fe8a4e612ea9ac36f5268d469ae6700), // expected token0 = 1.95996242641342649e-07
                POSITIVE_ZERO, // expected token1 = 0e+00
                false // skip the checks
            );
            console.log("single_tub_high_end_1_price_1_01000000010000000ep00 testing done.");
        }
    */

    function testLimitedRangePour_single_tub_high_end_2_price_1_01000000010000000ep00_with_checks() public {
        console.log("single_tub_high_end_2_price_1_01000000010000000ep00 starting ......");
        testLimitedRangePour(
            wrap(0x3fff028f5c2963b60ec387ecad6eb6e3), // price
            fromUint256(1) / fromUint256(100), // quadVar
            4095, // startingTub
            4096, // stoppingTub
            fromUint256(1), // liquidityPerTub
            wrap(0x3fe89277d353d3eb49cc12ff3691a100), // expected token0 = 1.87413798808594682e-07
            POSITIVE_ZERO, // expected token1 = 0e+00
            true // do the checks
        );
        console.log("single_tub_high_end_2_price_1_01000000010000000ep00 testing done.");
    }

    /*
        function testLimitedRangePour_single_tub_high_end_2_price_1_01000000010000000ep00_sans_checks() public {
            console.log("single_tub_high_end_2_price_1_01000000010000000ep00 starting ......");
            testLimitedRangePour(
                wrap(0x3fff028f5c2963b60ec387ecad6eb6e3), // price
                fromUint256(1)/fromUint256(100), // quadVar
                4095, // startingTub
                4096, // stoppingTub
                fromUint256(1), // liquidityPerTub
                wrap(0x3fe89277d353d3eb49cc12ff3691a100), // expected token0 = 1.87413798808594682e-07
                POSITIVE_ZERO, // expected token1 = 0e+00
                false // skip the checks
            );
            console.log("single_tub_high_end_2_price_1_01000000010000000ep00 testing done.");
        }
    */

    function testLimitedRangePour_small_tub_range_low_end_1_price_1_01000000010000000ep00_with_checks() public {
        console.log("small_tub_range_low_end_1_price_1_01000000010000000ep00 starting ......");
        testLimitedRangePour(
            wrap(0x3fff028f5c2963b60ec387ecad6eb6e3), // price
            fromUint256(1) / fromUint256(100), // quadVar
            0, // startingTub
            2, // stoppingTub
            fromUint256(1), // liquidityPerTub
            POSITIVE_ZERO, // expected token0 = 0e+00
            wrap(0x3fe99378c3a9fb2f2fed387476368580), // expected token1 = 3.75762335579409788e-07
            true // do the checks
        );
        console.log("small_tub_range_low_end_1_price_1_01000000010000000ep00 testing done.");
    }

    /*
        function testLimitedRangePour_small_tub_range_low_end_1_price_1_01000000010000000ep00_sans_checks() public {
            console.log("small_tub_range_low_end_1_price_1_01000000010000000ep00 starting ......");
            testLimitedRangePour(
                wrap(0x3fff028f5c2963b60ec387ecad6eb6e3), // price
                fromUint256(1)/fromUint256(100), // quadVar
                0, // startingTub
                2, // stoppingTub
                fromUint256(1), // liquidityPerTub
                POSITIVE_ZERO, // expected token0 = 0e+00
                wrap(0x3fe99378c3a9fb2f2fed387476368580), // expected token1 = 3.75762335579409788e-07
                false // skip the checks
            );
            console.log("small_tub_range_low_end_1_price_1_01000000010000000ep00 testing done.");
        }
    */

    function testLimitedRangePour_small_tub_range_low_end_2_price_1_01000000010000000ep00_with_checks() public {
        console.log("small_tub_range_low_end_2_price_1_01000000010000000ep00 starting ......");
        testLimitedRangePour(
            wrap(0x3fff028f5c2963b60ec387ecad6eb6e3), // price
            fromUint256(1) / fromUint256(100), // quadVar
            11, // startingTub
            13, // stoppingTub
            fromUint256(1), // liquidityPerTub
            POSITIVE_ZERO, // expected token0 = 0e+00
            wrap(0x3fe9aa2af77e94438ee950decc09fa80), // expected token1 = 3.96899729003761018e-07
            true // do the checks
        );
        console.log("small_tub_range_low_end_2_price_1_01000000010000000ep00 testing done.");
    }

    /*
        function testLimitedRangePour_small_tub_range_low_end_2_price_1_01000000010000000ep00_sans_checks() public {
            console.log("small_tub_range_low_end_2_price_1_01000000010000000ep00 starting ......");
            testLimitedRangePour(
                wrap(0x3fff028f5c2963b60ec387ecad6eb6e3), // price
                fromUint256(1)/fromUint256(100), // quadVar
                11, // startingTub
                13, // stoppingTub
                fromUint256(1), // liquidityPerTub
                POSITIVE_ZERO, // expected token0 = 0e+00
                wrap(0x3fe9aa2af77e94438ee950decc09fa80), // expected token1 = 3.96899729003761018e-07
                false // skip the checks
            );
            console.log("small_tub_range_low_end_2_price_1_01000000010000000ep00 testing done.");
        }
    */

    function testLimitedRangePour_small_tub_range_midpoint_price_1_01000000010000000ep00_with_checks() public {
        console.log("small_tub_range_midpoint_price_1_01000000010000000ep00 starting ......");
        testLimitedRangePour(
            wrap(0x3fff028f5c2963b60ec387ecad6eb6e3), // price
            fromUint256(1) / fromUint256(100), // quadVar
            2048, // startingTub
            2050, // stoppingTub
            fromUint256(1), // liquidityPerTub
            wrap(0x3ff743a0eab7a79558864449cd646332), // expected token0 = 4.93818025975508370e-03
            wrap(0x3ff746dd685f3777cfc1e29479c539f1), // expected token1 = 4.98756216185635997e-03
            true // do the checks
        );
        console.log("small_tub_range_midpoint_price_1_01000000010000000ep00 testing done.");
    }

    /*
        function testLimitedRangePour_small_tub_range_midpoint_price_1_01000000010000000ep00_sans_checks() public {
            console.log("small_tub_range_midpoint_price_1_01000000010000000ep00 starting ......");
            testLimitedRangePour(
                wrap(0x3fff028f5c2963b60ec387ecad6eb6e3), // price
                fromUint256(1)/fromUint256(100), // quadVar
                2048, // startingTub
                2050, // stoppingTub
                fromUint256(1), // liquidityPerTub
                wrap(0x3ff743a0eab7a79558864449cd646332), // expected token0 = 4.93818025975508370e-03
                wrap(0x3ff746dd685f3777cfc1e29479c539f1), // expected token1 = 4.98756216185635997e-03
                false // skip the checks
            );
            console.log("small_tub_range_midpoint_price_1_01000000010000000ep00 testing done.");
        }
    */

    function testLimitedRangePour_small_tub_range_high_end_price_1_01000000010000000ep00_with_checks() public {
        console.log("small_tub_range_high_end_price_1_01000000010000000ep00 starting ......");
        testLimitedRangePour(
            wrap(0x3fff028f5c2963b60ec387ecad6eb6e3), // price
            fromUint256(1) / fromUint256(100), // quadVar
            4094, // startingTub
            4096, // stoppingTub
            fromUint256(1), // liquidityPerTub
            wrap(0x3fe99378c3a9fb2f2fed387476368580), // expected token0 = 3.75762335579409788e-07
            POSITIVE_ZERO, // expected token1 = 0e+00
            true // do the checks
        );
        console.log("small_tub_range_high_end_price_1_01000000010000000ep00 testing done.");
    }

    /*
        function testLimitedRangePour_small_tub_range_high_end_price_1_01000000010000000ep00_sans_checks() public {
            console.log("small_tub_range_high_end_price_1_01000000010000000ep00 starting ......");
            testLimitedRangePour(
                wrap(0x3fff028f5c2963b60ec387ecad6eb6e3), // price
                fromUint256(1)/fromUint256(100), // quadVar
                4094, // startingTub
                4096, // stoppingTub
                fromUint256(1), // liquidityPerTub
                wrap(0x3fe99378c3a9fb2f2fed387476368580), // expected token0 = 3.75762335579409788e-07
                POSITIVE_ZERO, // expected token1 = 0e+00
                false // skip the checks
            );
            console.log("small_tub_range_high_end_price_1_01000000010000000ep00 testing done.");
        }
    */

    function testLimitedRangePour_big_tub_lower_range_price_1_01000000010000000ep00_with_checks() public {
        console.log("big_tub_lower_range_price_1_01000000010000000ep00 starting ......");
        testLimitedRangePour(
            wrap(0x3fff028f5c2963b60ec387ecad6eb6e3), // price
            fromUint256(1) / fromUint256(100), // quadVar
            256, // startingTub
            1792, // stoppingTub
            fromUint256(1), // liquidityPerTub
            POSITIVE_ZERO, // expected token0 = 0e+00
            wrap(0x3ffd1e63770a42ea4f7e9e2311893d4f), // expected token1 = 2.79676303864770324e-01
            true // do the checks
        );
        console.log("big_tub_lower_range_price_1_01000000010000000ep00 testing done.");
    }

    /*
        function testLimitedRangePour_big_tub_lower_range_price_1_01000000010000000ep00_sans_checks() public {
            console.log("big_tub_lower_range_price_1_01000000010000000ep00 starting ......");
            testLimitedRangePour(
                wrap(0x3fff028f5c2963b60ec387ecad6eb6e3), // price
                fromUint256(1)/fromUint256(100), // quadVar
                256, // startingTub
                1792, // stoppingTub
                fromUint256(1), // liquidityPerTub
                POSITIVE_ZERO, // expected token0 = 0e+00
                wrap(0x3ffd1e63770a42ea4f7e9e2311893d4f), // expected token1 = 2.79676303864770324e-01
                false // skip the checks
            );
            console.log("big_tub_lower_range_price_1_01000000010000000ep00 testing done.");
        }
    */

    function testLimitedRangePour_big_tub_almost_whole_range_price_1_01000000010000000ep00_with_checks() public {
        console.log("big_tub_almost_whole_range_price_1_01000000010000000ep00 starting ......");
        testLimitedRangePour(
            wrap(0x3fff028f5c2963b60ec387ecad6eb6e3), // price
            fromUint256(1) / fromUint256(100), // quadVar
            512, // startingTub
            3584, // stoppingTub
            fromUint256(1), // liquidityPerTub
            wrap(0x3ffefd369bb1fb5b7fe4bb5307db20c9), // expected token0 = 9.94557252384473677e-01
            wrap(0x3fff012769635198e1c76184a3832164), // expected token1 = 1.00450762438558485e+00
            true // do the checks
        );
        console.log("big_tub_almost_whole_range_price_1_01000000010000000ep00 testing done.");
    }

    /*
        function testLimitedRangePour_big_tub_almost_whole_range_price_1_01000000010000000ep00_sans_checks() public {
            console.log("big_tub_almost_whole_range_price_1_01000000010000000ep00 starting ......");
            testLimitedRangePour(
                wrap(0x3fff028f5c2963b60ec387ecad6eb6e3), // price
                fromUint256(1)/fromUint256(100), // quadVar
                512, // startingTub
                3584, // stoppingTub
                fromUint256(1), // liquidityPerTub
                wrap(0x3ffefd369bb1fb5b7fe4bb5307db20c9), // expected token0 = 9.94557252384473677e-01
                wrap(0x3fff012769635198e1c76184a3832164), // expected token1 = 1.00450762438558485e+00
                false // skip the checks
            );
            console.log("big_tub_almost_whole_range_price_1_01000000010000000ep00 testing done.");
        }
    */

    function testLimitedRangePour_big_tub_upper_range_price_1_01000000010000000ep00_with_checks() public {
        console.log("big_tub_upper_range_price_1_01000000010000000ep00 starting ......");
        testLimitedRangePour(
            wrap(0x3fff028f5c2963b60ec387ecad6eb6e3), // price
            fromUint256(1) / fromUint256(100), // quadVar
            2304, // startingTub
            3840, // stoppingTub
            fromUint256(1), // liquidityPerTub
            wrap(0x3ffd1e63770a42ea4f7e9e2311893d4f), // expected token0 = 2.79676303864770324e-01
            POSITIVE_ZERO, // expected token1 = 0e+00
            true // do the checks
        );
        console.log("big_tub_upper_range_price_1_01000000010000000ep00 testing done.");
    }

    /*
        function testLimitedRangePour_big_tub_upper_range_price_1_01000000010000000ep00_sans_checks() public {
            console.log("big_tub_upper_range_price_1_01000000010000000ep00 starting ......");
            testLimitedRangePour(
                wrap(0x3fff028f5c2963b60ec387ecad6eb6e3), // price
                fromUint256(1)/fromUint256(100), // quadVar
                2304, // startingTub
                3840, // stoppingTub
                fromUint256(1), // liquidityPerTub
                wrap(0x3ffd1e63770a42ea4f7e9e2311893d4f), // expected token0 = 2.79676303864770324e-01
                POSITIVE_ZERO, // expected token1 = 0e+00
                false // skip the checks
            );
            console.log("big_tub_upper_range_price_1_01000000010000000ep00 testing done.");
        }
    */

    function testLimitedRangePour_lower_half_tub_range_price_1_01000000010000000ep00_with_checks() public {
        console.log("lower_half_tub_range_price_1_01000000010000000ep00 starting ......");
        testLimitedRangePour(
            wrap(0x3fff028f5c2963b60ec387ecad6eb6e3), // price
            fromUint256(1) / fromUint256(100), // quadVar
            0, // startingTub
            2048, // stoppingTub
            fromUint256(1), // liquidityPerTub
            POSITIVE_ZERO, // expected token0 = 0e+00
            wrap(0x3ffefffb13269c8ccf0c8a3aaf940e96), // expected token1 = 9.99962423766442059e-01
            true // do the checks
        );
        console.log("lower_half_tub_range_price_1_01000000010000000ep00 testing done.");
    }

    /*
        function testLimitedRangePour_lower_half_tub_range_price_1_01000000010000000ep00_sans_checks() public {
            console.log("lower_half_tub_range_price_1_01000000010000000ep00 starting ......");
            testLimitedRangePour(
                wrap(0x3fff028f5c2963b60ec387ecad6eb6e3), // price
                fromUint256(1)/fromUint256(100), // quadVar
                0, // startingTub
                2048, // stoppingTub
                fromUint256(1), // liquidityPerTub
                POSITIVE_ZERO, // expected token0 = 0e+00
                wrap(0x3ffefffb13269c8ccf0c8a3aaf940e96), // expected token1 = 9.99962423766442059e-01
                false // skip the checks
            );
            console.log("lower_half_tub_range_price_1_01000000010000000ep00 testing done.");
        }
    */

    function testLimitedRangePour_upper_half_tub_range_price_1_01000000010000000ep00_with_checks() public {
        console.log("upper_half_tub_range_price_1_01000000010000000ep00 starting ......");
        testLimitedRangePour(
            wrap(0x3fff028f5c2963b60ec387ecad6eb6e3), // price
            fromUint256(1) / fromUint256(100), // quadVar
            2048, // startingTub
            4096, // stoppingTub
            fromUint256(1), // liquidityPerTub
            wrap(0x3ffefd7096e2b3257b020649995c770b), // expected token0 = 9.94999613927187241e-01
            wrap(0x3ff746dd685f3777cfc1e29479c539f1), // expected token1 = 4.98756216185635997e-03
            true // do the checks
        );
        console.log("upper_half_tub_range_price_1_01000000010000000ep00 testing done.");
    }

    /*
        function testLimitedRangePour_upper_half_tub_range_price_1_01000000010000000ep00_sans_checks() public {
            console.log("upper_half_tub_range_price_1_01000000010000000ep00 starting ......");
            testLimitedRangePour(
                wrap(0x3fff028f5c2963b60ec387ecad6eb6e3), // price
                fromUint256(1)/fromUint256(100), // quadVar
                2048, // startingTub
                4096, // stoppingTub
                fromUint256(1), // liquidityPerTub
                wrap(0x3ffefd7096e2b3257b020649995c770b), // expected token0 = 9.94999613927187241e-01
                wrap(0x3ff746dd685f3777cfc1e29479c539f1), // expected token1 = 4.98756216185635997e-03
                false // skip the checks
            );
            console.log("upper_half_tub_range_price_1_01000000010000000ep00 testing done.");
        }
    */

    function testWholeRangePour_whole_range_price_2ep00_with_checks() public {
        console.log("whole_range_price_2ep00 starting ......");
        testWholeRangePour(
            wrap(0x40000000000000000000000000000000), // price
            fromUint256(1) / fromUint256(100), // quadVar
            fromUint256(1), // liquidityPerTub
            wrap(0x3ffe6a04fa7e42f61eea3b22fb569190), // expected token0 = 7.07069232857502997e-01
            wrap(0x3fff6a0770eaff96e911d1c9d396cfb9), // expected token1 = 1.41417604195848024e+00
            true // do the checks
        );
        console.log("whole_range_price_2ep00 testing done.");
    }

    /*
        function testWholeRangePour_whole_range_price_2ep00_sans_checks() public {
            console.log("whole_range_price_2ep00 starting ......");
            testWholeRangePour(
                wrap(0x40000000000000000000000000000000), // price
                fromUint256(1)/fromUint256(100), // quadVar
                fromUint256(1), // liquidityPerTub
                wrap(0x3ffe6a04fa7e42f61eea3b22fb569190), // expected token0 = 7.07069232857502997e-01
                wrap(0x3fff6a0770eaff96e911d1c9d396cfb9), // expected token1 = 1.41417604195848024e+00
                false // skip the checks
            );
            console.log("whole_range_price_2ep00 testing done.");
        }
    */

    function testLimitedRangePour_single_tub_low_end_1_price_2ep00_with_checks() public {
        console.log("single_tub_low_end_1_price_2ep00 starting ......");
        testLimitedRangePour(
            wrap(0x40000000000000000000000000000000), // price
            fromUint256(1) / fromUint256(100), // quadVar
            0, // startingTub
            1, // stoppingTub
            fromUint256(1), // liquidityPerTub
            POSITIVE_ZERO, // expected token0 = 0e+00
            wrap(0x3fe89277d353d3eb49cc12ff3691a100), // expected token1 = 1.87413798808594682e-07
            true // do the checks
        );
        console.log("single_tub_low_end_1_price_2ep00 testing done.");
    }

    /*
        function testLimitedRangePour_single_tub_low_end_1_price_2ep00_sans_checks() public {
            console.log("single_tub_low_end_1_price_2ep00 starting ......");
            testLimitedRangePour(
                wrap(0x40000000000000000000000000000000), // price
                fromUint256(1)/fromUint256(100), // quadVar
                0, // startingTub
                1, // stoppingTub
                fromUint256(1), // liquidityPerTub
                POSITIVE_ZERO, // expected token0 = 0e+00
                wrap(0x3fe89277d353d3eb49cc12ff3691a100), // expected token1 = 1.87413798808594682e-07
                false // skip the checks
            );
            console.log("single_tub_low_end_1_price_2ep00 testing done.");
        }
    */

    function testLimitedRangePour_single_tub_low_end_2_price_2ep00_with_checks() public {
        console.log("single_tub_low_end_2_price_2ep00 starting ......");
        testLimitedRangePour(
            wrap(0x40000000000000000000000000000000), // price
            fromUint256(1) / fromUint256(100), // quadVar
            11, // startingTub
            12, // stoppingTub
            fromUint256(1), // liquidityPerTub
            POSITIVE_ZERO, // expected token0 = 0e+00
            wrap(0x3fe8a91b931b07d4bfcb8db7d1235700), // expected token1 = 1.97956205067756075e-07
            true // do the checks
        );
        console.log("single_tub_low_end_2_price_2ep00 testing done.");
    }

    /*
        function testLimitedRangePour_single_tub_low_end_2_price_2ep00_sans_checks() public {
            console.log("single_tub_low_end_2_price_2ep00 starting ......");
            testLimitedRangePour(
                wrap(0x40000000000000000000000000000000), // price
                fromUint256(1)/fromUint256(100), // quadVar
                11, // startingTub
                12, // stoppingTub
                fromUint256(1), // liquidityPerTub
                POSITIVE_ZERO, // expected token0 = 0e+00
                wrap(0x3fe8a91b931b07d4bfcb8db7d1235700), // expected token1 = 1.97956205067756075e-07
                false // skip the checks
            );
            console.log("single_tub_low_end_2_price_2ep00 testing done.");
        }
    */

    function testLimitedRangePour_single_tub_mid_range_price_2ep00_with_checks() public {
        console.log("single_tub_mid_range_price_2ep00 starting ......");
        testLimitedRangePour(
            wrap(0x40000000000000000000000000000000), // price
            fromUint256(1) / fromUint256(100), // quadVar
            2048, // startingTub
            2049, // stoppingTub
            fromUint256(1), // liquidityPerTub
            POSITIVE_ZERO, // expected token0 = 0e+00
            wrap(0x3ff746dd68287f35899f20af67dd6000), // expected token1 = 4.98756211208902702e-03
            true // do the checks
        );
        console.log("single_tub_mid_range_price_2ep00 testing done.");
    }

    /*
        function testLimitedRangePour_single_tub_mid_range_price_2ep00_sans_checks() public {
            console.log("single_tub_mid_range_price_2ep00 starting ......");
            testLimitedRangePour(
                wrap(0x40000000000000000000000000000000), // price
                fromUint256(1)/fromUint256(100), // quadVar
                2048, // startingTub
                2049, // stoppingTub
                fromUint256(1), // liquidityPerTub
                POSITIVE_ZERO, // expected token0 = 0e+00
                wrap(0x3ff746dd68287f35899f20af67dd6000), // expected token1 = 4.98756211208902702e-03
                false // skip the checks
            );
            console.log("single_tub_mid_range_price_2ep00 testing done.");
        }
    */

    function testLimitedRangePour_single_tub_high_end_1_price_2ep00_with_checks() public {
        console.log("single_tub_high_end_1_price_2ep00 starting ......");
        testLimitedRangePour(
            wrap(0x40000000000000000000000000000000), // price
            fromUint256(1) / fromUint256(100), // quadVar
            4086, // startingTub
            4087, // stoppingTub
            fromUint256(1), // liquidityPerTub
            wrap(0x3fe8a4e612ea9ac36f5268d469ae6700), // expected token0 = 1.95996242641342649e-07
            POSITIVE_ZERO, // expected token1 = 0e+00
            true // do the checks
        );
        console.log("single_tub_high_end_1_price_2ep00 testing done.");
    }

    /*
        function testLimitedRangePour_single_tub_high_end_1_price_2ep00_sans_checks() public {
            console.log("single_tub_high_end_1_price_2ep00 starting ......");
            testLimitedRangePour(
                wrap(0x40000000000000000000000000000000), // price
                fromUint256(1)/fromUint256(100), // quadVar
                4086, // startingTub
                4087, // stoppingTub
                fromUint256(1), // liquidityPerTub
                wrap(0x3fe8a4e612ea9ac36f5268d469ae6700), // expected token0 = 1.95996242641342649e-07
                POSITIVE_ZERO, // expected token1 = 0e+00
                false // skip the checks
            );
            console.log("single_tub_high_end_1_price_2ep00 testing done.");
        }
    */

    function testLimitedRangePour_single_tub_high_end_2_price_2ep00_with_checks() public {
        console.log("single_tub_high_end_2_price_2ep00 starting ......");
        testLimitedRangePour(
            wrap(0x40000000000000000000000000000000), // price
            fromUint256(1) / fromUint256(100), // quadVar
            4095, // startingTub
            4096, // stoppingTub
            fromUint256(1), // liquidityPerTub
            wrap(0x3fe89277d353d3eb49cc12ff3691a100), // expected token0 = 1.87413798808594682e-07
            POSITIVE_ZERO, // expected token1 = 0e+00
            true // do the checks
        );
        console.log("single_tub_high_end_2_price_2ep00 testing done.");
    }

    /*
        function testLimitedRangePour_single_tub_high_end_2_price_2ep00_sans_checks() public {
            console.log("single_tub_high_end_2_price_2ep00 starting ......");
            testLimitedRangePour(
                wrap(0x40000000000000000000000000000000), // price
                fromUint256(1)/fromUint256(100), // quadVar
                4095, // startingTub
                4096, // stoppingTub
                fromUint256(1), // liquidityPerTub
                wrap(0x3fe89277d353d3eb49cc12ff3691a100), // expected token0 = 1.87413798808594682e-07
                POSITIVE_ZERO, // expected token1 = 0e+00
                false // skip the checks
            );
            console.log("single_tub_high_end_2_price_2ep00 testing done.");
        }
    */

    function testLimitedRangePour_small_tub_range_low_end_1_price_2ep00_with_checks() public {
        console.log("small_tub_range_low_end_1_price_2ep00 starting ......");
        testLimitedRangePour(
            wrap(0x40000000000000000000000000000000), // price
            fromUint256(1) / fromUint256(100), // quadVar
            0, // startingTub
            2, // stoppingTub
            fromUint256(1), // liquidityPerTub
            POSITIVE_ZERO, // expected token0 = 0e+00
            wrap(0x3fe99378c3a9fb2f2fed387476368580), // expected token1 = 3.75762335579409788e-07
            true // do the checks
        );
        console.log("small_tub_range_low_end_1_price_2ep00 testing done.");
    }

    /*
        function testLimitedRangePour_small_tub_range_low_end_1_price_2ep00_sans_checks() public {
            console.log("small_tub_range_low_end_1_price_2ep00 starting ......");
            testLimitedRangePour(
                wrap(0x40000000000000000000000000000000), // price
                fromUint256(1)/fromUint256(100), // quadVar
                0, // startingTub
                2, // stoppingTub
                fromUint256(1), // liquidityPerTub
                POSITIVE_ZERO, // expected token0 = 0e+00
                wrap(0x3fe99378c3a9fb2f2fed387476368580), // expected token1 = 3.75762335579409788e-07
                false // skip the checks
            );
            console.log("small_tub_range_low_end_1_price_2ep00 testing done.");
        }
    */

    function testLimitedRangePour_small_tub_range_low_end_2_price_2ep00_with_checks() public {
        console.log("small_tub_range_low_end_2_price_2ep00 starting ......");
        testLimitedRangePour(
            wrap(0x40000000000000000000000000000000), // price
            fromUint256(1) / fromUint256(100), // quadVar
            11, // startingTub
            13, // stoppingTub
            fromUint256(1), // liquidityPerTub
            POSITIVE_ZERO, // expected token0 = 0e+00
            wrap(0x3fe9aa2af77e94438ee950decc09fa80), // expected token1 = 3.96899729003761018e-07
            true // do the checks
        );
        console.log("small_tub_range_low_end_2_price_2ep00 testing done.");
    }

    /*
        function testLimitedRangePour_small_tub_range_low_end_2_price_2ep00_sans_checks() public {
            console.log("small_tub_range_low_end_2_price_2ep00 starting ......");
            testLimitedRangePour(
                wrap(0x40000000000000000000000000000000), // price
                fromUint256(1)/fromUint256(100), // quadVar
                11, // startingTub
                13, // stoppingTub
                fromUint256(1), // liquidityPerTub
                POSITIVE_ZERO, // expected token0 = 0e+00
                wrap(0x3fe9aa2af77e94438ee950decc09fa80), // expected token1 = 3.96899729003761018e-07
                false // skip the checks
            );
            console.log("small_tub_range_low_end_2_price_2ep00 testing done.");
        }
    */

    function testLimitedRangePour_small_tub_range_midpoint_price_2ep00_with_checks() public {
        console.log("small_tub_range_midpoint_price_2ep00 starting ......");
        testLimitedRangePour(
            wrap(0x40000000000000000000000000000000), // price
            fromUint256(1) / fromUint256(100), // quadVar
            2048, // startingTub
            2050, // stoppingTub
            fromUint256(1), // liquidityPerTub
            POSITIVE_ZERO, // expected token0 = 0e+00
            wrap(0x3ff847ae147ae147ae147ae147ae1480), // expected token1 = 1.00000000000000000e-02
            true // do the checks
        );
        console.log("small_tub_range_midpoint_price_2ep00 testing done.");
    }

    /*
        function testLimitedRangePour_small_tub_range_midpoint_price_2ep00_sans_checks() public {
            console.log("small_tub_range_midpoint_price_2ep00 starting ......");
            testLimitedRangePour(
                wrap(0x40000000000000000000000000000000), // price
                fromUint256(1)/fromUint256(100), // quadVar
                2048, // startingTub
                2050, // stoppingTub
                fromUint256(1), // liquidityPerTub
                POSITIVE_ZERO, // expected token0 = 0e+00
                wrap(0x3ff847ae147ae147ae147ae147ae1480), // expected token1 = 1.00000000000000000e-02
                false // skip the checks
            );
            console.log("small_tub_range_midpoint_price_2ep00 testing done.");
        }
    */

    function testLimitedRangePour_small_tub_range_high_end_price_2ep00_with_checks() public {
        console.log("small_tub_range_high_end_price_2ep00 starting ......");
        testLimitedRangePour(
            wrap(0x40000000000000000000000000000000), // price
            fromUint256(1) / fromUint256(100), // quadVar
            4094, // startingTub
            4096, // stoppingTub
            fromUint256(1), // liquidityPerTub
            wrap(0x3fe99378c3a9fb2f2fed387476368580), // expected token0 = 3.75762335579409788e-07
            POSITIVE_ZERO, // expected token1 = 0e+00
            true // do the checks
        );
        console.log("small_tub_range_high_end_price_2ep00 testing done.");
    }

    /*
        function testLimitedRangePour_small_tub_range_high_end_price_2ep00_sans_checks() public {
            console.log("small_tub_range_high_end_price_2ep00 starting ......");
            testLimitedRangePour(
                wrap(0x40000000000000000000000000000000), // price
                fromUint256(1)/fromUint256(100), // quadVar
                4094, // startingTub
                4096, // stoppingTub
                fromUint256(1), // liquidityPerTub
                wrap(0x3fe99378c3a9fb2f2fed387476368580), // expected token0 = 3.75762335579409788e-07
                POSITIVE_ZERO, // expected token1 = 0e+00
                false // skip the checks
            );
            console.log("small_tub_range_high_end_price_2ep00 testing done.");
        }
    */

    function testLimitedRangePour_big_tub_lower_range_price_2ep00_with_checks() public {
        console.log("big_tub_lower_range_price_2ep00 starting ......");
        testLimitedRangePour(
            wrap(0x40000000000000000000000000000000), // price
            fromUint256(1) / fromUint256(100), // quadVar
            256, // startingTub
            1792, // stoppingTub
            fromUint256(1), // liquidityPerTub
            POSITIVE_ZERO, // expected token0 = 0e+00
            wrap(0x3ffd1e63770a42ea4f7e9e2311893d4f), // expected token1 = 2.79676303864770324e-01
            true // do the checks
        );
        console.log("big_tub_lower_range_price_2ep00 testing done.");
    }

    /*
        function testLimitedRangePour_big_tub_lower_range_price_2ep00_sans_checks() public {
            console.log("big_tub_lower_range_price_2ep00 starting ......");
            testLimitedRangePour(
                wrap(0x40000000000000000000000000000000), // price
                fromUint256(1)/fromUint256(100), // quadVar
                256, // startingTub
                1792, // stoppingTub
                fromUint256(1), // liquidityPerTub
                POSITIVE_ZERO, // expected token0 = 0e+00
                wrap(0x3ffd1e63770a42ea4f7e9e2311893d4f), // expected token1 = 2.79676303864770324e-01
                false // skip the checks
            );
            console.log("big_tub_lower_range_price_2ep00 testing done.");
        }
    */

    function testLimitedRangePour_big_tub_almost_whole_range_price_2ep00_with_checks() public {
        console.log("big_tub_almost_whole_range_price_2ep00 starting ......");
        testLimitedRangePour(
            wrap(0x40000000000000000000000000000000), // price
            fromUint256(1) / fromUint256(100), // quadVar
            512, // startingTub
            3584, // stoppingTub
            fromUint256(1), // liquidityPerTub
            wrap(0x3ffe69caff4d8b2c23ccf02c69d53b4e), // expected token0 = 7.06626871314789432e-01
            wrap(0x3fff69ea7352a3b1eb832c4e8ad62498), // expected token1 = 1.41373368041576668e+00
            true // do the checks
        );
        console.log("big_tub_almost_whole_range_price_2ep00 testing done.");
    }

    /*
        function testLimitedRangePour_big_tub_almost_whole_range_price_2ep00_sans_checks() public {
            console.log("big_tub_almost_whole_range_price_2ep00 starting ......");
            testLimitedRangePour(
                wrap(0x40000000000000000000000000000000), // price
                fromUint256(1)/fromUint256(100), // quadVar
                512, // startingTub
                3584, // stoppingTub
                fromUint256(1), // liquidityPerTub
                wrap(0x3ffe69caff4d8b2c23ccf02c69d53b4e), // expected token0 = 7.06626871314789432e-01
                wrap(0x3fff69ea7352a3b1eb832c4e8ad62498), // expected token1 = 1.41373368041576668e+00
                false // skip the checks
            );
            console.log("big_tub_almost_whole_range_price_2ep00 testing done.");
        }
    */

    function testLimitedRangePour_big_tub_upper_range_price_2ep00_with_checks() public {
        console.log("big_tub_upper_range_price_2ep00 starting ......");
        testLimitedRangePour(
            wrap(0x40000000000000000000000000000000), // price
            fromUint256(1) / fromUint256(100), // quadVar
            2304, // startingTub
            3840, // stoppingTub
            fromUint256(1), // liquidityPerTub
            wrap(0x3ffd1e63770a42ea4f7e9e2311893d4f), // expected token0 = 2.79676303864770324e-01
            POSITIVE_ZERO, // expected token1 = 0e+00
            true // do the checks
        );
        console.log("big_tub_upper_range_price_2ep00 testing done.");
    }

    /*
        function testLimitedRangePour_big_tub_upper_range_price_2ep00_sans_checks() public {
            console.log("big_tub_upper_range_price_2ep00 starting ......");
            testLimitedRangePour(
                wrap(0x40000000000000000000000000000000), // price
                fromUint256(1)/fromUint256(100), // quadVar
                2304, // startingTub
                3840, // stoppingTub
                fromUint256(1), // liquidityPerTub
                wrap(0x3ffd1e63770a42ea4f7e9e2311893d4f), // expected token0 = 2.79676303864770324e-01
                POSITIVE_ZERO, // expected token1 = 0e+00
                false // skip the checks
            );
            console.log("big_tub_upper_range_price_2ep00 testing done.");
        }
    */

    function testLimitedRangePour_lower_half_tub_range_price_2ep00_with_checks() public {
        console.log("lower_half_tub_range_price_2ep00 starting ......");
        testLimitedRangePour(
            wrap(0x40000000000000000000000000000000), // price
            fromUint256(1) / fromUint256(100), // quadVar
            0, // startingTub
            2048, // stoppingTub
            fromUint256(1), // liquidityPerTub
            POSITIVE_ZERO, // expected token0 = 0e+00
            wrap(0x3ffefffb13269c8ccf0c8a3aaf940e96), // expected token1 = 9.99962423766442059e-01
            true // do the checks
        );
        console.log("lower_half_tub_range_price_2ep00 testing done.");
    }

    /*
        function testLimitedRangePour_lower_half_tub_range_price_2ep00_sans_checks() public {
            console.log("lower_half_tub_range_price_2ep00 starting ......");
            testLimitedRangePour(
                wrap(0x40000000000000000000000000000000), // price
                fromUint256(1)/fromUint256(100), // quadVar
                0, // startingTub
                2048, // stoppingTub
                fromUint256(1), // liquidityPerTub
                POSITIVE_ZERO, // expected token0 = 0e+00
                wrap(0x3ffefffb13269c8ccf0c8a3aaf940e96), // expected token1 = 9.99962423766442059e-01
                false // skip the checks
            );
            console.log("lower_half_tub_range_price_2ep00 testing done.");
        }
    */

    function testLimitedRangePour_upper_half_tub_range_price_2ep00_with_checks() public {
        console.log("upper_half_tub_range_price_2ep00 starting ......");
        testLimitedRangePour(
            wrap(0x40000000000000000000000000000000), // price
            fromUint256(1) / fromUint256(100), // quadVar
            2048, // startingTub
            4096, // stoppingTub
            fromUint256(1), // liquidityPerTub
            wrap(0x3ffe6a04fa7e42f61eea3b22fb569190), // expected token0 = 7.07069232857502997e-01
            wrap(0x3ffda8279d5ec542062e32b1ef3321b8), // expected token1 = 4.14213618192038190e-01
            true // do the checks
        );
        console.log("upper_half_tub_range_price_2ep00 testing done.");
    }

    /*
        function testLimitedRangePour_upper_half_tub_range_price_2ep00_sans_checks() public {
            console.log("upper_half_tub_range_price_2ep00 starting ......");
            testLimitedRangePour(
                wrap(0x40000000000000000000000000000000), // price
                fromUint256(1)/fromUint256(100), // quadVar
                2048, // startingTub
                4096, // stoppingTub
                fromUint256(1), // liquidityPerTub
                wrap(0x3ffe6a04fa7e42f61eea3b22fb569190), // expected token0 = 7.07069232857502997e-01
                wrap(0x3ffda8279d5ec542062e32b1ef3321b8), // expected token1 = 4.14213618192038190e-01
                false // skip the checks
            );
            console.log("upper_half_tub_range_price_2ep00 testing done.");
        }
    */
}
