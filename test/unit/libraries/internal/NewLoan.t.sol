// SPDX-License-Identifier: UNLICENSED
// THIS IS AUTO-GENERATED. DO NOT MODIFY.
// GENERATOR SYNTAX
// sbt "project contract" "test:fgRunMain finance.infinitypools.contract.SolidityNewLoanTestsGenerator filepath"
pragma solidity ^0.8.20;

import {console} from "forge-std/console.sol";
import {TUBS} from "src/Constants.sol";
import {POSITIVE_ZERO, POSITIVE_INFINITY, fromInt256, fromUint256, intoUint256, Quad, wrap} from "src/types/ABDKMathQuad/Quad.sol";
import {UserPay} from "src/libraries/internal/UserPay.sol";
import {LPTestCore} from "./LPTestCore.sol";
import {OPT_INT256_NONE, OptInt256} from "src/types/Optional/OptInt256.sol";
import {NewLoan} from "src/libraries/external/NewLoan.sol";
import {logQuad} from "test/unit/utils/QuadDebug.sol";

contract NewLoanTest is LPTestCore {
    Quad newLoanTestEpsilon = fromUint256(1) / (tenbillion * tenbillion * tenbillion); // easy to change

    function testNewLoan_test_newloan_nontwap_with_whole_range_pour_immediate_below_mid_price_0_5_and_token_mix_0() public {
        console.log("testNewLoan_test_newloan_nontwap_with_whole_range_pour_immediate_below_mid_price_0_5_and_token_mix_0 starting ......");
        testLimitedRangePour(
            Quad.wrap(bytes16(0x3ffe0000000000000000000000000000)), // price = 5e-01
            Quad.wrap(bytes16(0x3ff847ae147ae147ae147ae147ae147b)), // quadVar = 1.00000000000000000000000000000000002e-02
            0, // startingTub
            4096, // stoppingTub
            Quad.wrap(bytes16(0x40059000000000000000000000000000)), // liquidityPerTub = 1e+02
            Quad.wrap(bytes16(0x40061ad5d03797ade615ebe5ad4dd249)), // expected token0 = 1.41417604195848024924996542572977972e+02
            Quad.wrap(bytes16(0x40051ad3e3b2a4504826fe33545ba1b8)), // expected token1 = 7.07069232857502997478571876931418406e+01
            false // skip the checks
        );
        Quad[] memory owedPotential = new Quad[](1);
        owedPotential[0] = Quad.wrap(bytes16(0x3fff0000000000000000000000000000));
        // int256 midBin = 15826;
        NewLoan.NewLoanParams memory params = NewLoan.NewLoanParams({
            owedPotential: owedPotential, // owedPotential = 1e+00
            startBin: 15825, // startBin
            strikeBin: 15825, // strikeBin
            tokenMix: POSITIVE_ZERO, // tokenMix = 0e+00
            lockinEnd: POSITIVE_INFINITY,
            deadEra: OptInt256.wrap(OPT_INT256_NONE), // deadEra
            token: false, // token, unused for non-twap
            twapUntil: OptInt256.wrap(OPT_INT256_NONE) // twapUntil, disabled
        });
        UserPay.Info memory userPay = pool.newLoanOnly(params);
        Quad expectedToken0 = Quad.wrap(bytes16(0x3ff4cd74c4c2dfb7eedfcfa6a51a7f42)); // expecting userPay.token0 = 8.80157713581172668729548720738279517e-04
        assertTokenAmount(userPay.token0, expectedToken0, newLoanTestEpsilon);
        Quad expectedToken1 = -Quad.wrap(bytes16(0x3ff3b953d10fb6c5bac2cdbdb3ae59b3)); // expecting userPay.token1 = -4.20882614873446221580792664657978585e-04
        assertTokenAmount(userPay.token1, expectedToken1, newLoanTestEpsilon);

        console.log("testNewLoan_test_newloan_nontwap_with_whole_range_pour_immediate_below_mid_price_0_5_and_token_mix_0 testing done.");
    }

    function testNewLoan_test_newloan_nontwap_with_whole_range_pour_immediate_above_mid_price_0_5_and_token_mix_0() public {
        console.log("testNewLoan_test_newloan_nontwap_with_whole_range_pour_immediate_above_mid_price_0_5_and_token_mix_0 starting ......");
        testLimitedRangePour(
            Quad.wrap(bytes16(0x3ffe0000000000000000000000000000)), // price = 5e-01
            Quad.wrap(bytes16(0x3ff847ae147ae147ae147ae147ae147b)), // quadVar = 1.00000000000000000000000000000000002e-02
            0, // startingTub
            4096, // stoppingTub
            Quad.wrap(bytes16(0x40059000000000000000000000000000)), // liquidityPerTub = 1e+02
            Quad.wrap(bytes16(0x40061ad5d03797ade615ebe5ad4dd249)), // expected token0 = 1.41417604195848024924996542572977972e+02
            Quad.wrap(bytes16(0x40051ad3e3b2a4504826fe33545ba1b8)), // expected token1 = 7.07069232857502997478571876931418406e+01
            false // skip the checks
        );
        Quad[] memory owedPotential = new Quad[](1);
        owedPotential[0] = Quad.wrap(bytes16(0x3fff0000000000000000000000000000));
        // int256 midBin = 15826;
        NewLoan.NewLoanParams memory params = NewLoan.NewLoanParams({
            owedPotential: owedPotential, // owedPotential = 1e+00
            startBin: 15827, // startBin
            strikeBin: 15827, // strikeBin
            tokenMix: POSITIVE_ZERO, // tokenMix = 0e+00
            lockinEnd: POSITIVE_INFINITY,
            deadEra: OptInt256.wrap(OPT_INT256_NONE), // deadEra
            token: false, // token, unused for non-twap
            twapUntil: OptInt256.wrap(OPT_INT256_NONE) // twapUntil, disabled
        });
        UserPay.Info memory userPay = pool.newLoanOnly(params);
        Quad expectedToken0 = Quad.wrap(bytes16(0x3ff036fff5fb7091ee31fdd2828dfd70)); // expecting userPay.token0 = 3.70740708279962427835064220235435682e-05
        assertTokenAmount(userPay.token0, expectedToken0, newLoanTestEpsilon);
        Quad expectedToken1 = POSITIVE_ZERO; // expecting userPay.token1 = 0e+00
        assertTokenAmount(userPay.token1, expectedToken1, newLoanTestEpsilon);

        console.log("testNewLoan_test_newloan_nontwap_with_whole_range_pour_immediate_above_mid_price_0_5_and_token_mix_0 testing done.");
    }

    function testNewLoan_test_newloan_nontwap_with_whole_range_pour_far_below_mid_price_0_5_and_token_mix_0() public {
        console.log("testNewLoan_test_newloan_nontwap_with_whole_range_pour_far_below_mid_price_0_5_and_token_mix_0 starting ......");
        testLimitedRangePour(
            Quad.wrap(bytes16(0x3ffe0000000000000000000000000000)), // price = 5e-01
            Quad.wrap(bytes16(0x3ff847ae147ae147ae147ae147ae147b)), // quadVar = 1.00000000000000000000000000000000002e-02
            0, // startingTub
            4096, // stoppingTub
            Quad.wrap(bytes16(0x40059000000000000000000000000000)), // liquidityPerTub = 1e+02
            Quad.wrap(bytes16(0x40061ad5d03797ade615ebe5ad4dd249)), // expected token0 = 1.41417604195848024924996542572977972e+02
            Quad.wrap(bytes16(0x40051ad3e3b2a4504826fe33545ba1b8)), // expected token1 = 7.07069232857502997478571876931418406e+01
            false // skip the checks
        );
        Quad[] memory owedPotential = new Quad[](1);
        owedPotential[0] = Quad.wrap(bytes16(0x3fff0000000000000000000000000000));
        // int256 midBin = 15826;
        NewLoan.NewLoanParams memory params = NewLoan.NewLoanParams({
            owedPotential: owedPotential, // owedPotential = 1e+00
            startBin: 15816, // startBin
            strikeBin: 15816, // strikeBin
            tokenMix: POSITIVE_ZERO, // tokenMix = 0e+00
            lockinEnd: POSITIVE_INFINITY,
            deadEra: OptInt256.wrap(OPT_INT256_NONE), // deadEra
            token: false, // token, unused for non-twap
            twapUntil: OptInt256.wrap(OPT_INT256_NONE) // twapUntil, disabled
        });
        UserPay.Info memory userPay = pool.newLoanOnly(params);
        Quad expectedToken0 = Quad.wrap(bytes16(0x3ff4d00bd19a20bd18a4b4875fe23eb2)); // expecting userPay.token0 = 8.85097822234443513024496344534098493e-04
        assertTokenAmount(userPay.token0, expectedToken0, newLoanTestEpsilon);
        Quad expectedToken1 = -Quad.wrap(bytes16(0x3ff3b9283a255535a8d38a116f8bba76)); // expecting userPay.token1 = -4.20720231280304803286382638678891897e-04
        assertTokenAmount(userPay.token1, expectedToken1, newLoanTestEpsilon);

        console.log("testNewLoan_test_newloan_nontwap_with_whole_range_pour_far_below_mid_price_0_5_and_token_mix_0 testing done.");
    }

    function testNewLoan_test_newloan_nontwap_with_whole_range_pour_far_above_mid_price_0_5_and_token_mix_0() public {
        console.log("testNewLoan_test_newloan_nontwap_with_whole_range_pour_far_above_mid_price_0_5_and_token_mix_0 starting ......");
        testLimitedRangePour(
            Quad.wrap(bytes16(0x3ffe0000000000000000000000000000)), // price = 5e-01
            Quad.wrap(bytes16(0x3ff847ae147ae147ae147ae147ae147b)), // quadVar = 1.00000000000000000000000000000000002e-02
            0, // startingTub
            4096, // stoppingTub
            Quad.wrap(bytes16(0x40059000000000000000000000000000)), // liquidityPerTub = 1e+02
            Quad.wrap(bytes16(0x40061ad5d03797ade615ebe5ad4dd249)), // expected token0 = 1.41417604195848024924996542572977972e+02
            Quad.wrap(bytes16(0x40051ad3e3b2a4504826fe33545ba1b8)), // expected token1 = 7.07069232857502997478571876931418406e+01
            false // skip the checks
        );
        Quad[] memory owedPotential = new Quad[](1);
        owedPotential[0] = Quad.wrap(bytes16(0x3fff0000000000000000000000000000));
        // int256 midBin = 15826;
        NewLoan.NewLoanParams memory params = NewLoan.NewLoanParams({
            owedPotential: owedPotential, // owedPotential = 1e+00
            startBin: 15836, // startBin
            strikeBin: 15836, // strikeBin
            tokenMix: POSITIVE_ZERO, // tokenMix = 0e+00
            lockinEnd: POSITIVE_INFINITY,
            deadEra: OptInt256.wrap(OPT_INT256_NONE), // deadEra
            token: false, // token, unused for non-twap
            twapUntil: OptInt256.wrap(OPT_INT256_NONE) // twapUntil, disabled
        });
        UserPay.Info memory userPay = pool.newLoanOnly(params);
        Quad expectedToken0 = Quad.wrap(bytes16(0x3ff010911a1dac6ef2ed7e1b72d3d8f0)); // expecting userPay.token0 = 3.24924951490399958687509285919016828e-05
        assertTokenAmount(userPay.token0, expectedToken0, newLoanTestEpsilon);
        Quad expectedToken1 = POSITIVE_ZERO; // expecting userPay.token1 = 0e+00
        assertTokenAmount(userPay.token1, expectedToken1, newLoanTestEpsilon);

        console.log("testNewLoan_test_newloan_nontwap_with_whole_range_pour_far_above_mid_price_0_5_and_token_mix_0 testing done.");
    }

    function testNewLoan_test_newloan_nontwap_with_whole_range_pour_immediate_below_mid_price_0_5_and_token_mix_0_25() public {
        console.log("testNewLoan_test_newloan_nontwap_with_whole_range_pour_immediate_below_mid_price_0_5_and_token_mix_0_25 starting ......");
        testLimitedRangePour(
            Quad.wrap(bytes16(0x3ffe0000000000000000000000000000)), // price = 5e-01
            Quad.wrap(bytes16(0x3ff847ae147ae147ae147ae147ae147b)), // quadVar = 1.00000000000000000000000000000000002e-02
            0, // startingTub
            4096, // stoppingTub
            Quad.wrap(bytes16(0x40059000000000000000000000000000)), // liquidityPerTub = 1e+02
            Quad.wrap(bytes16(0x40061ad5d03797ade615ebe5ad4dd249)), // expected token0 = 1.41417604195848024924996542572977972e+02
            Quad.wrap(bytes16(0x40051ad3e3b2a4504826fe33545ba1b8)), // expected token1 = 7.07069232857502997478571876931418406e+01
            false // skip the checks
        );
        Quad[] memory owedPotential = new Quad[](1);
        owedPotential[0] = Quad.wrap(bytes16(0x3fff0000000000000000000000000000));
        // int256 midBin = 15826;
        NewLoan.NewLoanParams memory params = NewLoan.NewLoanParams({
            owedPotential: owedPotential, // owedPotential = 1e+00
            startBin: 15825, // startBin
            strikeBin: 15825, // strikeBin
            tokenMix: Quad.wrap(bytes16(0x3ffd0000000000000000000000000000)), // tokenMix = 2.5e-01
            lockinEnd: POSITIVE_INFINITY,
            deadEra: OptInt256.wrap(OPT_INT256_NONE), // deadEra
            token: false, // token, unused for non-twap
            twapUntil: OptInt256.wrap(OPT_INT256_NONE) // twapUntil, disabled
        });
        UserPay.Info memory userPay = pool.newLoanOnly(params);
        Quad expectedToken0 = Quad.wrap(bytes16(0x3ff45a17939227c9f327dbbcfbd3df72)); // expecting userPay.token0 = 6.60118285185879501547161540553709684e-04
        assertTokenAmount(userPay.token0, expectedToken0, newLoanTestEpsilon);
        Quad expectedToken1 = -Quad.wrap(bytes16(0x3ff3462331cfe6e327e37c3c9526e4f9)); // expecting userPay.token1 = -3.11028937170584846550348312655512827e-04
        assertTokenAmount(userPay.token1, expectedToken1, newLoanTestEpsilon);

        console.log("testNewLoan_test_newloan_nontwap_with_whole_range_pour_immediate_below_mid_price_0_5_and_token_mix_0_25 testing done.");
    }

    function testNewLoan_test_newloan_nontwap_with_whole_range_pour_immediate_above_mid_price_0_5_and_token_mix_0_25() public {
        console.log("testNewLoan_test_newloan_nontwap_with_whole_range_pour_immediate_above_mid_price_0_5_and_token_mix_0_25 starting ......");
        testLimitedRangePour(
            Quad.wrap(bytes16(0x3ffe0000000000000000000000000000)), // price = 5e-01
            Quad.wrap(bytes16(0x3ff847ae147ae147ae147ae147ae147b)), // quadVar = 1.00000000000000000000000000000000002e-02
            0, // startingTub
            4096, // stoppingTub
            Quad.wrap(bytes16(0x40059000000000000000000000000000)), // liquidityPerTub = 1e+02
            Quad.wrap(bytes16(0x40061ad5d03797ade615ebe5ad4dd249)), // expected token0 = 1.41417604195848024924996542572977972e+02
            Quad.wrap(bytes16(0x40051ad3e3b2a4504826fe33545ba1b8)), // expected token1 = 7.07069232857502997478571876931418406e+01
            false // skip the checks
        );
        Quad[] memory owedPotential = new Quad[](1);
        owedPotential[0] = Quad.wrap(bytes16(0x3fff0000000000000000000000000000));
        // int256 midBin = 15826;
        NewLoan.NewLoanParams memory params = NewLoan.NewLoanParams({
            owedPotential: owedPotential, // owedPotential = 1e+00
            startBin: 15827, // startBin
            strikeBin: 15827, // strikeBin
            tokenMix: Quad.wrap(bytes16(0x3ffd0000000000000000000000000000)), // tokenMix = 2.5e-01
            lockinEnd: POSITIVE_INFINITY,
            deadEra: OptInt256.wrap(OPT_INT256_NONE), // deadEra
            token: false, // token, unused for non-twap
            twapUntil: OptInt256.wrap(OPT_INT256_NONE) // twapUntil, disabled
        });
        UserPay.Info memory userPay = pool.newLoanOnly(params);
        Quad expectedToken0 = -Quad.wrap(bytes16(0x3ff27f21efec97b049001b701fb1fe1c)); // expecting userPay.token0 = -1.82691844559955531168470295831864995e-04
        assertTokenAmount(userPay.token0, expectedToken0, newLoanTestEpsilon);
        Quad expectedToken1 = Quad.wrap(bytes16(0x3ff1cd554a525f4c095e51042106b984)); // expecting userPay.token1 = 1.09990397765674486782505670447694048e-04
        assertTokenAmount(userPay.token1, expectedToken1, newLoanTestEpsilon);

        console.log("testNewLoan_test_newloan_nontwap_with_whole_range_pour_immediate_above_mid_price_0_5_and_token_mix_0_25 testing done.");
    }

    function testNewLoan_test_newloan_nontwap_with_whole_range_pour_far_below_mid_price_0_5_and_token_mix_0_25() public {
        console.log("testNewLoan_test_newloan_nontwap_with_whole_range_pour_far_below_mid_price_0_5_and_token_mix_0_25 starting ......");
        testLimitedRangePour(
            Quad.wrap(bytes16(0x3ffe0000000000000000000000000000)), // price = 5e-01
            Quad.wrap(bytes16(0x3ff847ae147ae147ae147ae147ae147b)), // quadVar = 1.00000000000000000000000000000000002e-02
            0, // startingTub
            4096, // stoppingTub
            Quad.wrap(bytes16(0x40059000000000000000000000000000)), // liquidityPerTub = 1e+02
            Quad.wrap(bytes16(0x40061ad5d03797ade615ebe5ad4dd249)), // expected token0 = 1.41417604195848024924996542572977972e+02
            Quad.wrap(bytes16(0x40051ad3e3b2a4504826fe33545ba1b8)), // expected token1 = 7.07069232857502997478571876931418406e+01
            false // skip the checks
        );
        Quad[] memory owedPotential = new Quad[](1);
        owedPotential[0] = Quad.wrap(bytes16(0x3fff0000000000000000000000000000));
        // int256 midBin = 15826;
        NewLoan.NewLoanParams memory params = NewLoan.NewLoanParams({
            owedPotential: owedPotential, // owedPotential = 1e+00
            startBin: 15816, // startBin
            strikeBin: 15816, // strikeBin
            tokenMix: Quad.wrap(bytes16(0x3ffd0000000000000000000000000000)), // tokenMix = 2.5e-01
            lockinEnd: POSITIVE_INFINITY,
            deadEra: OptInt256.wrap(OPT_INT256_NONE), // deadEra
            token: false, // token, unused for non-twap
            twapUntil: OptInt256.wrap(OPT_INT256_NONE) // twapUntil, disabled
        });
        UserPay.Info memory userPay = pool.newLoanOnly(params);
        Quad expectedToken0 = Quad.wrap(bytes16(0x3ff45c08dd33988dd27b876587e9af05)); // expecting userPay.token0 = 6.63823366675832634768372258400573822e-04
        assertTokenAmount(userPay.token0, expectedToken0, newLoanTestEpsilon);
        Quad expectedToken1 = -Quad.wrap(bytes16(0x3ff3469c3192f228840c8947d5ffbc6e)); // expecting userPay.token1 = -3.11479693831752838508147878090727764e-04
        assertTokenAmount(userPay.token1, expectedToken1, newLoanTestEpsilon);

        console.log("testNewLoan_test_newloan_nontwap_with_whole_range_pour_far_below_mid_price_0_5_and_token_mix_0_25 testing done.");
    }

    function testNewLoan_test_newloan_nontwap_with_whole_range_pour_far_above_mid_price_0_5_and_token_mix_0_25() public {
        console.log("testNewLoan_test_newloan_nontwap_with_whole_range_pour_far_above_mid_price_0_5_and_token_mix_0_25 starting ......");
        testLimitedRangePour(
            Quad.wrap(bytes16(0x3ffe0000000000000000000000000000)), // price = 5e-01
            Quad.wrap(bytes16(0x3ff847ae147ae147ae147ae147ae147b)), // quadVar = 1.00000000000000000000000000000000002e-02
            0, // startingTub
            4096, // stoppingTub
            Quad.wrap(bytes16(0x40059000000000000000000000000000)), // liquidityPerTub = 1e+02
            Quad.wrap(bytes16(0x40061ad5d03797ade615ebe5ad4dd249)), // expected token0 = 1.41417604195848024924996542572977972e+02
            Quad.wrap(bytes16(0x40051ad3e3b2a4504826fe33545ba1b8)), // expected token1 = 7.07069232857502997478571876931418406e+01
            false // skip the checks
        );
        Quad[] memory owedPotential = new Quad[](1);
        owedPotential[0] = Quad.wrap(bytes16(0x3fff0000000000000000000000000000));
        // int256 midBin = 15826;
        NewLoan.NewLoanParams memory params = NewLoan.NewLoanParams({
            owedPotential: owedPotential, // owedPotential = 1e+00
            startBin: 15836, // startBin
            strikeBin: 15836, // strikeBin
            tokenMix: Quad.wrap(bytes16(0x3ffd0000000000000000000000000000)), // tokenMix = 2.5e-01
            lockinEnd: POSITIVE_INFINITY,
            deadEra: OptInt256.wrap(OPT_INT256_NONE), // deadEra
            token: false, // token, unused for non-twap
            twapUntil: OptInt256.wrap(OPT_INT256_NONE) // twapUntil, disabled
        });
        UserPay.Info memory userPay = pool.newLoanOnly(params);
        Quad expectedToken0 = -Quad.wrap(bytes16(0x3ff2862b1f4262113b4a01d17593babc)); // expecting userPay.token0 = -1.86046812882042201900936377171645739e-04
        assertTokenAmount(userPay.token0, expectedToken0, newLoanTestEpsilon);
        Quad expectedToken1 = Quad.wrap(bytes16(0x3ff1cfec29eebc922f7ae4e58b7c68e2)); // expecting userPay.token1 = 1.10607746801414998760079530886811643e-04
        assertTokenAmount(userPay.token1, expectedToken1, newLoanTestEpsilon);

        console.log("testNewLoan_test_newloan_nontwap_with_whole_range_pour_far_above_mid_price_0_5_and_token_mix_0_25 testing done.");
    }

    function testNewLoan_test_newloan_nontwap_with_whole_range_pour_immediate_below_mid_price_0_5_and_token_mix_0_5() public {
        console.log("testNewLoan_test_newloan_nontwap_with_whole_range_pour_immediate_below_mid_price_0_5_and_token_mix_0_5 starting ......");
        testLimitedRangePour(
            Quad.wrap(bytes16(0x3ffe0000000000000000000000000000)), // price = 5e-01
            Quad.wrap(bytes16(0x3ff847ae147ae147ae147ae147ae147b)), // quadVar = 1.00000000000000000000000000000000002e-02
            0, // startingTub
            4096, // stoppingTub
            Quad.wrap(bytes16(0x40059000000000000000000000000000)), // liquidityPerTub = 1e+02
            Quad.wrap(bytes16(0x40061ad5d03797ade615ebe5ad4dd249)), // expected token0 = 1.41417604195848024924996542572977972e+02
            Quad.wrap(bytes16(0x40051ad3e3b2a4504826fe33545ba1b8)), // expected token1 = 7.07069232857502997478571876931418406e+01
            false // skip the checks
        );
        Quad[] memory owedPotential = new Quad[](1);
        owedPotential[0] = Quad.wrap(bytes16(0x3fff0000000000000000000000000000));
        // int256 midBin = 15826;
        NewLoan.NewLoanParams memory params = NewLoan.NewLoanParams({
            owedPotential: owedPotential, // owedPotential = 1e+00
            startBin: 15825, // startBin
            strikeBin: 15825, // strikeBin
            tokenMix: Quad.wrap(bytes16(0x3ffe0000000000000000000000000000)), // tokenMix = 5e-01
            lockinEnd: POSITIVE_INFINITY,
            deadEra: OptInt256.wrap(OPT_INT256_NONE), // deadEra
            token: false, // token, unused for non-twap
            twapUntil: OptInt256.wrap(OPT_INT256_NONE) // twapUntil, disabled
        });
        UserPay.Info memory userPay = pool.newLoanOnly(params);
        Quad expectedToken0 = Quad.wrap(bytes16(0x3ff3cd74c4c2dfb7eedfcfa6a51a7f42)); // expecting userPay.token0 = 4.40078856790586334364774360369139758e-04
        assertTokenAmount(userPay.token0, expectedToken0, newLoanTestEpsilon);
        Quad expectedToken1 = -Quad.wrap(bytes16(0x3ff2a5e525202e012a085576ed3ee07d)); // expecting userPay.token1 = -2.01175259467723471519903960653047046e-04
        assertTokenAmount(userPay.token1, expectedToken1, newLoanTestEpsilon);

        console.log("testNewLoan_test_newloan_nontwap_with_whole_range_pour_immediate_below_mid_price_0_5_and_token_mix_0_5 testing done.");
    }

    function testNewLoan_test_newloan_nontwap_with_whole_range_pour_immediate_above_mid_price_0_5_and_token_mix_0_5() public {
        console.log("testNewLoan_test_newloan_nontwap_with_whole_range_pour_immediate_above_mid_price_0_5_and_token_mix_0_5 starting ......");
        testLimitedRangePour(
            Quad.wrap(bytes16(0x3ffe0000000000000000000000000000)), // price = 5e-01
            Quad.wrap(bytes16(0x3ff847ae147ae147ae147ae147ae147b)), // quadVar = 1.00000000000000000000000000000000002e-02
            0, // startingTub
            4096, // stoppingTub
            Quad.wrap(bytes16(0x40059000000000000000000000000000)), // liquidityPerTub = 1e+02
            Quad.wrap(bytes16(0x40061ad5d03797ade615ebe5ad4dd249)), // expected token0 = 1.41417604195848024924996542572977972e+02
            Quad.wrap(bytes16(0x40051ad3e3b2a4504826fe33545ba1b8)), // expected token1 = 7.07069232857502997478571876931418406e+01
            false // skip the checks
        );
        Quad[] memory owedPotential = new Quad[](1);
        owedPotential[0] = Quad.wrap(bytes16(0x3fff0000000000000000000000000000));
        // int256 midBin = 15826;
        NewLoan.NewLoanParams memory params = NewLoan.NewLoanParams({
            owedPotential: owedPotential, // owedPotential = 1e+00
            startBin: 15827, // startBin
            strikeBin: 15827, // strikeBin
            tokenMix: Quad.wrap(bytes16(0x3ffe0000000000000000000000000000)), // tokenMix = 5e-01
            lockinEnd: POSITIVE_INFINITY,
            deadEra: OptInt256.wrap(OPT_INT256_NONE), // deadEra
            token: false, // token, unused for non-twap
            twapUntil: OptInt256.wrap(OPT_INT256_NONE) // twapUntil, disabled
        });
        UserPay.Info memory userPay = pool.newLoanOnly(params);
        Quad expectedToken0 = -Quad.wrap(bytes16(0x3ff3a601eeac05c286c65b2a7003bdc9)); // expecting userPay.token0 = -4.0245775994790730512044701368727351e-04
        assertTokenAmount(userPay.token0, expectedToken0, newLoanTestEpsilon);
        Quad expectedToken1 = Quad.wrap(bytes16(0x3ff2cd554a525f4c095e51042106b984)); // expecting userPay.token1 = 2.19980795531348973565011340895388096e-04
        assertTokenAmount(userPay.token1, expectedToken1, newLoanTestEpsilon);

        console.log("testNewLoan_test_newloan_nontwap_with_whole_range_pour_immediate_above_mid_price_0_5_and_token_mix_0_5 testing done.");
    }

    function testNewLoan_test_newloan_nontwap_with_whole_range_pour_far_below_mid_price_0_5_and_token_mix_0_5() public {
        console.log("testNewLoan_test_newloan_nontwap_with_whole_range_pour_far_below_mid_price_0_5_and_token_mix_0_5 starting ......");
        testLimitedRangePour(
            Quad.wrap(bytes16(0x3ffe0000000000000000000000000000)), // price = 5e-01
            Quad.wrap(bytes16(0x3ff847ae147ae147ae147ae147ae147b)), // quadVar = 1.00000000000000000000000000000000002e-02
            0, // startingTub
            4096, // stoppingTub
            Quad.wrap(bytes16(0x40059000000000000000000000000000)), // liquidityPerTub = 1e+02
            Quad.wrap(bytes16(0x40061ad5d03797ade615ebe5ad4dd249)), // expected token0 = 1.41417604195848024924996542572977972e+02
            Quad.wrap(bytes16(0x40051ad3e3b2a4504826fe33545ba1b8)), // expected token1 = 7.07069232857502997478571876931418406e+01
            false // skip the checks
        );
        Quad[] memory owedPotential = new Quad[](1);
        owedPotential[0] = Quad.wrap(bytes16(0x3fff0000000000000000000000000000));
        // int256 midBin = 15826;
        NewLoan.NewLoanParams memory params = NewLoan.NewLoanParams({
            owedPotential: owedPotential, // owedPotential = 1e+00
            startBin: 15816, // startBin
            strikeBin: 15816, // strikeBin
            tokenMix: Quad.wrap(bytes16(0x3ffe0000000000000000000000000000)), // tokenMix = 5e-01
            lockinEnd: POSITIVE_INFINITY,
            deadEra: OptInt256.wrap(OPT_INT256_NONE), // deadEra
            token: false, // token, unused for non-twap
            twapUntil: OptInt256.wrap(OPT_INT256_NONE) // twapUntil, disabled
        });
        UserPay.Info memory userPay = pool.newLoanOnly(params);
        Quad expectedToken0 = Quad.wrap(bytes16(0x3ff3d00bd19a20bd18a4b4875fe23eb2)); // expecting userPay.token0 = 4.42548911117221756512248172267049246e-04
        assertTokenAmount(userPay.token0, expectedToken0, newLoanTestEpsilon);
        Quad expectedToken1 = -Quad.wrap(bytes16(0x3ff2a82052011e36be8b10fc78e77cca)); // expecting userPay.token1 = -2.02239156383200873729913117502563584e-04
        assertTokenAmount(userPay.token1, expectedToken1, newLoanTestEpsilon);

        console.log("testNewLoan_test_newloan_nontwap_with_whole_range_pour_far_below_mid_price_0_5_and_token_mix_0_5 testing done.");
    }

    function testNewLoan_test_newloan_nontwap_with_whole_range_pour_far_above_mid_price_0_5_and_token_mix_0_5() public {
        console.log("testNewLoan_test_newloan_nontwap_with_whole_range_pour_far_above_mid_price_0_5_and_token_mix_0_5 starting ......");
        testLimitedRangePour(
            Quad.wrap(bytes16(0x3ffe0000000000000000000000000000)), // price = 5e-01
            Quad.wrap(bytes16(0x3ff847ae147ae147ae147ae147ae147b)), // quadVar = 1.00000000000000000000000000000000002e-02
            0, // startingTub
            4096, // stoppingTub
            Quad.wrap(bytes16(0x40059000000000000000000000000000)), // liquidityPerTub = 1e+02
            Quad.wrap(bytes16(0x40061ad5d03797ade615ebe5ad4dd249)), // expected token0 = 1.41417604195848024924996542572977972e+02
            Quad.wrap(bytes16(0x40051ad3e3b2a4504826fe33545ba1b8)), // expected token1 = 7.07069232857502997478571876931418406e+01
            false // skip the checks
        );
        Quad[] memory owedPotential = new Quad[](1);
        owedPotential[0] = Quad.wrap(bytes16(0x3fff0000000000000000000000000000));
        // int256 midBin = 15826;
        NewLoan.NewLoanParams memory params = NewLoan.NewLoanParams({
            owedPotential: owedPotential, // owedPotential = 1e+00
            startBin: 15836, // startBin
            strikeBin: 15836, // strikeBin
            tokenMix: Quad.wrap(bytes16(0x3ffe0000000000000000000000000000)), // tokenMix = 5e-01
            lockinEnd: POSITIVE_INFINITY,
            deadEra: OptInt256.wrap(OPT_INT256_NONE), // deadEra
            token: false, // token, unused for non-twap
            twapUntil: OptInt256.wrap(OPT_INT256_NONE) // twapUntil, disabled
        });
        UserPay.Info memory userPay = pool.newLoanOnly(params);
        Quad expectedToken0 = -Quad.wrap(bytes16(0x3ff3a83d4286179f19a7b194e3ee35dd)); // expecting userPay.token0 = -4.04586120913124399670623682935193302e-04
        assertTokenAmount(userPay.token0, expectedToken0, newLoanTestEpsilon);
        Quad expectedToken1 = Quad.wrap(bytes16(0x3ff2cfec29eebc922f7ae4e58b7c68e2)); // expecting userPay.token1 = 2.21215493602829997520159061773623285e-04
        assertTokenAmount(userPay.token1, expectedToken1, newLoanTestEpsilon);

        console.log("testNewLoan_test_newloan_nontwap_with_whole_range_pour_far_above_mid_price_0_5_and_token_mix_0_5 testing done.");
    }

    function testNewLoan_test_newloan_nontwap_with_whole_range_pour_immediate_below_mid_price_0_5_and_token_mix_0_75() public {
        console.log("testNewLoan_test_newloan_nontwap_with_whole_range_pour_immediate_below_mid_price_0_5_and_token_mix_0_75 starting ......");
        testLimitedRangePour(
            Quad.wrap(bytes16(0x3ffe0000000000000000000000000000)), // price = 5e-01
            Quad.wrap(bytes16(0x3ff847ae147ae147ae147ae147ae147b)), // quadVar = 1.00000000000000000000000000000000002e-02
            0, // startingTub
            4096, // stoppingTub
            Quad.wrap(bytes16(0x40059000000000000000000000000000)), // liquidityPerTub = 1e+02
            Quad.wrap(bytes16(0x40061ad5d03797ade615ebe5ad4dd249)), // expected token0 = 1.41417604195848024924996542572977972e+02
            Quad.wrap(bytes16(0x40051ad3e3b2a4504826fe33545ba1b8)), // expected token1 = 7.07069232857502997478571876931418406e+01
            false // skip the checks
        );
        Quad[] memory owedPotential = new Quad[](1);
        owedPotential[0] = Quad.wrap(bytes16(0x3fff0000000000000000000000000000));
        // int256 midBin = 15826;
        NewLoan.NewLoanParams memory params = NewLoan.NewLoanParams({
            owedPotential: owedPotential, // owedPotential = 1e+00
            startBin: 15825, // startBin
            strikeBin: 15825, // strikeBin
            tokenMix: Quad.wrap(bytes16(0x3ffe8000000000000000000000000000)), // tokenMix = 7.5e-01
            lockinEnd: POSITIVE_INFINITY,
            deadEra: OptInt256.wrap(OPT_INT256_NONE), // deadEra
            token: false, // token, unused for non-twap
            twapUntil: OptInt256.wrap(OPT_INT256_NONE) // twapUntil, disabled
        });
        UserPay.Info memory userPay = pool.newLoanOnly(params);
        Quad expectedToken0 = Quad.wrap(bytes16(0x3ff2cd74c4c2dfb7eedfcfa6a51a7f42)); // expecting userPay.token0 = 2.20039428395293167182387180184569879e-04
        assertTokenAmount(userPay.token0, expectedToken0, newLoanTestEpsilon);
        Quad expectedToken1 = -Quad.wrap(bytes16(0x3ff17f07cd411c78089364e9605fee0c)); // expecting userPay.token1 = -9.13215817648620964894596086505812173e-05
        assertTokenAmount(userPay.token1, expectedToken1, newLoanTestEpsilon);

        console.log("testNewLoan_test_newloan_nontwap_with_whole_range_pour_immediate_below_mid_price_0_5_and_token_mix_0_75 testing done.");
    }

    function testNewLoan_test_newloan_nontwap_with_whole_range_pour_immediate_above_mid_price_0_5_and_token_mix_0_75() public {
        console.log("testNewLoan_test_newloan_nontwap_with_whole_range_pour_immediate_above_mid_price_0_5_and_token_mix_0_75 starting ......");
        testLimitedRangePour(
            Quad.wrap(bytes16(0x3ffe0000000000000000000000000000)), // price = 5e-01
            Quad.wrap(bytes16(0x3ff847ae147ae147ae147ae147ae147b)), // quadVar = 1.00000000000000000000000000000000002e-02
            0, // startingTub
            4096, // stoppingTub
            Quad.wrap(bytes16(0x40059000000000000000000000000000)), // liquidityPerTub = 1e+02
            Quad.wrap(bytes16(0x40061ad5d03797ade615ebe5ad4dd249)), // expected token0 = 1.41417604195848024924996542572977972e+02
            Quad.wrap(bytes16(0x40051ad3e3b2a4504826fe33545ba1b8)), // expected token1 = 7.07069232857502997478571876931418406e+01
            false // skip the checks
        );
        Quad[] memory owedPotential = new Quad[](1);
        owedPotential[0] = Quad.wrap(bytes16(0x3fff0000000000000000000000000000));
        // int256 midBin = 15826;
        NewLoan.NewLoanParams memory params = NewLoan.NewLoanParams({
            owedPotential: owedPotential, // owedPotential = 1e+00
            startBin: 15827, // startBin
            strikeBin: 15827, // strikeBin
            tokenMix: Quad.wrap(bytes16(0x3ffe8000000000000000000000000000)), // tokenMix = 7.5e-01
            lockinEnd: POSITIVE_INFINITY,
            deadEra: OptInt256.wrap(OPT_INT256_NONE), // deadEra
            token: false, // token, unused for non-twap
            twapUntil: OptInt256.wrap(OPT_INT256_NONE) // twapUntil, disabled
        });
        UserPay.Info memory userPay = pool.newLoanOnly(params);
        Quad expectedToken0 = -Quad.wrap(bytes16(0x3ff4463972b0dfd67486544e68173e42)); // expecting userPay.token0 = -6.22223675335859079072423731542682026e-04
        assertTokenAmount(userPay.token0, expectedToken0, newLoanTestEpsilon);
        Quad expectedToken1 = Quad.wrap(bytes16(0x3ff359fff7bdc7790706bcc318c50b23)); // expecting userPay.token1 = 3.29971193297023460347517011343082144e-04
        assertTokenAmount(userPay.token1, expectedToken1, newLoanTestEpsilon);

        console.log("testNewLoan_test_newloan_nontwap_with_whole_range_pour_immediate_above_mid_price_0_5_and_token_mix_0_75 testing done.");
    }

    function testNewLoan_test_newloan_nontwap_with_whole_range_pour_far_below_mid_price_0_5_and_token_mix_0_75() public {
        console.log("testNewLoan_test_newloan_nontwap_with_whole_range_pour_far_below_mid_price_0_5_and_token_mix_0_75 starting ......");
        testLimitedRangePour(
            Quad.wrap(bytes16(0x3ffe0000000000000000000000000000)), // price = 5e-01
            Quad.wrap(bytes16(0x3ff847ae147ae147ae147ae147ae147b)), // quadVar = 1.00000000000000000000000000000000002e-02
            0, // startingTub
            4096, // stoppingTub
            Quad.wrap(bytes16(0x40059000000000000000000000000000)), // liquidityPerTub = 1e+02
            Quad.wrap(bytes16(0x40061ad5d03797ade615ebe5ad4dd249)), // expected token0 = 1.41417604195848024924996542572977972e+02
            Quad.wrap(bytes16(0x40051ad3e3b2a4504826fe33545ba1b8)), // expected token1 = 7.07069232857502997478571876931418406e+01
            false // skip the checks
        );
        Quad[] memory owedPotential = new Quad[](1);
        owedPotential[0] = Quad.wrap(bytes16(0x3fff0000000000000000000000000000));
        // int256 midBin = 15826;
        NewLoan.NewLoanParams memory params = NewLoan.NewLoanParams({
            owedPotential: owedPotential, // owedPotential = 1e+00
            startBin: 15816, // startBin
            strikeBin: 15816, // strikeBin
            tokenMix: Quad.wrap(bytes16(0x3ffe8000000000000000000000000000)), // tokenMix = 7.5e-01
            lockinEnd: POSITIVE_INFINITY,
            deadEra: OptInt256.wrap(OPT_INT256_NONE), // deadEra
            token: false, // token, unused for non-twap
            twapUntil: OptInt256.wrap(OPT_INT256_NONE) // twapUntil, disabled
        });
        UserPay.Info memory userPay = pool.newLoanOnly(params);
        Quad expectedToken0 = Quad.wrap(bytes16(0x3ff2d00bd19a20bd18a4b4875fe23eb2)); // expecting userPay.token0 = 2.21274455558610878256124086133524623e-04
        assertTokenAmount(userPay.token0, expectedToken0, newLoanTestEpsilon);
        Quad expectedToken1 = -Quad.wrap(bytes16(0x3ff1861081b8b038e9fa1ed28b9f0174)); // expecting userPay.token1 = -9.29986189346489089516783569143994505e-05
        assertTokenAmount(userPay.token1, expectedToken1, newLoanTestEpsilon);

        console.log("testNewLoan_test_newloan_nontwap_with_whole_range_pour_far_below_mid_price_0_5_and_token_mix_0_75 testing done.");
    }

    function testNewLoan_test_newloan_nontwap_with_whole_range_pour_far_above_mid_price_0_5_and_token_mix_0_75() public {
        console.log("testNewLoan_test_newloan_nontwap_with_whole_range_pour_far_above_mid_price_0_5_and_token_mix_0_75 starting ......");
        testLimitedRangePour(
            Quad.wrap(bytes16(0x3ffe0000000000000000000000000000)), // price = 5e-01
            Quad.wrap(bytes16(0x3ff847ae147ae147ae147ae147ae147b)), // quadVar = 1.00000000000000000000000000000000002e-02
            0, // startingTub
            4096, // stoppingTub
            Quad.wrap(bytes16(0x40059000000000000000000000000000)), // liquidityPerTub = 1e+02
            Quad.wrap(bytes16(0x40061ad5d03797ade615ebe5ad4dd249)), // expected token0 = 1.41417604195848024924996542572977972e+02
            Quad.wrap(bytes16(0x40051ad3e3b2a4504826fe33545ba1b8)), // expected token1 = 7.07069232857502997478571876931418406e+01
            false // skip the checks
        );
        Quad[] memory owedPotential = new Quad[](1);
        owedPotential[0] = Quad.wrap(bytes16(0x3fff0000000000000000000000000000));
        // int256 midBin = 15826;
        NewLoan.NewLoanParams memory params = NewLoan.NewLoanParams({
            owedPotential: owedPotential, // owedPotential = 1e+00
            startBin: 15836, // startBin
            strikeBin: 15836, // strikeBin
            tokenMix: Quad.wrap(bytes16(0x3ffe8000000000000000000000000000)), // tokenMix = 7.5e-01
            lockinEnd: POSITIVE_INFINITY,
            deadEra: OptInt256.wrap(OPT_INT256_NONE), // deadEra
            token: false, // token, unused for non-twap
            twapUntil: OptInt256.wrap(OPT_INT256_NONE) // twapUntil, disabled
        });
        UserPay.Info memory userPay = pool.newLoanOnly(params);
        Quad expectedToken0 = -Quad.wrap(bytes16(0x3ff446b27ab57f1acad531208689472d)); // expecting userPay.token0 = -6.23125428944206597440310988698740771e-04
        assertTokenAmount(userPay.token0, expectedToken0, newLoanTestEpsilon);
        Quad expectedToken1 = Quad.wrap(bytes16(0x3ff35bf11f730d6da39c2bac289d4eaa)); // expecting userPay.token1 = 3.31823240404244996280238592660434952e-04
        assertTokenAmount(userPay.token1, expectedToken1, newLoanTestEpsilon);

        console.log("testNewLoan_test_newloan_nontwap_with_whole_range_pour_far_above_mid_price_0_5_and_token_mix_0_75 testing done.");
    }

    function testNewLoan_test_newloan_nontwap_with_whole_range_pour_immediate_below_mid_price_0_5_and_token_mix_1() public {
        console.log("testNewLoan_test_newloan_nontwap_with_whole_range_pour_immediate_below_mid_price_0_5_and_token_mix_1 starting ......");
        testLimitedRangePour(
            Quad.wrap(bytes16(0x3ffe0000000000000000000000000000)), // price = 5e-01
            Quad.wrap(bytes16(0x3ff847ae147ae147ae147ae147ae147b)), // quadVar = 1.00000000000000000000000000000000002e-02
            0, // startingTub
            4096, // stoppingTub
            Quad.wrap(bytes16(0x40059000000000000000000000000000)), // liquidityPerTub = 1e+02
            Quad.wrap(bytes16(0x40061ad5d03797ade615ebe5ad4dd249)), // expected token0 = 1.41417604195848024924996542572977972e+02
            Quad.wrap(bytes16(0x40051ad3e3b2a4504826fe33545ba1b8)), // expected token1 = 7.07069232857502997478571876931418406e+01
            false // skip the checks
        );
        Quad[] memory owedPotential = new Quad[](1);
        owedPotential[0] = Quad.wrap(bytes16(0x3fff0000000000000000000000000000));
        // int256 midBin = 15826;
        NewLoan.NewLoanParams memory params = NewLoan.NewLoanParams({
            owedPotential: owedPotential, // owedPotential = 1e+00
            startBin: 15825, // startBin
            strikeBin: 15825, // strikeBin
            tokenMix: Quad.wrap(bytes16(0x3fff0000000000000000000000000000)), // tokenMix = 1e+00
            lockinEnd: POSITIVE_INFINITY,
            deadEra: OptInt256.wrap(OPT_INT256_NONE), // deadEra
            token: false, // token, unused for non-twap
            twapUntil: OptInt256.wrap(OPT_INT256_NONE) // twapUntil, disabled
        });
        UserPay.Info memory userPay = pool.newLoanOnly(params);
        Quad expectedToken0 = POSITIVE_ZERO; // expecting userPay.token0 = 0e+00
        assertTokenAmount(userPay.token0, expectedToken0, newLoanTestEpsilon);
        Quad expectedToken1 = Quad.wrap(bytes16(0x3fef36eabef88c490ba7846c66f79360)); // expecting userPay.token1 = 1.85320959379992785409847433518844934e-05
        assertTokenAmount(userPay.token1, expectedToken1, newLoanTestEpsilon);

        console.log("testNewLoan_test_newloan_nontwap_with_whole_range_pour_immediate_below_mid_price_0_5_and_token_mix_1 testing done.");
    }

    function testNewLoan_test_newloan_nontwap_with_whole_range_pour_immediate_above_mid_price_0_5_and_token_mix_1() public {
        console.log("testNewLoan_test_newloan_nontwap_with_whole_range_pour_immediate_above_mid_price_0_5_and_token_mix_1 starting ......");
        testLimitedRangePour(
            Quad.wrap(bytes16(0x3ffe0000000000000000000000000000)), // price = 5e-01
            Quad.wrap(bytes16(0x3ff847ae147ae147ae147ae147ae147b)), // quadVar = 1.00000000000000000000000000000000002e-02
            0, // startingTub
            4096, // stoppingTub
            Quad.wrap(bytes16(0x40059000000000000000000000000000)), // liquidityPerTub = 1e+02
            Quad.wrap(bytes16(0x40061ad5d03797ade615ebe5ad4dd249)), // expected token0 = 1.41417604195848024924996542572977972e+02
            Quad.wrap(bytes16(0x40051ad3e3b2a4504826fe33545ba1b8)), // expected token1 = 7.07069232857502997478571876931418406e+01
            false // skip the checks
        );
        Quad[] memory owedPotential = new Quad[](1);
        owedPotential[0] = Quad.wrap(bytes16(0x3fff0000000000000000000000000000));
        // int256 midBin = 15826;
        NewLoan.NewLoanParams memory params = NewLoan.NewLoanParams({
            owedPotential: owedPotential, // owedPotential = 1e+00
            startBin: 15827, // startBin
            strikeBin: 15827, // strikeBin
            tokenMix: Quad.wrap(bytes16(0x3fff0000000000000000000000000000)), // tokenMix = 1e+00
            lockinEnd: POSITIVE_INFINITY,
            deadEra: OptInt256.wrap(OPT_INT256_NONE), // deadEra
            token: false, // token, unused for non-twap
            twapUntil: OptInt256.wrap(OPT_INT256_NONE) // twapUntil, disabled
        });
        UserPay.Info memory userPay = pool.newLoanOnly(params);
        Quad expectedToken0 = -Quad.wrap(bytes16(0x3ff4b971ee0bbccba5a97b07982c9da0)); // expecting userPay.token0 = -8.41989590723810853024400449398090589e-04
        assertTokenAmount(userPay.token0, expectedToken0, newLoanTestEpsilon);
        Quad expectedToken1 = Quad.wrap(bytes16(0x3ff3cd554a525f4c095e51042106b984)); // expecting userPay.token1 = 4.39961591062697947130022681790776191e-04
        assertTokenAmount(userPay.token1, expectedToken1, newLoanTestEpsilon);

        console.log("testNewLoan_test_newloan_nontwap_with_whole_range_pour_immediate_above_mid_price_0_5_and_token_mix_1 testing done.");
    }

    function testNewLoan_test_newloan_nontwap_with_whole_range_pour_far_below_mid_price_0_5_and_token_mix_1() public {
        console.log("testNewLoan_test_newloan_nontwap_with_whole_range_pour_far_below_mid_price_0_5_and_token_mix_1 starting ......");
        testLimitedRangePour(
            Quad.wrap(bytes16(0x3ffe0000000000000000000000000000)), // price = 5e-01
            Quad.wrap(bytes16(0x3ff847ae147ae147ae147ae147ae147b)), // quadVar = 1.00000000000000000000000000000000002e-02
            0, // startingTub
            4096, // stoppingTub
            Quad.wrap(bytes16(0x40059000000000000000000000000000)), // liquidityPerTub = 1e+02
            Quad.wrap(bytes16(0x40061ad5d03797ade615ebe5ad4dd249)), // expected token0 = 1.41417604195848024924996542572977972e+02
            Quad.wrap(bytes16(0x40051ad3e3b2a4504826fe33545ba1b8)), // expected token1 = 7.07069232857502997478571876931418406e+01
            false // skip the checks
        );
        Quad[] memory owedPotential = new Quad[](1);
        owedPotential[0] = Quad.wrap(bytes16(0x3fff0000000000000000000000000000));
        // int256 midBin = 15826;
        NewLoan.NewLoanParams memory params = NewLoan.NewLoanParams({
            owedPotential: owedPotential, // owedPotential = 1e+00
            startBin: 15816, // startBin
            strikeBin: 15816, // strikeBin
            tokenMix: Quad.wrap(bytes16(0x3fff0000000000000000000000000000)), // tokenMix = 1e+00
            lockinEnd: POSITIVE_INFINITY,
            deadEra: OptInt256.wrap(OPT_INT256_NONE), // deadEra
            token: false, // token, unused for non-twap
            twapUntil: OptInt256.wrap(OPT_INT256_NONE) // twapUntil, disabled
        });
        UserPay.Info memory userPay = pool.newLoanOnly(params);
        Quad expectedToken0 = POSITIVE_ZERO; // expecting userPay.token0 = 0e+00
        assertTokenAmount(userPay.token0, expectedToken0, newLoanTestEpsilon);
        Quad expectedToken1 = Quad.wrap(bytes16(0x3fef107e82436feea487914f6a43dac0)); // expecting userPay.token1 = 1.62419185139030558265564036737647298e-05
        assertTokenAmount(userPay.token1, expectedToken1, newLoanTestEpsilon);

        console.log("testNewLoan_test_newloan_nontwap_with_whole_range_pour_far_below_mid_price_0_5_and_token_mix_1 testing done.");
    }

    function testNewLoan_test_newloan_nontwap_with_whole_range_pour_far_above_mid_price_0_5_and_token_mix_1() public {
        console.log("testNewLoan_test_newloan_nontwap_with_whole_range_pour_far_above_mid_price_0_5_and_token_mix_1 starting ......");
        testLimitedRangePour(
            Quad.wrap(bytes16(0x3ffe0000000000000000000000000000)), // price = 5e-01
            Quad.wrap(bytes16(0x3ff847ae147ae147ae147ae147ae147b)), // quadVar = 1.00000000000000000000000000000000002e-02
            0, // startingTub
            4096, // stoppingTub
            Quad.wrap(bytes16(0x40059000000000000000000000000000)), // liquidityPerTub = 1e+02
            Quad.wrap(bytes16(0x40061ad5d03797ade615ebe5ad4dd249)), // expected token0 = 1.41417604195848024924996542572977972e+02
            Quad.wrap(bytes16(0x40051ad3e3b2a4504826fe33545ba1b8)), // expected token1 = 7.07069232857502997478571876931418406e+01
            false // skip the checks
        );
        Quad[] memory owedPotential = new Quad[](1);
        owedPotential[0] = Quad.wrap(bytes16(0x3fff0000000000000000000000000000));
        // int256 midBin = 15826;
        NewLoan.NewLoanParams memory params = NewLoan.NewLoanParams({
            owedPotential: owedPotential, // owedPotential = 1e+00
            startBin: 15836, // startBin
            strikeBin: 15836, // strikeBin
            tokenMix: Quad.wrap(bytes16(0x3fff0000000000000000000000000000)), // tokenMix = 1e+00
            lockinEnd: POSITIVE_INFINITY,
            deadEra: OptInt256.wrap(OPT_INT256_NONE), // deadEra
            token: false, // token, unused for non-twap
            twapUntil: OptInt256.wrap(OPT_INT256_NONE) // twapUntil, disabled
        });
        UserPay.Info memory userPay = pool.newLoanOnly(params);
        Quad expectedToken0 = -Quad.wrap(bytes16(0x3ff4b9465427f26608d689769b1b736c)); // expecting userPay.token0 = -8.41664736975288795209998294462288287e-04
        assertTokenAmount(userPay.token0, expectedToken0, newLoanTestEpsilon);
        Quad expectedToken1 = Quad.wrap(bytes16(0x3ff3cfec29eebc922f7ae4e58b7c68e2)); // expecting userPay.token1 = 4.42430987205659995040318123547246571e-04
        assertTokenAmount(userPay.token1, expectedToken1, newLoanTestEpsilon);

        console.log("testNewLoan_test_newloan_nontwap_with_whole_range_pour_far_above_mid_price_0_5_and_token_mix_1 testing done.");
    }

    function testNewLoan_test_newloan_nontwap_with_whole_range_pour_immediate_below_mid_price_0_989999999999999999999999999999999992_and_token_mix_0()
        public
    {
        console.log(
            "testNewLoan_test_newloan_nontwap_with_whole_range_pour_immediate_below_mid_price_0_989999999999999999999999999999999992_and_token_mix_0 starting ......"
        );
        testLimitedRangePour(
            Quad.wrap(bytes16(0x3ffefae147ae147ae147ae147ae147ae)), // price = 9.89999999999999999999999999999999992e-01
            Quad.wrap(bytes16(0x3ff847ae147ae147ae147ae147ae147b)), // quadVar = 1.00000000000000000000000000000000002e-02
            0, // startingTub
            4096, // stoppingTub
            Quad.wrap(bytes16(0x40059000000000000000000000000000)), // liquidityPerTub = 1e+02
            Quad.wrap(bytes16(0x4005920006a486d7fa6966fcc0be345e)), // expected token0 = 1.00500025339822963853933145844738578e+02
            Quad.wrap(bytes16(0x40058dfade01784b70683475311c5d2d)), // expected token1 = 9.94949875096962021166384124352674141e+01
            false // skip the checks
        );
        Quad[] memory owedPotential = new Quad[](1);
        owedPotential[0] = Quad.wrap(bytes16(0x3fff0000000000000000000000000000));
        // int256 midBin = 16375;
        NewLoan.NewLoanParams memory params = NewLoan.NewLoanParams({
            owedPotential: owedPotential, // owedPotential = 1e+00
            startBin: 16374, // startBin
            strikeBin: 16374, // strikeBin
            tokenMix: POSITIVE_ZERO, // tokenMix = 0e+00
            lockinEnd: POSITIVE_INFINITY,
            deadEra: OptInt256.wrap(OPT_INT256_NONE), // deadEra
            token: false, // token, unused for non-twap
            twapUntil: OptInt256.wrap(OPT_INT256_NONE) // twapUntil, disabled
        });
        UserPay.Info memory userPay = pool.newLoanOnly(params);
        Quad expectedToken0 = Quad.wrap(bytes16(0x3ff447fc062923f1ad3795b45e7aa6b2)); // expecting userPay.token0 = 6.25580728540217756143357468514328875e-04
        assertTokenAmount(userPay.token0, expectedToken0, newLoanTestEpsilon);
        Quad expectedToken1 = -Quad.wrap(bytes16(0x3ff436763280283c7ed9a9240ac72665)); // expecting userPay.token1 = -5.92158714443618588143985337407496128e-04
        assertTokenAmount(userPay.token1, expectedToken1, newLoanTestEpsilon);

        console.log(
            "testNewLoan_test_newloan_nontwap_with_whole_range_pour_immediate_below_mid_price_0_989999999999999999999999999999999992_and_token_mix_0 testing done."
        );
    }

    function testNewLoan_test_newloan_nontwap_with_whole_range_pour_immediate_above_mid_price_0_989999999999999999999999999999999992_and_token_mix_0()
        public
    {
        console.log(
            "testNewLoan_test_newloan_nontwap_with_whole_range_pour_immediate_above_mid_price_0_989999999999999999999999999999999992_and_token_mix_0 starting ......"
        );
        testLimitedRangePour(
            Quad.wrap(bytes16(0x3ffefae147ae147ae147ae147ae147ae)), // price = 9.89999999999999999999999999999999992e-01
            Quad.wrap(bytes16(0x3ff847ae147ae147ae147ae147ae147b)), // quadVar = 1.00000000000000000000000000000000002e-02
            0, // startingTub
            4096, // stoppingTub
            Quad.wrap(bytes16(0x40059000000000000000000000000000)), // liquidityPerTub = 1e+02
            Quad.wrap(bytes16(0x4005920006a486d7fa6966fcc0be345e)), // expected token0 = 1.00500025339822963853933145844738578e+02
            Quad.wrap(bytes16(0x40058dfade01784b70683475311c5d2d)), // expected token1 = 9.94949875096962021166384124352674141e+01
            false // skip the checks
        );
        Quad[] memory owedPotential = new Quad[](1);
        owedPotential[0] = Quad.wrap(bytes16(0x3fff0000000000000000000000000000));
        // int256 midBin = 16375;
        NewLoan.NewLoanParams memory params = NewLoan.NewLoanParams({
            owedPotential: owedPotential, // owedPotential = 1e+00
            startBin: 16376, // startBin
            strikeBin: 16376, // strikeBin
            tokenMix: POSITIVE_ZERO, // tokenMix = 0e+00
            lockinEnd: POSITIVE_INFINITY,
            deadEra: OptInt256.wrap(OPT_INT256_NONE), // deadEra
            token: false, // token, unused for non-twap
            twapUntil: OptInt256.wrap(OPT_INT256_NONE) // twapUntil, disabled
        });
        UserPay.Info memory userPay = pool.newLoanOnly(params);
        Quad expectedToken0 = Quad.wrap(bytes16(0x3fefba17a67a73a39eb0da6408c5a280)); // expecting userPay.token0 = 2.63507595066830738209087333703816386e-05
        assertTokenAmount(userPay.token0, expectedToken0, newLoanTestEpsilon);
        Quad expectedToken1 = POSITIVE_ZERO; // expecting userPay.token1 = 0e+00
        assertTokenAmount(userPay.token1, expectedToken1, newLoanTestEpsilon);

        console.log(
            "testNewLoan_test_newloan_nontwap_with_whole_range_pour_immediate_above_mid_price_0_989999999999999999999999999999999992_and_token_mix_0 testing done."
        );
    }

    function testNewLoan_test_newloan_nontwap_with_whole_range_pour_far_below_mid_price_0_989999999999999999999999999999999992_and_token_mix_0()
        public
    {
        console.log(
            "testNewLoan_test_newloan_nontwap_with_whole_range_pour_far_below_mid_price_0_989999999999999999999999999999999992_and_token_mix_0 starting ......"
        );
        testLimitedRangePour(
            Quad.wrap(bytes16(0x3ffefae147ae147ae147ae147ae147ae)), // price = 9.89999999999999999999999999999999992e-01
            Quad.wrap(bytes16(0x3ff847ae147ae147ae147ae147ae147b)), // quadVar = 1.00000000000000000000000000000000002e-02
            0, // startingTub
            4096, // stoppingTub
            Quad.wrap(bytes16(0x40059000000000000000000000000000)), // liquidityPerTub = 1e+02
            Quad.wrap(bytes16(0x4005920006a486d7fa6966fcc0be345e)), // expected token0 = 1.00500025339822963853933145844738578e+02
            Quad.wrap(bytes16(0x40058dfade01784b70683475311c5d2d)), // expected token1 = 9.94949875096962021166384124352674141e+01
            false // skip the checks
        );
        Quad[] memory owedPotential = new Quad[](1);
        owedPotential[0] = Quad.wrap(bytes16(0x3fff0000000000000000000000000000));
        // int256 midBin = 16375;
        NewLoan.NewLoanParams memory params = NewLoan.NewLoanParams({
            owedPotential: owedPotential, // owedPotential = 1e+00
            startBin: 16365, // startBin
            strikeBin: 16365, // strikeBin
            tokenMix: POSITIVE_ZERO, // tokenMix = 0e+00
            lockinEnd: POSITIVE_INFINITY,
            deadEra: OptInt256.wrap(OPT_INT256_NONE), // deadEra
            token: false, // token, unused for non-twap
            twapUntil: OptInt256.wrap(OPT_INT256_NONE) // twapUntil, disabled
        });
        UserPay.Info memory userPay = pool.newLoanOnly(params);
        Quad expectedToken0 = Quad.wrap(bytes16(0x3ff449d34b20db33c17b3d71d4bcfa8b)); // expecting userPay.token0 = 6.29091959223871808789304157654216016e-04
        assertTokenAmount(userPay.token0, expectedToken0, newLoanTestEpsilon);
        Quad expectedToken1 = -Quad.wrap(bytes16(0x3ff43657888294717b26068dec3dc3ac)); // expecting userPay.token1 = -5.91930249649960453938194349489031508e-04
        assertTokenAmount(userPay.token1, expectedToken1, newLoanTestEpsilon);

        console.log(
            "testNewLoan_test_newloan_nontwap_with_whole_range_pour_far_below_mid_price_0_989999999999999999999999999999999992_and_token_mix_0 testing done."
        );
    }

    function testNewLoan_test_newloan_nontwap_with_whole_range_pour_far_above_mid_price_0_989999999999999999999999999999999992_and_token_mix_0()
        public
    {
        console.log(
            "testNewLoan_test_newloan_nontwap_with_whole_range_pour_far_above_mid_price_0_989999999999999999999999999999999992_and_token_mix_0 starting ......"
        );
        testLimitedRangePour(
            Quad.wrap(bytes16(0x3ffefae147ae147ae147ae147ae147ae)), // price = 9.89999999999999999999999999999999992e-01
            Quad.wrap(bytes16(0x3ff847ae147ae147ae147ae147ae147b)), // quadVar = 1.00000000000000000000000000000000002e-02
            0, // startingTub
            4096, // stoppingTub
            Quad.wrap(bytes16(0x40059000000000000000000000000000)), // liquidityPerTub = 1e+02
            Quad.wrap(bytes16(0x4005920006a486d7fa6966fcc0be345e)), // expected token0 = 1.00500025339822963853933145844738578e+02
            Quad.wrap(bytes16(0x40058dfade01784b70683475311c5d2d)), // expected token1 = 9.94949875096962021166384124352674141e+01
            false // skip the checks
        );
        Quad[] memory owedPotential = new Quad[](1);
        owedPotential[0] = Quad.wrap(bytes16(0x3fff0000000000000000000000000000));
        // int256 midBin = 16375;
        NewLoan.NewLoanParams memory params = NewLoan.NewLoanParams({
            owedPotential: owedPotential, // owedPotential = 1e+00
            startBin: 16385, // startBin
            strikeBin: 16385, // strikeBin
            tokenMix: POSITIVE_ZERO, // tokenMix = 0e+00
            lockinEnd: POSITIVE_INFINITY,
            deadEra: OptInt256.wrap(OPT_INT256_NONE), // deadEra
            token: false, // token, unused for non-twap
            twapUntil: OptInt256.wrap(OPT_INT256_NONE) // twapUntil, disabled
        });
        UserPay.Info memory userPay = pool.newLoanOnly(params);
        Quad expectedToken0 = Quad.wrap(bytes16(0x3fef837584f908cf93aa4e1423c5fb80)); // expecting userPay.token0 = 2.30943596514322897337157095913326479e-05
        assertTokenAmount(userPay.token0, expectedToken0, newLoanTestEpsilon);
        Quad expectedToken1 = POSITIVE_ZERO; // expecting userPay.token1 = 0e+00
        assertTokenAmount(userPay.token1, expectedToken1, newLoanTestEpsilon);

        console.log(
            "testNewLoan_test_newloan_nontwap_with_whole_range_pour_far_above_mid_price_0_989999999999999999999999999999999992_and_token_mix_0 testing done."
        );
    }

    function testNewLoan_test_newloan_nontwap_with_whole_range_pour_immediate_below_mid_price_0_989999999999999999999999999999999992_and_token_mix_0_25(
    ) public {
        console.log(
            "testNewLoan_test_newloan_nontwap_with_whole_range_pour_immediate_below_mid_price_0_989999999999999999999999999999999992_and_token_mix_0_25 starting ......"
        );
        testLimitedRangePour(
            Quad.wrap(bytes16(0x3ffefae147ae147ae147ae147ae147ae)), // price = 9.89999999999999999999999999999999992e-01
            Quad.wrap(bytes16(0x3ff847ae147ae147ae147ae147ae147b)), // quadVar = 1.00000000000000000000000000000000002e-02
            0, // startingTub
            4096, // stoppingTub
            Quad.wrap(bytes16(0x40059000000000000000000000000000)), // liquidityPerTub = 1e+02
            Quad.wrap(bytes16(0x4005920006a486d7fa6966fcc0be345e)), // expected token0 = 1.00500025339822963853933145844738578e+02
            Quad.wrap(bytes16(0x40058dfade01784b70683475311c5d2d)), // expected token1 = 9.94949875096962021166384124352674141e+01
            false // skip the checks
        );
        Quad[] memory owedPotential = new Quad[](1);
        owedPotential[0] = Quad.wrap(bytes16(0x3fff0000000000000000000000000000));
        // int256 midBin = 16375;
        NewLoan.NewLoanParams memory params = NewLoan.NewLoanParams({
            owedPotential: owedPotential, // owedPotential = 1e+00
            startBin: 16374, // startBin
            strikeBin: 16374, // strikeBin
            tokenMix: Quad.wrap(bytes16(0x3ffd0000000000000000000000000000)), // tokenMix = 2.5e-01
            lockinEnd: POSITIVE_INFINITY,
            deadEra: OptInt256.wrap(OPT_INT256_NONE), // deadEra
            token: false, // token, unused for non-twap
            twapUntil: OptInt256.wrap(OPT_INT256_NONE) // twapUntil, disabled
        });
        UserPay.Info memory userPay = pool.newLoanOnly(params);
        Quad expectedToken0 = Quad.wrap(bytes16(0x3ff3ebfa093db5ea83d3608e8db7fa0a)); // expecting userPay.token0 = 4.69185546405163317107518101385746609e-04
        assertTokenAmount(userPay.token0, expectedToken0, newLoanTestEpsilon);
        Quad expectedToken1 = -Quad.wrap(bytes16(0x3ff3cadb86036a3f9d3aef9889d27358)); // expecting userPay.token1 = -4.37600625640188421548501521961097096e-04
        assertTokenAmount(userPay.token1, expectedToken1, newLoanTestEpsilon);

        console.log(
            "testNewLoan_test_newloan_nontwap_with_whole_range_pour_immediate_below_mid_price_0_989999999999999999999999999999999992_and_token_mix_0_25 testing done."
        );
    }

    function testNewLoan_test_newloan_nontwap_with_whole_range_pour_immediate_above_mid_price_0_989999999999999999999999999999999992_and_token_mix_0_25(
    ) public {
        console.log(
            "testNewLoan_test_newloan_nontwap_with_whole_range_pour_immediate_above_mid_price_0_989999999999999999999999999999999992_and_token_mix_0_25 starting ......"
        );
        testLimitedRangePour(
            Quad.wrap(bytes16(0x3ffefae147ae147ae147ae147ae147ae)), // price = 9.89999999999999999999999999999999992e-01
            Quad.wrap(bytes16(0x3ff847ae147ae147ae147ae147ae147b)), // quadVar = 1.00000000000000000000000000000000002e-02
            0, // startingTub
            4096, // stoppingTub
            Quad.wrap(bytes16(0x40059000000000000000000000000000)), // liquidityPerTub = 1e+02
            Quad.wrap(bytes16(0x4005920006a486d7fa6966fcc0be345e)), // expected token0 = 1.00500025339822963853933145844738578e+02
            Quad.wrap(bytes16(0x40058dfade01784b70683475311c5d2d)), // expected token1 = 9.94949875096962021166384124352674141e+01
            false // skip the checks
        );
        Quad[] memory owedPotential = new Quad[](1);
        owedPotential[0] = Quad.wrap(bytes16(0x3fff0000000000000000000000000000));
        // int256 midBin = 16375;
        NewLoan.NewLoanParams memory params = NewLoan.NewLoanParams({
            owedPotential: owedPotential, // owedPotential = 1e+00
            startBin: 16376, // startBin
            strikeBin: 16376, // strikeBin
            tokenMix: Quad.wrap(bytes16(0x3ffd0000000000000000000000000000)), // tokenMix = 2.5e-01
            lockinEnd: POSITIVE_INFINITY,
            deadEra: OptInt256.wrap(OPT_INT256_NONE), // deadEra
            token: false, // token, unused for non-twap
            twapUntil: OptInt256.wrap(OPT_INT256_NONE) // twapUntil, disabled
        });
        UserPay.Info memory userPay = pool.newLoanOnly(params);
        Quad expectedToken0 = -Quad.wrap(bytes16(0x3ff21050b2efab77fa9b46569ff2218a)); // expecting userPay.token0 = -1.29850020575469201367364845970107984e-04
        assertTokenAmount(userPay.token0, expectedToken0, newLoanTestEpsilon);
        Quad expectedToken1 = Quad.wrap(bytes16(0x3ff244890367c0a903d5b3fbd651ebdd)); // expecting userPay.token1 = 1.54750446419955635631200669350971415e-04
        assertTokenAmount(userPay.token1, expectedToken1, newLoanTestEpsilon);

        console.log(
            "testNewLoan_test_newloan_nontwap_with_whole_range_pour_immediate_above_mid_price_0_989999999999999999999999999999999992_and_token_mix_0_25 testing done."
        );
    }

    function testNewLoan_test_newloan_nontwap_with_whole_range_pour_far_below_mid_price_0_989999999999999999999999999999999992_and_token_mix_0_25()
        public
    {
        console.log(
            "testNewLoan_test_newloan_nontwap_with_whole_range_pour_far_below_mid_price_0_989999999999999999999999999999999992_and_token_mix_0_25 starting ......"
        );
        testLimitedRangePour(
            Quad.wrap(bytes16(0x3ffefae147ae147ae147ae147ae147ae)), // price = 9.89999999999999999999999999999999992e-01
            Quad.wrap(bytes16(0x3ff847ae147ae147ae147ae147ae147b)), // quadVar = 1.00000000000000000000000000000000002e-02
            0, // startingTub
            4096, // stoppingTub
            Quad.wrap(bytes16(0x40059000000000000000000000000000)), // liquidityPerTub = 1e+02
            Quad.wrap(bytes16(0x4005920006a486d7fa6966fcc0be345e)), // expected token0 = 1.00500025339822963853933145844738578e+02
            Quad.wrap(bytes16(0x40058dfade01784b70683475311c5d2d)), // expected token1 = 9.94949875096962021166384124352674141e+01
            false // skip the checks
        );
        Quad[] memory owedPotential = new Quad[](1);
        owedPotential[0] = Quad.wrap(bytes16(0x3fff0000000000000000000000000000));
        // int256 midBin = 16375;
        NewLoan.NewLoanParams memory params = NewLoan.NewLoanParams({
            owedPotential: owedPotential, // owedPotential = 1e+00
            startBin: 16365, // startBin
            strikeBin: 16365, // strikeBin
            tokenMix: Quad.wrap(bytes16(0x3ffd0000000000000000000000000000)), // tokenMix = 2.5e-01
            lockinEnd: POSITIVE_INFINITY,
            deadEra: OptInt256.wrap(OPT_INT256_NONE), // deadEra
            token: false, // token, unused for non-twap
            twapUntil: OptInt256.wrap(OPT_INT256_NONE) // twapUntil, disabled
        });
        UserPay.Info memory userPay = pool.newLoanOnly(params);
        Quad expectedToken0 = Quad.wrap(bytes16(0x3ff3eebcf0b148cda238dc2abf1b77d1)); // expecting userPay.token0 = 4.71818969417903856591978118240662035e-04
        assertTokenAmount(userPay.token0, expectedToken0, newLoanTestEpsilon);
        Quad expectedToken1 = -Quad.wrap(bytes16(0x3ff3cb85c3355a51645a9cbf1491c6dc)); // expecting userPay.token1 = -4.38234815496389526485692044568527667e-04
        assertTokenAmount(userPay.token1, expectedToken1, newLoanTestEpsilon);

        console.log(
            "testNewLoan_test_newloan_nontwap_with_whole_range_pour_far_below_mid_price_0_989999999999999999999999999999999992_and_token_mix_0_25 testing done."
        );
    }

    function testNewLoan_test_newloan_nontwap_with_whole_range_pour_far_above_mid_price_0_989999999999999999999999999999999992_and_token_mix_0_25()
        public
    {
        console.log(
            "testNewLoan_test_newloan_nontwap_with_whole_range_pour_far_above_mid_price_0_989999999999999999999999999999999992_and_token_mix_0_25 starting ......"
        );
        testLimitedRangePour(
            Quad.wrap(bytes16(0x3ffefae147ae147ae147ae147ae147ae)), // price = 9.89999999999999999999999999999999992e-01
            Quad.wrap(bytes16(0x3ff847ae147ae147ae147ae147ae147b)), // quadVar = 1.00000000000000000000000000000000002e-02
            0, // startingTub
            4096, // stoppingTub
            Quad.wrap(bytes16(0x40059000000000000000000000000000)), // liquidityPerTub = 1e+02
            Quad.wrap(bytes16(0x4005920006a486d7fa6966fcc0be345e)), // expected token0 = 1.00500025339822963853933145844738578e+02
            Quad.wrap(bytes16(0x40058dfade01784b70683475311c5d2d)), // expected token1 = 9.94949875096962021166384124352674141e+01
            false // skip the checks
        );
        Quad[] memory owedPotential = new Quad[](1);
        owedPotential[0] = Quad.wrap(bytes16(0x3fff0000000000000000000000000000));
        // int256 midBin = 16375;
        NewLoan.NewLoanParams memory params = NewLoan.NewLoanParams({
            owedPotential: owedPotential, // owedPotential = 1e+00
            startBin: 16385, // startBin
            strikeBin: 16385, // strikeBin
            tokenMix: Quad.wrap(bytes16(0x3ffd0000000000000000000000000000)), // tokenMix = 2.5e-01
            lockinEnd: POSITIVE_INFINITY,
            deadEra: OptInt256.wrap(OPT_INT256_NONE), // deadEra
            token: false, // token, unused for non-twap
            twapUntil: OptInt256.wrap(OPT_INT256_NONE) // twapUntil, disabled
        });
        UserPay.Info memory userPay = pool.newLoanOnly(params);
        Quad expectedToken0 = -Quad.wrap(bytes16(0x3ff21550e8a7996f51ccd0223aac155c)); // expecting userPay.token0 = -1.32234597219830756422678408526514663e-04
        assertTokenAmount(userPay.token0, expectedToken0, newLoanTestEpsilon);
        Quad expectedToken1 = Quad.wrap(bytes16(0x3ff2465b539b0c9861af7816fcda4537)); // expecting userPay.token1 = 1.55619022594044058634001057875664262e-04
        assertTokenAmount(userPay.token1, expectedToken1, newLoanTestEpsilon);

        console.log(
            "testNewLoan_test_newloan_nontwap_with_whole_range_pour_far_above_mid_price_0_989999999999999999999999999999999992_and_token_mix_0_25 testing done."
        );
    }

    function testNewLoan_test_newloan_nontwap_with_whole_range_pour_immediate_below_mid_price_0_989999999999999999999999999999999992_and_token_mix_0_5(
    ) public {
        console.log(
            "testNewLoan_test_newloan_nontwap_with_whole_range_pour_immediate_below_mid_price_0_989999999999999999999999999999999992_and_token_mix_0_5 starting ......"
        );
        testLimitedRangePour(
            Quad.wrap(bytes16(0x3ffefae147ae147ae147ae147ae147ae)), // price = 9.89999999999999999999999999999999992e-01
            Quad.wrap(bytes16(0x3ff847ae147ae147ae147ae147ae147b)), // quadVar = 1.00000000000000000000000000000000002e-02
            0, // startingTub
            4096, // stoppingTub
            Quad.wrap(bytes16(0x40059000000000000000000000000000)), // liquidityPerTub = 1e+02
            Quad.wrap(bytes16(0x4005920006a486d7fa6966fcc0be345e)), // expected token0 = 1.00500025339822963853933145844738578e+02
            Quad.wrap(bytes16(0x40058dfade01784b70683475311c5d2d)), // expected token1 = 9.94949875096962021166384124352674141e+01
            false // skip the checks
        );
        Quad[] memory owedPotential = new Quad[](1);
        owedPotential[0] = Quad.wrap(bytes16(0x3fff0000000000000000000000000000));
        // int256 midBin = 16375;
        NewLoan.NewLoanParams memory params = NewLoan.NewLoanParams({
            owedPotential: owedPotential, // owedPotential = 1e+00
            startBin: 16374, // startBin
            strikeBin: 16374, // strikeBin
            tokenMix: Quad.wrap(bytes16(0x3ffe0000000000000000000000000000)), // tokenMix = 5e-01
            lockinEnd: POSITIVE_INFINITY,
            deadEra: OptInt256.wrap(OPT_INT256_NONE), // deadEra
            token: false, // token, unused for non-twap
            twapUntil: OptInt256.wrap(OPT_INT256_NONE) // twapUntil, disabled
        });
        UserPay.Info memory userPay = pool.newLoanOnly(params);
        Quad expectedToken0 = Quad.wrap(bytes16(0x3ff347fc062923f1ad3795b45e7aa6b2)); // expecting userPay.token0 = 3.12790364270108878071678734257164438e-04
        assertTokenAmount(userPay.token0, expectedToken0, newLoanTestEpsilon);
        Quad expectedToken1 = -Quad.wrap(bytes16(0x3ff328caa70684063cc28ce8fe1699e6)); // expecting userPay.token1 = -2.83042536836758254953017706514698063e-04
        assertTokenAmount(userPay.token1, expectedToken1, newLoanTestEpsilon);

        console.log(
            "testNewLoan_test_newloan_nontwap_with_whole_range_pour_immediate_below_mid_price_0_989999999999999999999999999999999992_and_token_mix_0_5 testing done."
        );
    }

    function testNewLoan_test_newloan_nontwap_with_whole_range_pour_immediate_above_mid_price_0_989999999999999999999999999999999992_and_token_mix_0_5(
    ) public {
        console.log(
            "testNewLoan_test_newloan_nontwap_with_whole_range_pour_immediate_above_mid_price_0_989999999999999999999999999999999992_and_token_mix_0_5 starting ......"
        );
        testLimitedRangePour(
            Quad.wrap(bytes16(0x3ffefae147ae147ae147ae147ae147ae)), // price = 9.89999999999999999999999999999999992e-01
            Quad.wrap(bytes16(0x3ff847ae147ae147ae147ae147ae147b)), // quadVar = 1.00000000000000000000000000000000002e-02
            0, // startingTub
            4096, // stoppingTub
            Quad.wrap(bytes16(0x40059000000000000000000000000000)), // liquidityPerTub = 1e+02
            Quad.wrap(bytes16(0x4005920006a486d7fa6966fcc0be345e)), // expected token0 = 1.00500025339822963853933145844738578e+02
            Quad.wrap(bytes16(0x40058dfade01784b70683475311c5d2d)), // expected token1 = 9.94949875096962021166384124352674141e+01
            false // skip the checks
        );
        Quad[] memory owedPotential = new Quad[](1);
        owedPotential[0] = Quad.wrap(bytes16(0x3fff0000000000000000000000000000));
        // int256 midBin = 16375;
        NewLoan.NewLoanParams memory params = NewLoan.NewLoanParams({
            owedPotential: owedPotential, // owedPotential = 1e+00
            startBin: 16376, // startBin
            strikeBin: 16376, // strikeBin
            tokenMix: Quad.wrap(bytes16(0x3ffe0000000000000000000000000000)), // tokenMix = 5e-01
            lockinEnd: POSITIVE_INFINITY,
            deadEra: OptInt256.wrap(OPT_INT256_NONE), // deadEra
            token: false, // token, unused for non-twap
            twapUntil: OptInt256.wrap(OPT_INT256_NONE) // twapUntil, disabled
        });
        UserPay.Info memory userPay = pool.newLoanOnly(params);
        Quad expectedToken0 = -Quad.wrap(bytes16(0x3ff32bf22d5752b2348653fce07e7bb4)); // expecting userPay.token0 = -2.86050800657621476555638425310597702e-04
        assertTokenAmount(userPay.token0, expectedToken0, newLoanTestEpsilon);
        Quad expectedToken1 = Quad.wrap(bytes16(0x3ff344890367c0a903d5b3fbd651ebdd)); // expecting userPay.token1 = 3.09500892839911271262401338701942831e-04
        assertTokenAmount(userPay.token1, expectedToken1, newLoanTestEpsilon);

        console.log(
            "testNewLoan_test_newloan_nontwap_with_whole_range_pour_immediate_above_mid_price_0_989999999999999999999999999999999992_and_token_mix_0_5 testing done."
        );
    }

    function testNewLoan_test_newloan_nontwap_with_whole_range_pour_far_below_mid_price_0_989999999999999999999999999999999992_and_token_mix_0_5()
        public
    {
        console.log(
            "testNewLoan_test_newloan_nontwap_with_whole_range_pour_far_below_mid_price_0_989999999999999999999999999999999992_and_token_mix_0_5 starting ......"
        );
        testLimitedRangePour(
            Quad.wrap(bytes16(0x3ffefae147ae147ae147ae147ae147ae)), // price = 9.89999999999999999999999999999999992e-01
            Quad.wrap(bytes16(0x3ff847ae147ae147ae147ae147ae147b)), // quadVar = 1.00000000000000000000000000000000002e-02
            0, // startingTub
            4096, // stoppingTub
            Quad.wrap(bytes16(0x40059000000000000000000000000000)), // liquidityPerTub = 1e+02
            Quad.wrap(bytes16(0x4005920006a486d7fa6966fcc0be345e)), // expected token0 = 1.00500025339822963853933145844738578e+02
            Quad.wrap(bytes16(0x40058dfade01784b70683475311c5d2d)), // expected token1 = 9.94949875096962021166384124352674141e+01
            false // skip the checks
        );
        Quad[] memory owedPotential = new Quad[](1);
        owedPotential[0] = Quad.wrap(bytes16(0x3fff0000000000000000000000000000));
        // int256 midBin = 16375;
        NewLoan.NewLoanParams memory params = NewLoan.NewLoanParams({
            owedPotential: owedPotential, // owedPotential = 1e+00
            startBin: 16365, // startBin
            strikeBin: 16365, // strikeBin
            tokenMix: Quad.wrap(bytes16(0x3ffe0000000000000000000000000000)), // tokenMix = 5e-01
            lockinEnd: POSITIVE_INFINITY,
            deadEra: OptInt256.wrap(OPT_INT256_NONE), // deadEra
            token: false, // token, unused for non-twap
            twapUntil: OptInt256.wrap(OPT_INT256_NONE) // twapUntil, disabled
        });
        UserPay.Info memory userPay = pool.newLoanOnly(params);
        Quad expectedToken0 = Quad.wrap(bytes16(0x3ff349d34b20db33c17b3d71d4bcfa8b)); // expecting userPay.token0 = 3.14545979611935904394652078827108008e-04
        assertTokenAmount(userPay.token0, expectedToken0, newLoanTestEpsilon);
        Quad expectedToken1 = -Quad.wrap(bytes16(0x3ff32a5c75658bbfd2692c6250a8065f)); // expecting userPay.token1 = -2.84539381342818599033189739648023779e-04
        assertTokenAmount(userPay.token1, expectedToken1, newLoanTestEpsilon);

        console.log(
            "testNewLoan_test_newloan_nontwap_with_whole_range_pour_far_below_mid_price_0_989999999999999999999999999999999992_and_token_mix_0_5 testing done."
        );
    }

    function testNewLoan_test_newloan_nontwap_with_whole_range_pour_far_above_mid_price_0_989999999999999999999999999999999992_and_token_mix_0_5()
        public
    {
        console.log(
            "testNewLoan_test_newloan_nontwap_with_whole_range_pour_far_above_mid_price_0_989999999999999999999999999999999992_and_token_mix_0_5 starting ......"
        );
        testLimitedRangePour(
            Quad.wrap(bytes16(0x3ffefae147ae147ae147ae147ae147ae)), // price = 9.89999999999999999999999999999999992e-01
            Quad.wrap(bytes16(0x3ff847ae147ae147ae147ae147ae147b)), // quadVar = 1.00000000000000000000000000000000002e-02
            0, // startingTub
            4096, // stoppingTub
            Quad.wrap(bytes16(0x40059000000000000000000000000000)), // liquidityPerTub = 1e+02
            Quad.wrap(bytes16(0x4005920006a486d7fa6966fcc0be345e)), // expected token0 = 1.00500025339822963853933145844738578e+02
            Quad.wrap(bytes16(0x40058dfade01784b70683475311c5d2d)), // expected token1 = 9.94949875096962021166384124352674141e+01
            false // skip the checks
        );
        Quad[] memory owedPotential = new Quad[](1);
        owedPotential[0] = Quad.wrap(bytes16(0x3fff0000000000000000000000000000));
        // int256 midBin = 16375;
        NewLoan.NewLoanParams memory params = NewLoan.NewLoanParams({
            owedPotential: owedPotential, // owedPotential = 1e+00
            startBin: 16385, // startBin
            strikeBin: 16385, // strikeBin
            tokenMix: Quad.wrap(bytes16(0x3ffe0000000000000000000000000000)), // tokenMix = 5e-01
            lockinEnd: POSITIVE_INFINITY,
            deadEra: OptInt256.wrap(OPT_INT256_NONE), // deadEra
            token: false, // token, unused for non-twap
            twapUntil: OptInt256.wrap(OPT_INT256_NONE) // twapUntil, disabled
        });
        UserPay.Info memory userPay = pool.newLoanOnly(params);
        Quad expectedToken0 = -Quad.wrap(bytes16(0x3ff32d8840f729fc4b0775037ce87513)); // expecting userPay.token0 = -2.87563554091093802579072526644361927e-04
        assertTokenAmount(userPay.token0, expectedToken0, newLoanTestEpsilon);
        Quad expectedToken1 = Quad.wrap(bytes16(0x3ff3465b539b0c9861af7816fcda4537)); // expecting userPay.token1 = 3.11238045188088117268002115751328524e-04
        assertTokenAmount(userPay.token1, expectedToken1, newLoanTestEpsilon);

        console.log(
            "testNewLoan_test_newloan_nontwap_with_whole_range_pour_far_above_mid_price_0_989999999999999999999999999999999992_and_token_mix_0_5 testing done."
        );
    }

    function testNewLoan_test_newloan_nontwap_with_whole_range_pour_immediate_below_mid_price_0_989999999999999999999999999999999992_and_token_mix_0_75(
    ) public {
        console.log(
            "testNewLoan_test_newloan_nontwap_with_whole_range_pour_immediate_below_mid_price_0_989999999999999999999999999999999992_and_token_mix_0_75 starting ......"
        );
        testLimitedRangePour(
            Quad.wrap(bytes16(0x3ffefae147ae147ae147ae147ae147ae)), // price = 9.89999999999999999999999999999999992e-01
            Quad.wrap(bytes16(0x3ff847ae147ae147ae147ae147ae147b)), // quadVar = 1.00000000000000000000000000000000002e-02
            0, // startingTub
            4096, // stoppingTub
            Quad.wrap(bytes16(0x40059000000000000000000000000000)), // liquidityPerTub = 1e+02
            Quad.wrap(bytes16(0x4005920006a486d7fa6966fcc0be345e)), // expected token0 = 1.00500025339822963853933145844738578e+02
            Quad.wrap(bytes16(0x40058dfade01784b70683475311c5d2d)), // expected token1 = 9.94949875096962021166384124352674141e+01
            false // skip the checks
        );
        Quad[] memory owedPotential = new Quad[](1);
        owedPotential[0] = Quad.wrap(bytes16(0x3fff0000000000000000000000000000));
        // int256 midBin = 16375;
        NewLoan.NewLoanParams memory params = NewLoan.NewLoanParams({
            owedPotential: owedPotential, // owedPotential = 1e+00
            startBin: 16374, // startBin
            strikeBin: 16374, // strikeBin
            tokenMix: Quad.wrap(bytes16(0x3ffe8000000000000000000000000000)), // tokenMix = 7.5e-01
            lockinEnd: POSITIVE_INFINITY,
            deadEra: OptInt256.wrap(OPT_INT256_NONE), // deadEra
            token: false, // token, unused for non-twap
            twapUntil: OptInt256.wrap(OPT_INT256_NONE) // twapUntil, disabled
        });
        UserPay.Info memory userPay = pool.newLoanOnly(params);
        Quad expectedToken0 = Quad.wrap(bytes16(0x3ff247fc062923f1ad3795b45e7aa6b2)); // expecting userPay.token0 = 1.56395182135054439035839367128582219e-04
        assertTokenAmount(userPay.token0, expectedToken0, newLoanTestEpsilon);
        Quad expectedToken1 = -Quad.wrap(bytes16(0x3ff20d7390133b99b8945472e4b580e8)); // expecting userPay.token1 = -1.28484448033328088357533891068299031e-04
        assertTokenAmount(userPay.token1, expectedToken1, newLoanTestEpsilon);

        console.log(
            "testNewLoan_test_newloan_nontwap_with_whole_range_pour_immediate_below_mid_price_0_989999999999999999999999999999999992_and_token_mix_0_75 testing done."
        );
    }

    function testNewLoan_test_newloan_nontwap_with_whole_range_pour_immediate_above_mid_price_0_989999999999999999999999999999999992_and_token_mix_0_75(
    ) public {
        console.log(
            "testNewLoan_test_newloan_nontwap_with_whole_range_pour_immediate_above_mid_price_0_989999999999999999999999999999999992_and_token_mix_0_75 starting ......"
        );
        testLimitedRangePour(
            Quad.wrap(bytes16(0x3ffefae147ae147ae147ae147ae147ae)), // price = 9.89999999999999999999999999999999992e-01
            Quad.wrap(bytes16(0x3ff847ae147ae147ae147ae147ae147b)), // quadVar = 1.00000000000000000000000000000000002e-02
            0, // startingTub
            4096, // stoppingTub
            Quad.wrap(bytes16(0x40059000000000000000000000000000)), // liquidityPerTub = 1e+02
            Quad.wrap(bytes16(0x4005920006a486d7fa6966fcc0be345e)), // expected token0 = 1.00500025339822963853933145844738578e+02
            Quad.wrap(bytes16(0x40058dfade01784b70683475311c5d2d)), // expected token1 = 9.94949875096962021166384124352674141e+01
            false // skip the checks
        );
        Quad[] memory owedPotential = new Quad[](1);
        owedPotential[0] = Quad.wrap(bytes16(0x3fff0000000000000000000000000000));
        // int256 midBin = 16375;
        NewLoan.NewLoanParams memory params = NewLoan.NewLoanParams({
            owedPotential: owedPotential, // owedPotential = 1e+00
            startBin: 16376, // startBin
            strikeBin: 16376, // strikeBin
            tokenMix: Quad.wrap(bytes16(0x3ffe8000000000000000000000000000)), // tokenMix = 7.5e-01
            lockinEnd: POSITIVE_INFINITY,
            deadEra: OptInt256.wrap(OPT_INT256_NONE), // deadEra
            token: false, // token, unused for non-twap
            twapUntil: OptInt256.wrap(OPT_INT256_NONE) // twapUntil, disabled
        });
        UserPay.Info memory userPay = pool.newLoanOnly(params);
        Quad expectedToken0 = -Quad.wrap(bytes16(0x3ff3cfbc0136cfa86bbf04ce7103e6a2)); // expecting userPay.token0 = -4.42251580739773751743912004651087372e-04
        assertTokenAmount(userPay.token0, expectedToken0, newLoanTestEpsilon);
        Quad expectedToken1 = Quad.wrap(bytes16(0x3ff3e6cd851ba0fd85c08df9c17ae1cb)); // expecting userPay.token1 = 4.64251339259866906893602008052914223e-04
        assertTokenAmount(userPay.token1, expectedToken1, newLoanTestEpsilon);

        console.log(
            "testNewLoan_test_newloan_nontwap_with_whole_range_pour_immediate_above_mid_price_0_989999999999999999999999999999999992_and_token_mix_0_75 testing done."
        );
    }

    function testNewLoan_test_newloan_nontwap_with_whole_range_pour_far_below_mid_price_0_989999999999999999999999999999999992_and_token_mix_0_75()
        public
    {
        console.log(
            "testNewLoan_test_newloan_nontwap_with_whole_range_pour_far_below_mid_price_0_989999999999999999999999999999999992_and_token_mix_0_75 starting ......"
        );
        testLimitedRangePour(
            Quad.wrap(bytes16(0x3ffefae147ae147ae147ae147ae147ae)), // price = 9.89999999999999999999999999999999992e-01
            Quad.wrap(bytes16(0x3ff847ae147ae147ae147ae147ae147b)), // quadVar = 1.00000000000000000000000000000000002e-02
            0, // startingTub
            4096, // stoppingTub
            Quad.wrap(bytes16(0x40059000000000000000000000000000)), // liquidityPerTub = 1e+02
            Quad.wrap(bytes16(0x4005920006a486d7fa6966fcc0be345e)), // expected token0 = 1.00500025339822963853933145844738578e+02
            Quad.wrap(bytes16(0x40058dfade01784b70683475311c5d2d)), // expected token1 = 9.94949875096962021166384124352674141e+01
            false // skip the checks
        );
        Quad[] memory owedPotential = new Quad[](1);
        owedPotential[0] = Quad.wrap(bytes16(0x3fff0000000000000000000000000000));
        // int256 midBin = 16375;
        NewLoan.NewLoanParams memory params = NewLoan.NewLoanParams({
            owedPotential: owedPotential, // owedPotential = 1e+00
            startBin: 16365, // startBin
            strikeBin: 16365, // strikeBin
            tokenMix: Quad.wrap(bytes16(0x3ffe8000000000000000000000000000)), // tokenMix = 7.5e-01
            lockinEnd: POSITIVE_INFINITY,
            deadEra: OptInt256.wrap(OPT_INT256_NONE), // deadEra
            token: false, // token, unused for non-twap
            twapUntil: OptInt256.wrap(OPT_INT256_NONE) // twapUntil, disabled
        });
        UserPay.Info memory userPay = pool.newLoanOnly(params);
        Quad expectedToken0 = Quad.wrap(bytes16(0x3ff249d34b20db33c17b3d71d4bcfa8b)); // expecting userPay.token0 = 1.57272989805967952197326039413554004e-04
        assertTokenAmount(userPay.token0, expectedToken0, newLoanTestEpsilon);
        Quad expectedToken1 = -Quad.wrap(bytes16(0x3ff212664f2b7a5c80ef780b197c8bc8)); // expecting userPay.token1 = -1.30843947189247671580687434727519985e-04
        assertTokenAmount(userPay.token1, expectedToken1, newLoanTestEpsilon);

        console.log(
            "testNewLoan_test_newloan_nontwap_with_whole_range_pour_far_below_mid_price_0_989999999999999999999999999999999992_and_token_mix_0_75 testing done."
        );
    }

    function testNewLoan_test_newloan_nontwap_with_whole_range_pour_far_above_mid_price_0_989999999999999999999999999999999992_and_token_mix_0_75()
        public
    {
        console.log(
            "testNewLoan_test_newloan_nontwap_with_whole_range_pour_far_above_mid_price_0_989999999999999999999999999999999992_and_token_mix_0_75 starting ......"
        );
        testLimitedRangePour(
            Quad.wrap(bytes16(0x3ffefae147ae147ae147ae147ae147ae)), // price = 9.89999999999999999999999999999999992e-01
            Quad.wrap(bytes16(0x3ff847ae147ae147ae147ae147ae147b)), // quadVar = 1.00000000000000000000000000000000002e-02
            0, // startingTub
            4096, // stoppingTub
            Quad.wrap(bytes16(0x40059000000000000000000000000000)), // liquidityPerTub = 1e+02
            Quad.wrap(bytes16(0x4005920006a486d7fa6966fcc0be345e)), // expected token0 = 1.00500025339822963853933145844738578e+02
            Quad.wrap(bytes16(0x40058dfade01784b70683475311c5d2d)), // expected token1 = 9.94949875096962021166384124352674141e+01
            false // skip the checks
        );
        Quad[] memory owedPotential = new Quad[](1);
        owedPotential[0] = Quad.wrap(bytes16(0x3fff0000000000000000000000000000));
        // int256 midBin = 16375;
        NewLoan.NewLoanParams memory params = NewLoan.NewLoanParams({
            owedPotential: owedPotential, // owedPotential = 1e+00
            startBin: 16385, // startBin
            strikeBin: 16385, // strikeBin
            tokenMix: Quad.wrap(bytes16(0x3ffe8000000000000000000000000000)), // tokenMix = 7.5e-01
            lockinEnd: POSITIVE_INFINITY,
            deadEra: OptInt256.wrap(OPT_INT256_NONE), // deadEra
            token: false, // token, unused for non-twap
            twapUntil: OptInt256.wrap(OPT_INT256_NONE) // twapUntil, disabled
        });
        UserPay.Info memory userPay = pool.newLoanOnly(params);
        Quad expectedToken0 = -Quad.wrap(bytes16(0x3ff3d0680d9a8740ed2881f5dc7adf78)); // expecting userPay.token0 = -4.4289251096235684873546664476220919e-04
        assertTokenAmount(userPay.token0, expectedToken0, newLoanTestEpsilon);
        Quad expectedToken1 = Quad.wrap(bytes16(0x3ff3e988fd6892e4928734227b4767d2)); // expecting userPay.token1 = 4.66857067782132175902003173626992763e-04
        assertTokenAmount(userPay.token1, expectedToken1, newLoanTestEpsilon);

        console.log(
            "testNewLoan_test_newloan_nontwap_with_whole_range_pour_far_above_mid_price_0_989999999999999999999999999999999992_and_token_mix_0_75 testing done."
        );
    }

    function testNewLoan_test_newloan_nontwap_with_whole_range_pour_immediate_below_mid_price_0_989999999999999999999999999999999992_and_token_mix_1()
        public
    {
        console.log(
            "testNewLoan_test_newloan_nontwap_with_whole_range_pour_immediate_below_mid_price_0_989999999999999999999999999999999992_and_token_mix_1 starting ......"
        );
        testLimitedRangePour(
            Quad.wrap(bytes16(0x3ffefae147ae147ae147ae147ae147ae)), // price = 9.89999999999999999999999999999999992e-01
            Quad.wrap(bytes16(0x3ff847ae147ae147ae147ae147ae147b)), // quadVar = 1.00000000000000000000000000000000002e-02
            0, // startingTub
            4096, // stoppingTub
            Quad.wrap(bytes16(0x40059000000000000000000000000000)), // liquidityPerTub = 1e+02
            Quad.wrap(bytes16(0x4005920006a486d7fa6966fcc0be345e)), // expected token0 = 1.00500025339822963853933145844738578e+02
            Quad.wrap(bytes16(0x40058dfade01784b70683475311c5d2d)), // expected token1 = 9.94949875096962021166384124352674141e+01
            false // skip the checks
        );
        Quad[] memory owedPotential = new Quad[](1);
        owedPotential[0] = Quad.wrap(bytes16(0x3fff0000000000000000000000000000));
        // int256 midBin = 16375;
        NewLoan.NewLoanParams memory params = NewLoan.NewLoanParams({
            owedPotential: owedPotential, // owedPotential = 1e+00
            startBin: 16374, // startBin
            strikeBin: 16374, // strikeBin
            tokenMix: Quad.wrap(bytes16(0x3fff0000000000000000000000000000)), // tokenMix = 1e+00
            lockinEnd: POSITIVE_INFINITY,
            deadEra: OptInt256.wrap(OPT_INT256_NONE), // deadEra
            token: false, // token, unused for non-twap
            twapUntil: OptInt256.wrap(OPT_INT256_NONE) // twapUntil, disabled
        });
        UserPay.Info memory userPay = pool.newLoanOnly(params);
        Quad expectedToken0 = POSITIVE_ZERO; // expecting userPay.token0 = 0e+00
        assertTokenAmount(userPay.token0, expectedToken0, newLoanTestEpsilon);
        Quad expectedToken1 = Quad.wrap(bytes16(0x3fefb5716f3486c842e3876196118fe0)); // expecting userPay.token1 = 2.6073640770102078237949924378100002e-05
        assertTokenAmount(userPay.token1, expectedToken1, newLoanTestEpsilon);

        console.log(
            "testNewLoan_test_newloan_nontwap_with_whole_range_pour_immediate_below_mid_price_0_989999999999999999999999999999999992_and_token_mix_1 testing done."
        );
    }

    function testNewLoan_test_newloan_nontwap_with_whole_range_pour_immediate_above_mid_price_0_989999999999999999999999999999999992_and_token_mix_1()
        public
    {
        console.log(
            "testNewLoan_test_newloan_nontwap_with_whole_range_pour_immediate_above_mid_price_0_989999999999999999999999999999999992_and_token_mix_1 starting ......"
        );
        testLimitedRangePour(
            Quad.wrap(bytes16(0x3ffefae147ae147ae147ae147ae147ae)), // price = 9.89999999999999999999999999999999992e-01
            Quad.wrap(bytes16(0x3ff847ae147ae147ae147ae147ae147b)), // quadVar = 1.00000000000000000000000000000000002e-02
            0, // startingTub
            4096, // stoppingTub
            Quad.wrap(bytes16(0x40059000000000000000000000000000)), // liquidityPerTub = 1e+02
            Quad.wrap(bytes16(0x4005920006a486d7fa6966fcc0be345e)), // expected token0 = 1.00500025339822963853933145844738578e+02
            Quad.wrap(bytes16(0x40058dfade01784b70683475311c5d2d)), // expected token1 = 9.94949875096962021166384124352674141e+01
            false // skip the checks
        );
        Quad[] memory owedPotential = new Quad[](1);
        owedPotential[0] = Quad.wrap(bytes16(0x3fff0000000000000000000000000000));
        // int256 midBin = 16375;
        NewLoan.NewLoanParams memory params = NewLoan.NewLoanParams({
            owedPotential: owedPotential, // owedPotential = 1e+00
            startBin: 16376, // startBin
            strikeBin: 16376, // strikeBin
            tokenMix: Quad.wrap(bytes16(0x3fff0000000000000000000000000000)), // tokenMix = 1e+00
            lockinEnd: POSITIVE_INFINITY,
            deadEra: OptInt256.wrap(OPT_INT256_NONE), // deadEra
            token: false, // token, unused for non-twap
            twapUntil: OptInt256.wrap(OPT_INT256_NONE) // twapUntil, disabled
        });
        UserPay.Info memory userPay = pool.newLoanOnly(params);
        Quad expectedToken0 = -Quad.wrap(bytes16(0x3ff439c2ea8b264f517bdad000c4a8c8)); // expecting userPay.token0 = -5.98452360821926026932185583991577042e-04
        assertTokenAmount(userPay.token0, expectedToken0, newLoanTestEpsilon);
        Quad expectedToken1 = Quad.wrap(bytes16(0x3ff444890367c0a903d5b3fbd651ebdd)); // expecting userPay.token1 = 6.19001785679822542524802677403885662e-04
        assertTokenAmount(userPay.token1, expectedToken1, newLoanTestEpsilon);

        console.log(
            "testNewLoan_test_newloan_nontwap_with_whole_range_pour_immediate_above_mid_price_0_989999999999999999999999999999999992_and_token_mix_1 testing done."
        );
    }

    function testNewLoan_test_newloan_nontwap_with_whole_range_pour_far_below_mid_price_0_989999999999999999999999999999999992_and_token_mix_1()
        public
    {
        console.log(
            "testNewLoan_test_newloan_nontwap_with_whole_range_pour_far_below_mid_price_0_989999999999999999999999999999999992_and_token_mix_1 starting ......"
        );
        testLimitedRangePour(
            Quad.wrap(bytes16(0x3ffefae147ae147ae147ae147ae147ae)), // price = 9.89999999999999999999999999999999992e-01
            Quad.wrap(bytes16(0x3ff847ae147ae147ae147ae147ae147b)), // quadVar = 1.00000000000000000000000000000000002e-02
            0, // startingTub
            4096, // stoppingTub
            Quad.wrap(bytes16(0x40059000000000000000000000000000)), // liquidityPerTub = 1e+02
            Quad.wrap(bytes16(0x4005920006a486d7fa6966fcc0be345e)), // expected token0 = 1.00500025339822963853933145844738578e+02
            Quad.wrap(bytes16(0x40058dfade01784b70683475311c5d2d)), // expected token1 = 9.94949875096962021166384124352674141e+01
            false // skip the checks
        );
        Quad[] memory owedPotential = new Quad[](1);
        owedPotential[0] = Quad.wrap(bytes16(0x3fff0000000000000000000000000000));
        // int256 midBin = 16375;
        NewLoan.NewLoanParams memory params = NewLoan.NewLoanParams({
            owedPotential: owedPotential, // owedPotential = 1e+00
            startBin: 16365, // startBin
            strikeBin: 16365, // strikeBin
            tokenMix: Quad.wrap(bytes16(0x3fff0000000000000000000000000000)), // tokenMix = 1e+00
            lockinEnd: POSITIVE_INFINITY,
            deadEra: OptInt256.wrap(OPT_INT256_NONE), // deadEra
            token: false, // token, unused for non-twap
            twapUntil: OptInt256.wrap(OPT_INT256_NONE) // twapUntil, disabled
        });
        UserPay.Info memory userPay = pool.newLoanOnly(params);
        Quad expectedToken0 = POSITIVE_ZERO; // expecting userPay.token0 = 0e+00
        assertTokenAmount(userPay.token0, expectedToken0, newLoanTestEpsilon);
        Quad expectedToken1 = Quad.wrap(bytes16(0x3fef7f6263a11635179b457372b7a9a0)); // expecting userPay.token1 = 2.28514869643232558718148701929839499e-05
        assertTokenAmount(userPay.token1, expectedToken1, newLoanTestEpsilon);

        console.log(
            "testNewLoan_test_newloan_nontwap_with_whole_range_pour_far_below_mid_price_0_989999999999999999999999999999999992_and_token_mix_1 testing done."
        );
    }

    function testNewLoan_test_newloan_nontwap_with_whole_range_pour_far_above_mid_price_0_989999999999999999999999999999999992_and_token_mix_1()
        public
    {
        console.log(
            "testNewLoan_test_newloan_nontwap_with_whole_range_pour_far_above_mid_price_0_989999999999999999999999999999999992_and_token_mix_1 starting ......"
        );
        testLimitedRangePour(
            Quad.wrap(bytes16(0x3ffefae147ae147ae147ae147ae147ae)), // price = 9.89999999999999999999999999999999992e-01
            Quad.wrap(bytes16(0x3ff847ae147ae147ae147ae147ae147b)), // quadVar = 1.00000000000000000000000000000000002e-02
            0, // startingTub
            4096, // stoppingTub
            Quad.wrap(bytes16(0x40059000000000000000000000000000)), // liquidityPerTub = 1e+02
            Quad.wrap(bytes16(0x4005920006a486d7fa6966fcc0be345e)), // expected token0 = 1.00500025339822963853933145844738578e+02
            Quad.wrap(bytes16(0x40058dfade01784b70683475311c5d2d)), // expected token1 = 9.94949875096962021166384124352674141e+01
            false // skip the checks
        );
        Quad[] memory owedPotential = new Quad[](1);
        owedPotential[0] = Quad.wrap(bytes16(0x3fff0000000000000000000000000000));
        // int256 midBin = 16375;
        NewLoan.NewLoanParams memory params = NewLoan.NewLoanParams({
            owedPotential: owedPotential, // owedPotential = 1e+00
            startBin: 16385, // startBin
            strikeBin: 16385, // strikeBin
            tokenMix: Quad.wrap(bytes16(0x3fff0000000000000000000000000000)), // tokenMix = 1e+00
            lockinEnd: POSITIVE_INFINITY,
            deadEra: OptInt256.wrap(OPT_INT256_NONE), // deadEra
            token: false, // token, unused for non-twap
            twapUntil: OptInt256.wrap(OPT_INT256_NONE) // twapUntil, disabled
        });
        UserPay.Info memory userPay = pool.newLoanOnly(params);
        Quad expectedToken0 = -Quad.wrap(bytes16(0x3ff439a3ed1ef242c7a4c7741e06a4ef)); // expecting userPay.token0 = -5.98221467833619894891860762880056501e-04
        assertTokenAmount(userPay.token0, expectedToken0, newLoanTestEpsilon);
        Quad expectedToken1 = Quad.wrap(bytes16(0x3ff4465b539b0c9861af7816fcda4537)); // expecting userPay.token1 = 6.22476090376176234536004231502657049e-04
        assertTokenAmount(userPay.token1, expectedToken1, newLoanTestEpsilon);

        console.log(
            "testNewLoan_test_newloan_nontwap_with_whole_range_pour_far_above_mid_price_0_989999999999999999999999999999999992_and_token_mix_1 testing done."
        );
    }

    function testNewLoan_test_newloan_nontwap_with_whole_range_pour_immediate_below_mid_price_0_990099009900990099009900990099009911_and_token_mix_0()
        public
    {
        console.log(
            "testNewLoan_test_newloan_nontwap_with_whole_range_pour_immediate_below_mid_price_0_990099009900990099009900990099009911_and_token_mix_0 starting ......"
        );
        testLimitedRangePour(
            Quad.wrap(bytes16(0x3ffefaee41e6a74981446f86562d9faf)), // price = 9.90099009900990099009900990099009911e-01
            Quad.wrap(bytes16(0x3ff847ae147ae147ae147ae147ae147b)), // quadVar = 1.00000000000000000000000000000000002e-02
            0, // startingTub
            4096, // stoppingTub
            Quad.wrap(bytes16(0x40059000000000000000000000000000)), // liquidityPerTub = 1e+02
            Quad.wrap(bytes16(0x400591fae0e8e994c568d4a0eb3df54b)), // expected token0 = 1.00494998587853108604312572889908098e+02
            Quad.wrap(bytes16(0x40058dfff5e1708f004dd48b06f1bcce)), // expected token1 = 9.94999613976431194686472991361695447e+01
            false // skip the checks
        );
        Quad[] memory owedPotential = new Quad[](1);
        owedPotential[0] = Quad.wrap(bytes16(0x3fff0000000000000000000000000000));
        // int256 midBin = 16376;
        NewLoan.NewLoanParams memory params = NewLoan.NewLoanParams({
            owedPotential: owedPotential, // owedPotential = 1e+00
            startBin: 16375, // startBin
            strikeBin: 16375, // strikeBin
            tokenMix: POSITIVE_ZERO, // tokenMix = 0e+00
            lockinEnd: POSITIVE_INFINITY,
            deadEra: OptInt256.wrap(OPT_INT256_NONE), // deadEra
            token: false, // token, unused for non-twap
            twapUntil: OptInt256.wrap(OPT_INT256_NONE) // twapUntil, disabled
        });
        UserPay.Info memory userPay = pool.newLoanOnly(params);
        Quad expectedToken0 = Quad.wrap(bytes16(0x3ff447c7d2cca14e8b8d999fa2b40543)); // expecting userPay.token0 = 6.25191803536620767950050704177924514e-04
        assertTokenAmount(userPay.token0, expectedToken0, newLoanTestEpsilon);
        Quad expectedToken1 = -Quad.wrap(bytes16(0x3ff436a7a3c923655847ef753b0ec075)); // expecting userPay.token1 = -5.92527089922699036566520380189680248e-04
        assertTokenAmount(userPay.token1, expectedToken1, newLoanTestEpsilon);

        console.log(
            "testNewLoan_test_newloan_nontwap_with_whole_range_pour_immediate_below_mid_price_0_990099009900990099009900990099009911_and_token_mix_0 testing done."
        );
    }

    function testNewLoan_test_newloan_nontwap_with_whole_range_pour_immediate_above_mid_price_0_990099009900990099009900990099009911_and_token_mix_0()
        public
    {
        console.log(
            "testNewLoan_test_newloan_nontwap_with_whole_range_pour_immediate_above_mid_price_0_990099009900990099009900990099009911_and_token_mix_0 starting ......"
        );
        testLimitedRangePour(
            Quad.wrap(bytes16(0x3ffefaee41e6a74981446f86562d9faf)), // price = 9.90099009900990099009900990099009911e-01
            Quad.wrap(bytes16(0x3ff847ae147ae147ae147ae147ae147b)), // quadVar = 1.00000000000000000000000000000000002e-02
            0, // startingTub
            4096, // stoppingTub
            Quad.wrap(bytes16(0x40059000000000000000000000000000)), // liquidityPerTub = 1e+02
            Quad.wrap(bytes16(0x400591fae0e8e994c568d4a0eb3df54b)), // expected token0 = 1.00494998587853108604312572889908098e+02
            Quad.wrap(bytes16(0x40058dfff5e1708f004dd48b06f1bcce)), // expected token1 = 9.94999613976431194686472991361695447e+01
            false // skip the checks
        );
        Quad[] memory owedPotential = new Quad[](1);
        owedPotential[0] = Quad.wrap(bytes16(0x3fff0000000000000000000000000000));
        // int256 midBin = 16376;
        NewLoan.NewLoanParams memory params = NewLoan.NewLoanParams({
            owedPotential: owedPotential, // owedPotential = 1e+00
            startBin: 16377, // startBin
            strikeBin: 16377, // strikeBin
            tokenMix: POSITIVE_ZERO, // tokenMix = 0e+00
            lockinEnd: POSITIVE_INFINITY,
            deadEra: OptInt256.wrap(OPT_INT256_NONE), // deadEra
            token: false, // token, unused for non-twap
            twapUntil: OptInt256.wrap(OPT_INT256_NONE) // twapUntil, disabled
        });
        UserPay.Info memory userPay = pool.newLoanOnly(params);
        Quad expectedToken0 = Quad.wrap(bytes16(0x3fefb9d149eacfcf62471588f64a0ec0)); // expecting userPay.token0 = 2.63343771778030990203294236218809992e-05
        assertTokenAmount(userPay.token0, expectedToken0, newLoanTestEpsilon);
        Quad expectedToken1 = POSITIVE_ZERO; // expecting userPay.token1 = 0e+00
        assertTokenAmount(userPay.token1, expectedToken1, newLoanTestEpsilon);

        console.log(
            "testNewLoan_test_newloan_nontwap_with_whole_range_pour_immediate_above_mid_price_0_990099009900990099009900990099009911_and_token_mix_0 testing done."
        );
    }

    function testNewLoan_test_newloan_nontwap_with_whole_range_pour_far_below_mid_price_0_990099009900990099009900990099009911_and_token_mix_0()
        public
    {
        console.log(
            "testNewLoan_test_newloan_nontwap_with_whole_range_pour_far_below_mid_price_0_990099009900990099009900990099009911_and_token_mix_0 starting ......"
        );
        testLimitedRangePour(
            Quad.wrap(bytes16(0x3ffefaee41e6a74981446f86562d9faf)), // price = 9.90099009900990099009900990099009911e-01
            Quad.wrap(bytes16(0x3ff847ae147ae147ae147ae147ae147b)), // quadVar = 1.00000000000000000000000000000000002e-02
            0, // startingTub
            4096, // stoppingTub
            Quad.wrap(bytes16(0x40059000000000000000000000000000)), // liquidityPerTub = 1e+02
            Quad.wrap(bytes16(0x400591fae0e8e994c568d4a0eb3df54b)), // expected token0 = 1.00494998587853108604312572889908098e+02
            Quad.wrap(bytes16(0x40058dfff5e1708f004dd48b06f1bcce)), // expected token1 = 9.94999613976431194686472991361695447e+01
            false // skip the checks
        );
        Quad[] memory owedPotential = new Quad[](1);
        owedPotential[0] = Quad.wrap(bytes16(0x3fff0000000000000000000000000000));
        // int256 midBin = 16376;
        NewLoan.NewLoanParams memory params = NewLoan.NewLoanParams({
            owedPotential: owedPotential, // owedPotential = 1e+00
            startBin: 16366, // startBin
            strikeBin: 16366, // strikeBin
            tokenMix: POSITIVE_ZERO, // tokenMix = 0e+00
            lockinEnd: POSITIVE_INFINITY,
            deadEra: OptInt256.wrap(OPT_INT256_NONE), // deadEra
            token: false, // token, unused for non-twap
            twapUntil: OptInt256.wrap(OPT_INT256_NONE) // twapUntil, disabled
        });
        UserPay.Info memory userPay = pool.newLoanOnly(params);
        Quad expectedToken0 = Quad.wrap(bytes16(0x3ff4499eccc2ffebd34d62402d760d96)); // expecting userPay.token0 = 6.28700851279937996881364273817683594e-04
        assertTokenAmount(userPay.token0, expectedToken0, newLoanTestEpsilon);
        Quad expectedToken1 = -Quad.wrap(bytes16(0x3ff43688f4e969868de795520461d375)); // expecting userPay.token1 = -5.92298483003584054348376992950550944e-04
        assertTokenAmount(userPay.token1, expectedToken1, newLoanTestEpsilon);

        console.log(
            "testNewLoan_test_newloan_nontwap_with_whole_range_pour_far_below_mid_price_0_990099009900990099009900990099009911_and_token_mix_0 testing done."
        );
    }

    function testNewLoan_test_newloan_nontwap_with_whole_range_pour_far_above_mid_price_0_990099009900990099009900990099009911_and_token_mix_0()
        public
    {
        console.log(
            "testNewLoan_test_newloan_nontwap_with_whole_range_pour_far_above_mid_price_0_990099009900990099009900990099009911_and_token_mix_0 starting ......"
        );
        testLimitedRangePour(
            Quad.wrap(bytes16(0x3ffefaee41e6a74981446f86562d9faf)), // price = 9.90099009900990099009900990099009911e-01
            Quad.wrap(bytes16(0x3ff847ae147ae147ae147ae147ae147b)), // quadVar = 1.00000000000000000000000000000000002e-02
            0, // startingTub
            4096, // stoppingTub
            Quad.wrap(bytes16(0x40059000000000000000000000000000)), // liquidityPerTub = 1e+02
            Quad.wrap(bytes16(0x400591fae0e8e994c568d4a0eb3df54b)), // expected token0 = 1.00494998587853108604312572889908098e+02
            Quad.wrap(bytes16(0x40058dfff5e1708f004dd48b06f1bcce)), // expected token1 = 9.94999613976431194686472991361695447e+01
            false // skip the checks
        );
        Quad[] memory owedPotential = new Quad[](1);
        owedPotential[0] = Quad.wrap(bytes16(0x3fff0000000000000000000000000000));
        // int256 midBin = 16376;
        NewLoan.NewLoanParams memory params = NewLoan.NewLoanParams({
            owedPotential: owedPotential, // owedPotential = 1e+00
            startBin: 16386, // startBin
            strikeBin: 16386, // strikeBin
            tokenMix: POSITIVE_ZERO, // tokenMix = 0e+00
            lockinEnd: POSITIVE_INFINITY,
            deadEra: OptInt256.wrap(OPT_INT256_NONE), // deadEra
            token: false, // token, unused for non-twap
            twapUntil: OptInt256.wrap(OPT_INT256_NONE) // twapUntil, disabled
        });
        UserPay.Info memory userPay = pool.newLoanOnly(params);
        Quad expectedToken0 = Quad.wrap(bytes16(0x3fef8337da62b296e733dd2f7b8b6b60)); // expecting userPay.token0 = 2.30800018339664884305330188949138298e-05
        assertTokenAmount(userPay.token0, expectedToken0, newLoanTestEpsilon);
        Quad expectedToken1 = POSITIVE_ZERO; // expecting userPay.token1 = 0e+00
        assertTokenAmount(userPay.token1, expectedToken1, newLoanTestEpsilon);

        console.log(
            "testNewLoan_test_newloan_nontwap_with_whole_range_pour_far_above_mid_price_0_990099009900990099009900990099009911_and_token_mix_0 testing done."
        );
    }

    function testNewLoan_test_newloan_nontwap_with_whole_range_pour_immediate_below_mid_price_0_990099009900990099009900990099009911_and_token_mix_0_25(
    ) public {
        console.log(
            "testNewLoan_test_newloan_nontwap_with_whole_range_pour_immediate_below_mid_price_0_990099009900990099009900990099009911_and_token_mix_0_25 starting ......"
        );
        testLimitedRangePour(
            Quad.wrap(bytes16(0x3ffefaee41e6a74981446f86562d9faf)), // price = 9.90099009900990099009900990099009911e-01
            Quad.wrap(bytes16(0x3ff847ae147ae147ae147ae147ae147b)), // quadVar = 1.00000000000000000000000000000000002e-02
            0, // startingTub
            4096, // stoppingTub
            Quad.wrap(bytes16(0x40059000000000000000000000000000)), // liquidityPerTub = 1e+02
            Quad.wrap(bytes16(0x400591fae0e8e994c568d4a0eb3df54b)), // expected token0 = 1.00494998587853108604312572889908098e+02
            Quad.wrap(bytes16(0x40058dfff5e1708f004dd48b06f1bcce)), // expected token1 = 9.94999613976431194686472991361695447e+01
            false // skip the checks
        );
        Quad[] memory owedPotential = new Quad[](1);
        owedPotential[0] = Quad.wrap(bytes16(0x3fff0000000000000000000000000000));
        // int256 midBin = 16376;
        NewLoan.NewLoanParams memory params = NewLoan.NewLoanParams({
            owedPotential: owedPotential, // owedPotential = 1e+00
            startBin: 16375, // startBin
            strikeBin: 16375, // strikeBin
            tokenMix: Quad.wrap(bytes16(0x3ffd0000000000000000000000000000)), // tokenMix = 2.5e-01
            lockinEnd: POSITIVE_INFINITY,
            deadEra: OptInt256.wrap(OPT_INT256_NONE), // deadEra
            token: false, // token, unused for non-twap
            twapUntil: OptInt256.wrap(OPT_INT256_NONE) // twapUntil, disabled
        });
        UserPay.Info memory userPay = pool.newLoanOnly(params);
        Quad expectedToken0 = Quad.wrap(bytes16(0x3ff3ebabbc32f1f5d154666f740e07e5)); // expecting userPay.token0 = 4.68893852652465575962538028133443409e-04
        assertTokenAmount(userPay.token0, expectedToken0, newLoanTestEpsilon);
        Quad expectedToken1 = -Quad.wrap(bytes16(0x3ff3cb24994802d4608a6f36da5a0a5e)); // expecting userPay.token1 = -4.37872852217597774003873271931769652e-04
        assertTokenAmount(userPay.token1, expectedToken1, newLoanTestEpsilon);

        console.log(
            "testNewLoan_test_newloan_nontwap_with_whole_range_pour_immediate_below_mid_price_0_990099009900990099009900990099009911_and_token_mix_0_25 testing done."
        );
    }

    function testNewLoan_test_newloan_nontwap_with_whole_range_pour_immediate_above_mid_price_0_990099009900990099009900990099009911_and_token_mix_0_25(
    ) public {
        console.log(
            "testNewLoan_test_newloan_nontwap_with_whole_range_pour_immediate_above_mid_price_0_990099009900990099009900990099009911_and_token_mix_0_25 starting ......"
        );
        testLimitedRangePour(
            Quad.wrap(bytes16(0x3ffefaee41e6a74981446f86562d9faf)), // price = 9.90099009900990099009900990099009911e-01
            Quad.wrap(bytes16(0x3ff847ae147ae147ae147ae147ae147b)), // quadVar = 1.00000000000000000000000000000000002e-02
            0, // startingTub
            4096, // stoppingTub
            Quad.wrap(bytes16(0x40059000000000000000000000000000)), // liquidityPerTub = 1e+02
            Quad.wrap(bytes16(0x400591fae0e8e994c568d4a0eb3df54b)), // expected token0 = 1.00494998587853108604312572889908098e+02
            Quad.wrap(bytes16(0x40058dfff5e1708f004dd48b06f1bcce)), // expected token1 = 9.94999613976431194686472991361695447e+01
            false // skip the checks
        );
        Quad[] memory owedPotential = new Quad[](1);
        owedPotential[0] = Quad.wrap(bytes16(0x3fff0000000000000000000000000000));
        // int256 midBin = 16376;
        NewLoan.NewLoanParams memory params = NewLoan.NewLoanParams({
            owedPotential: owedPotential, // owedPotential = 1e+00
            startBin: 16377, // startBin
            strikeBin: 16377, // strikeBin
            tokenMix: Quad.wrap(bytes16(0x3ffd0000000000000000000000000000)), // tokenMix = 2.5e-01
            lockinEnd: POSITIVE_INFINITY,
            deadEra: OptInt256.wrap(OPT_INT256_NONE), // deadEra
            token: false, // token, unused for non-twap
            twapUntil: OptInt256.wrap(OPT_INT256_NONE) // twapUntil, disabled
        });
        UserPay.Info memory userPay = pool.newLoanOnly(params);
        Quad expectedToken0 = -Quad.wrap(bytes16(0x3ff210255bc1815104aa4b0da46fa37a)); // expecting userPay.token0 = -1.29769292513661369241109229978982028e-04
        assertTokenAmount(userPay.token0, expectedToken0, newLoanTestEpsilon);
        Quad expectedToken1 = Quad.wrap(bytes16(0x3ff244bcb274c5ce5552ea668b2adcce)); // expecting userPay.token1 = 1.54846714985202414886969670424338815e-04
        assertTokenAmount(userPay.token1, expectedToken1, newLoanTestEpsilon);

        console.log(
            "testNewLoan_test_newloan_nontwap_with_whole_range_pour_immediate_above_mid_price_0_990099009900990099009900990099009911_and_token_mix_0_25 testing done."
        );
    }

    function testNewLoan_test_newloan_nontwap_with_whole_range_pour_far_below_mid_price_0_990099009900990099009900990099009911_and_token_mix_0_25()
        public
    {
        console.log(
            "testNewLoan_test_newloan_nontwap_with_whole_range_pour_far_below_mid_price_0_990099009900990099009900990099009911_and_token_mix_0_25 starting ......"
        );
        testLimitedRangePour(
            Quad.wrap(bytes16(0x3ffefaee41e6a74981446f86562d9faf)), // price = 9.90099009900990099009900990099009911e-01
            Quad.wrap(bytes16(0x3ff847ae147ae147ae147ae147ae147b)), // quadVar = 1.00000000000000000000000000000000002e-02
            0, // startingTub
            4096, // stoppingTub
            Quad.wrap(bytes16(0x40059000000000000000000000000000)), // liquidityPerTub = 1e+02
            Quad.wrap(bytes16(0x400591fae0e8e994c568d4a0eb3df54b)), // expected token0 = 1.00494998587853108604312572889908098e+02
            Quad.wrap(bytes16(0x40058dfff5e1708f004dd48b06f1bcce)), // expected token1 = 9.94999613976431194686472991361695447e+01
            false // skip the checks
        );
        Quad[] memory owedPotential = new Quad[](1);
        owedPotential[0] = Quad.wrap(bytes16(0x3fff0000000000000000000000000000));
        // int256 midBin = 16376;
        NewLoan.NewLoanParams memory params = NewLoan.NewLoanParams({
            owedPotential: owedPotential, // owedPotential = 1e+00
            startBin: 16366, // startBin
            strikeBin: 16366, // strikeBin
            tokenMix: Quad.wrap(bytes16(0x3ffd0000000000000000000000000000)), // tokenMix = 2.5e-01
            lockinEnd: POSITIVE_INFINITY,
            deadEra: OptInt256.wrap(OPT_INT256_NONE), // deadEra
            token: false, // token, unused for non-twap
            twapUntil: OptInt256.wrap(OPT_INT256_NONE) // twapUntil, disabled
        });
        UserPay.Info memory userPay = pool.newLoanOnly(params);
        Quad expectedToken0 = Quad.wrap(bytes16(0x3ff3ee6e33247fe1bcf4136044311461)); // expecting userPay.token0 = 4.71525638459953497661023205363262695e-04
        assertTokenAmount(userPay.token0, expectedToken0, newLoanTestEpsilon);
        Quad expectedToken1 = -Quad.wrap(bytes16(0x3ff3cbcef19676b4e0abe8982df0c8fa)); // expecting userPay.token1 = -4.38507436596392919540065984913078377e-04
        assertTokenAmount(userPay.token1, expectedToken1, newLoanTestEpsilon);

        console.log(
            "testNewLoan_test_newloan_nontwap_with_whole_range_pour_far_below_mid_price_0_990099009900990099009900990099009911_and_token_mix_0_25 testing done."
        );
    }

    function testNewLoan_test_newloan_nontwap_with_whole_range_pour_far_above_mid_price_0_990099009900990099009900990099009911_and_token_mix_0_25()
        public
    {
        console.log(
            "testNewLoan_test_newloan_nontwap_with_whole_range_pour_far_above_mid_price_0_990099009900990099009900990099009911_and_token_mix_0_25 starting ......"
        );
        testLimitedRangePour(
            Quad.wrap(bytes16(0x3ffefaee41e6a74981446f86562d9faf)), // price = 9.90099009900990099009900990099009911e-01
            Quad.wrap(bytes16(0x3ff847ae147ae147ae147ae147ae147b)), // quadVar = 1.00000000000000000000000000000000002e-02
            0, // startingTub
            4096, // stoppingTub
            Quad.wrap(bytes16(0x40059000000000000000000000000000)), // liquidityPerTub = 1e+02
            Quad.wrap(bytes16(0x400591fae0e8e994c568d4a0eb3df54b)), // expected token0 = 1.00494998587853108604312572889908098e+02
            Quad.wrap(bytes16(0x40058dfff5e1708f004dd48b06f1bcce)), // expected token1 = 9.94999613976431194686472991361695447e+01
            false // skip the checks
        );
        Quad[] memory owedPotential = new Quad[](1);
        owedPotential[0] = Quad.wrap(bytes16(0x3fff0000000000000000000000000000));
        // int256 midBin = 16376;
        NewLoan.NewLoanParams memory params = NewLoan.NewLoanParams({
            owedPotential: owedPotential, // owedPotential = 1e+00
            startBin: 16386, // startBin
            strikeBin: 16386, // strikeBin
            tokenMix: Quad.wrap(bytes16(0x3ffd0000000000000000000000000000)), // tokenMix = 2.5e-01
            lockinEnd: POSITIVE_INFINITY,
            deadEra: OptInt256.wrap(OPT_INT256_NONE), // deadEra
            token: false, // token, unused for non-twap
            twapUntil: OptInt256.wrap(OPT_INT256_NONE) // twapUntil, disabled
        });
        UserPay.Info memory userPay = pool.newLoanOnly(params);
        Quad expectedToken0 = -Quad.wrap(bytes16(0x3ff21524c5b8b6770758437bd9bdca9a)); // expecting userPay.token0 = -1.3215238666114014829649430907479508e-04
        assertTokenAmount(userPay.token0, expectedToken0, newLoanTestEpsilon);
        Quad expectedToken1 = Quad.wrap(bytes16(0x3ff2468f4ceb4da03bc386575b80cf82)); // expecting userPay.token1 = 1.5571583149105737841319409842926139e-04
        assertTokenAmount(userPay.token1, expectedToken1, newLoanTestEpsilon);

        console.log(
            "testNewLoan_test_newloan_nontwap_with_whole_range_pour_far_above_mid_price_0_990099009900990099009900990099009911_and_token_mix_0_25 testing done."
        );
    }

    function testNewLoan_test_newloan_nontwap_with_whole_range_pour_immediate_below_mid_price_0_990099009900990099009900990099009911_and_token_mix_0_5(
    ) public {
        console.log(
            "testNewLoan_test_newloan_nontwap_with_whole_range_pour_immediate_below_mid_price_0_990099009900990099009900990099009911_and_token_mix_0_5 starting ......"
        );
        testLimitedRangePour(
            Quad.wrap(bytes16(0x3ffefaee41e6a74981446f86562d9faf)), // price = 9.90099009900990099009900990099009911e-01
            Quad.wrap(bytes16(0x3ff847ae147ae147ae147ae147ae147b)), // quadVar = 1.00000000000000000000000000000000002e-02
            0, // startingTub
            4096, // stoppingTub
            Quad.wrap(bytes16(0x40059000000000000000000000000000)), // liquidityPerTub = 1e+02
            Quad.wrap(bytes16(0x400591fae0e8e994c568d4a0eb3df54b)), // expected token0 = 1.00494998587853108604312572889908098e+02
            Quad.wrap(bytes16(0x40058dfff5e1708f004dd48b06f1bcce)), // expected token1 = 9.94999613976431194686472991361695447e+01
            false // skip the checks
        );
        Quad[] memory owedPotential = new Quad[](1);
        owedPotential[0] = Quad.wrap(bytes16(0x3fff0000000000000000000000000000));
        // int256 midBin = 16376;
        NewLoan.NewLoanParams memory params = NewLoan.NewLoanParams({
            owedPotential: owedPotential, // owedPotential = 1e+00
            startBin: 16375, // startBin
            strikeBin: 16375, // strikeBin
            tokenMix: Quad.wrap(bytes16(0x3ffe0000000000000000000000000000)), // tokenMix = 5e-01
            lockinEnd: POSITIVE_INFINITY,
            deadEra: OptInt256.wrap(OPT_INT256_NONE), // deadEra
            token: false, // token, unused for non-twap
            twapUntil: OptInt256.wrap(OPT_INT256_NONE) // twapUntil, disabled
        });
        UserPay.Info memory userPay = pool.newLoanOnly(params);
        Quad expectedToken0 = Quad.wrap(bytes16(0x3ff347c7d2cca14e8b8d999fa2b40543)); // expecting userPay.token0 = 3.12595901768310383975025352088962257e-04
        assertTokenAmount(userPay.token0, expectedToken0, newLoanTestEpsilon);
        Quad expectedToken1 = -Quad.wrap(bytes16(0x3ff328f9eafdbede1084ff833e9693d3)); // expecting userPay.token1 = -2.83218614512496511441226163673859103e-04
        assertTokenAmount(userPay.token1, expectedToken1, newLoanTestEpsilon);

        console.log(
            "testNewLoan_test_newloan_nontwap_with_whole_range_pour_immediate_below_mid_price_0_990099009900990099009900990099009911_and_token_mix_0_5 testing done."
        );
    }

    function testNewLoan_test_newloan_nontwap_with_whole_range_pour_immediate_above_mid_price_0_990099009900990099009900990099009911_and_token_mix_0_5(
    ) public {
        console.log(
            "testNewLoan_test_newloan_nontwap_with_whole_range_pour_immediate_above_mid_price_0_990099009900990099009900990099009911_and_token_mix_0_5 starting ......"
        );
        testLimitedRangePour(
            Quad.wrap(bytes16(0x3ffefaee41e6a74981446f86562d9faf)), // price = 9.90099009900990099009900990099009911e-01
            Quad.wrap(bytes16(0x3ff847ae147ae147ae147ae147ae147b)), // quadVar = 1.00000000000000000000000000000000002e-02
            0, // startingTub
            4096, // stoppingTub
            Quad.wrap(bytes16(0x40059000000000000000000000000000)), // liquidityPerTub = 1e+02
            Quad.wrap(bytes16(0x400591fae0e8e994c568d4a0eb3df54b)), // expected token0 = 1.00494998587853108604312572889908098e+02
            Quad.wrap(bytes16(0x40058dfff5e1708f004dd48b06f1bcce)), // expected token1 = 9.94999613976431194686472991361695447e+01
            false // skip the checks
        );
        Quad[] memory owedPotential = new Quad[](1);
        owedPotential[0] = Quad.wrap(bytes16(0x3fff0000000000000000000000000000));
        // int256 midBin = 16376;
        NewLoan.NewLoanParams memory params = NewLoan.NewLoanParams({
            owedPotential: owedPotential, // owedPotential = 1e+00
            startBin: 16377, // startBin
            strikeBin: 16377, // strikeBin
            tokenMix: Quad.wrap(bytes16(0x3ffe0000000000000000000000000000)), // tokenMix = 5e-01
            lockinEnd: POSITIVE_INFINITY,
            deadEra: OptInt256.wrap(OPT_INT256_NONE), // deadEra
            token: false, // token, unused for non-twap
            twapUntil: OptInt256.wrap(OPT_INT256_NONE) // twapUntil, disabled
        });
        UserPay.Info memory userPay = pool.newLoanOnly(params);
        Quad expectedToken0 = -Quad.wrap(bytes16(0x3ff32bc270602e4dfacebc6633d44466)); // expecting userPay.token0 = -2.85872962205125837502547883579845056e-04
        assertTokenAmount(userPay.token0, expectedToken0, newLoanTestEpsilon);
        Quad expectedToken1 = Quad.wrap(bytes16(0x3ff344bcb274c5ce5552ea668b2adcce)); // expecting userPay.token1 = 3.0969342997040482977393934084867763e-04
        assertTokenAmount(userPay.token1, expectedToken1, newLoanTestEpsilon);

        console.log(
            "testNewLoan_test_newloan_nontwap_with_whole_range_pour_immediate_above_mid_price_0_990099009900990099009900990099009911_and_token_mix_0_5 testing done."
        );
    }

    function testNewLoan_test_newloan_nontwap_with_whole_range_pour_far_below_mid_price_0_990099009900990099009900990099009911_and_token_mix_0_5()
        public
    {
        console.log(
            "testNewLoan_test_newloan_nontwap_with_whole_range_pour_far_below_mid_price_0_990099009900990099009900990099009911_and_token_mix_0_5 starting ......"
        );
        testLimitedRangePour(
            Quad.wrap(bytes16(0x3ffefaee41e6a74981446f86562d9faf)), // price = 9.90099009900990099009900990099009911e-01
            Quad.wrap(bytes16(0x3ff847ae147ae147ae147ae147ae147b)), // quadVar = 1.00000000000000000000000000000000002e-02
            0, // startingTub
            4096, // stoppingTub
            Quad.wrap(bytes16(0x40059000000000000000000000000000)), // liquidityPerTub = 1e+02
            Quad.wrap(bytes16(0x400591fae0e8e994c568d4a0eb3df54b)), // expected token0 = 1.00494998587853108604312572889908098e+02
            Quad.wrap(bytes16(0x40058dfff5e1708f004dd48b06f1bcce)), // expected token1 = 9.94999613976431194686472991361695447e+01
            false // skip the checks
        );
        Quad[] memory owedPotential = new Quad[](1);
        owedPotential[0] = Quad.wrap(bytes16(0x3fff0000000000000000000000000000));
        // int256 midBin = 16376;
        NewLoan.NewLoanParams memory params = NewLoan.NewLoanParams({
            owedPotential: owedPotential, // owedPotential = 1e+00
            startBin: 16366, // startBin
            strikeBin: 16366, // strikeBin
            tokenMix: Quad.wrap(bytes16(0x3ffe0000000000000000000000000000)), // tokenMix = 5e-01
            lockinEnd: POSITIVE_INFINITY,
            deadEra: OptInt256.wrap(OPT_INT256_NONE), // deadEra
            token: false, // token, unused for non-twap
            twapUntil: OptInt256.wrap(OPT_INT256_NONE) // twapUntil, disabled
        });
        UserPay.Info memory userPay = pool.newLoanOnly(params);
        Quad expectedToken0 = Quad.wrap(bytes16(0x3ff3499eccc2ffebd34d62402d760d96)); // expecting userPay.token0 = 3.14350425639968998440682136908841797e-04
        assertTokenAmount(userPay.token0, expectedToken0, newLoanTestEpsilon);
        Quad expectedToken1 = -Quad.wrap(bytes16(0x3ff32a8bf95a1a5ca588a68c531deb0b)); // expecting userPay.token1 = -2.84716390189201784731754976875605858e-04
        assertTokenAmount(userPay.token1, expectedToken1, newLoanTestEpsilon);

        console.log(
            "testNewLoan_test_newloan_nontwap_with_whole_range_pour_far_below_mid_price_0_990099009900990099009900990099009911_and_token_mix_0_5 testing done."
        );
    }

    function testNewLoan_test_newloan_nontwap_with_whole_range_pour_far_above_mid_price_0_990099009900990099009900990099009911_and_token_mix_0_5()
        public
    {
        console.log(
            "testNewLoan_test_newloan_nontwap_with_whole_range_pour_far_above_mid_price_0_990099009900990099009900990099009911_and_token_mix_0_5 starting ......"
        );
        testLimitedRangePour(
            Quad.wrap(bytes16(0x3ffefaee41e6a74981446f86562d9faf)), // price = 9.90099009900990099009900990099009911e-01
            Quad.wrap(bytes16(0x3ff847ae147ae147ae147ae147ae147b)), // quadVar = 1.00000000000000000000000000000000002e-02
            0, // startingTub
            4096, // stoppingTub
            Quad.wrap(bytes16(0x40059000000000000000000000000000)), // liquidityPerTub = 1e+02
            Quad.wrap(bytes16(0x400591fae0e8e994c568d4a0eb3df54b)), // expected token0 = 1.00494998587853108604312572889908098e+02
            Quad.wrap(bytes16(0x40058dfff5e1708f004dd48b06f1bcce)), // expected token1 = 9.94999613976431194686472991361695447e+01
            false // skip the checks
        );
        Quad[] memory owedPotential = new Quad[](1);
        owedPotential[0] = Quad.wrap(bytes16(0x3fff0000000000000000000000000000));
        // int256 midBin = 16376;
        NewLoan.NewLoanParams memory params = NewLoan.NewLoanParams({
            owedPotential: owedPotential, // owedPotential = 1e+00
            startBin: 16386, // startBin
            strikeBin: 16386, // strikeBin
            tokenMix: Quad.wrap(bytes16(0x3ffe0000000000000000000000000000)), // tokenMix = 5e-01
            lockinEnd: POSITIVE_INFINITY,
            deadEra: OptInt256.wrap(OPT_INT256_NONE), // deadEra
            token: false, // token, unused for non-twap
            twapUntil: OptInt256.wrap(OPT_INT256_NONE) // twapUntil, disabled
        });
        UserPay.Info memory userPay = pool.newLoanOnly(params);
        Quad expectedToken0 = -Quad.wrap(bytes16(0x3ff32d58435ee1a075cb814ed1768150)); // expecting userPay.token0 = -2.87384775156246785023521637044503989e-04
        assertTokenAmount(userPay.token0, expectedToken0, newLoanTestEpsilon);
        Quad expectedToken1 = Quad.wrap(bytes16(0x3ff3468f4ceb4da03bc386575b80cf82)); // expecting userPay.token1 = 3.11431662982114756826388196858522779e-04
        assertTokenAmount(userPay.token1, expectedToken1, newLoanTestEpsilon);

        console.log(
            "testNewLoan_test_newloan_nontwap_with_whole_range_pour_far_above_mid_price_0_990099009900990099009900990099009911_and_token_mix_0_5 testing done."
        );
    }

    function testNewLoan_test_newloan_nontwap_with_whole_range_pour_immediate_below_mid_price_0_990099009900990099009900990099009911_and_token_mix_0_75(
    ) public {
        console.log(
            "testNewLoan_test_newloan_nontwap_with_whole_range_pour_immediate_below_mid_price_0_990099009900990099009900990099009911_and_token_mix_0_75 starting ......"
        );
        testLimitedRangePour(
            Quad.wrap(bytes16(0x3ffefaee41e6a74981446f86562d9faf)), // price = 9.90099009900990099009900990099009911e-01
            Quad.wrap(bytes16(0x3ff847ae147ae147ae147ae147ae147b)), // quadVar = 1.00000000000000000000000000000000002e-02
            0, // startingTub
            4096, // stoppingTub
            Quad.wrap(bytes16(0x40059000000000000000000000000000)), // liquidityPerTub = 1e+02
            Quad.wrap(bytes16(0x400591fae0e8e994c568d4a0eb3df54b)), // expected token0 = 1.00494998587853108604312572889908098e+02
            Quad.wrap(bytes16(0x40058dfff5e1708f004dd48b06f1bcce)), // expected token1 = 9.94999613976431194686472991361695447e+01
            false // skip the checks
        );
        Quad[] memory owedPotential = new Quad[](1);
        owedPotential[0] = Quad.wrap(bytes16(0x3fff0000000000000000000000000000));
        // int256 midBin = 16376;
        NewLoan.NewLoanParams memory params = NewLoan.NewLoanParams({
            owedPotential: owedPotential, // owedPotential = 1e+00
            startBin: 16375, // startBin
            strikeBin: 16375, // strikeBin
            tokenMix: Quad.wrap(bytes16(0x3ffe8000000000000000000000000000)), // tokenMix = 7.5e-01
            lockinEnd: POSITIVE_INFINITY,
            deadEra: OptInt256.wrap(OPT_INT256_NONE), // deadEra
            token: false, // token, unused for non-twap
            twapUntil: OptInt256.wrap(OPT_INT256_NONE) // twapUntil, disabled
        });
        UserPay.Info memory userPay = pool.newLoanOnly(params);
        Quad expectedToken0 = Quad.wrap(bytes16(0x3ff247c7d2cca14e8b8d999fa2b40543)); // expecting userPay.token0 = 1.56297950884155191987512676044481128e-04
        assertTokenAmount(userPay.token0, expectedToken0, newLoanTestEpsilon);
        Quad expectedToken1 = -Quad.wrap(bytes16(0x3ff20d9e7966f5cf80ff1f9f45a63a8c)); // expecting userPay.token1 = -1.28564376807395248878579055415948459e-04
        assertTokenAmount(userPay.token1, expectedToken1, newLoanTestEpsilon);

        console.log(
            "testNewLoan_test_newloan_nontwap_with_whole_range_pour_immediate_below_mid_price_0_990099009900990099009900990099009911_and_token_mix_0_75 testing done."
        );
    }

    function testNewLoan_test_newloan_nontwap_with_whole_range_pour_immediate_above_mid_price_0_990099009900990099009900990099009911_and_token_mix_0_75(
    ) public {
        console.log(
            "testNewLoan_test_newloan_nontwap_with_whole_range_pour_immediate_above_mid_price_0_990099009900990099009900990099009911_and_token_mix_0_75 starting ......"
        );
        testLimitedRangePour(
            Quad.wrap(bytes16(0x3ffefaee41e6a74981446f86562d9faf)), // price = 9.90099009900990099009900990099009911e-01
            Quad.wrap(bytes16(0x3ff847ae147ae147ae147ae147ae147b)), // quadVar = 1.00000000000000000000000000000000002e-02
            0, // startingTub
            4096, // stoppingTub
            Quad.wrap(bytes16(0x40059000000000000000000000000000)), // liquidityPerTub = 1e+02
            Quad.wrap(bytes16(0x400591fae0e8e994c568d4a0eb3df54b)), // expected token0 = 1.00494998587853108604312572889908098e+02
            Quad.wrap(bytes16(0x40058dfff5e1708f004dd48b06f1bcce)), // expected token1 = 9.94999613976431194686472991361695447e+01
            false // skip the checks
        );
        Quad[] memory owedPotential = new Quad[](1);
        owedPotential[0] = Quad.wrap(bytes16(0x3fff0000000000000000000000000000));
        // int256 midBin = 16376;
        NewLoan.NewLoanParams memory params = NewLoan.NewLoanParams({
            owedPotential: owedPotential, // owedPotential = 1e+00
            startBin: 16377, // startBin
            strikeBin: 16377, // strikeBin
            tokenMix: Quad.wrap(bytes16(0x3ffe8000000000000000000000000000)), // tokenMix = 7.5e-01
            lockinEnd: POSITIVE_INFINITY,
            deadEra: OptInt256.wrap(OPT_INT256_NONE), // deadEra
            token: false, // token, unused for non-twap
            twapUntil: OptInt256.wrap(OPT_INT256_NONE) // twapUntil, disabled
        });
        UserPay.Info memory userPay = pool.newLoanOnly(params);
        Quad expectedToken0 = -Quad.wrap(bytes16(0x3ff3cf7232df9bf3734853459570b70f)); // expecting userPay.token0 = -4.41976631896590305763986537180708084e-04
        assertTokenAmount(userPay.token0, expectedToken0, newLoanTestEpsilon);
        Quad expectedToken1 = Quad.wrap(bytes16(0x3ff3e71b0baf28b57ffc5f99d0c04b36)); // expecting userPay.token1 = 4.64540144955607244660909011273016492e-04
        assertTokenAmount(userPay.token1, expectedToken1, newLoanTestEpsilon);

        console.log(
            "testNewLoan_test_newloan_nontwap_with_whole_range_pour_immediate_above_mid_price_0_990099009900990099009900990099009911_and_token_mix_0_75 testing done."
        );
    }

    function testNewLoan_test_newloan_nontwap_with_whole_range_pour_far_below_mid_price_0_990099009900990099009900990099009911_and_token_mix_0_75()
        public
    {
        console.log(
            "testNewLoan_test_newloan_nontwap_with_whole_range_pour_far_below_mid_price_0_990099009900990099009900990099009911_and_token_mix_0_75 starting ......"
        );
        testLimitedRangePour(
            Quad.wrap(bytes16(0x3ffefaee41e6a74981446f86562d9faf)), // price = 9.90099009900990099009900990099009911e-01
            Quad.wrap(bytes16(0x3ff847ae147ae147ae147ae147ae147b)), // quadVar = 1.00000000000000000000000000000000002e-02
            0, // startingTub
            4096, // stoppingTub
            Quad.wrap(bytes16(0x40059000000000000000000000000000)), // liquidityPerTub = 1e+02
            Quad.wrap(bytes16(0x400591fae0e8e994c568d4a0eb3df54b)), // expected token0 = 1.00494998587853108604312572889908098e+02
            Quad.wrap(bytes16(0x40058dfff5e1708f004dd48b06f1bcce)), // expected token1 = 9.94999613976431194686472991361695447e+01
            false // skip the checks
        );
        Quad[] memory owedPotential = new Quad[](1);
        owedPotential[0] = Quad.wrap(bytes16(0x3fff0000000000000000000000000000));
        // int256 midBin = 16376;
        NewLoan.NewLoanParams memory params = NewLoan.NewLoanParams({
            owedPotential: owedPotential, // owedPotential = 1e+00
            startBin: 16366, // startBin
            strikeBin: 16366, // strikeBin
            tokenMix: Quad.wrap(bytes16(0x3ffe8000000000000000000000000000)), // tokenMix = 7.5e-01
            lockinEnd: POSITIVE_INFINITY,
            deadEra: OptInt256.wrap(OPT_INT256_NONE), // deadEra
            token: false, // token, unused for non-twap
            twapUntil: OptInt256.wrap(OPT_INT256_NONE) // twapUntil, disabled
        });
        UserPay.Info memory userPay = pool.newLoanOnly(params);
        Quad expectedToken0 = Quad.wrap(bytes16(0x3ff2499eccc2ffebd34d62402d760d96)); // expecting userPay.token0 = 1.57175212819984499220341068454420898e-04
        assertTokenAmount(userPay.token0, expectedToken0, newLoanTestEpsilon);
        Quad expectedToken1 = -Quad.wrap(bytes16(0x3ff21292023b7c08d4cac900f0961a36)); // expecting userPay.token1 = -1.30925343782010649923443968838133292e-04
        assertTokenAmount(userPay.token1, expectedToken1, newLoanTestEpsilon);

        console.log(
            "testNewLoan_test_newloan_nontwap_with_whole_range_pour_far_below_mid_price_0_990099009900990099009900990099009911_and_token_mix_0_75 testing done."
        );
    }

    function testNewLoan_test_newloan_nontwap_with_whole_range_pour_far_above_mid_price_0_990099009900990099009900990099009911_and_token_mix_0_75()
        public
    {
        console.log(
            "testNewLoan_test_newloan_nontwap_with_whole_range_pour_far_above_mid_price_0_990099009900990099009900990099009911_and_token_mix_0_75 starting ......"
        );
        testLimitedRangePour(
            Quad.wrap(bytes16(0x3ffefaee41e6a74981446f86562d9faf)), // price = 9.90099009900990099009900990099009911e-01
            Quad.wrap(bytes16(0x3ff847ae147ae147ae147ae147ae147b)), // quadVar = 1.00000000000000000000000000000000002e-02
            0, // startingTub
            4096, // stoppingTub
            Quad.wrap(bytes16(0x40059000000000000000000000000000)), // liquidityPerTub = 1e+02
            Quad.wrap(bytes16(0x400591fae0e8e994c568d4a0eb3df54b)), // expected token0 = 1.00494998587853108604312572889908098e+02
            Quad.wrap(bytes16(0x40058dfff5e1708f004dd48b06f1bcce)), // expected token1 = 9.94999613976431194686472991361695447e+01
            false // skip the checks
        );
        Quad[] memory owedPotential = new Quad[](1);
        owedPotential[0] = Quad.wrap(bytes16(0x3fff0000000000000000000000000000));
        // int256 midBin = 16376;
        NewLoan.NewLoanParams memory params = NewLoan.NewLoanParams({
            owedPotential: owedPotential, // owedPotential = 1e+00
            startBin: 16386, // startBin
            strikeBin: 16386, // strikeBin
            tokenMix: Quad.wrap(bytes16(0x3ffe8000000000000000000000000000)), // tokenMix = 7.5e-01
            lockinEnd: POSITIVE_INFINITY,
            deadEra: OptInt256.wrap(OPT_INT256_NONE), // deadEra
            token: false, // token, unused for non-twap
            twapUntil: OptInt256.wrap(OPT_INT256_NONE) // twapUntil, disabled
        });
        UserPay.Info memory userPay = pool.newLoanOnly(params);
        Quad expectedToken0 = -Quad.wrap(bytes16(0x3ff3d01e23e1680567eae0dfb60e1d53)); // expecting userPay.token0 = -4.42617163651353421750548965014212899e-04
        assertTokenAmount(userPay.token0, expectedToken0, newLoanTestEpsilon);
        Quad expectedToken1 = Quad.wrap(bytes16(0x3ff3e9d6f360f47059a5498309413742)); // expecting userPay.token1 = 4.67147494473172135239582295287784122e-04
        assertTokenAmount(userPay.token1, expectedToken1, newLoanTestEpsilon);

        console.log(
            "testNewLoan_test_newloan_nontwap_with_whole_range_pour_far_above_mid_price_0_990099009900990099009900990099009911_and_token_mix_0_75 testing done."
        );
    }

    function testNewLoan_test_newloan_nontwap_with_whole_range_pour_immediate_below_mid_price_0_990099009900990099009900990099009911_and_token_mix_1()
        public
    {
        console.log(
            "testNewLoan_test_newloan_nontwap_with_whole_range_pour_immediate_below_mid_price_0_990099009900990099009900990099009911_and_token_mix_1 starting ......"
        );
        testLimitedRangePour(
            Quad.wrap(bytes16(0x3ffefaee41e6a74981446f86562d9faf)), // price = 9.90099009900990099009900990099009911e-01
            Quad.wrap(bytes16(0x3ff847ae147ae147ae147ae147ae147b)), // quadVar = 1.00000000000000000000000000000000002e-02
            0, // startingTub
            4096, // stoppingTub
            Quad.wrap(bytes16(0x40059000000000000000000000000000)), // liquidityPerTub = 1e+02
            Quad.wrap(bytes16(0x400591fae0e8e994c568d4a0eb3df54b)), // expected token0 = 1.00494998587853108604312572889908098e+02
            Quad.wrap(bytes16(0x40058dfff5e1708f004dd48b06f1bcce)), // expected token1 = 9.94999613976431194686472991361695447e+01
            false // skip the checks
        );
        Quad[] memory owedPotential = new Quad[](1);
        owedPotential[0] = Quad.wrap(bytes16(0x3fff0000000000000000000000000000));
        // int256 midBin = 16376;
        NewLoan.NewLoanParams memory params = NewLoan.NewLoanParams({
            owedPotential: owedPotential, // owedPotential = 1e+00
            startBin: 16375, // startBin
            strikeBin: 16375, // strikeBin
            tokenMix: Quad.wrap(bytes16(0x3fff0000000000000000000000000000)), // tokenMix = 1e+00
            lockinEnd: POSITIVE_INFINITY,
            deadEra: OptInt256.wrap(OPT_INT256_NONE), // deadEra
            token: false, // token, unused for non-twap
            twapUntil: OptInt256.wrap(OPT_INT256_NONE) // twapUntil, disabled
        });
        UserPay.Info memory userPay = pool.newLoanOnly(params);
        Quad expectedToken0 = POSITIVE_ZERO; // expecting userPay.token0 = 0e+00
        assertTokenAmount(userPay.token0, expectedToken0, newLoanTestEpsilon);
        Quad expectedToken1 = Quad.wrap(bytes16(0x3fefb5b7196c90e8f85dfe3f8f059440)); // expecting userPay.token1 = 2.60898608977060136840680528419620427e-05
        assertTokenAmount(userPay.token1, expectedToken1, newLoanTestEpsilon);

        console.log(
            "testNewLoan_test_newloan_nontwap_with_whole_range_pour_immediate_below_mid_price_0_990099009900990099009900990099009911_and_token_mix_1 testing done."
        );
    }

    function testNewLoan_test_newloan_nontwap_with_whole_range_pour_immediate_above_mid_price_0_990099009900990099009900990099009911_and_token_mix_1()
        public
    {
        console.log(
            "testNewLoan_test_newloan_nontwap_with_whole_range_pour_immediate_above_mid_price_0_990099009900990099009900990099009911_and_token_mix_1 starting ......"
        );
        testLimitedRangePour(
            Quad.wrap(bytes16(0x3ffefaee41e6a74981446f86562d9faf)), // price = 9.90099009900990099009900990099009911e-01
            Quad.wrap(bytes16(0x3ff847ae147ae147ae147ae147ae147b)), // quadVar = 1.00000000000000000000000000000000002e-02
            0, // startingTub
            4096, // stoppingTub
            Quad.wrap(bytes16(0x40059000000000000000000000000000)), // liquidityPerTub = 1e+02
            Quad.wrap(bytes16(0x400591fae0e8e994c568d4a0eb3df54b)), // expected token0 = 1.00494998587853108604312572889908098e+02
            Quad.wrap(bytes16(0x40058dfff5e1708f004dd48b06f1bcce)), // expected token1 = 9.94999613976431194686472991361695447e+01
            false // skip the checks
        );
        Quad[] memory owedPotential = new Quad[](1);
        owedPotential[0] = Quad.wrap(bytes16(0x3fff0000000000000000000000000000));
        // int256 midBin = 16376;
        NewLoan.NewLoanParams memory params = NewLoan.NewLoanParams({
            owedPotential: owedPotential, // owedPotential = 1e+00
            startBin: 16377, // startBin
            strikeBin: 16377, // strikeBin
            tokenMix: Quad.wrap(bytes16(0x3fff0000000000000000000000000000)), // tokenMix = 1e+00
            lockinEnd: POSITIVE_INFINITY,
            deadEra: OptInt256.wrap(OPT_INT256_NONE), // deadEra
            token: false, // token, unused for non-twap
            twapUntil: OptInt256.wrap(OPT_INT256_NONE) // twapUntil, disabled
        });
        UserPay.Info memory userPay = pool.newLoanOnly(params);
        Quad expectedToken0 = -Quad.wrap(bytes16(0x3ff43990faaf84cc75e0f5127b8694dc)); // expecting userPay.token0 = -5.98080301588054774025425190781571111e-04
        assertTokenAmount(userPay.token0, expectedToken0, newLoanTestEpsilon);
        Quad expectedToken1 = Quad.wrap(bytes16(0x3ff444bcb274c5ce5552ea668b2adcce)); // expecting userPay.token1 = 6.19386859940809659547878681697355261e-04
        assertTokenAmount(userPay.token1, expectedToken1, newLoanTestEpsilon);

        console.log(
            "testNewLoan_test_newloan_nontwap_with_whole_range_pour_immediate_above_mid_price_0_990099009900990099009900990099009911_and_token_mix_1 testing done."
        );
    }

    function testNewLoan_test_newloan_nontwap_with_whole_range_pour_far_below_mid_price_0_990099009900990099009900990099009911_and_token_mix_1()
        public
    {
        console.log(
            "testNewLoan_test_newloan_nontwap_with_whole_range_pour_far_below_mid_price_0_990099009900990099009900990099009911_and_token_mix_1 starting ......"
        );
        testLimitedRangePour(
            Quad.wrap(bytes16(0x3ffefaee41e6a74981446f86562d9faf)), // price = 9.90099009900990099009900990099009911e-01
            Quad.wrap(bytes16(0x3ff847ae147ae147ae147ae147ae147b)), // quadVar = 1.00000000000000000000000000000000002e-02
            0, // startingTub
            4096, // stoppingTub
            Quad.wrap(bytes16(0x40059000000000000000000000000000)), // liquidityPerTub = 1e+02
            Quad.wrap(bytes16(0x400591fae0e8e994c568d4a0eb3df54b)), // expected token0 = 1.00494998587853108604312572889908098e+02
            Quad.wrap(bytes16(0x40058dfff5e1708f004dd48b06f1bcce)), // expected token1 = 9.94999613976431194686472991361695447e+01
            false // skip the checks
        );
        Quad[] memory owedPotential = new Quad[](1);
        owedPotential[0] = Quad.wrap(bytes16(0x3fff0000000000000000000000000000));
        // int256 midBin = 16376;
        NewLoan.NewLoanParams memory params = NewLoan.NewLoanParams({
            owedPotential: owedPotential, // owedPotential = 1e+00
            startBin: 16366, // startBin
            strikeBin: 16366, // strikeBin
            tokenMix: Quad.wrap(bytes16(0x3fff0000000000000000000000000000)), // tokenMix = 1e+00
            lockinEnd: POSITIVE_INFINITY,
            deadEra: OptInt256.wrap(OPT_INT256_NONE), // deadEra
            token: false, // token, unused for non-twap
            twapUntil: OptInt256.wrap(OPT_INT256_NONE) // twapUntil, disabled
        });
        UserPay.Info memory userPay = pool.newLoanOnly(params);
        Quad expectedToken0 = POSITIVE_ZERO; // expecting userPay.token0 = 0e+00
        assertTokenAmount(userPay.token0, expectedToken0, newLoanTestEpsilon);
        Quad expectedToken1 = Quad.wrap(bytes16(0x3fef7f9f71e9e53d0bddd8b6287d0d40)); // expecting userPay.token1 = 2.28657026251804848848670391993392274e-05
        assertTokenAmount(userPay.token1, expectedToken1, newLoanTestEpsilon);

        console.log(
            "testNewLoan_test_newloan_nontwap_with_whole_range_pour_far_below_mid_price_0_990099009900990099009900990099009911_and_token_mix_1 testing done."
        );
    }

    function testNewLoan_test_newloan_nontwap_with_whole_range_pour_far_above_mid_price_0_990099009900990099009900990099009911_and_token_mix_1()
        public
    {
        console.log(
            "testNewLoan_test_newloan_nontwap_with_whole_range_pour_far_above_mid_price_0_990099009900990099009900990099009911_and_token_mix_1 starting ......"
        );
        testLimitedRangePour(
            Quad.wrap(bytes16(0x3ffefaee41e6a74981446f86562d9faf)), // price = 9.90099009900990099009900990099009911e-01
            Quad.wrap(bytes16(0x3ff847ae147ae147ae147ae147ae147b)), // quadVar = 1.00000000000000000000000000000000002e-02
            0, // startingTub
            4096, // stoppingTub
            Quad.wrap(bytes16(0x40059000000000000000000000000000)), // liquidityPerTub = 1e+02
            Quad.wrap(bytes16(0x400591fae0e8e994c568d4a0eb3df54b)), // expected token0 = 1.00494998587853108604312572889908098e+02
            Quad.wrap(bytes16(0x40058dfff5e1708f004dd48b06f1bcce)), // expected token1 = 9.94999613976431194686472991361695447e+01
            false // skip the checks
        );
        Quad[] memory owedPotential = new Quad[](1);
        owedPotential[0] = Quad.wrap(bytes16(0x3fff0000000000000000000000000000));
        // int256 midBin = 16376;
        NewLoan.NewLoanParams memory params = NewLoan.NewLoanParams({
            owedPotential: owedPotential, // owedPotential = 1e+00
            startBin: 16386, // startBin
            strikeBin: 16386, // strikeBin
            tokenMix: Quad.wrap(bytes16(0x3fff0000000000000000000000000000)), // tokenMix = 1e+00
            lockinEnd: POSITIVE_INFINITY,
            deadEra: OptInt256.wrap(OPT_INT256_NONE), // deadEra
            token: false, // token, unused for non-twap
            twapUntil: OptInt256.wrap(OPT_INT256_NONE) // twapUntil, disabled
        });
        UserPay.Info memory userPay = pool.newLoanOnly(params);
        Quad expectedToken0 = -Quad.wrap(bytes16(0x3ff439720231f7352d0520384d52dcab)); // expecting userPay.token0 = -5.97849552146460058477576292983921808e-04
        assertTokenAmount(userPay.token0, expectedToken0, newLoanTestEpsilon);
        Quad expectedToken1 = Quad.wrap(bytes16(0x3ff4468f4ceb4da03bc386575b80cf82)); // expecting userPay.token1 = 6.22863325964229513652776393717045558e-04
        assertTokenAmount(userPay.token1, expectedToken1, newLoanTestEpsilon);

        console.log(
            "testNewLoan_test_newloan_nontwap_with_whole_range_pour_far_above_mid_price_0_990099009900990099009900990099009911_and_token_mix_1 testing done."
        );
    }

    function testNewLoan_test_newloan_nontwap_with_whole_range_pour_immediate_below_mid_price_1_and_token_mix_0() public {
        console.log("testNewLoan_test_newloan_nontwap_with_whole_range_pour_immediate_below_mid_price_1_and_token_mix_0 starting ......");
        testLimitedRangePour(
            Quad.wrap(bytes16(0x3fff0000000000000000000000000000)), // price = 1e+00
            Quad.wrap(bytes16(0x3ff847ae147ae147ae147ae147ae147b)), // quadVar = 1.00000000000000000000000000000000002e-02
            0, // startingTub
            4096, // stoppingTub
            Quad.wrap(bytes16(0x40059000000000000000000000000000)), // liquidityPerTub = 1e+02
            Quad.wrap(bytes16(0x40058ffc26f62a4e01c1cbfdd92bab65)), // expected token0 = 9.99962423766442059021199237623123453e+01
            Quad.wrap(bytes16(0x40058ffc26f62a4e01c1cbfdd92bab65)), // expected token1 = 9.99962423766442059021199237623123453e+01
            false // skip the checks
        );
        Quad[] memory owedPotential = new Quad[](1);
        owedPotential[0] = Quad.wrap(bytes16(0x3fff0000000000000000000000000000));
        // int256 midBin = 16384;
        NewLoan.NewLoanParams memory params = NewLoan.NewLoanParams({
            owedPotential: owedPotential, // owedPotential = 1e+00
            startBin: 16383, // startBin
            strikeBin: 16383, // strikeBin
            tokenMix: POSITIVE_ZERO, // tokenMix = 0e+00
            lockinEnd: POSITIVE_INFINITY,
            deadEra: OptInt256.wrap(OPT_INT256_NONE), // deadEra
            token: false, // token, unused for non-twap
            twapUntil: OptInt256.wrap(OPT_INT256_NONE) // twapUntil, disabled
        });
        UserPay.Info memory userPay = pool.newLoanOnly(params);
        Quad expectedToken0 = Quad.wrap(bytes16(0x3ff44627629069b8fae87e6ce6acf49e)); // expecting userPay.token0 = 6.22089095533394677486329146872985519e-04
        assertTokenAmount(userPay.token0, expectedToken0, newLoanTestEpsilon);
        Quad expectedToken1 = -Quad.wrap(bytes16(0x3ff4383449f0d32c28549d7b99dc6fa4)); // expecting userPay.token1 = -5.954823555867838582123050480006771e-04
        assertTokenAmount(userPay.token1, expectedToken1, newLoanTestEpsilon);

        console.log("testNewLoan_test_newloan_nontwap_with_whole_range_pour_immediate_below_mid_price_1_and_token_mix_0 testing done.");
    }

    function testNewLoan_test_newloan_nontwap_with_whole_range_pour_immediate_above_mid_price_1_and_token_mix_0() public {
        console.log("testNewLoan_test_newloan_nontwap_with_whole_range_pour_immediate_above_mid_price_1_and_token_mix_0 starting ......");
        testLimitedRangePour(
            Quad.wrap(bytes16(0x3fff0000000000000000000000000000)), // price = 1e+00
            Quad.wrap(bytes16(0x3ff847ae147ae147ae147ae147ae147b)), // quadVar = 1.00000000000000000000000000000000002e-02
            0, // startingTub
            4096, // stoppingTub
            Quad.wrap(bytes16(0x40059000000000000000000000000000)), // liquidityPerTub = 1e+02
            Quad.wrap(bytes16(0x40058ffc26f62a4e01c1cbfdd92bab65)), // expected token0 = 9.99962423766442059021199237623123453e+01
            Quad.wrap(bytes16(0x40058ffc26f62a4e01c1cbfdd92bab65)), // expected token1 = 9.99962423766442059021199237623123453e+01
            false // skip the checks
        );
        Quad[] memory owedPotential = new Quad[](1);
        owedPotential[0] = Quad.wrap(bytes16(0x3fff0000000000000000000000000000));
        // int256 midBin = 16384;
        NewLoan.NewLoanParams memory params = NewLoan.NewLoanParams({
            owedPotential: owedPotential, // owedPotential = 1e+00
            startBin: 16385, // startBin
            strikeBin: 16385, // strikeBin
            tokenMix: POSITIVE_ZERO, // tokenMix = 0e+00
            lockinEnd: POSITIVE_INFINITY,
            deadEra: OptInt256.wrap(OPT_INT256_NONE), // deadEra
            token: false, // token, unused for non-twap
            twapUntil: OptInt256.wrap(OPT_INT256_NONE) // twapUntil, disabled
        });
        UserPay.Info memory userPay = pool.newLoanOnly(params);
        Quad expectedToken0 = Quad.wrap(bytes16(0x3fefb79ff7fd0bf483bc5dfb6d6ec7c0)); // expecting userPay.token0 = 2.62036846729312591243305264760789022e-05
        assertTokenAmount(userPay.token0, expectedToken0, newLoanTestEpsilon);
        Quad expectedToken1 = POSITIVE_ZERO; // expecting userPay.token1 = 0e+00
        assertTokenAmount(userPay.token1, expectedToken1, newLoanTestEpsilon);

        console.log("testNewLoan_test_newloan_nontwap_with_whole_range_pour_immediate_above_mid_price_1_and_token_mix_0 testing done.");
    }

    function testNewLoan_test_newloan_nontwap_with_whole_range_pour_far_below_mid_price_1_and_token_mix_0() public {
        console.log("testNewLoan_test_newloan_nontwap_with_whole_range_pour_far_below_mid_price_1_and_token_mix_0 starting ......");
        testLimitedRangePour(
            Quad.wrap(bytes16(0x3fff0000000000000000000000000000)), // price = 1e+00
            Quad.wrap(bytes16(0x3ff847ae147ae147ae147ae147ae147b)), // quadVar = 1.00000000000000000000000000000000002e-02
            0, // startingTub
            4096, // stoppingTub
            Quad.wrap(bytes16(0x40059000000000000000000000000000)), // liquidityPerTub = 1e+02
            Quad.wrap(bytes16(0x40058ffc26f62a4e01c1cbfdd92bab65)), // expected token0 = 9.99962423766442059021199237623123453e+01
            Quad.wrap(bytes16(0x40058ffc26f62a4e01c1cbfdd92bab65)), // expected token1 = 9.99962423766442059021199237623123453e+01
            false // skip the checks
        );
        Quad[] memory owedPotential = new Quad[](1);
        owedPotential[0] = Quad.wrap(bytes16(0x3fff0000000000000000000000000000));
        // int256 midBin = 16384;
        NewLoan.NewLoanParams memory params = NewLoan.NewLoanParams({
            owedPotential: owedPotential, // owedPotential = 1e+00
            startBin: 16374, // startBin
            strikeBin: 16374, // strikeBin
            tokenMix: POSITIVE_ZERO, // tokenMix = 0e+00
            lockinEnd: POSITIVE_INFINITY,
            deadEra: OptInt256.wrap(OPT_INT256_NONE), // deadEra
            token: false, // token, unused for non-twap
            twapUntil: OptInt256.wrap(OPT_INT256_NONE) // twapUntil, disabled
        });
        UserPay.Info memory userPay = pool.newLoanOnly(params);
        Quad expectedToken0 = Quad.wrap(bytes16(0x3ff447fc062923f1ad3795b45e7aa6b2)); // expecting userPay.token0 = 6.25580728540217756143357468514328875e-04
        assertTokenAmount(userPay.token0, expectedToken0, newLoanTestEpsilon);
        Quad expectedToken1 = -Quad.wrap(bytes16(0x3ff4381573e3def3a35394b3367ffb84)); // expecting userPay.token1 = -5.95252608476460536708085694487231057e-04
        assertTokenAmount(userPay.token1, expectedToken1, newLoanTestEpsilon);

        console.log("testNewLoan_test_newloan_nontwap_with_whole_range_pour_far_below_mid_price_1_and_token_mix_0 testing done.");
    }

    function testNewLoan_test_newloan_nontwap_with_whole_range_pour_far_above_mid_price_1_and_token_mix_0() public {
        console.log("testNewLoan_test_newloan_nontwap_with_whole_range_pour_far_above_mid_price_1_and_token_mix_0 starting ......");
        testLimitedRangePour(
            Quad.wrap(bytes16(0x3fff0000000000000000000000000000)), // price = 1e+00
            Quad.wrap(bytes16(0x3ff847ae147ae147ae147ae147ae147b)), // quadVar = 1.00000000000000000000000000000000002e-02
            0, // startingTub
            4096, // stoppingTub
            Quad.wrap(bytes16(0x40059000000000000000000000000000)), // liquidityPerTub = 1e+02
            Quad.wrap(bytes16(0x40058ffc26f62a4e01c1cbfdd92bab65)), // expected token0 = 9.99962423766442059021199237623123453e+01
            Quad.wrap(bytes16(0x40058ffc26f62a4e01c1cbfdd92bab65)), // expected token1 = 9.99962423766442059021199237623123453e+01
            false // skip the checks
        );
        Quad[] memory owedPotential = new Quad[](1);
        owedPotential[0] = Quad.wrap(bytes16(0x3fff0000000000000000000000000000));
        // int256 midBin = 16384;
        NewLoan.NewLoanParams memory params = NewLoan.NewLoanParams({
            owedPotential: owedPotential, // owedPotential = 1e+00
            startBin: 16394, // startBin
            strikeBin: 16394, // strikeBin
            tokenMix: POSITIVE_ZERO, // tokenMix = 0e+00
            lockinEnd: POSITIVE_INFINITY,
            deadEra: OptInt256.wrap(OPT_INT256_NONE), // deadEra
            token: false, // token, unused for non-twap
            twapUntil: OptInt256.wrap(OPT_INT256_NONE) // twapUntil, disabled
        });
        UserPay.Info memory userPay = pool.newLoanOnly(params);
        Quad expectedToken0 = Quad.wrap(bytes16(0x3fef814be67fe1f7ca6241198f76c8c0)); // expecting userPay.token0 = 2.2965460174911410838352641304303048e-05
        assertTokenAmount(userPay.token0, expectedToken0, newLoanTestEpsilon);
        Quad expectedToken1 = POSITIVE_ZERO; // expecting userPay.token1 = 0e+00
        assertTokenAmount(userPay.token1, expectedToken1, newLoanTestEpsilon);

        console.log("testNewLoan_test_newloan_nontwap_with_whole_range_pour_far_above_mid_price_1_and_token_mix_0 testing done.");
    }

    function testNewLoan_test_newloan_nontwap_with_whole_range_pour_immediate_below_mid_price_1_and_token_mix_0_25() public {
        console.log("testNewLoan_test_newloan_nontwap_with_whole_range_pour_immediate_below_mid_price_1_and_token_mix_0_25 starting ......");
        testLimitedRangePour(
            Quad.wrap(bytes16(0x3fff0000000000000000000000000000)), // price = 1e+00
            Quad.wrap(bytes16(0x3ff847ae147ae147ae147ae147ae147b)), // quadVar = 1.00000000000000000000000000000000002e-02
            0, // startingTub
            4096, // stoppingTub
            Quad.wrap(bytes16(0x40059000000000000000000000000000)), // liquidityPerTub = 1e+02
            Quad.wrap(bytes16(0x40058ffc26f62a4e01c1cbfdd92bab65)), // expected token0 = 9.99962423766442059021199237623123453e+01
            Quad.wrap(bytes16(0x40058ffc26f62a4e01c1cbfdd92bab65)), // expected token1 = 9.99962423766442059021199237623123453e+01
            false // skip the checks
        );
        Quad[] memory owedPotential = new Quad[](1);
        owedPotential[0] = Quad.wrap(bytes16(0x3fff0000000000000000000000000000));
        // int256 midBin = 16384;
        NewLoan.NewLoanParams memory params = NewLoan.NewLoanParams({
            owedPotential: owedPotential, // owedPotential = 1e+00
            startBin: 16383, // startBin
            strikeBin: 16383, // strikeBin
            tokenMix: Quad.wrap(bytes16(0x3ffd0000000000000000000000000000)), // tokenMix = 2.5e-01
            lockinEnd: POSITIVE_INFINITY,
            deadEra: OptInt256.wrap(OPT_INT256_NONE), // deadEra
            token: false, // token, unused for non-twap
            twapUntil: OptInt256.wrap(OPT_INT256_NONE) // twapUntil, disabled
        });
        UserPay.Info memory userPay = pool.newLoanOnly(params);
        Quad expectedToken0 = Quad.wrap(bytes16(0x3ff3e93b13d89e95785cbda35a036eef)); // expecting userPay.token0 = 4.66566821650046008114746860154739233e-04
        assertTokenAmount(userPay.token0, expectedToken0, newLoanTestEpsilon);
        Quad expectedToken1 = -Quad.wrap(bytes16(0x3ff3cd6ed6fc9c5b49d090021563d3d1)); // expecting userPay.token1 = -4.40056770265230622357165920155260077e-04
        assertTokenAmount(userPay.token1, expectedToken1, newLoanTestEpsilon);

        console.log("testNewLoan_test_newloan_nontwap_with_whole_range_pour_immediate_below_mid_price_1_and_token_mix_0_25 testing done.");
    }

    function testNewLoan_test_newloan_nontwap_with_whole_range_pour_immediate_above_mid_price_1_and_token_mix_0_25() public {
        console.log("testNewLoan_test_newloan_nontwap_with_whole_range_pour_immediate_above_mid_price_1_and_token_mix_0_25 starting ......");
        testLimitedRangePour(
            Quad.wrap(bytes16(0x3fff0000000000000000000000000000)), // price = 1e+00
            Quad.wrap(bytes16(0x3ff847ae147ae147ae147ae147ae147b)), // quadVar = 1.00000000000000000000000000000000002e-02
            0, // startingTub
            4096, // stoppingTub
            Quad.wrap(bytes16(0x40059000000000000000000000000000)), // liquidityPerTub = 1e+02
            Quad.wrap(bytes16(0x40058ffc26f62a4e01c1cbfdd92bab65)), // expected token0 = 9.99962423766442059021199237623123453e+01
            Quad.wrap(bytes16(0x40058ffc26f62a4e01c1cbfdd92bab65)), // expected token1 = 9.99962423766442059021199237623123453e+01
            false // skip the checks
        );
        Quad[] memory owedPotential = new Quad[](1);
        owedPotential[0] = Quad.wrap(bytes16(0x3fff0000000000000000000000000000));
        // int256 midBin = 16384;
        NewLoan.NewLoanParams memory params = NewLoan.NewLoanParams({
            owedPotential: owedPotential, // owedPotential = 1e+00
            startBin: 16385, // startBin
            strikeBin: 16385, // strikeBin
            tokenMix: Quad.wrap(bytes16(0x3ffd0000000000000000000000000000)), // tokenMix = 2.5e-01
            lockinEnd: POSITIVE_INFINITY,
            deadEra: OptInt256.wrap(OPT_INT256_NONE), // deadEra
            token: false, // token, unused for non-twap
            twapUntil: OptInt256.wrap(OPT_INT256_NONE) // twapUntil, disabled
        });
        UserPay.Info memory userPay = pool.newLoanOnly(params);
        Quad expectedToken0 = -Quad.wrap(bytes16(0x3ff20ecb9a47190ab3ca8e255176fbd4)); // expecting userPay.token0 = -1.29125272198331787032063591641768409e-04
        assertTokenAmount(userPay.token0, expectedToken0, newLoanTestEpsilon);
        Quad expectedToken1 = Quad.wrap(bytes16(0x3ff2465b539b0c9861af7816fcda4537)); // expecting userPay.token1 = 1.55619022594044058634001057875664262e-04
        assertTokenAmount(userPay.token1, expectedToken1, newLoanTestEpsilon);

        console.log("testNewLoan_test_newloan_nontwap_with_whole_range_pour_immediate_above_mid_price_1_and_token_mix_0_25 testing done.");
    }

    function testNewLoan_test_newloan_nontwap_with_whole_range_pour_far_below_mid_price_1_and_token_mix_0_25() public {
        console.log("testNewLoan_test_newloan_nontwap_with_whole_range_pour_far_below_mid_price_1_and_token_mix_0_25 starting ......");
        testLimitedRangePour(
            Quad.wrap(bytes16(0x3fff0000000000000000000000000000)), // price = 1e+00
            Quad.wrap(bytes16(0x3ff847ae147ae147ae147ae147ae147b)), // quadVar = 1.00000000000000000000000000000000002e-02
            0, // startingTub
            4096, // stoppingTub
            Quad.wrap(bytes16(0x40059000000000000000000000000000)), // liquidityPerTub = 1e+02
            Quad.wrap(bytes16(0x40058ffc26f62a4e01c1cbfdd92bab65)), // expected token0 = 9.99962423766442059021199237623123453e+01
            Quad.wrap(bytes16(0x40058ffc26f62a4e01c1cbfdd92bab65)), // expected token1 = 9.99962423766442059021199237623123453e+01
            false // skip the checks
        );
        Quad[] memory owedPotential = new Quad[](1);
        owedPotential[0] = Quad.wrap(bytes16(0x3fff0000000000000000000000000000));
        // int256 midBin = 16384;
        NewLoan.NewLoanParams memory params = NewLoan.NewLoanParams({
            owedPotential: owedPotential, // owedPotential = 1e+00
            startBin: 16374, // startBin
            strikeBin: 16374, // strikeBin
            tokenMix: Quad.wrap(bytes16(0x3ffd0000000000000000000000000000)), // tokenMix = 2.5e-01
            lockinEnd: POSITIVE_INFINITY,
            deadEra: OptInt256.wrap(OPT_INT256_NONE), // deadEra
            token: false, // token, unused for non-twap
            twapUntil: OptInt256.wrap(OPT_INT256_NONE) // twapUntil, disabled
        });
        UserPay.Info memory userPay = pool.newLoanOnly(params);
        Quad expectedToken0 = Quad.wrap(bytes16(0x3ff3ebfa093db5ea83d3608e8db7fa0a)); // expecting userPay.token0 = 4.69185546405163317107518101385746609e-04
        assertTokenAmount(userPay.token0, expectedToken0, newLoanTestEpsilon);
        Quad expectedToken1 = -Quad.wrap(bytes16(0x3ff3ce1a08cad7ade62ec6b6e1441d96)); // expecting userPay.token1 = -4.40694519673030370112601879040832024e-04
        assertTokenAmount(userPay.token1, expectedToken1, newLoanTestEpsilon);

        console.log("testNewLoan_test_newloan_nontwap_with_whole_range_pour_far_below_mid_price_1_and_token_mix_0_25 testing done.");
    }

    function testNewLoan_test_newloan_nontwap_with_whole_range_pour_far_above_mid_price_1_and_token_mix_0_25() public {
        console.log("testNewLoan_test_newloan_nontwap_with_whole_range_pour_far_above_mid_price_1_and_token_mix_0_25 starting ......");
        testLimitedRangePour(
            Quad.wrap(bytes16(0x3fff0000000000000000000000000000)), // price = 1e+00
            Quad.wrap(bytes16(0x3ff847ae147ae147ae147ae147ae147b)), // quadVar = 1.00000000000000000000000000000000002e-02
            0, // startingTub
            4096, // stoppingTub
            Quad.wrap(bytes16(0x40059000000000000000000000000000)), // liquidityPerTub = 1e+02
            Quad.wrap(bytes16(0x40058ffc26f62a4e01c1cbfdd92bab65)), // expected token0 = 9.99962423766442059021199237623123453e+01
            Quad.wrap(bytes16(0x40058ffc26f62a4e01c1cbfdd92bab65)), // expected token1 = 9.99962423766442059021199237623123453e+01
            false // skip the checks
        );
        Quad[] memory owedPotential = new Quad[](1);
        owedPotential[0] = Quad.wrap(bytes16(0x3fff0000000000000000000000000000));
        // int256 midBin = 16384;
        NewLoan.NewLoanParams memory params = NewLoan.NewLoanParams({
            owedPotential: owedPotential, // owedPotential = 1e+00
            startBin: 16394, // startBin
            strikeBin: 16394, // strikeBin
            tokenMix: Quad.wrap(bytes16(0x3ffd0000000000000000000000000000)), // tokenMix = 2.5e-01
            lockinEnd: POSITIVE_INFINITY,
            deadEra: OptInt256.wrap(OPT_INT256_NONE), // deadEra
            token: false, // token, unused for non-twap
            twapUntil: OptInt256.wrap(OPT_INT256_NONE) // twapUntil, disabled
        });
        UserPay.Info memory userPay = pool.newLoanOnly(params);
        Quad expectedToken0 = -Quad.wrap(bytes16(0x3ff213c4aac6430b5b89fd462e2588a4)); // expecting userPay.token0 = -1.31496539502844940808202856346896084e-04
        assertTokenAmount(userPay.token0, expectedToken0, newLoanTestEpsilon);
        Quad expectedToken1 = Quad.wrap(bytes16(0x3ff2483041d5d48c20d1a37aa06a7364)); // expecting userPay.token1 = 1.56492473872454615577330248181434316e-04
        assertTokenAmount(userPay.token1, expectedToken1, newLoanTestEpsilon);

        console.log("testNewLoan_test_newloan_nontwap_with_whole_range_pour_far_above_mid_price_1_and_token_mix_0_25 testing done.");
    }

    function testNewLoan_test_newloan_nontwap_with_whole_range_pour_immediate_below_mid_price_1_and_token_mix_0_5() public {
        console.log("testNewLoan_test_newloan_nontwap_with_whole_range_pour_immediate_below_mid_price_1_and_token_mix_0_5 starting ......");
        testLimitedRangePour(
            Quad.wrap(bytes16(0x3fff0000000000000000000000000000)), // price = 1e+00
            Quad.wrap(bytes16(0x3ff847ae147ae147ae147ae147ae147b)), // quadVar = 1.00000000000000000000000000000000002e-02
            0, // startingTub
            4096, // stoppingTub
            Quad.wrap(bytes16(0x40059000000000000000000000000000)), // liquidityPerTub = 1e+02
            Quad.wrap(bytes16(0x40058ffc26f62a4e01c1cbfdd92bab65)), // expected token0 = 9.99962423766442059021199237623123453e+01
            Quad.wrap(bytes16(0x40058ffc26f62a4e01c1cbfdd92bab65)), // expected token1 = 9.99962423766442059021199237623123453e+01
            false // skip the checks
        );
        Quad[] memory owedPotential = new Quad[](1);
        owedPotential[0] = Quad.wrap(bytes16(0x3fff0000000000000000000000000000));
        // int256 midBin = 16384;
        NewLoan.NewLoanParams memory params = NewLoan.NewLoanParams({
            owedPotential: owedPotential, // owedPotential = 1e+00
            startBin: 16383, // startBin
            strikeBin: 16383, // strikeBin
            tokenMix: Quad.wrap(bytes16(0x3ffe0000000000000000000000000000)), // tokenMix = 5e-01
            lockinEnd: POSITIVE_INFINITY,
            deadEra: OptInt256.wrap(OPT_INT256_NONE), // deadEra
            token: false, // token, unused for non-twap
            twapUntil: OptInt256.wrap(OPT_INT256_NONE) // twapUntil, disabled
        });
        UserPay.Info memory userPay = pool.newLoanOnly(params);
        Quad expectedToken0 = Quad.wrap(bytes16(0x3ff34627629069b8fae87e6ce6acf49e)); // expecting userPay.token0 = 3.11044547766697338743164573436492759e-04
        assertTokenAmount(userPay.token0, expectedToken0, newLoanTestEpsilon);
        Quad expectedToken1 = -Quad.wrap(bytes16(0x3ff32a751a17925e42f7e50cf70ec85a)); // expecting userPay.token1 = -2.84631184943677386502026792309843055e-04
        assertTokenAmount(userPay.token1, expectedToken1, newLoanTestEpsilon);

        console.log("testNewLoan_test_newloan_nontwap_with_whole_range_pour_immediate_below_mid_price_1_and_token_mix_0_5 testing done.");
    }

    function testNewLoan_test_newloan_nontwap_with_whole_range_pour_immediate_above_mid_price_1_and_token_mix_0_5() public {
        console.log("testNewLoan_test_newloan_nontwap_with_whole_range_pour_immediate_above_mid_price_1_and_token_mix_0_5 starting ......");
        testLimitedRangePour(
            Quad.wrap(bytes16(0x3fff0000000000000000000000000000)), // price = 1e+00
            Quad.wrap(bytes16(0x3ff847ae147ae147ae147ae147ae147b)), // quadVar = 1.00000000000000000000000000000000002e-02
            0, // startingTub
            4096, // stoppingTub
            Quad.wrap(bytes16(0x40059000000000000000000000000000)), // liquidityPerTub = 1e+02
            Quad.wrap(bytes16(0x40058ffc26f62a4e01c1cbfdd92bab65)), // expected token0 = 9.99962423766442059021199237623123453e+01
            Quad.wrap(bytes16(0x40058ffc26f62a4e01c1cbfdd92bab65)), // expected token1 = 9.99962423766442059021199237623123453e+01
            false // skip the checks
        );
        Quad[] memory owedPotential = new Quad[](1);
        owedPotential[0] = Quad.wrap(bytes16(0x3fff0000000000000000000000000000));
        // int256 midBin = 16384;
        NewLoan.NewLoanParams memory params = NewLoan.NewLoanParams({
            owedPotential: owedPotential, // owedPotential = 1e+00
            startBin: 16385, // startBin
            strikeBin: 16385, // strikeBin
            tokenMix: Quad.wrap(bytes16(0x3ffe0000000000000000000000000000)), // tokenMix = 5e-01
            lockinEnd: POSITIVE_INFINITY,
            deadEra: OptInt256.wrap(OPT_INT256_NONE), // deadEra
            token: false, // token, unused for non-twap
            twapUntil: OptInt256.wrap(OPT_INT256_NONE) // twapUntil, disabled
        });
        UserPay.Info memory userPay = pool.newLoanOnly(params);
        Quad expectedToken0 = -Quad.wrap(bytes16(0x3ff32a4599c6e9c9fc065405084de84f)); // expecting userPay.token0 = -2.84454229069594833188457709759615672e-04
        assertTokenAmount(userPay.token0, expectedToken0, newLoanTestEpsilon);
        Quad expectedToken1 = Quad.wrap(bytes16(0x3ff3465b539b0c9861af7816fcda4537)); // expecting userPay.token1 = 3.11238045188088117268002115751328524e-04
        assertTokenAmount(userPay.token1, expectedToken1, newLoanTestEpsilon);

        console.log("testNewLoan_test_newloan_nontwap_with_whole_range_pour_immediate_above_mid_price_1_and_token_mix_0_5 testing done.");
    }

    function testNewLoan_test_newloan_nontwap_with_whole_range_pour_far_below_mid_price_1_and_token_mix_0_5() public {
        console.log("testNewLoan_test_newloan_nontwap_with_whole_range_pour_far_below_mid_price_1_and_token_mix_0_5 starting ......");
        testLimitedRangePour(
            Quad.wrap(bytes16(0x3fff0000000000000000000000000000)), // price = 1e+00
            Quad.wrap(bytes16(0x3ff847ae147ae147ae147ae147ae147b)), // quadVar = 1.00000000000000000000000000000000002e-02
            0, // startingTub
            4096, // stoppingTub
            Quad.wrap(bytes16(0x40059000000000000000000000000000)), // liquidityPerTub = 1e+02
            Quad.wrap(bytes16(0x40058ffc26f62a4e01c1cbfdd92bab65)), // expected token0 = 9.99962423766442059021199237623123453e+01
            Quad.wrap(bytes16(0x40058ffc26f62a4e01c1cbfdd92bab65)), // expected token1 = 9.99962423766442059021199237623123453e+01
            false // skip the checks
        );
        Quad[] memory owedPotential = new Quad[](1);
        owedPotential[0] = Quad.wrap(bytes16(0x3fff0000000000000000000000000000));
        // int256 midBin = 16384;
        NewLoan.NewLoanParams memory params = NewLoan.NewLoanParams({
            owedPotential: owedPotential, // owedPotential = 1e+00
            startBin: 16374, // startBin
            strikeBin: 16374, // strikeBin
            tokenMix: Quad.wrap(bytes16(0x3ffe0000000000000000000000000000)), // tokenMix = 5e-01
            lockinEnd: POSITIVE_INFINITY,
            deadEra: OptInt256.wrap(OPT_INT256_NONE), // deadEra
            token: false, // token, unused for non-twap
            twapUntil: OptInt256.wrap(OPT_INT256_NONE) // twapUntil, disabled
        });
        UserPay.Info memory userPay = pool.newLoanOnly(params);
        Quad expectedToken0 = Quad.wrap(bytes16(0x3ff347fc062923f1ad3795b45e7aa6b2)); // expecting userPay.token0 = 3.12790364270108878071678734257164438e-04
        assertTokenAmount(userPay.token0, expectedToken0, newLoanTestEpsilon);
        Quad expectedToken1 = -Quad.wrap(bytes16(0x3ff32c0929cdf17485b6640755884424)); // expecting userPay.token1 = -2.86136430869600203517118063594432992e-04
        assertTokenAmount(userPay.token1, expectedToken1, newLoanTestEpsilon);

        console.log("testNewLoan_test_newloan_nontwap_with_whole_range_pour_far_below_mid_price_1_and_token_mix_0_5 testing done.");
    }

    function testNewLoan_test_newloan_nontwap_with_whole_range_pour_far_above_mid_price_1_and_token_mix_0_5() public {
        console.log("testNewLoan_test_newloan_nontwap_with_whole_range_pour_far_above_mid_price_1_and_token_mix_0_5 starting ......");
        testLimitedRangePour(
            Quad.wrap(bytes16(0x3fff0000000000000000000000000000)), // price = 1e+00
            Quad.wrap(bytes16(0x3ff847ae147ae147ae147ae147ae147b)), // quadVar = 1.00000000000000000000000000000000002e-02
            0, // startingTub
            4096, // stoppingTub
            Quad.wrap(bytes16(0x40059000000000000000000000000000)), // liquidityPerTub = 1e+02
            Quad.wrap(bytes16(0x40058ffc26f62a4e01c1cbfdd92bab65)), // expected token0 = 9.99962423766442059021199237623123453e+01
            Quad.wrap(bytes16(0x40058ffc26f62a4e01c1cbfdd92bab65)), // expected token1 = 9.99962423766442059021199237623123453e+01
            false // skip the checks
        );
        Quad[] memory owedPotential = new Quad[](1);
        owedPotential[0] = Quad.wrap(bytes16(0x3fff0000000000000000000000000000));
        // int256 midBin = 16384;
        NewLoan.NewLoanParams memory params = NewLoan.NewLoanParams({
            owedPotential: owedPotential, // owedPotential = 1e+00
            startBin: 16394, // startBin
            strikeBin: 16394, // strikeBin
            tokenMix: Quad.wrap(bytes16(0x3ffe0000000000000000000000000000)), // tokenMix = 5e-01
            lockinEnd: POSITIVE_INFINITY,
            deadEra: OptInt256.wrap(OPT_INT256_NONE), // deadEra
            token: false, // token, unused for non-twap
            twapUntil: OptInt256.wrap(OPT_INT256_NONE) // twapUntil, disabled
        });
        UserPay.Info memory userPay = pool.newLoanOnly(params);
        Quad expectedToken0 = -Quad.wrap(bytes16(0x3ff32bd9692e412ad8302157c71cf531)); // expecting userPay.token0 = -2.85958539180601292454758353998095263e-04
        assertTokenAmount(userPay.token0, expectedToken0, newLoanTestEpsilon);
        Quad expectedToken1 = Quad.wrap(bytes16(0x3ff3483041d5d48c20d1a37aa06a7364)); // expecting userPay.token1 = 3.12984947744909231154660496362868633e-04
        assertTokenAmount(userPay.token1, expectedToken1, newLoanTestEpsilon);

        console.log("testNewLoan_test_newloan_nontwap_with_whole_range_pour_far_above_mid_price_1_and_token_mix_0_5 testing done.");
    }

    function testNewLoan_test_newloan_nontwap_with_whole_range_pour_immediate_below_mid_price_1_and_token_mix_0_75() public {
        console.log("testNewLoan_test_newloan_nontwap_with_whole_range_pour_immediate_below_mid_price_1_and_token_mix_0_75 starting ......");
        testLimitedRangePour(
            Quad.wrap(bytes16(0x3fff0000000000000000000000000000)), // price = 1e+00
            Quad.wrap(bytes16(0x3ff847ae147ae147ae147ae147ae147b)), // quadVar = 1.00000000000000000000000000000000002e-02
            0, // startingTub
            4096, // stoppingTub
            Quad.wrap(bytes16(0x40059000000000000000000000000000)), // liquidityPerTub = 1e+02
            Quad.wrap(bytes16(0x40058ffc26f62a4e01c1cbfdd92bab65)), // expected token0 = 9.99962423766442059021199237623123453e+01
            Quad.wrap(bytes16(0x40058ffc26f62a4e01c1cbfdd92bab65)), // expected token1 = 9.99962423766442059021199237623123453e+01
            false // skip the checks
        );
        Quad[] memory owedPotential = new Quad[](1);
        owedPotential[0] = Quad.wrap(bytes16(0x3fff0000000000000000000000000000));
        // int256 midBin = 16384;
        NewLoan.NewLoanParams memory params = NewLoan.NewLoanParams({
            owedPotential: owedPotential, // owedPotential = 1e+00
            startBin: 16383, // startBin
            strikeBin: 16383, // strikeBin
            tokenMix: Quad.wrap(bytes16(0x3ffe8000000000000000000000000000)), // tokenMix = 7.5e-01
            lockinEnd: POSITIVE_INFINITY,
            deadEra: OptInt256.wrap(OPT_INT256_NONE), // deadEra
            token: false, // token, unused for non-twap
            twapUntil: OptInt256.wrap(OPT_INT256_NONE) // twapUntil, disabled
        });
        UserPay.Info memory userPay = pool.newLoanOnly(params);
        Quad expectedToken0 = Quad.wrap(bytes16(0x3ff24627629069b8fae87e6ce6acf49e)); // expecting userPay.token0 = 1.5552227388334866937158228671824638e-04
        assertTokenAmount(userPay.token0, expectedToken0, newLoanTestEpsilon);
        Quad expectedToken1 = -Quad.wrap(bytes16(0x3ff20ef6ba6510c2783e742fb17379c4)); // expecting userPay.token1 = -1.29205599622124150646887664464425985e-04
        assertTokenAmount(userPay.token1, expectedToken1, newLoanTestEpsilon);

        console.log("testNewLoan_test_newloan_nontwap_with_whole_range_pour_immediate_below_mid_price_1_and_token_mix_0_75 testing done.");
    }

    function testNewLoan_test_newloan_nontwap_with_whole_range_pour_immediate_above_mid_price_1_and_token_mix_0_75() public {
        console.log("testNewLoan_test_newloan_nontwap_with_whole_range_pour_immediate_above_mid_price_1_and_token_mix_0_75 starting ......");
        testLimitedRangePour(
            Quad.wrap(bytes16(0x3fff0000000000000000000000000000)), // price = 1e+00
            Quad.wrap(bytes16(0x3ff847ae147ae147ae147ae147ae147b)), // quadVar = 1.00000000000000000000000000000000002e-02
            0, // startingTub
            4096, // stoppingTub
            Quad.wrap(bytes16(0x40059000000000000000000000000000)), // liquidityPerTub = 1e+02
            Quad.wrap(bytes16(0x40058ffc26f62a4e01c1cbfdd92bab65)), // expected token0 = 9.99962423766442059021199237623123453e+01
            Quad.wrap(bytes16(0x40058ffc26f62a4e01c1cbfdd92bab65)), // expected token1 = 9.99962423766442059021199237623123453e+01
            false // skip the checks
        );
        Quad[] memory owedPotential = new Quad[](1);
        owedPotential[0] = Quad.wrap(bytes16(0x3fff0000000000000000000000000000));
        // int256 midBin = 16384;
        NewLoan.NewLoanParams memory params = NewLoan.NewLoanParams({
            owedPotential: owedPotential, // owedPotential = 1e+00
            startBin: 16385, // startBin
            strikeBin: 16385, // strikeBin
            tokenMix: Quad.wrap(bytes16(0x3ffe8000000000000000000000000000)), // tokenMix = 7.5e-01
            lockinEnd: POSITIVE_INFINITY,
            deadEra: OptInt256.wrap(OPT_INT256_NONE), // deadEra
            token: false, // token, unused for non-twap
            twapUntil: OptInt256.wrap(OPT_INT256_NONE) // twapUntil, disabled
        });
        UserPay.Info memory userPay = pool.newLoanOnly(params);
        Quad expectedToken0 = -Quad.wrap(bytes16(0x3ff3cd25666a470e9e2760f767e052b4)); // expecting userPay.token0 = -4.39783185940857879344851827877462936e-04
        assertTokenAmount(userPay.token0, expectedToken0, newLoanTestEpsilon);
        Quad expectedToken1 = Quad.wrap(bytes16(0x3ff3e988fd6892e4928734227b4767d2)); // expecting userPay.token1 = 4.66857067782132175902003173626992763e-04
        assertTokenAmount(userPay.token1, expectedToken1, newLoanTestEpsilon);

        console.log("testNewLoan_test_newloan_nontwap_with_whole_range_pour_immediate_above_mid_price_1_and_token_mix_0_75 testing done.");
    }

    function testNewLoan_test_newloan_nontwap_with_whole_range_pour_far_below_mid_price_1_and_token_mix_0_75() public {
        console.log("testNewLoan_test_newloan_nontwap_with_whole_range_pour_far_below_mid_price_1_and_token_mix_0_75 starting ......");
        testLimitedRangePour(
            Quad.wrap(bytes16(0x3fff0000000000000000000000000000)), // price = 1e+00
            Quad.wrap(bytes16(0x3ff847ae147ae147ae147ae147ae147b)), // quadVar = 1.00000000000000000000000000000000002e-02
            0, // startingTub
            4096, // stoppingTub
            Quad.wrap(bytes16(0x40059000000000000000000000000000)), // liquidityPerTub = 1e+02
            Quad.wrap(bytes16(0x40058ffc26f62a4e01c1cbfdd92bab65)), // expected token0 = 9.99962423766442059021199237623123453e+01
            Quad.wrap(bytes16(0x40058ffc26f62a4e01c1cbfdd92bab65)), // expected token1 = 9.99962423766442059021199237623123453e+01
            false // skip the checks
        );
        Quad[] memory owedPotential = new Quad[](1);
        owedPotential[0] = Quad.wrap(bytes16(0x3fff0000000000000000000000000000));
        // int256 midBin = 16384;
        NewLoan.NewLoanParams memory params = NewLoan.NewLoanParams({
            owedPotential: owedPotential, // owedPotential = 1e+00
            startBin: 16374, // startBin
            strikeBin: 16374, // strikeBin
            tokenMix: Quad.wrap(bytes16(0x3ffe8000000000000000000000000000)), // tokenMix = 7.5e-01
            lockinEnd: POSITIVE_INFINITY,
            deadEra: OptInt256.wrap(OPT_INT256_NONE), // deadEra
            token: false, // token, unused for non-twap
            twapUntil: OptInt256.wrap(OPT_INT256_NONE) // twapUntil, disabled
        });
        UserPay.Info memory userPay = pool.newLoanOnly(params);
        Quad expectedToken0 = Quad.wrap(bytes16(0x3ff247fc062923f1ad3795b45e7aa6b2)); // expecting userPay.token0 = 1.56395182135054439035839367128582219e-04
        assertTokenAmount(userPay.token0, expectedToken0, newLoanTestEpsilon);
        Quad expectedToken1 = -Quad.wrap(bytes16(0x3ff213f095a216764a7c02af9398d564)); // expecting userPay.token1 = -1.31578342066170036921634248148033959e-04
        assertTokenAmount(userPay.token1, expectedToken1, newLoanTestEpsilon);

        console.log("testNewLoan_test_newloan_nontwap_with_whole_range_pour_far_below_mid_price_1_and_token_mix_0_75 testing done.");
    }

    function testNewLoan_test_newloan_nontwap_with_whole_range_pour_far_above_mid_price_1_and_token_mix_0_75() public {
        console.log("testNewLoan_test_newloan_nontwap_with_whole_range_pour_far_above_mid_price_1_and_token_mix_0_75 starting ......");
        testLimitedRangePour(
            Quad.wrap(bytes16(0x3fff0000000000000000000000000000)), // price = 1e+00
            Quad.wrap(bytes16(0x3ff847ae147ae147ae147ae147ae147b)), // quadVar = 1.00000000000000000000000000000000002e-02
            0, // startingTub
            4096, // stoppingTub
            Quad.wrap(bytes16(0x40059000000000000000000000000000)), // liquidityPerTub = 1e+02
            Quad.wrap(bytes16(0x40058ffc26f62a4e01c1cbfdd92bab65)), // expected token0 = 9.99962423766442059021199237623123453e+01
            Quad.wrap(bytes16(0x40058ffc26f62a4e01c1cbfdd92bab65)), // expected token1 = 9.99962423766442059021199237623123453e+01
            false // skip the checks
        );
        Quad[] memory owedPotential = new Quad[](1);
        owedPotential[0] = Quad.wrap(bytes16(0x3fff0000000000000000000000000000));
        // int256 midBin = 16384;
        NewLoan.NewLoanParams memory params = NewLoan.NewLoanParams({
            owedPotential: owedPotential, // owedPotential = 1e+00
            startBin: 16394, // startBin
            strikeBin: 16394, // strikeBin
            tokenMix: Quad.wrap(bytes16(0x3ffe8000000000000000000000000000)), // tokenMix = 7.5e-01
            lockinEnd: POSITIVE_INFINITY,
            deadEra: OptInt256.wrap(OPT_INT256_NONE), // deadEra
            token: false, // token, unused for non-twap
            twapUntil: OptInt256.wrap(OPT_INT256_NONE) // twapUntil, disabled
        });
        UserPay.Info memory userPay = pool.newLoanOnly(params);
        Quad expectedToken0 = -Quad.wrap(bytes16(0x3ff3cdd07cf960d0029b440c77272610)); // expecting userPay.token0 = -4.40420538858357644101313851649294442e-04
        assertTokenAmount(userPay.token0, expectedToken0, newLoanTestEpsilon);
        Quad expectedToken1 = Quad.wrap(bytes16(0x3ff3ec4862c0bed2313a7537f09fad17)); // expecting userPay.token1 = 4.69477421617363846731990744544302996e-04
        assertTokenAmount(userPay.token1, expectedToken1, newLoanTestEpsilon);

        console.log("testNewLoan_test_newloan_nontwap_with_whole_range_pour_far_above_mid_price_1_and_token_mix_0_75 testing done.");
    }

    function testNewLoan_test_newloan_nontwap_with_whole_range_pour_immediate_below_mid_price_1_and_token_mix_1() public {
        console.log("testNewLoan_test_newloan_nontwap_with_whole_range_pour_immediate_below_mid_price_1_and_token_mix_1 starting ......");
        testLimitedRangePour(
            Quad.wrap(bytes16(0x3fff0000000000000000000000000000)), // price = 1e+00
            Quad.wrap(bytes16(0x3ff847ae147ae147ae147ae147ae147b)), // quadVar = 1.00000000000000000000000000000000002e-02
            0, // startingTub
            4096, // stoppingTub
            Quad.wrap(bytes16(0x40059000000000000000000000000000)), // liquidityPerTub = 1e+02
            Quad.wrap(bytes16(0x40058ffc26f62a4e01c1cbfdd92bab65)), // expected token0 = 9.99962423766442059021199237623123453e+01
            Quad.wrap(bytes16(0x40058ffc26f62a4e01c1cbfdd92bab65)), // expected token1 = 9.99962423766442059021199237623123453e+01
            false // skip the checks
        );
        Quad[] memory owedPotential = new Quad[](1);
        owedPotential[0] = Quad.wrap(bytes16(0x3fff0000000000000000000000000000));
        // int256 midBin = 16384;
        NewLoan.NewLoanParams memory params = NewLoan.NewLoanParams({
            owedPotential: owedPotential, // owedPotential = 1e+00
            startBin: 16383, // startBin
            strikeBin: 16383, // strikeBin
            tokenMix: Quad.wrap(bytes16(0x3fff0000000000000000000000000000)), // tokenMix = 1e+00
            lockinEnd: POSITIVE_INFINITY,
            deadEra: OptInt256.wrap(OPT_INT256_NONE), // deadEra
            token: false, // token, unused for non-twap
            twapUntil: OptInt256.wrap(OPT_INT256_NONE) // twapUntil, disabled
        });
        UserPay.Info memory userPay = pool.newLoanOnly(params);
        Quad expectedToken0 = POSITIVE_ZERO; // expecting userPay.token0 = 0e+00
        assertTokenAmount(userPay.token0, expectedToken0, newLoanTestEpsilon);
        Quad expectedToken1 = Quad.wrap(bytes16(0x3fefb7e5fb2819bcab970dd459b4e940)); // expecting userPay.token1 = 2.62199856994290852082514633809909902e-05
        assertTokenAmount(userPay.token1, expectedToken1, newLoanTestEpsilon);

        console.log("testNewLoan_test_newloan_nontwap_with_whole_range_pour_immediate_below_mid_price_1_and_token_mix_1 testing done.");
    }

    function testNewLoan_test_newloan_nontwap_with_whole_range_pour_immediate_above_mid_price_1_and_token_mix_1() public {
        console.log("testNewLoan_test_newloan_nontwap_with_whole_range_pour_immediate_above_mid_price_1_and_token_mix_1 starting ......");
        testLimitedRangePour(
            Quad.wrap(bytes16(0x3fff0000000000000000000000000000)), // price = 1e+00
            Quad.wrap(bytes16(0x3ff847ae147ae147ae147ae147ae147b)), // quadVar = 1.00000000000000000000000000000000002e-02
            0, // startingTub
            4096, // stoppingTub
            Quad.wrap(bytes16(0x40059000000000000000000000000000)), // liquidityPerTub = 1e+02
            Quad.wrap(bytes16(0x40058ffc26f62a4e01c1cbfdd92bab65)), // expected token0 = 9.99962423766442059021199237623123453e+01
            Quad.wrap(bytes16(0x40058ffc26f62a4e01c1cbfdd92bab65)), // expected token1 = 9.99962423766442059021199237623123453e+01
            false // skip the checks
        );
        Quad[] memory owedPotential = new Quad[](1);
        owedPotential[0] = Quad.wrap(bytes16(0x3fff0000000000000000000000000000));
        // int256 midBin = 16384;
        NewLoan.NewLoanParams memory params = NewLoan.NewLoanParams({
            owedPotential: owedPotential, // owedPotential = 1e+00
            startBin: 16385, // startBin
            strikeBin: 16385, // strikeBin
            tokenMix: Quad.wrap(bytes16(0x3fff0000000000000000000000000000)), // tokenMix = 1e+00
            lockinEnd: POSITIVE_INFINITY,
            deadEra: OptInt256.wrap(OPT_INT256_NONE), // deadEra
            token: false, // token, unused for non-twap
            twapUntil: OptInt256.wrap(OPT_INT256_NONE) // twapUntil, disabled
        });
        UserPay.Info memory userPay = pool.newLoanOnly(params);
        Quad expectedToken0 = -Quad.wrap(bytes16(0x3ff438029986d229a02436f4e3b95e8d)); // expecting userPay.token0 = -5.95112142812120925501245945995310247e-04
        assertTokenAmount(userPay.token0, expectedToken0, newLoanTestEpsilon);
        Quad expectedToken1 = Quad.wrap(bytes16(0x3ff4465b539b0c9861af7816fcda4537)); // expecting userPay.token1 = 6.22476090376176234536004231502657049e-04
        assertTokenAmount(userPay.token1, expectedToken1, newLoanTestEpsilon);

        console.log("testNewLoan_test_newloan_nontwap_with_whole_range_pour_immediate_above_mid_price_1_and_token_mix_1 testing done.");
    }

    function testNewLoan_test_newloan_nontwap_with_whole_range_pour_far_below_mid_price_1_and_token_mix_1() public {
        console.log("testNewLoan_test_newloan_nontwap_with_whole_range_pour_far_below_mid_price_1_and_token_mix_1 starting ......");
        testLimitedRangePour(
            Quad.wrap(bytes16(0x3fff0000000000000000000000000000)), // price = 1e+00
            Quad.wrap(bytes16(0x3ff847ae147ae147ae147ae147ae147b)), // quadVar = 1.00000000000000000000000000000000002e-02
            0, // startingTub
            4096, // stoppingTub
            Quad.wrap(bytes16(0x40059000000000000000000000000000)), // liquidityPerTub = 1e+02
            Quad.wrap(bytes16(0x40058ffc26f62a4e01c1cbfdd92bab65)), // expected token0 = 9.99962423766442059021199237623123453e+01
            Quad.wrap(bytes16(0x40058ffc26f62a4e01c1cbfdd92bab65)), // expected token1 = 9.99962423766442059021199237623123453e+01
            false // skip the checks
        );
        Quad[] memory owedPotential = new Quad[](1);
        owedPotential[0] = Quad.wrap(bytes16(0x3fff0000000000000000000000000000));
        // int256 midBin = 16384;
        NewLoan.NewLoanParams memory params = NewLoan.NewLoanParams({
            owedPotential: owedPotential, // owedPotential = 1e+00
            startBin: 16374, // startBin
            strikeBin: 16374, // strikeBin
            tokenMix: Quad.wrap(bytes16(0x3fff0000000000000000000000000000)), // tokenMix = 1e+00
            lockinEnd: POSITIVE_INFINITY,
            deadEra: OptInt256.wrap(OPT_INT256_NONE), // deadEra
            token: false, // token, unused for non-twap
            twapUntil: OptInt256.wrap(OPT_INT256_NONE) // twapUntil, disabled
        });
        UserPay.Info memory userPay = pool.newLoanOnly(params);
        Quad expectedToken0 = POSITIVE_ZERO; // expecting userPay.token0 = 0e+00
        assertTokenAmount(userPay.token0, expectedToken0, newLoanTestEpsilon);
        Quad expectedToken1 = Quad.wrap(bytes16(0x3fef818942bdafe3b3a6157c1ef6ec00)); // expecting userPay.token1 = 2.29797467372601296738495672983650737e-05
        assertTokenAmount(userPay.token1, expectedToken1, newLoanTestEpsilon);

        console.log("testNewLoan_test_newloan_nontwap_with_whole_range_pour_far_below_mid_price_1_and_token_mix_1 testing done.");
    }

    function testNewLoan_test_newloan_nontwap_with_whole_range_pour_far_above_mid_price_1_and_token_mix_1() public {
        console.log("testNewLoan_test_newloan_nontwap_with_whole_range_pour_far_above_mid_price_1_and_token_mix_1 starting ......");
        testLimitedRangePour(
            Quad.wrap(bytes16(0x3fff0000000000000000000000000000)), // price = 1e+00
            Quad.wrap(bytes16(0x3ff847ae147ae147ae147ae147ae147b)), // quadVar = 1.00000000000000000000000000000000002e-02
            0, // startingTub
            4096, // stoppingTub
            Quad.wrap(bytes16(0x40059000000000000000000000000000)), // liquidityPerTub = 1e+02
            Quad.wrap(bytes16(0x40058ffc26f62a4e01c1cbfdd92bab65)), // expected token0 = 9.99962423766442059021199237623123453e+01
            Quad.wrap(bytes16(0x40058ffc26f62a4e01c1cbfdd92bab65)), // expected token1 = 9.99962423766442059021199237623123453e+01
            false // skip the checks
        );
        Quad[] memory owedPotential = new Quad[](1);
        owedPotential[0] = Quad.wrap(bytes16(0x3fff0000000000000000000000000000));
        // int256 midBin = 16384;
        NewLoan.NewLoanParams memory params = NewLoan.NewLoanParams({
            owedPotential: owedPotential, // owedPotential = 1e+00
            startBin: 16394, // startBin
            strikeBin: 16394, // strikeBin
            tokenMix: Quad.wrap(bytes16(0x3fff0000000000000000000000000000)), // tokenMix = 1e+00
            lockinEnd: POSITIVE_INFINITY,
            deadEra: OptInt256.wrap(OPT_INT256_NONE), // deadEra
            token: false, // token, unused for non-twap
            twapUntil: OptInt256.wrap(OPT_INT256_NONE) // twapUntil, disabled
        });
        UserPay.Info memory userPay = pool.newLoanOnly(params);
        Quad expectedToken0 = -Quad.wrap(bytes16(0x3ff437e3c862403a968333609398ab77)); // expecting userPay.token0 = -5.94882538536113995747869349300493573e-04
        assertTokenAmount(userPay.token0, expectedToken0, newLoanTestEpsilon);
        Quad expectedToken1 = Quad.wrap(bytes16(0x3ff4483041d5d48c20d1a37aa06a7364)); // expecting userPay.token1 = 6.25969895489818462309320992725737265e-04
        assertTokenAmount(userPay.token1, expectedToken1, newLoanTestEpsilon);

        console.log("testNewLoan_test_newloan_nontwap_with_whole_range_pour_far_above_mid_price_1_and_token_mix_1 testing done.");
    }

    function testNewLoan_test_newloan_nontwap_with_whole_range_pour_immediate_below_mid_price_1_00999999989999999999999999999999994_and_token_mix_0()
        public
    {
        console.log(
            "testNewLoan_test_newloan_nontwap_with_whole_range_pour_immediate_below_mid_price_1_00999999989999999999999999999999994_and_token_mix_0 starting ......"
        );
        testLimitedRangePour(
            Quad.wrap(bytes16(0x3fff028f5c2887cf0ff4c9fed7b0016f)), // price = 1.00999999989999999999999999999999994e+00
            Quad.wrap(bytes16(0x3ff847ae147ae147ae147ae147ae147b)), // quadVar = 1.00000000000000000000000000000000002e-02
            0, // startingTub
            4096, // stoppingTub
            Quad.wrap(bytes16(0x40059000000000000000000000000000)), // liquidityPerTub = 1e+02
            Quad.wrap(bytes16(0x40058dfff5e1c536319aca31783c6db9)), // expected token0 = 9.94999614025705781769272952999967145e+01
            Quad.wrap(bytes16(0x400591fae0e8942279715b8bb23141c6)), // expected token1 = 1.00494998582879469355691460864723265e+02
            false // skip the checks
        );
        Quad[] memory owedPotential = new Quad[](1);
        owedPotential[0] = Quad.wrap(bytes16(0x3fff0000000000000000000000000000));
        // int256 midBin = 16391;
        NewLoan.NewLoanParams memory params = NewLoan.NewLoanParams({
            owedPotential: owedPotential, // owedPotential = 1e+00
            startBin: 16390, // startBin
            strikeBin: 16390, // strikeBin
            tokenMix: POSITIVE_ZERO, // tokenMix = 0e+00
            lockinEnd: POSITIVE_INFINITY,
            deadEra: OptInt256.wrap(OPT_INT256_NONE), // deadEra
            token: false, // token, unused for non-twap
            twapUntil: OptInt256.wrap(OPT_INT256_NONE) // twapUntil, disabled
        });
        UserPay.Info memory userPay = pool.newLoanOnly(params);
        Quad expectedToken0 = Quad.wrap(bytes16(0x3ff444bcb274c5ce5552ea668b2adccf)); // expecting userPay.token0 = 6.19386859940809659547878681697355355e-04
        assertTokenAmount(userPay.token0, expectedToken0, newLoanTestEpsilon);
        Quad expectedToken1 = -Quad.wrap(bytes16(0x3ff43990faaf84cc75e0f5127b8694db)); // expecting userPay.token1 = -5.98080301588054774025425190781571017e-04
        assertTokenAmount(userPay.token1, expectedToken1, newLoanTestEpsilon);

        console.log(
            "testNewLoan_test_newloan_nontwap_with_whole_range_pour_immediate_below_mid_price_1_00999999989999999999999999999999994_and_token_mix_0 testing done."
        );
    }

    function testNewLoan_test_newloan_nontwap_with_whole_range_pour_immediate_above_mid_price_1_00999999989999999999999999999999994_and_token_mix_0()
        public
    {
        console.log(
            "testNewLoan_test_newloan_nontwap_with_whole_range_pour_immediate_above_mid_price_1_00999999989999999999999999999999994_and_token_mix_0 starting ......"
        );
        testLimitedRangePour(
            Quad.wrap(bytes16(0x3fff028f5c2887cf0ff4c9fed7b0016f)), // price = 1.00999999989999999999999999999999994e+00
            Quad.wrap(bytes16(0x3ff847ae147ae147ae147ae147ae147b)), // quadVar = 1.00000000000000000000000000000000002e-02
            0, // startingTub
            4096, // stoppingTub
            Quad.wrap(bytes16(0x40059000000000000000000000000000)), // liquidityPerTub = 1e+02
            Quad.wrap(bytes16(0x40058dfff5e1c536319aca31783c6db9)), // expected token0 = 9.94999614025705781769272952999967145e+01
            Quad.wrap(bytes16(0x400591fae0e8942279715b8bb23141c6)), // expected token1 = 1.00494998582879469355691460864723265e+02
            false // skip the checks
        );
        Quad[] memory owedPotential = new Quad[](1);
        owedPotential[0] = Quad.wrap(bytes16(0x3fff0000000000000000000000000000));
        // int256 midBin = 16391;
        NewLoan.NewLoanParams memory params = NewLoan.NewLoanParams({
            owedPotential: owedPotential, // owedPotential = 1e+00
            startBin: 16392, // startBin
            strikeBin: 16392, // strikeBin
            tokenMix: POSITIVE_ZERO, // tokenMix = 0e+00
            lockinEnd: POSITIVE_INFINITY,
            deadEra: OptInt256.wrap(OPT_INT256_NONE), // deadEra
            token: false, // token, unused for non-twap
            twapUntil: OptInt256.wrap(OPT_INT256_NONE) // twapUntil, disabled
        });
        UserPay.Info memory userPay = pool.newLoanOnly(params);
        Quad expectedToken0 = Quad.wrap(bytes16(0x3fefb5b7196c90e8f85dfe3f8f059440)); // expecting userPay.token0 = 2.60898608977060136840680528419620427e-05
        assertTokenAmount(userPay.token0, expectedToken0, newLoanTestEpsilon);
        Quad expectedToken1 = POSITIVE_ZERO; // expecting userPay.token1 = 0e+00
        assertTokenAmount(userPay.token1, expectedToken1, newLoanTestEpsilon);

        console.log(
            "testNewLoan_test_newloan_nontwap_with_whole_range_pour_immediate_above_mid_price_1_00999999989999999999999999999999994_and_token_mix_0 testing done."
        );
    }

    function testNewLoan_test_newloan_nontwap_with_whole_range_pour_far_below_mid_price_1_00999999989999999999999999999999994_and_token_mix_0()
        public
    {
        console.log(
            "testNewLoan_test_newloan_nontwap_with_whole_range_pour_far_below_mid_price_1_00999999989999999999999999999999994_and_token_mix_0 starting ......"
        );
        testLimitedRangePour(
            Quad.wrap(bytes16(0x3fff028f5c2887cf0ff4c9fed7b0016f)), // price = 1.00999999989999999999999999999999994e+00
            Quad.wrap(bytes16(0x3ff847ae147ae147ae147ae147ae147b)), // quadVar = 1.00000000000000000000000000000000002e-02
            0, // startingTub
            4096, // stoppingTub
            Quad.wrap(bytes16(0x40059000000000000000000000000000)), // liquidityPerTub = 1e+02
            Quad.wrap(bytes16(0x40058dfff5e1c536319aca31783c6db9)), // expected token0 = 9.94999614025705781769272952999967145e+01
            Quad.wrap(bytes16(0x400591fae0e8942279715b8bb23141c6)), // expected token1 = 1.00494998582879469355691460864723265e+02
            false // skip the checks
        );
        Quad[] memory owedPotential = new Quad[](1);
        owedPotential[0] = Quad.wrap(bytes16(0x3fff0000000000000000000000000000));
        // int256 midBin = 16391;
        NewLoan.NewLoanParams memory params = NewLoan.NewLoanParams({
            owedPotential: owedPotential, // owedPotential = 1e+00
            startBin: 16381, // startBin
            strikeBin: 16381, // strikeBin
            tokenMix: POSITIVE_ZERO, // tokenMix = 0e+00
            lockinEnd: POSITIVE_INFINITY,
            deadEra: OptInt256.wrap(OPT_INT256_NONE), // deadEra
            token: false, // token, unused for non-twap
            twapUntil: OptInt256.wrap(OPT_INT256_NONE) // twapUntil, disabled
        });
        UserPay.Info memory userPay = pool.newLoanOnly(params);
        Quad expectedToken0 = Quad.wrap(bytes16(0x3ff4468f4ceb4da03bc386575b80cf83)); // expecting userPay.token0 = 6.22863325964229513652776393717045652e-04
        assertTokenAmount(userPay.token0, expectedToken0, newLoanTestEpsilon);
        Quad expectedToken1 = -Quad.wrap(bytes16(0x3ff439720231f7352d0520384d52dcab)); // expecting userPay.token1 = -5.97849552146460058477576292983921808e-04
        assertTokenAmount(userPay.token1, expectedToken1, newLoanTestEpsilon);

        console.log(
            "testNewLoan_test_newloan_nontwap_with_whole_range_pour_far_below_mid_price_1_00999999989999999999999999999999994_and_token_mix_0 testing done."
        );
    }

    function testNewLoan_test_newloan_nontwap_with_whole_range_pour_far_above_mid_price_1_00999999989999999999999999999999994_and_token_mix_0()
        public
    {
        console.log(
            "testNewLoan_test_newloan_nontwap_with_whole_range_pour_far_above_mid_price_1_00999999989999999999999999999999994_and_token_mix_0 starting ......"
        );
        testLimitedRangePour(
            Quad.wrap(bytes16(0x3fff028f5c2887cf0ff4c9fed7b0016f)), // price = 1.00999999989999999999999999999999994e+00
            Quad.wrap(bytes16(0x3ff847ae147ae147ae147ae147ae147b)), // quadVar = 1.00000000000000000000000000000000002e-02
            0, // startingTub
            4096, // stoppingTub
            Quad.wrap(bytes16(0x40059000000000000000000000000000)), // liquidityPerTub = 1e+02
            Quad.wrap(bytes16(0x40058dfff5e1c536319aca31783c6db9)), // expected token0 = 9.94999614025705781769272952999967145e+01
            Quad.wrap(bytes16(0x400591fae0e8942279715b8bb23141c6)), // expected token1 = 1.00494998582879469355691460864723265e+02
            false // skip the checks
        );
        Quad[] memory owedPotential = new Quad[](1);
        owedPotential[0] = Quad.wrap(bytes16(0x3fff0000000000000000000000000000));
        // int256 midBin = 16391;
        NewLoan.NewLoanParams memory params = NewLoan.NewLoanParams({
            owedPotential: owedPotential, // owedPotential = 1e+00
            startBin: 16401, // startBin
            strikeBin: 16401, // strikeBin
            tokenMix: POSITIVE_ZERO, // tokenMix = 0e+00
            lockinEnd: POSITIVE_INFINITY,
            deadEra: OptInt256.wrap(OPT_INT256_NONE), // deadEra
            token: false, // token, unused for non-twap
            twapUntil: OptInt256.wrap(OPT_INT256_NONE) // twapUntil, disabled
        });
        UserPay.Info memory userPay = pool.newLoanOnly(params);
        Quad expectedToken0 = Quad.wrap(bytes16(0x3fef7f9f71e9e53d0bddd8b6287d0d40)); // expecting userPay.token0 = 2.28657026251804848848670391993392274e-05
        assertTokenAmount(userPay.token0, expectedToken0, newLoanTestEpsilon);
        Quad expectedToken1 = POSITIVE_ZERO; // expecting userPay.token1 = 0e+00
        assertTokenAmount(userPay.token1, expectedToken1, newLoanTestEpsilon);

        console.log(
            "testNewLoan_test_newloan_nontwap_with_whole_range_pour_far_above_mid_price_1_00999999989999999999999999999999994_and_token_mix_0 testing done."
        );
    }

    function testNewLoan_test_newloan_nontwap_with_whole_range_pour_immediate_below_mid_price_1_00999999989999999999999999999999994_and_token_mix_0_25(
    ) public {
        console.log(
            "testNewLoan_test_newloan_nontwap_with_whole_range_pour_immediate_below_mid_price_1_00999999989999999999999999999999994_and_token_mix_0_25 starting ......"
        );
        testLimitedRangePour(
            Quad.wrap(bytes16(0x3fff028f5c2887cf0ff4c9fed7b0016f)), // price = 1.00999999989999999999999999999999994e+00
            Quad.wrap(bytes16(0x3ff847ae147ae147ae147ae147ae147b)), // quadVar = 1.00000000000000000000000000000000002e-02
            0, // startingTub
            4096, // stoppingTub
            Quad.wrap(bytes16(0x40059000000000000000000000000000)), // liquidityPerTub = 1e+02
            Quad.wrap(bytes16(0x40058dfff5e1c536319aca31783c6db9)), // expected token0 = 9.94999614025705781769272952999967145e+01
            Quad.wrap(bytes16(0x400591fae0e8942279715b8bb23141c6)), // expected token1 = 1.00494998582879469355691460864723265e+02
            false // skip the checks
        );
        Quad[] memory owedPotential = new Quad[](1);
        owedPotential[0] = Quad.wrap(bytes16(0x3fff0000000000000000000000000000));
        // int256 midBin = 16391;
        NewLoan.NewLoanParams memory params = NewLoan.NewLoanParams({
            owedPotential: owedPotential, // owedPotential = 1e+00
            startBin: 16390, // startBin
            strikeBin: 16390, // strikeBin
            tokenMix: Quad.wrap(bytes16(0x3ffd0000000000000000000000000000)), // tokenMix = 2.5e-01
            lockinEnd: POSITIVE_INFINITY,
            deadEra: OptInt256.wrap(OPT_INT256_NONE), // deadEra
            token: false, // token, unused for non-twap
            twapUntil: OptInt256.wrap(OPT_INT256_NONE) // twapUntil, disabled
        });
        UserPay.Info memory userPay = pool.newLoanOnly(params);
        Quad expectedToken0 = Quad.wrap(bytes16(0x3ff3e71b0baf28b57ffc5f99d0c04b36)); // expecting userPay.token0 = 4.64540144955607244660909011273016492e-04
        assertTokenAmount(userPay.token0, expectedToken0, newLoanTestEpsilon);
        Quad expectedToken1 = -Quad.wrap(bytes16(0x3ff3cf7232df9bf3734853459570b70d)); // expecting userPay.token1 = -4.4197663189659030576398653718070799e-04
        assertTokenAmount(userPay.token1, expectedToken1, newLoanTestEpsilon);

        console.log(
            "testNewLoan_test_newloan_nontwap_with_whole_range_pour_immediate_below_mid_price_1_00999999989999999999999999999999994_and_token_mix_0_25 testing done."
        );
    }

    function testNewLoan_test_newloan_nontwap_with_whole_range_pour_immediate_above_mid_price_1_00999999989999999999999999999999994_and_token_mix_0_25(
    ) public {
        console.log(
            "testNewLoan_test_newloan_nontwap_with_whole_range_pour_immediate_above_mid_price_1_00999999989999999999999999999999994_and_token_mix_0_25 starting ......"
        );
        testLimitedRangePour(
            Quad.wrap(bytes16(0x3fff028f5c2887cf0ff4c9fed7b0016f)), // price = 1.00999999989999999999999999999999994e+00
            Quad.wrap(bytes16(0x3ff847ae147ae147ae147ae147ae147b)), // quadVar = 1.00000000000000000000000000000000002e-02
            0, // startingTub
            4096, // stoppingTub
            Quad.wrap(bytes16(0x40059000000000000000000000000000)), // liquidityPerTub = 1e+02
            Quad.wrap(bytes16(0x40058dfff5e1c536319aca31783c6db9)), // expected token0 = 9.94999614025705781769272952999967145e+01
            Quad.wrap(bytes16(0x400591fae0e8942279715b8bb23141c6)), // expected token1 = 1.00494998582879469355691460864723265e+02
            false // skip the checks
        );
        Quad[] memory owedPotential = new Quad[](1);
        owedPotential[0] = Quad.wrap(bytes16(0x3fff0000000000000000000000000000));
        // int256 midBin = 16391;
        NewLoan.NewLoanParams memory params = NewLoan.NewLoanParams({
            owedPotential: owedPotential, // owedPotential = 1e+00
            startBin: 16392, // startBin
            strikeBin: 16392, // strikeBin
            tokenMix: Quad.wrap(bytes16(0x3ffd0000000000000000000000000000)), // tokenMix = 2.5e-01
            lockinEnd: POSITIVE_INFINITY,
            deadEra: OptInt256.wrap(OPT_INT256_NONE), // deadEra
            token: false, // token, unused for non-twap
            twapUntil: OptInt256.wrap(OPT_INT256_NONE) // twapUntil, disabled
        });
        UserPay.Info memory userPay = pool.newLoanOnly(params);
        Quad expectedToken0 = -Quad.wrap(bytes16(0x3ff20d9e7966f5cf80ff1f9f45a63a8c)); // expecting userPay.token0 = -1.28564376807395248878579055415948459e-04
        assertTokenAmount(userPay.token0, expectedToken0, newLoanTestEpsilon);
        Quad expectedToken1 = Quad.wrap(bytes16(0x3ff247c7d2cca14e8b8d999fa2b40543)); // expecting userPay.token1 = 1.56297950884155191987512676044481128e-04
        assertTokenAmount(userPay.token1, expectedToken1, newLoanTestEpsilon);

        console.log(
            "testNewLoan_test_newloan_nontwap_with_whole_range_pour_immediate_above_mid_price_1_00999999989999999999999999999999994_and_token_mix_0_25 testing done."
        );
    }

    function testNewLoan_test_newloan_nontwap_with_whole_range_pour_far_below_mid_price_1_00999999989999999999999999999999994_and_token_mix_0_25()
        public
    {
        console.log(
            "testNewLoan_test_newloan_nontwap_with_whole_range_pour_far_below_mid_price_1_00999999989999999999999999999999994_and_token_mix_0_25 starting ......"
        );
        testLimitedRangePour(
            Quad.wrap(bytes16(0x3fff028f5c2887cf0ff4c9fed7b0016f)), // price = 1.00999999989999999999999999999999994e+00
            Quad.wrap(bytes16(0x3ff847ae147ae147ae147ae147ae147b)), // quadVar = 1.00000000000000000000000000000000002e-02
            0, // startingTub
            4096, // stoppingTub
            Quad.wrap(bytes16(0x40059000000000000000000000000000)), // liquidityPerTub = 1e+02
            Quad.wrap(bytes16(0x40058dfff5e1c536319aca31783c6db9)), // expected token0 = 9.94999614025705781769272952999967145e+01
            Quad.wrap(bytes16(0x400591fae0e8942279715b8bb23141c6)), // expected token1 = 1.00494998582879469355691460864723265e+02
            false // skip the checks
        );
        Quad[] memory owedPotential = new Quad[](1);
        owedPotential[0] = Quad.wrap(bytes16(0x3fff0000000000000000000000000000));
        // int256 midBin = 16391;
        NewLoan.NewLoanParams memory params = NewLoan.NewLoanParams({
            owedPotential: owedPotential, // owedPotential = 1e+00
            startBin: 16381, // startBin
            strikeBin: 16381, // strikeBin
            tokenMix: Quad.wrap(bytes16(0x3ffd0000000000000000000000000000)), // tokenMix = 2.5e-01
            lockinEnd: POSITIVE_INFINITY,
            deadEra: OptInt256.wrap(OPT_INT256_NONE), // deadEra
            token: false, // token, unused for non-twap
            twapUntil: OptInt256.wrap(OPT_INT256_NONE) // twapUntil, disabled
        });
        UserPay.Info memory userPay = pool.newLoanOnly(params);
        Quad expectedToken0 = Quad.wrap(bytes16(0x3ff3e9d6f360f47059a5498309413744)); // expecting userPay.token0 = 4.67147494473172135239582295287784216e-04
        assertTokenAmount(userPay.token0, expectedToken0, newLoanTestEpsilon);
        Quad expectedToken1 = -Quad.wrap(bytes16(0x3ff3d01e23e1680567eae0dfb60e1d54)); // expecting userPay.token1 = -4.42617163651353421750548965014212946e-04
        assertTokenAmount(userPay.token1, expectedToken1, newLoanTestEpsilon);

        console.log(
            "testNewLoan_test_newloan_nontwap_with_whole_range_pour_far_below_mid_price_1_00999999989999999999999999999999994_and_token_mix_0_25 testing done."
        );
    }

    function testNewLoan_test_newloan_nontwap_with_whole_range_pour_far_above_mid_price_1_00999999989999999999999999999999994_and_token_mix_0_25()
        public
    {
        console.log(
            "testNewLoan_test_newloan_nontwap_with_whole_range_pour_far_above_mid_price_1_00999999989999999999999999999999994_and_token_mix_0_25 starting ......"
        );
        testLimitedRangePour(
            Quad.wrap(bytes16(0x3fff028f5c2887cf0ff4c9fed7b0016f)), // price = 1.00999999989999999999999999999999994e+00
            Quad.wrap(bytes16(0x3ff847ae147ae147ae147ae147ae147b)), // quadVar = 1.00000000000000000000000000000000002e-02
            0, // startingTub
            4096, // stoppingTub
            Quad.wrap(bytes16(0x40059000000000000000000000000000)), // liquidityPerTub = 1e+02
            Quad.wrap(bytes16(0x40058dfff5e1c536319aca31783c6db9)), // expected token0 = 9.94999614025705781769272952999967145e+01
            Quad.wrap(bytes16(0x400591fae0e8942279715b8bb23141c6)), // expected token1 = 1.00494998582879469355691460864723265e+02
            false // skip the checks
        );
        Quad[] memory owedPotential = new Quad[](1);
        owedPotential[0] = Quad.wrap(bytes16(0x3fff0000000000000000000000000000));
        // int256 midBin = 16391;
        NewLoan.NewLoanParams memory params = NewLoan.NewLoanParams({
            owedPotential: owedPotential, // owedPotential = 1e+00
            startBin: 16401, // startBin
            strikeBin: 16401, // strikeBin
            tokenMix: Quad.wrap(bytes16(0x3ffd0000000000000000000000000000)), // tokenMix = 2.5e-01
            lockinEnd: POSITIVE_INFINITY,
            deadEra: OptInt256.wrap(OPT_INT256_NONE), // deadEra
            token: false, // token, unused for non-twap
            twapUntil: OptInt256.wrap(OPT_INT256_NONE) // twapUntil, disabled
        });
        UserPay.Info memory userPay = pool.newLoanOnly(params);
        Quad expectedToken0 = -Quad.wrap(bytes16(0x3ff21292023b7c08d4cac900f0961a36)); // expecting userPay.token0 = -1.30925343782010649923443968838133292e-04
        assertTokenAmount(userPay.token0, expectedToken0, newLoanTestEpsilon);
        Quad expectedToken1 = Quad.wrap(bytes16(0x3ff2499eccc2ffebd34d62402d760d96)); // expecting userPay.token1 = 1.57175212819984499220341068454420898e-04
        assertTokenAmount(userPay.token1, expectedToken1, newLoanTestEpsilon);

        console.log(
            "testNewLoan_test_newloan_nontwap_with_whole_range_pour_far_above_mid_price_1_00999999989999999999999999999999994_and_token_mix_0_25 testing done."
        );
    }

    function testNewLoan_test_newloan_nontwap_with_whole_range_pour_immediate_below_mid_price_1_00999999989999999999999999999999994_and_token_mix_0_5(
    ) public {
        console.log(
            "testNewLoan_test_newloan_nontwap_with_whole_range_pour_immediate_below_mid_price_1_00999999989999999999999999999999994_and_token_mix_0_5 starting ......"
        );
        testLimitedRangePour(
            Quad.wrap(bytes16(0x3fff028f5c2887cf0ff4c9fed7b0016f)), // price = 1.00999999989999999999999999999999994e+00
            Quad.wrap(bytes16(0x3ff847ae147ae147ae147ae147ae147b)), // quadVar = 1.00000000000000000000000000000000002e-02
            0, // startingTub
            4096, // stoppingTub
            Quad.wrap(bytes16(0x40059000000000000000000000000000)), // liquidityPerTub = 1e+02
            Quad.wrap(bytes16(0x40058dfff5e1c536319aca31783c6db9)), // expected token0 = 9.94999614025705781769272952999967145e+01
            Quad.wrap(bytes16(0x400591fae0e8942279715b8bb23141c6)), // expected token1 = 1.00494998582879469355691460864723265e+02
            false // skip the checks
        );
        Quad[] memory owedPotential = new Quad[](1);
        owedPotential[0] = Quad.wrap(bytes16(0x3fff0000000000000000000000000000));
        // int256 midBin = 16391;
        NewLoan.NewLoanParams memory params = NewLoan.NewLoanParams({
            owedPotential: owedPotential, // owedPotential = 1e+00
            startBin: 16390, // startBin
            strikeBin: 16390, // strikeBin
            tokenMix: Quad.wrap(bytes16(0x3ffe0000000000000000000000000000)), // tokenMix = 5e-01
            lockinEnd: POSITIVE_INFINITY,
            deadEra: OptInt256.wrap(OPT_INT256_NONE), // deadEra
            token: false, // token, unused for non-twap
            twapUntil: OptInt256.wrap(OPT_INT256_NONE) // twapUntil, disabled
        });
        UserPay.Info memory userPay = pool.newLoanOnly(params);
        Quad expectedToken0 = Quad.wrap(bytes16(0x3ff344bcb274c5ce5552ea668b2adccf)); // expecting userPay.token0 = 3.09693429970404829773939340848677677e-04
        assertTokenAmount(userPay.token0, expectedToken0, newLoanTestEpsilon);
        Quad expectedToken1 = -Quad.wrap(bytes16(0x3ff32bc270602e4dfacebc6633d44464)); // expecting userPay.token1 = -2.85872962205125837502547883579844962e-04
        assertTokenAmount(userPay.token1, expectedToken1, newLoanTestEpsilon);

        console.log(
            "testNewLoan_test_newloan_nontwap_with_whole_range_pour_immediate_below_mid_price_1_00999999989999999999999999999999994_and_token_mix_0_5 testing done."
        );
    }

    function testNewLoan_test_newloan_nontwap_with_whole_range_pour_immediate_above_mid_price_1_00999999989999999999999999999999994_and_token_mix_0_5(
    ) public {
        console.log(
            "testNewLoan_test_newloan_nontwap_with_whole_range_pour_immediate_above_mid_price_1_00999999989999999999999999999999994_and_token_mix_0_5 starting ......"
        );
        testLimitedRangePour(
            Quad.wrap(bytes16(0x3fff028f5c2887cf0ff4c9fed7b0016f)), // price = 1.00999999989999999999999999999999994e+00
            Quad.wrap(bytes16(0x3ff847ae147ae147ae147ae147ae147b)), // quadVar = 1.00000000000000000000000000000000002e-02
            0, // startingTub
            4096, // stoppingTub
            Quad.wrap(bytes16(0x40059000000000000000000000000000)), // liquidityPerTub = 1e+02
            Quad.wrap(bytes16(0x40058dfff5e1c536319aca31783c6db9)), // expected token0 = 9.94999614025705781769272952999967145e+01
            Quad.wrap(bytes16(0x400591fae0e8942279715b8bb23141c6)), // expected token1 = 1.00494998582879469355691460864723265e+02
            false // skip the checks
        );
        Quad[] memory owedPotential = new Quad[](1);
        owedPotential[0] = Quad.wrap(bytes16(0x3fff0000000000000000000000000000));
        // int256 midBin = 16391;
        NewLoan.NewLoanParams memory params = NewLoan.NewLoanParams({
            owedPotential: owedPotential, // owedPotential = 1e+00
            startBin: 16392, // startBin
            strikeBin: 16392, // strikeBin
            tokenMix: Quad.wrap(bytes16(0x3ffe0000000000000000000000000000)), // tokenMix = 5e-01
            lockinEnd: POSITIVE_INFINITY,
            deadEra: OptInt256.wrap(OPT_INT256_NONE), // deadEra
            token: false, // token, unused for non-twap
            twapUntil: OptInt256.wrap(OPT_INT256_NONE) // twapUntil, disabled
        });
        UserPay.Info memory userPay = pool.newLoanOnly(params);
        Quad expectedToken0 = -Quad.wrap(bytes16(0x3ff328f9eafdbede1084ff833e9693d3)); // expecting userPay.token0 = -2.83218614512496511441226163673859103e-04
        assertTokenAmount(userPay.token0, expectedToken0, newLoanTestEpsilon);
        Quad expectedToken1 = Quad.wrap(bytes16(0x3ff347c7d2cca14e8b8d999fa2b40543)); // expecting userPay.token1 = 3.12595901768310383975025352088962257e-04
        assertTokenAmount(userPay.token1, expectedToken1, newLoanTestEpsilon);

        console.log(
            "testNewLoan_test_newloan_nontwap_with_whole_range_pour_immediate_above_mid_price_1_00999999989999999999999999999999994_and_token_mix_0_5 testing done."
        );
    }

    function testNewLoan_test_newloan_nontwap_with_whole_range_pour_far_below_mid_price_1_00999999989999999999999999999999994_and_token_mix_0_5()
        public
    {
        console.log(
            "testNewLoan_test_newloan_nontwap_with_whole_range_pour_far_below_mid_price_1_00999999989999999999999999999999994_and_token_mix_0_5 starting ......"
        );
        testLimitedRangePour(
            Quad.wrap(bytes16(0x3fff028f5c2887cf0ff4c9fed7b0016f)), // price = 1.00999999989999999999999999999999994e+00
            Quad.wrap(bytes16(0x3ff847ae147ae147ae147ae147ae147b)), // quadVar = 1.00000000000000000000000000000000002e-02
            0, // startingTub
            4096, // stoppingTub
            Quad.wrap(bytes16(0x40059000000000000000000000000000)), // liquidityPerTub = 1e+02
            Quad.wrap(bytes16(0x40058dfff5e1c536319aca31783c6db9)), // expected token0 = 9.94999614025705781769272952999967145e+01
            Quad.wrap(bytes16(0x400591fae0e8942279715b8bb23141c6)), // expected token1 = 1.00494998582879469355691460864723265e+02
            false // skip the checks
        );
        Quad[] memory owedPotential = new Quad[](1);
        owedPotential[0] = Quad.wrap(bytes16(0x3fff0000000000000000000000000000));
        // int256 midBin = 16391;
        NewLoan.NewLoanParams memory params = NewLoan.NewLoanParams({
            owedPotential: owedPotential, // owedPotential = 1e+00
            startBin: 16381, // startBin
            strikeBin: 16381, // strikeBin
            tokenMix: Quad.wrap(bytes16(0x3ffe0000000000000000000000000000)), // tokenMix = 5e-01
            lockinEnd: POSITIVE_INFINITY,
            deadEra: OptInt256.wrap(OPT_INT256_NONE), // deadEra
            token: false, // token, unused for non-twap
            twapUntil: OptInt256.wrap(OPT_INT256_NONE) // twapUntil, disabled
        });
        UserPay.Info memory userPay = pool.newLoanOnly(params);
        Quad expectedToken0 = Quad.wrap(bytes16(0x3ff3468f4ceb4da03bc386575b80cf83)); // expecting userPay.token0 = 3.11431662982114756826388196858522826e-04
        assertTokenAmount(userPay.token0, expectedToken0, newLoanTestEpsilon);
        Quad expectedToken1 = -Quad.wrap(bytes16(0x3ff32d58435ee1a075cb814ed1768151)); // expecting userPay.token1 = -2.87384775156246785023521637044504036e-04
        assertTokenAmount(userPay.token1, expectedToken1, newLoanTestEpsilon);

        console.log(
            "testNewLoan_test_newloan_nontwap_with_whole_range_pour_far_below_mid_price_1_00999999989999999999999999999999994_and_token_mix_0_5 testing done."
        );
    }

    function testNewLoan_test_newloan_nontwap_with_whole_range_pour_far_above_mid_price_1_00999999989999999999999999999999994_and_token_mix_0_5()
        public
    {
        console.log(
            "testNewLoan_test_newloan_nontwap_with_whole_range_pour_far_above_mid_price_1_00999999989999999999999999999999994_and_token_mix_0_5 starting ......"
        );
        testLimitedRangePour(
            Quad.wrap(bytes16(0x3fff028f5c2887cf0ff4c9fed7b0016f)), // price = 1.00999999989999999999999999999999994e+00
            Quad.wrap(bytes16(0x3ff847ae147ae147ae147ae147ae147b)), // quadVar = 1.00000000000000000000000000000000002e-02
            0, // startingTub
            4096, // stoppingTub
            Quad.wrap(bytes16(0x40059000000000000000000000000000)), // liquidityPerTub = 1e+02
            Quad.wrap(bytes16(0x40058dfff5e1c536319aca31783c6db9)), // expected token0 = 9.94999614025705781769272952999967145e+01
            Quad.wrap(bytes16(0x400591fae0e8942279715b8bb23141c6)), // expected token1 = 1.00494998582879469355691460864723265e+02
            false // skip the checks
        );
        Quad[] memory owedPotential = new Quad[](1);
        owedPotential[0] = Quad.wrap(bytes16(0x3fff0000000000000000000000000000));
        // int256 midBin = 16391;
        NewLoan.NewLoanParams memory params = NewLoan.NewLoanParams({
            owedPotential: owedPotential, // owedPotential = 1e+00
            startBin: 16401, // startBin
            strikeBin: 16401, // strikeBin
            tokenMix: Quad.wrap(bytes16(0x3ffe0000000000000000000000000000)), // tokenMix = 5e-01
            lockinEnd: POSITIVE_INFINITY,
            deadEra: OptInt256.wrap(OPT_INT256_NONE), // deadEra
            token: false, // token, unused for non-twap
            twapUntil: OptInt256.wrap(OPT_INT256_NONE) // twapUntil, disabled
        });
        UserPay.Info memory userPay = pool.newLoanOnly(params);
        Quad expectedToken0 = -Quad.wrap(bytes16(0x3ff32a8bf95a1a5ca588a68c531deb0b)); // expecting userPay.token0 = -2.84716390189201784731754976875605858e-04
        assertTokenAmount(userPay.token0, expectedToken0, newLoanTestEpsilon);
        Quad expectedToken1 = Quad.wrap(bytes16(0x3ff3499eccc2ffebd34d62402d760d96)); // expecting userPay.token1 = 3.14350425639968998440682136908841797e-04
        assertTokenAmount(userPay.token1, expectedToken1, newLoanTestEpsilon);

        console.log(
            "testNewLoan_test_newloan_nontwap_with_whole_range_pour_far_above_mid_price_1_00999999989999999999999999999999994_and_token_mix_0_5 testing done."
        );
    }

    function testNewLoan_test_newloan_nontwap_with_whole_range_pour_immediate_below_mid_price_1_00999999989999999999999999999999994_and_token_mix_0_75(
    ) public {
        console.log(
            "testNewLoan_test_newloan_nontwap_with_whole_range_pour_immediate_below_mid_price_1_00999999989999999999999999999999994_and_token_mix_0_75 starting ......"
        );
        testLimitedRangePour(
            Quad.wrap(bytes16(0x3fff028f5c2887cf0ff4c9fed7b0016f)), // price = 1.00999999989999999999999999999999994e+00
            Quad.wrap(bytes16(0x3ff847ae147ae147ae147ae147ae147b)), // quadVar = 1.00000000000000000000000000000000002e-02
            0, // startingTub
            4096, // stoppingTub
            Quad.wrap(bytes16(0x40059000000000000000000000000000)), // liquidityPerTub = 1e+02
            Quad.wrap(bytes16(0x40058dfff5e1c536319aca31783c6db9)), // expected token0 = 9.94999614025705781769272952999967145e+01
            Quad.wrap(bytes16(0x400591fae0e8942279715b8bb23141c6)), // expected token1 = 1.00494998582879469355691460864723265e+02
            false // skip the checks
        );
        Quad[] memory owedPotential = new Quad[](1);
        owedPotential[0] = Quad.wrap(bytes16(0x3fff0000000000000000000000000000));
        // int256 midBin = 16391;
        NewLoan.NewLoanParams memory params = NewLoan.NewLoanParams({
            owedPotential: owedPotential, // owedPotential = 1e+00
            startBin: 16390, // startBin
            strikeBin: 16390, // strikeBin
            tokenMix: Quad.wrap(bytes16(0x3ffe8000000000000000000000000000)), // tokenMix = 7.5e-01
            lockinEnd: POSITIVE_INFINITY,
            deadEra: OptInt256.wrap(OPT_INT256_NONE), // deadEra
            token: false, // token, unused for non-twap
            twapUntil: OptInt256.wrap(OPT_INT256_NONE) // twapUntil, disabled
        });
        UserPay.Info memory userPay = pool.newLoanOnly(params);
        Quad expectedToken0 = Quad.wrap(bytes16(0x3ff244bcb274c5ce5552ea668b2adccf)); // expecting userPay.token0 = 1.54846714985202414886969670424338839e-04
        assertTokenAmount(userPay.token0, expectedToken0, newLoanTestEpsilon);
        Quad expectedToken1 = -Quad.wrap(bytes16(0x3ff210255bc1815104aa4b0da46fa376)); // expecting userPay.token1 = -1.29769292513661369241109229978981934e-04
        assertTokenAmount(userPay.token1, expectedToken1, newLoanTestEpsilon);

        console.log(
            "testNewLoan_test_newloan_nontwap_with_whole_range_pour_immediate_below_mid_price_1_00999999989999999999999999999999994_and_token_mix_0_75 testing done."
        );
    }

    function testNewLoan_test_newloan_nontwap_with_whole_range_pour_immediate_above_mid_price_1_00999999989999999999999999999999994_and_token_mix_0_75(
    ) public {
        console.log(
            "testNewLoan_test_newloan_nontwap_with_whole_range_pour_immediate_above_mid_price_1_00999999989999999999999999999999994_and_token_mix_0_75 starting ......"
        );
        testLimitedRangePour(
            Quad.wrap(bytes16(0x3fff028f5c2887cf0ff4c9fed7b0016f)), // price = 1.00999999989999999999999999999999994e+00
            Quad.wrap(bytes16(0x3ff847ae147ae147ae147ae147ae147b)), // quadVar = 1.00000000000000000000000000000000002e-02
            0, // startingTub
            4096, // stoppingTub
            Quad.wrap(bytes16(0x40059000000000000000000000000000)), // liquidityPerTub = 1e+02
            Quad.wrap(bytes16(0x40058dfff5e1c536319aca31783c6db9)), // expected token0 = 9.94999614025705781769272952999967145e+01
            Quad.wrap(bytes16(0x400591fae0e8942279715b8bb23141c6)), // expected token1 = 1.00494998582879469355691460864723265e+02
            false // skip the checks
        );
        Quad[] memory owedPotential = new Quad[](1);
        owedPotential[0] = Quad.wrap(bytes16(0x3fff0000000000000000000000000000));
        // int256 midBin = 16391;
        NewLoan.NewLoanParams memory params = NewLoan.NewLoanParams({
            owedPotential: owedPotential, // owedPotential = 1e+00
            startBin: 16392, // startBin
            strikeBin: 16392, // strikeBin
            tokenMix: Quad.wrap(bytes16(0x3ffe8000000000000000000000000000)), // tokenMix = 7.5e-01
            lockinEnd: POSITIVE_INFINITY,
            deadEra: OptInt256.wrap(OPT_INT256_NONE), // deadEra
            token: false, // token, unused for non-twap
            twapUntil: OptInt256.wrap(OPT_INT256_NONE) // twapUntil, disabled
        });
        UserPay.Info memory userPay = pool.newLoanOnly(params);
        Quad expectedToken0 = -Quad.wrap(bytes16(0x3ff3cb24994802d4608a6f36da5a0a5e)); // expecting userPay.token0 = -4.37872852217597774003873271931769652e-04
        assertTokenAmount(userPay.token0, expectedToken0, newLoanTestEpsilon);
        Quad expectedToken1 = Quad.wrap(bytes16(0x3ff3ebabbc32f1f5d154666f740e07e5)); // expecting userPay.token1 = 4.68893852652465575962538028133443409e-04
        assertTokenAmount(userPay.token1, expectedToken1, newLoanTestEpsilon);

        console.log(
            "testNewLoan_test_newloan_nontwap_with_whole_range_pour_immediate_above_mid_price_1_00999999989999999999999999999999994_and_token_mix_0_75 testing done."
        );
    }

    function testNewLoan_test_newloan_nontwap_with_whole_range_pour_far_below_mid_price_1_00999999989999999999999999999999994_and_token_mix_0_75()
        public
    {
        console.log(
            "testNewLoan_test_newloan_nontwap_with_whole_range_pour_far_below_mid_price_1_00999999989999999999999999999999994_and_token_mix_0_75 starting ......"
        );
        testLimitedRangePour(
            Quad.wrap(bytes16(0x3fff028f5c2887cf0ff4c9fed7b0016f)), // price = 1.00999999989999999999999999999999994e+00
            Quad.wrap(bytes16(0x3ff847ae147ae147ae147ae147ae147b)), // quadVar = 1.00000000000000000000000000000000002e-02
            0, // startingTub
            4096, // stoppingTub
            Quad.wrap(bytes16(0x40059000000000000000000000000000)), // liquidityPerTub = 1e+02
            Quad.wrap(bytes16(0x40058dfff5e1c536319aca31783c6db9)), // expected token0 = 9.94999614025705781769272952999967145e+01
            Quad.wrap(bytes16(0x400591fae0e8942279715b8bb23141c6)), // expected token1 = 1.00494998582879469355691460864723265e+02
            false // skip the checks
        );
        Quad[] memory owedPotential = new Quad[](1);
        owedPotential[0] = Quad.wrap(bytes16(0x3fff0000000000000000000000000000));
        // int256 midBin = 16391;
        NewLoan.NewLoanParams memory params = NewLoan.NewLoanParams({
            owedPotential: owedPotential, // owedPotential = 1e+00
            startBin: 16381, // startBin
            strikeBin: 16381, // strikeBin
            tokenMix: Quad.wrap(bytes16(0x3ffe8000000000000000000000000000)), // tokenMix = 7.5e-01
            lockinEnd: POSITIVE_INFINITY,
            deadEra: OptInt256.wrap(OPT_INT256_NONE), // deadEra
            token: false, // token, unused for non-twap
            twapUntil: OptInt256.wrap(OPT_INT256_NONE) // twapUntil, disabled
        });
        UserPay.Info memory userPay = pool.newLoanOnly(params);
        Quad expectedToken0 = Quad.wrap(bytes16(0x3ff2468f4ceb4da03bc386575b80cf83)); // expecting userPay.token0 = 1.55715831491057378413194098429261413e-04
        assertTokenAmount(userPay.token0, expectedToken0, newLoanTestEpsilon);
        Quad expectedToken1 = -Quad.wrap(bytes16(0x3ff21524c5b8b6770758437bd9bdca9e)); // expecting userPay.token1 = -1.32152386661140148296494309074795174e-04
        assertTokenAmount(userPay.token1, expectedToken1, newLoanTestEpsilon);

        console.log(
            "testNewLoan_test_newloan_nontwap_with_whole_range_pour_far_below_mid_price_1_00999999989999999999999999999999994_and_token_mix_0_75 testing done."
        );
    }

    function testNewLoan_test_newloan_nontwap_with_whole_range_pour_far_above_mid_price_1_00999999989999999999999999999999994_and_token_mix_0_75()
        public
    {
        console.log(
            "testNewLoan_test_newloan_nontwap_with_whole_range_pour_far_above_mid_price_1_00999999989999999999999999999999994_and_token_mix_0_75 starting ......"
        );
        testLimitedRangePour(
            Quad.wrap(bytes16(0x3fff028f5c2887cf0ff4c9fed7b0016f)), // price = 1.00999999989999999999999999999999994e+00
            Quad.wrap(bytes16(0x3ff847ae147ae147ae147ae147ae147b)), // quadVar = 1.00000000000000000000000000000000002e-02
            0, // startingTub
            4096, // stoppingTub
            Quad.wrap(bytes16(0x40059000000000000000000000000000)), // liquidityPerTub = 1e+02
            Quad.wrap(bytes16(0x40058dfff5e1c536319aca31783c6db9)), // expected token0 = 9.94999614025705781769272952999967145e+01
            Quad.wrap(bytes16(0x400591fae0e8942279715b8bb23141c6)), // expected token1 = 1.00494998582879469355691460864723265e+02
            false // skip the checks
        );
        Quad[] memory owedPotential = new Quad[](1);
        owedPotential[0] = Quad.wrap(bytes16(0x3fff0000000000000000000000000000));
        // int256 midBin = 16391;
        NewLoan.NewLoanParams memory params = NewLoan.NewLoanParams({
            owedPotential: owedPotential, // owedPotential = 1e+00
            startBin: 16401, // startBin
            strikeBin: 16401, // strikeBin
            tokenMix: Quad.wrap(bytes16(0x3ffe8000000000000000000000000000)), // tokenMix = 7.5e-01
            lockinEnd: POSITIVE_INFINITY,
            deadEra: OptInt256.wrap(OPT_INT256_NONE), // deadEra
            token: false, // token, unused for non-twap
            twapUntil: OptInt256.wrap(OPT_INT256_NONE) // twapUntil, disabled
        });
        UserPay.Info memory userPay = pool.newLoanOnly(params);
        Quad expectedToken0 = -Quad.wrap(bytes16(0x3ff3cbcef19676b4e0abe8982df0c8fa)); // expecting userPay.token0 = -4.38507436596392919540065984913078377e-04
        assertTokenAmount(userPay.token0, expectedToken0, newLoanTestEpsilon);
        Quad expectedToken1 = Quad.wrap(bytes16(0x3ff3ee6e33247fe1bcf4136044311461)); // expecting userPay.token1 = 4.71525638459953497661023205363262695e-04
        assertTokenAmount(userPay.token1, expectedToken1, newLoanTestEpsilon);

        console.log(
            "testNewLoan_test_newloan_nontwap_with_whole_range_pour_far_above_mid_price_1_00999999989999999999999999999999994_and_token_mix_0_75 testing done."
        );
    }

    function testNewLoan_test_newloan_nontwap_with_whole_range_pour_immediate_below_mid_price_1_00999999989999999999999999999999994_and_token_mix_1()
        public
    {
        console.log(
            "testNewLoan_test_newloan_nontwap_with_whole_range_pour_immediate_below_mid_price_1_00999999989999999999999999999999994_and_token_mix_1 starting ......"
        );
        testLimitedRangePour(
            Quad.wrap(bytes16(0x3fff028f5c2887cf0ff4c9fed7b0016f)), // price = 1.00999999989999999999999999999999994e+00
            Quad.wrap(bytes16(0x3ff847ae147ae147ae147ae147ae147b)), // quadVar = 1.00000000000000000000000000000000002e-02
            0, // startingTub
            4096, // stoppingTub
            Quad.wrap(bytes16(0x40059000000000000000000000000000)), // liquidityPerTub = 1e+02
            Quad.wrap(bytes16(0x40058dfff5e1c536319aca31783c6db9)), // expected token0 = 9.94999614025705781769272952999967145e+01
            Quad.wrap(bytes16(0x400591fae0e8942279715b8bb23141c6)), // expected token1 = 1.00494998582879469355691460864723265e+02
            false // skip the checks
        );
        Quad[] memory owedPotential = new Quad[](1);
        owedPotential[0] = Quad.wrap(bytes16(0x3fff0000000000000000000000000000));
        // int256 midBin = 16391;
        NewLoan.NewLoanParams memory params = NewLoan.NewLoanParams({
            owedPotential: owedPotential, // owedPotential = 1e+00
            startBin: 16390, // startBin
            strikeBin: 16390, // strikeBin
            tokenMix: Quad.wrap(bytes16(0x3fff0000000000000000000000000000)), // tokenMix = 1e+00
            lockinEnd: POSITIVE_INFINITY,
            deadEra: OptInt256.wrap(OPT_INT256_NONE), // deadEra
            token: false, // token, unused for non-twap
            twapUntil: OptInt256.wrap(OPT_INT256_NONE) // twapUntil, disabled
        });
        UserPay.Info memory userPay = pool.newLoanOnly(params);
        Quad expectedToken0 = POSITIVE_ZERO; // expecting userPay.token0 = 0e+00
        assertTokenAmount(userPay.token0, expectedToken0, newLoanTestEpsilon);
        Quad expectedToken1 = Quad.wrap(bytes16(0x3fefb9d149eacfcf62471588f64a0ee0)); // expecting userPay.token1 = 2.63343771778030990203294236218810933e-05
        assertTokenAmount(userPay.token1, expectedToken1, newLoanTestEpsilon);

        console.log(
            "testNewLoan_test_newloan_nontwap_with_whole_range_pour_immediate_below_mid_price_1_00999999989999999999999999999999994_and_token_mix_1 testing done."
        );
    }

    function testNewLoan_test_newloan_nontwap_with_whole_range_pour_immediate_above_mid_price_1_00999999989999999999999999999999994_and_token_mix_1()
        public
    {
        console.log(
            "testNewLoan_test_newloan_nontwap_with_whole_range_pour_immediate_above_mid_price_1_00999999989999999999999999999999994_and_token_mix_1 starting ......"
        );
        testLimitedRangePour(
            Quad.wrap(bytes16(0x3fff028f5c2887cf0ff4c9fed7b0016f)), // price = 1.00999999989999999999999999999999994e+00
            Quad.wrap(bytes16(0x3ff847ae147ae147ae147ae147ae147b)), // quadVar = 1.00000000000000000000000000000000002e-02
            0, // startingTub
            4096, // stoppingTub
            Quad.wrap(bytes16(0x40059000000000000000000000000000)), // liquidityPerTub = 1e+02
            Quad.wrap(bytes16(0x40058dfff5e1c536319aca31783c6db9)), // expected token0 = 9.94999614025705781769272952999967145e+01
            Quad.wrap(bytes16(0x400591fae0e8942279715b8bb23141c6)), // expected token1 = 1.00494998582879469355691460864723265e+02
            false // skip the checks
        );
        Quad[] memory owedPotential = new Quad[](1);
        owedPotential[0] = Quad.wrap(bytes16(0x3fff0000000000000000000000000000));
        // int256 midBin = 16391;
        NewLoan.NewLoanParams memory params = NewLoan.NewLoanParams({
            owedPotential: owedPotential, // owedPotential = 1e+00
            startBin: 16392, // startBin
            strikeBin: 16392, // strikeBin
            tokenMix: Quad.wrap(bytes16(0x3fff0000000000000000000000000000)), // tokenMix = 1e+00
            lockinEnd: POSITIVE_INFINITY,
            deadEra: OptInt256.wrap(OPT_INT256_NONE), // deadEra
            token: false, // token, unused for non-twap
            twapUntil: OptInt256.wrap(OPT_INT256_NONE) // twapUntil, disabled
        });
        UserPay.Info memory userPay = pool.newLoanOnly(params);
        Quad expectedToken0 = -Quad.wrap(bytes16(0x3ff436a7a3c923655847ef753b0ec075)); // expecting userPay.token0 = -5.92527089922699036566520380189680248e-04
        assertTokenAmount(userPay.token0, expectedToken0, newLoanTestEpsilon);
        Quad expectedToken1 = Quad.wrap(bytes16(0x3ff447c7d2cca14e8b8d999fa2b40543)); // expecting userPay.token1 = 6.25191803536620767950050704177924514e-04
        assertTokenAmount(userPay.token1, expectedToken1, newLoanTestEpsilon);

        console.log(
            "testNewLoan_test_newloan_nontwap_with_whole_range_pour_immediate_above_mid_price_1_00999999989999999999999999999999994_and_token_mix_1 testing done."
        );
    }

    function testNewLoan_test_newloan_nontwap_with_whole_range_pour_far_below_mid_price_1_00999999989999999999999999999999994_and_token_mix_1()
        public
    {
        console.log(
            "testNewLoan_test_newloan_nontwap_with_whole_range_pour_far_below_mid_price_1_00999999989999999999999999999999994_and_token_mix_1 starting ......"
        );
        testLimitedRangePour(
            Quad.wrap(bytes16(0x3fff028f5c2887cf0ff4c9fed7b0016f)), // price = 1.00999999989999999999999999999999994e+00
            Quad.wrap(bytes16(0x3ff847ae147ae147ae147ae147ae147b)), // quadVar = 1.00000000000000000000000000000000002e-02
            0, // startingTub
            4096, // stoppingTub
            Quad.wrap(bytes16(0x40059000000000000000000000000000)), // liquidityPerTub = 1e+02
            Quad.wrap(bytes16(0x40058dfff5e1c536319aca31783c6db9)), // expected token0 = 9.94999614025705781769272952999967145e+01
            Quad.wrap(bytes16(0x400591fae0e8942279715b8bb23141c6)), // expected token1 = 1.00494998582879469355691460864723265e+02
            false // skip the checks
        );
        Quad[] memory owedPotential = new Quad[](1);
        owedPotential[0] = Quad.wrap(bytes16(0x3fff0000000000000000000000000000));
        // int256 midBin = 16391;
        NewLoan.NewLoanParams memory params = NewLoan.NewLoanParams({
            owedPotential: owedPotential, // owedPotential = 1e+00
            startBin: 16381, // startBin
            strikeBin: 16381, // strikeBin
            tokenMix: Quad.wrap(bytes16(0x3fff0000000000000000000000000000)), // tokenMix = 1e+00
            lockinEnd: POSITIVE_INFINITY,
            deadEra: OptInt256.wrap(OPT_INT256_NONE), // deadEra
            token: false, // token, unused for non-twap
            twapUntil: OptInt256.wrap(OPT_INT256_NONE) // twapUntil, disabled
        });
        UserPay.Info memory userPay = pool.newLoanOnly(params);
        Quad expectedToken0 = POSITIVE_ZERO; // expecting userPay.token0 = 0e+00
        assertTokenAmount(userPay.token0, expectedToken0, newLoanTestEpsilon);
        Quad expectedToken1 = Quad.wrap(bytes16(0x3fef8337da62b296e733dd2f7b8b6b40)); // expecting userPay.token1 = 2.30800018339664884305330188949137358e-05
        assertTokenAmount(userPay.token1, expectedToken1, newLoanTestEpsilon);

        console.log(
            "testNewLoan_test_newloan_nontwap_with_whole_range_pour_far_below_mid_price_1_00999999989999999999999999999999994_and_token_mix_1 testing done."
        );
    }

    function testNewLoan_test_newloan_nontwap_with_whole_range_pour_far_above_mid_price_1_00999999989999999999999999999999994_and_token_mix_1()
        public
    {
        console.log(
            "testNewLoan_test_newloan_nontwap_with_whole_range_pour_far_above_mid_price_1_00999999989999999999999999999999994_and_token_mix_1 starting ......"
        );
        testLimitedRangePour(
            Quad.wrap(bytes16(0x3fff028f5c2887cf0ff4c9fed7b0016f)), // price = 1.00999999989999999999999999999999994e+00
            Quad.wrap(bytes16(0x3ff847ae147ae147ae147ae147ae147b)), // quadVar = 1.00000000000000000000000000000000002e-02
            0, // startingTub
            4096, // stoppingTub
            Quad.wrap(bytes16(0x40059000000000000000000000000000)), // liquidityPerTub = 1e+02
            Quad.wrap(bytes16(0x40058dfff5e1c536319aca31783c6db9)), // expected token0 = 9.94999614025705781769272952999967145e+01
            Quad.wrap(bytes16(0x400591fae0e8942279715b8bb23141c6)), // expected token1 = 1.00494998582879469355691460864723265e+02
            false // skip the checks
        );
        Quad[] memory owedPotential = new Quad[](1);
        owedPotential[0] = Quad.wrap(bytes16(0x3fff0000000000000000000000000000));
        // int256 midBin = 16391;
        NewLoan.NewLoanParams memory params = NewLoan.NewLoanParams({
            owedPotential: owedPotential, // owedPotential = 1e+00
            startBin: 16401, // startBin
            strikeBin: 16401, // strikeBin
            tokenMix: Quad.wrap(bytes16(0x3fff0000000000000000000000000000)), // tokenMix = 1e+00
            lockinEnd: POSITIVE_INFINITY,
            deadEra: OptInt256.wrap(OPT_INT256_NONE), // deadEra
            token: false, // token, unused for non-twap
            twapUntil: OptInt256.wrap(OPT_INT256_NONE) // twapUntil, disabled
        });
        UserPay.Info memory userPay = pool.newLoanOnly(params);
        Quad expectedToken0 = -Quad.wrap(bytes16(0x3ff43688f4e969868de795520461d375)); // expecting userPay.token0 = -5.92298483003584054348376992950550944e-04
        assertTokenAmount(userPay.token0, expectedToken0, newLoanTestEpsilon);
        Quad expectedToken1 = Quad.wrap(bytes16(0x3ff4499eccc2ffebd34d62402d760d96)); // expecting userPay.token1 = 6.28700851279937996881364273817683594e-04
        assertTokenAmount(userPay.token1, expectedToken1, newLoanTestEpsilon);

        console.log(
            "testNewLoan_test_newloan_nontwap_with_whole_range_pour_far_above_mid_price_1_00999999989999999999999999999999994_and_token_mix_1 testing done."
        );
    }

    function testNewLoan_test_newloan_nontwap_with_whole_range_pour_immediate_below_mid_price_1_01000000000000000000000000000000001_and_token_mix_0()
        public
    {
        console.log(
            "testNewLoan_test_newloan_nontwap_with_whole_range_pour_immediate_below_mid_price_1_01000000000000000000000000000000001_and_token_mix_0 starting ......"
        );
        testLimitedRangePour(
            Quad.wrap(bytes16(0x3fff028f5c28f5c28f5c28f5c28f5c29)), // price = 1.01000000000000000000000000000000001e+00
            Quad.wrap(bytes16(0x3ff847ae147ae147ae147ae147ae147b)), // quadVar = 1.00000000000000000000000000000000002e-02
            0, // startingTub
            4096, // stoppingTub
            Quad.wrap(bytes16(0x40059000000000000000000000000000)), // liquidityPerTub = 1e+02
            Quad.wrap(bytes16(0x40058dfff5e1708f004dd48b06f1bcce)), // expected token0 = 9.94999613976431194686472991361695447e+01
            Quad.wrap(bytes16(0x400591fae0e8e994c568d4a0eb3df54b)), // expected token1 = 1.00494998587853108604312572889908098e+02
            false // skip the checks
        );
        Quad[] memory owedPotential = new Quad[](1);
        owedPotential[0] = Quad.wrap(bytes16(0x3fff0000000000000000000000000000));
        // int256 midBin = 16392;
        NewLoan.NewLoanParams memory params = NewLoan.NewLoanParams({
            owedPotential: owedPotential, // owedPotential = 1e+00
            startBin: 16391, // startBin
            strikeBin: 16391, // strikeBin
            tokenMix: POSITIVE_ZERO, // tokenMix = 0e+00
            lockinEnd: POSITIVE_INFINITY,
            deadEra: OptInt256.wrap(OPT_INT256_NONE), // deadEra
            token: false, // token, unused for non-twap
            twapUntil: OptInt256.wrap(OPT_INT256_NONE) // twapUntil, disabled
        });
        UserPay.Info memory userPay = pool.newLoanOnly(params);
        Quad expectedToken0 = Quad.wrap(bytes16(0x3ff444890367c0a903d5b3fbd651ebdd)); // expecting userPay.token0 = 6.19001785679822542524802677403885662e-04
        assertTokenAmount(userPay.token0, expectedToken0, newLoanTestEpsilon);
        Quad expectedToken1 = -Quad.wrap(bytes16(0x3ff439c2ea8b264f517bdad000c4a8c8)); // expecting userPay.token1 = -5.98452360821926026932185583991577042e-04
        assertTokenAmount(userPay.token1, expectedToken1, newLoanTestEpsilon);

        console.log(
            "testNewLoan_test_newloan_nontwap_with_whole_range_pour_immediate_below_mid_price_1_01000000000000000000000000000000001_and_token_mix_0 testing done."
        );
    }

    function testNewLoan_test_newloan_nontwap_with_whole_range_pour_immediate_above_mid_price_1_01000000000000000000000000000000001_and_token_mix_0()
        public
    {
        console.log(
            "testNewLoan_test_newloan_nontwap_with_whole_range_pour_immediate_above_mid_price_1_01000000000000000000000000000000001_and_token_mix_0 starting ......"
        );
        testLimitedRangePour(
            Quad.wrap(bytes16(0x3fff028f5c28f5c28f5c28f5c28f5c29)), // price = 1.01000000000000000000000000000000001e+00
            Quad.wrap(bytes16(0x3ff847ae147ae147ae147ae147ae147b)), // quadVar = 1.00000000000000000000000000000000002e-02
            0, // startingTub
            4096, // stoppingTub
            Quad.wrap(bytes16(0x40059000000000000000000000000000)), // liquidityPerTub = 1e+02
            Quad.wrap(bytes16(0x40058dfff5e1708f004dd48b06f1bcce)), // expected token0 = 9.94999613976431194686472991361695447e+01
            Quad.wrap(bytes16(0x400591fae0e8e994c568d4a0eb3df54b)), // expected token1 = 1.00494998587853108604312572889908098e+02
            false // skip the checks
        );
        Quad[] memory owedPotential = new Quad[](1);
        owedPotential[0] = Quad.wrap(bytes16(0x3fff0000000000000000000000000000));
        // int256 midBin = 16392;
        NewLoan.NewLoanParams memory params = NewLoan.NewLoanParams({
            owedPotential: owedPotential, // owedPotential = 1e+00
            startBin: 16393, // startBin
            strikeBin: 16393, // strikeBin
            tokenMix: POSITIVE_ZERO, // tokenMix = 0e+00
            lockinEnd: POSITIVE_INFINITY,
            deadEra: OptInt256.wrap(OPT_INT256_NONE), // deadEra
            token: false, // token, unused for non-twap
            twapUntil: OptInt256.wrap(OPT_INT256_NONE) // twapUntil, disabled
        });
        UserPay.Info memory userPay = pool.newLoanOnly(params);
        Quad expectedToken0 = Quad.wrap(bytes16(0x3fefb5716f3486c842e3876196118fe0)); // expecting userPay.token0 = 2.6073640770102078237949924378100002e-05
        assertTokenAmount(userPay.token0, expectedToken0, newLoanTestEpsilon);
        Quad expectedToken1 = POSITIVE_ZERO; // expecting userPay.token1 = 0e+00
        assertTokenAmount(userPay.token1, expectedToken1, newLoanTestEpsilon);

        console.log(
            "testNewLoan_test_newloan_nontwap_with_whole_range_pour_immediate_above_mid_price_1_01000000000000000000000000000000001_and_token_mix_0 testing done."
        );
    }

    function testNewLoan_test_newloan_nontwap_with_whole_range_pour_far_below_mid_price_1_01000000000000000000000000000000001_and_token_mix_0()
        public
    {
        console.log(
            "testNewLoan_test_newloan_nontwap_with_whole_range_pour_far_below_mid_price_1_01000000000000000000000000000000001_and_token_mix_0 starting ......"
        );
        testLimitedRangePour(
            Quad.wrap(bytes16(0x3fff028f5c28f5c28f5c28f5c28f5c29)), // price = 1.01000000000000000000000000000000001e+00
            Quad.wrap(bytes16(0x3ff847ae147ae147ae147ae147ae147b)), // quadVar = 1.00000000000000000000000000000000002e-02
            0, // startingTub
            4096, // stoppingTub
            Quad.wrap(bytes16(0x40059000000000000000000000000000)), // liquidityPerTub = 1e+02
            Quad.wrap(bytes16(0x40058dfff5e1708f004dd48b06f1bcce)), // expected token0 = 9.94999613976431194686472991361695447e+01
            Quad.wrap(bytes16(0x400591fae0e8e994c568d4a0eb3df54b)), // expected token1 = 1.00494998587853108604312572889908098e+02
            false // skip the checks
        );
        Quad[] memory owedPotential = new Quad[](1);
        owedPotential[0] = Quad.wrap(bytes16(0x3fff0000000000000000000000000000));
        // int256 midBin = 16392;
        NewLoan.NewLoanParams memory params = NewLoan.NewLoanParams({
            owedPotential: owedPotential, // owedPotential = 1e+00
            startBin: 16382, // startBin
            strikeBin: 16382, // strikeBin
            tokenMix: POSITIVE_ZERO, // tokenMix = 0e+00
            lockinEnd: POSITIVE_INFINITY,
            deadEra: OptInt256.wrap(OPT_INT256_NONE), // deadEra
            token: false, // token, unused for non-twap
            twapUntil: OptInt256.wrap(OPT_INT256_NONE) // twapUntil, disabled
        });
        UserPay.Info memory userPay = pool.newLoanOnly(params);
        Quad expectedToken0 = Quad.wrap(bytes16(0x3ff4465b539b0c9861af7816fcda4537)); // expecting userPay.token0 = 6.22476090376176234536004231502657049e-04
        assertTokenAmount(userPay.token0, expectedToken0, newLoanTestEpsilon);
        Quad expectedToken1 = -Quad.wrap(bytes16(0x3ff439a3ed1ef242c7a4c7741e06a4ef)); // expecting userPay.token1 = -5.98221467833619894891860762880056501e-04
        assertTokenAmount(userPay.token1, expectedToken1, newLoanTestEpsilon);

        console.log(
            "testNewLoan_test_newloan_nontwap_with_whole_range_pour_far_below_mid_price_1_01000000000000000000000000000000001_and_token_mix_0 testing done."
        );
    }

    function testNewLoan_test_newloan_nontwap_with_whole_range_pour_far_above_mid_price_1_01000000000000000000000000000000001_and_token_mix_0()
        public
    {
        console.log(
            "testNewLoan_test_newloan_nontwap_with_whole_range_pour_far_above_mid_price_1_01000000000000000000000000000000001_and_token_mix_0 starting ......"
        );
        testLimitedRangePour(
            Quad.wrap(bytes16(0x3fff028f5c28f5c28f5c28f5c28f5c29)), // price = 1.01000000000000000000000000000000001e+00
            Quad.wrap(bytes16(0x3ff847ae147ae147ae147ae147ae147b)), // quadVar = 1.00000000000000000000000000000000002e-02
            0, // startingTub
            4096, // stoppingTub
            Quad.wrap(bytes16(0x40059000000000000000000000000000)), // liquidityPerTub = 1e+02
            Quad.wrap(bytes16(0x40058dfff5e1708f004dd48b06f1bcce)), // expected token0 = 9.94999613976431194686472991361695447e+01
            Quad.wrap(bytes16(0x400591fae0e8e994c568d4a0eb3df54b)), // expected token1 = 1.00494998587853108604312572889908098e+02
            false // skip the checks
        );
        Quad[] memory owedPotential = new Quad[](1);
        owedPotential[0] = Quad.wrap(bytes16(0x3fff0000000000000000000000000000));
        // int256 midBin = 16392;
        NewLoan.NewLoanParams memory params = NewLoan.NewLoanParams({
            owedPotential: owedPotential, // owedPotential = 1e+00
            startBin: 16402, // startBin
            strikeBin: 16402, // strikeBin
            tokenMix: POSITIVE_ZERO, // tokenMix = 0e+00
            lockinEnd: POSITIVE_INFINITY,
            deadEra: OptInt256.wrap(OPT_INT256_NONE), // deadEra
            token: false, // token, unused for non-twap
            twapUntil: OptInt256.wrap(OPT_INT256_NONE) // twapUntil, disabled
        });
        UserPay.Info memory userPay = pool.newLoanOnly(params);
        Quad expectedToken0 = Quad.wrap(bytes16(0x3fef7f6263a11635179b457372b7a9a0)); // expecting userPay.token0 = 2.28514869643232558718148701929839499e-05
        assertTokenAmount(userPay.token0, expectedToken0, newLoanTestEpsilon);
        Quad expectedToken1 = POSITIVE_ZERO; // expecting userPay.token1 = 0e+00
        assertTokenAmount(userPay.token1, expectedToken1, newLoanTestEpsilon);

        console.log(
            "testNewLoan_test_newloan_nontwap_with_whole_range_pour_far_above_mid_price_1_01000000000000000000000000000000001_and_token_mix_0 testing done."
        );
    }

    function testNewLoan_test_newloan_nontwap_with_whole_range_pour_immediate_below_mid_price_1_01000000000000000000000000000000001_and_token_mix_0_25(
    ) public {
        console.log(
            "testNewLoan_test_newloan_nontwap_with_whole_range_pour_immediate_below_mid_price_1_01000000000000000000000000000000001_and_token_mix_0_25 starting ......"
        );
        testLimitedRangePour(
            Quad.wrap(bytes16(0x3fff028f5c28f5c28f5c28f5c28f5c29)), // price = 1.01000000000000000000000000000000001e+00
            Quad.wrap(bytes16(0x3ff847ae147ae147ae147ae147ae147b)), // quadVar = 1.00000000000000000000000000000000002e-02
            0, // startingTub
            4096, // stoppingTub
            Quad.wrap(bytes16(0x40059000000000000000000000000000)), // liquidityPerTub = 1e+02
            Quad.wrap(bytes16(0x40058dfff5e1708f004dd48b06f1bcce)), // expected token0 = 9.94999613976431194686472991361695447e+01
            Quad.wrap(bytes16(0x400591fae0e8e994c568d4a0eb3df54b)), // expected token1 = 1.00494998587853108604312572889908098e+02
            false // skip the checks
        );
        Quad[] memory owedPotential = new Quad[](1);
        owedPotential[0] = Quad.wrap(bytes16(0x3fff0000000000000000000000000000));
        // int256 midBin = 16392;
        NewLoan.NewLoanParams memory params = NewLoan.NewLoanParams({
            owedPotential: owedPotential, // owedPotential = 1e+00
            startBin: 16391, // startBin
            strikeBin: 16391, // strikeBin
            tokenMix: Quad.wrap(bytes16(0x3ffd0000000000000000000000000000)), // tokenMix = 2.5e-01
            lockinEnd: POSITIVE_INFINITY,
            deadEra: OptInt256.wrap(OPT_INT256_NONE), // deadEra
            token: false, // token, unused for non-twap
            twapUntil: OptInt256.wrap(OPT_INT256_NONE) // twapUntil, disabled
        });
        UserPay.Info memory userPay = pool.newLoanOnly(params);
        Quad expectedToken0 = Quad.wrap(bytes16(0x3ff3e6cd851ba0fd85c08df9c17ae1cb)); // expecting userPay.token0 = 4.64251339259866906893602008052914223e-04
        assertTokenAmount(userPay.token0, expectedToken0, newLoanTestEpsilon);
        Quad expectedToken1 = -Quad.wrap(bytes16(0x3ff3cfbc0136cfa86bbf04ce7103e6a2)); // expecting userPay.token1 = -4.42251580739773751743912004651087372e-04
        assertTokenAmount(userPay.token1, expectedToken1, newLoanTestEpsilon);

        console.log(
            "testNewLoan_test_newloan_nontwap_with_whole_range_pour_immediate_below_mid_price_1_01000000000000000000000000000000001_and_token_mix_0_25 testing done."
        );
    }

    function testNewLoan_test_newloan_nontwap_with_whole_range_pour_immediate_above_mid_price_1_01000000000000000000000000000000001_and_token_mix_0_25(
    ) public {
        console.log(
            "testNewLoan_test_newloan_nontwap_with_whole_range_pour_immediate_above_mid_price_1_01000000000000000000000000000000001_and_token_mix_0_25 starting ......"
        );
        testLimitedRangePour(
            Quad.wrap(bytes16(0x3fff028f5c28f5c28f5c28f5c28f5c29)), // price = 1.01000000000000000000000000000000001e+00
            Quad.wrap(bytes16(0x3ff847ae147ae147ae147ae147ae147b)), // quadVar = 1.00000000000000000000000000000000002e-02
            0, // startingTub
            4096, // stoppingTub
            Quad.wrap(bytes16(0x40059000000000000000000000000000)), // liquidityPerTub = 1e+02
            Quad.wrap(bytes16(0x40058dfff5e1708f004dd48b06f1bcce)), // expected token0 = 9.94999613976431194686472991361695447e+01
            Quad.wrap(bytes16(0x400591fae0e8e994c568d4a0eb3df54b)), // expected token1 = 1.00494998587853108604312572889908098e+02
            false // skip the checks
        );
        Quad[] memory owedPotential = new Quad[](1);
        owedPotential[0] = Quad.wrap(bytes16(0x3fff0000000000000000000000000000));
        // int256 midBin = 16392;
        NewLoan.NewLoanParams memory params = NewLoan.NewLoanParams({
            owedPotential: owedPotential, // owedPotential = 1e+00
            startBin: 16393, // startBin
            strikeBin: 16393, // strikeBin
            tokenMix: Quad.wrap(bytes16(0x3ffd0000000000000000000000000000)), // tokenMix = 2.5e-01
            lockinEnd: POSITIVE_INFINITY,
            deadEra: OptInt256.wrap(OPT_INT256_NONE), // deadEra
            token: false, // token, unused for non-twap
            twapUntil: OptInt256.wrap(OPT_INT256_NONE) // twapUntil, disabled
        });
        UserPay.Info memory userPay = pool.newLoanOnly(params);
        Quad expectedToken0 = -Quad.wrap(bytes16(0x3ff20d7390133b99b8945472e4b580e4)); // expecting userPay.token0 = -1.28484448033328088357533891068298937e-04
        assertTokenAmount(userPay.token0, expectedToken0, newLoanTestEpsilon);
        Quad expectedToken1 = Quad.wrap(bytes16(0x3ff247fc062923f1ad3795b45e7aa6b2)); // expecting userPay.token1 = 1.56395182135054439035839367128582219e-04
        assertTokenAmount(userPay.token1, expectedToken1, newLoanTestEpsilon);

        console.log(
            "testNewLoan_test_newloan_nontwap_with_whole_range_pour_immediate_above_mid_price_1_01000000000000000000000000000000001_and_token_mix_0_25 testing done."
        );
    }

    function testNewLoan_test_newloan_nontwap_with_whole_range_pour_far_below_mid_price_1_01000000000000000000000000000000001_and_token_mix_0_25()
        public
    {
        console.log(
            "testNewLoan_test_newloan_nontwap_with_whole_range_pour_far_below_mid_price_1_01000000000000000000000000000000001_and_token_mix_0_25 starting ......"
        );
        testLimitedRangePour(
            Quad.wrap(bytes16(0x3fff028f5c28f5c28f5c28f5c28f5c29)), // price = 1.01000000000000000000000000000000001e+00
            Quad.wrap(bytes16(0x3ff847ae147ae147ae147ae147ae147b)), // quadVar = 1.00000000000000000000000000000000002e-02
            0, // startingTub
            4096, // stoppingTub
            Quad.wrap(bytes16(0x40059000000000000000000000000000)), // liquidityPerTub = 1e+02
            Quad.wrap(bytes16(0x40058dfff5e1708f004dd48b06f1bcce)), // expected token0 = 9.94999613976431194686472991361695447e+01
            Quad.wrap(bytes16(0x400591fae0e8e994c568d4a0eb3df54b)), // expected token1 = 1.00494998587853108604312572889908098e+02
            false // skip the checks
        );
        Quad[] memory owedPotential = new Quad[](1);
        owedPotential[0] = Quad.wrap(bytes16(0x3fff0000000000000000000000000000));
        // int256 midBin = 16392;
        NewLoan.NewLoanParams memory params = NewLoan.NewLoanParams({
            owedPotential: owedPotential, // owedPotential = 1e+00
            startBin: 16382, // startBin
            strikeBin: 16382, // strikeBin
            tokenMix: Quad.wrap(bytes16(0x3ffd0000000000000000000000000000)), // tokenMix = 2.5e-01
            lockinEnd: POSITIVE_INFINITY,
            deadEra: OptInt256.wrap(OPT_INT256_NONE), // deadEra
            token: false, // token, unused for non-twap
            twapUntil: OptInt256.wrap(OPT_INT256_NONE) // twapUntil, disabled
        });
        UserPay.Info memory userPay = pool.newLoanOnly(params);
        Quad expectedToken0 = Quad.wrap(bytes16(0x3ff3e988fd6892e4928734227b4767d2)); // expecting userPay.token0 = 4.66857067782132175902003173626992763e-04
        assertTokenAmount(userPay.token0, expectedToken0, newLoanTestEpsilon);
        Quad expectedToken1 = -Quad.wrap(bytes16(0x3ff3d0680d9a8740ed2881f5dc7adf78)); // expecting userPay.token1 = -4.4289251096235684873546664476220919e-04
        assertTokenAmount(userPay.token1, expectedToken1, newLoanTestEpsilon);

        console.log(
            "testNewLoan_test_newloan_nontwap_with_whole_range_pour_far_below_mid_price_1_01000000000000000000000000000000001_and_token_mix_0_25 testing done."
        );
    }

    function testNewLoan_test_newloan_nontwap_with_whole_range_pour_far_above_mid_price_1_01000000000000000000000000000000001_and_token_mix_0_25()
        public
    {
        console.log(
            "testNewLoan_test_newloan_nontwap_with_whole_range_pour_far_above_mid_price_1_01000000000000000000000000000000001_and_token_mix_0_25 starting ......"
        );
        testLimitedRangePour(
            Quad.wrap(bytes16(0x3fff028f5c28f5c28f5c28f5c28f5c29)), // price = 1.01000000000000000000000000000000001e+00
            Quad.wrap(bytes16(0x3ff847ae147ae147ae147ae147ae147b)), // quadVar = 1.00000000000000000000000000000000002e-02
            0, // startingTub
            4096, // stoppingTub
            Quad.wrap(bytes16(0x40059000000000000000000000000000)), // liquidityPerTub = 1e+02
            Quad.wrap(bytes16(0x40058dfff5e1708f004dd48b06f1bcce)), // expected token0 = 9.94999613976431194686472991361695447e+01
            Quad.wrap(bytes16(0x400591fae0e8e994c568d4a0eb3df54b)), // expected token1 = 1.00494998587853108604312572889908098e+02
            false // skip the checks
        );
        Quad[] memory owedPotential = new Quad[](1);
        owedPotential[0] = Quad.wrap(bytes16(0x3fff0000000000000000000000000000));
        // int256 midBin = 16392;
        NewLoan.NewLoanParams memory params = NewLoan.NewLoanParams({
            owedPotential: owedPotential, // owedPotential = 1e+00
            startBin: 16402, // startBin
            strikeBin: 16402, // strikeBin
            tokenMix: Quad.wrap(bytes16(0x3ffd0000000000000000000000000000)), // tokenMix = 2.5e-01
            lockinEnd: POSITIVE_INFINITY,
            deadEra: OptInt256.wrap(OPT_INT256_NONE), // deadEra
            token: false, // token, unused for non-twap
            twapUntil: OptInt256.wrap(OPT_INT256_NONE) // twapUntil, disabled
        });
        UserPay.Info memory userPay = pool.newLoanOnly(params);
        Quad expectedToken0 = -Quad.wrap(bytes16(0x3ff212664f2b7a5c80ef780b197c8bc6)); // expecting userPay.token0 = -1.30843947189247671580687434727519938e-04
        assertTokenAmount(userPay.token0, expectedToken0, newLoanTestEpsilon);
        Quad expectedToken1 = Quad.wrap(bytes16(0x3ff249d34b20db33c17b3d71d4bcfa8c)); // expecting userPay.token1 = 1.57272989805967952197326039413554027e-04
        assertTokenAmount(userPay.token1, expectedToken1, newLoanTestEpsilon);

        console.log(
            "testNewLoan_test_newloan_nontwap_with_whole_range_pour_far_above_mid_price_1_01000000000000000000000000000000001_and_token_mix_0_25 testing done."
        );
    }

    function testNewLoan_test_newloan_nontwap_with_whole_range_pour_immediate_below_mid_price_1_01000000000000000000000000000000001_and_token_mix_0_5(
    ) public {
        console.log(
            "testNewLoan_test_newloan_nontwap_with_whole_range_pour_immediate_below_mid_price_1_01000000000000000000000000000000001_and_token_mix_0_5 starting ......"
        );
        testLimitedRangePour(
            Quad.wrap(bytes16(0x3fff028f5c28f5c28f5c28f5c28f5c29)), // price = 1.01000000000000000000000000000000001e+00
            Quad.wrap(bytes16(0x3ff847ae147ae147ae147ae147ae147b)), // quadVar = 1.00000000000000000000000000000000002e-02
            0, // startingTub
            4096, // stoppingTub
            Quad.wrap(bytes16(0x40059000000000000000000000000000)), // liquidityPerTub = 1e+02
            Quad.wrap(bytes16(0x40058dfff5e1708f004dd48b06f1bcce)), // expected token0 = 9.94999613976431194686472991361695447e+01
            Quad.wrap(bytes16(0x400591fae0e8e994c568d4a0eb3df54b)), // expected token1 = 1.00494998587853108604312572889908098e+02
            false // skip the checks
        );
        Quad[] memory owedPotential = new Quad[](1);
        owedPotential[0] = Quad.wrap(bytes16(0x3fff0000000000000000000000000000));
        // int256 midBin = 16392;
        NewLoan.NewLoanParams memory params = NewLoan.NewLoanParams({
            owedPotential: owedPotential, // owedPotential = 1e+00
            startBin: 16391, // startBin
            strikeBin: 16391, // strikeBin
            tokenMix: Quad.wrap(bytes16(0x3ffe0000000000000000000000000000)), // tokenMix = 5e-01
            lockinEnd: POSITIVE_INFINITY,
            deadEra: OptInt256.wrap(OPT_INT256_NONE), // deadEra
            token: false, // token, unused for non-twap
            twapUntil: OptInt256.wrap(OPT_INT256_NONE) // twapUntil, disabled
        });
        UserPay.Info memory userPay = pool.newLoanOnly(params);
        Quad expectedToken0 = Quad.wrap(bytes16(0x3ff344890367c0a903d5b3fbd651ebdd)); // expecting userPay.token0 = 3.09500892839911271262401338701942831e-04
        assertTokenAmount(userPay.token0, expectedToken0, newLoanTestEpsilon);
        Quad expectedToken1 = -Quad.wrap(bytes16(0x3ff32bf22d5752b2348653fce07e7bb4)); // expecting userPay.token1 = -2.86050800657621476555638425310597702e-04
        assertTokenAmount(userPay.token1, expectedToken1, newLoanTestEpsilon);

        console.log(
            "testNewLoan_test_newloan_nontwap_with_whole_range_pour_immediate_below_mid_price_1_01000000000000000000000000000000001_and_token_mix_0_5 testing done."
        );
    }

    function testNewLoan_test_newloan_nontwap_with_whole_range_pour_immediate_above_mid_price_1_01000000000000000000000000000000001_and_token_mix_0_5(
    ) public {
        console.log(
            "testNewLoan_test_newloan_nontwap_with_whole_range_pour_immediate_above_mid_price_1_01000000000000000000000000000000001_and_token_mix_0_5 starting ......"
        );
        testLimitedRangePour(
            Quad.wrap(bytes16(0x3fff028f5c28f5c28f5c28f5c28f5c29)), // price = 1.01000000000000000000000000000000001e+00
            Quad.wrap(bytes16(0x3ff847ae147ae147ae147ae147ae147b)), // quadVar = 1.00000000000000000000000000000000002e-02
            0, // startingTub
            4096, // stoppingTub
            Quad.wrap(bytes16(0x40059000000000000000000000000000)), // liquidityPerTub = 1e+02
            Quad.wrap(bytes16(0x40058dfff5e1708f004dd48b06f1bcce)), // expected token0 = 9.94999613976431194686472991361695447e+01
            Quad.wrap(bytes16(0x400591fae0e8e994c568d4a0eb3df54b)), // expected token1 = 1.00494998587853108604312572889908098e+02
            false // skip the checks
        );
        Quad[] memory owedPotential = new Quad[](1);
        owedPotential[0] = Quad.wrap(bytes16(0x3fff0000000000000000000000000000));
        // int256 midBin = 16392;
        NewLoan.NewLoanParams memory params = NewLoan.NewLoanParams({
            owedPotential: owedPotential, // owedPotential = 1e+00
            startBin: 16393, // startBin
            strikeBin: 16393, // strikeBin
            tokenMix: Quad.wrap(bytes16(0x3ffe0000000000000000000000000000)), // tokenMix = 5e-01
            lockinEnd: POSITIVE_INFINITY,
            deadEra: OptInt256.wrap(OPT_INT256_NONE), // deadEra
            token: false, // token, unused for non-twap
            twapUntil: OptInt256.wrap(OPT_INT256_NONE) // twapUntil, disabled
        });
        UserPay.Info memory userPay = pool.newLoanOnly(params);
        Quad expectedToken0 = -Quad.wrap(bytes16(0x3ff328caa70684063cc28ce8fe1699e5)); // expecting userPay.token0 = -2.83042536836758254953017706514698016e-04
        assertTokenAmount(userPay.token0, expectedToken0, newLoanTestEpsilon);
        Quad expectedToken1 = Quad.wrap(bytes16(0x3ff347fc062923f1ad3795b45e7aa6b2)); // expecting userPay.token1 = 3.12790364270108878071678734257164438e-04
        assertTokenAmount(userPay.token1, expectedToken1, newLoanTestEpsilon);

        console.log(
            "testNewLoan_test_newloan_nontwap_with_whole_range_pour_immediate_above_mid_price_1_01000000000000000000000000000000001_and_token_mix_0_5 testing done."
        );
    }

    function testNewLoan_test_newloan_nontwap_with_whole_range_pour_far_below_mid_price_1_01000000000000000000000000000000001_and_token_mix_0_5()
        public
    {
        console.log(
            "testNewLoan_test_newloan_nontwap_with_whole_range_pour_far_below_mid_price_1_01000000000000000000000000000000001_and_token_mix_0_5 starting ......"
        );
        testLimitedRangePour(
            Quad.wrap(bytes16(0x3fff028f5c28f5c28f5c28f5c28f5c29)), // price = 1.01000000000000000000000000000000001e+00
            Quad.wrap(bytes16(0x3ff847ae147ae147ae147ae147ae147b)), // quadVar = 1.00000000000000000000000000000000002e-02
            0, // startingTub
            4096, // stoppingTub
            Quad.wrap(bytes16(0x40059000000000000000000000000000)), // liquidityPerTub = 1e+02
            Quad.wrap(bytes16(0x40058dfff5e1708f004dd48b06f1bcce)), // expected token0 = 9.94999613976431194686472991361695447e+01
            Quad.wrap(bytes16(0x400591fae0e8e994c568d4a0eb3df54b)), // expected token1 = 1.00494998587853108604312572889908098e+02
            false // skip the checks
        );
        Quad[] memory owedPotential = new Quad[](1);
        owedPotential[0] = Quad.wrap(bytes16(0x3fff0000000000000000000000000000));
        // int256 midBin = 16392;
        NewLoan.NewLoanParams memory params = NewLoan.NewLoanParams({
            owedPotential: owedPotential, // owedPotential = 1e+00
            startBin: 16382, // startBin
            strikeBin: 16382, // strikeBin
            tokenMix: Quad.wrap(bytes16(0x3ffe0000000000000000000000000000)), // tokenMix = 5e-01
            lockinEnd: POSITIVE_INFINITY,
            deadEra: OptInt256.wrap(OPT_INT256_NONE), // deadEra
            token: false, // token, unused for non-twap
            twapUntil: OptInt256.wrap(OPT_INT256_NONE) // twapUntil, disabled
        });
        UserPay.Info memory userPay = pool.newLoanOnly(params);
        Quad expectedToken0 = Quad.wrap(bytes16(0x3ff3465b539b0c9861af7816fcda4537)); // expecting userPay.token0 = 3.11238045188088117268002115751328524e-04
        assertTokenAmount(userPay.token0, expectedToken0, newLoanTestEpsilon);
        Quad expectedToken1 = -Quad.wrap(bytes16(0x3ff32d8840f729fc4b0775037ce87513)); // expecting userPay.token1 = -2.87563554091093802579072526644361927e-04
        assertTokenAmount(userPay.token1, expectedToken1, newLoanTestEpsilon);

        console.log(
            "testNewLoan_test_newloan_nontwap_with_whole_range_pour_far_below_mid_price_1_01000000000000000000000000000000001_and_token_mix_0_5 testing done."
        );
    }

    function testNewLoan_test_newloan_nontwap_with_whole_range_pour_far_above_mid_price_1_01000000000000000000000000000000001_and_token_mix_0_5()
        public
    {
        console.log(
            "testNewLoan_test_newloan_nontwap_with_whole_range_pour_far_above_mid_price_1_01000000000000000000000000000000001_and_token_mix_0_5 starting ......"
        );
        testLimitedRangePour(
            Quad.wrap(bytes16(0x3fff028f5c28f5c28f5c28f5c28f5c29)), // price = 1.01000000000000000000000000000000001e+00
            Quad.wrap(bytes16(0x3ff847ae147ae147ae147ae147ae147b)), // quadVar = 1.00000000000000000000000000000000002e-02
            0, // startingTub
            4096, // stoppingTub
            Quad.wrap(bytes16(0x40059000000000000000000000000000)), // liquidityPerTub = 1e+02
            Quad.wrap(bytes16(0x40058dfff5e1708f004dd48b06f1bcce)), // expected token0 = 9.94999613976431194686472991361695447e+01
            Quad.wrap(bytes16(0x400591fae0e8e994c568d4a0eb3df54b)), // expected token1 = 1.00494998587853108604312572889908098e+02
            false // skip the checks
        );
        Quad[] memory owedPotential = new Quad[](1);
        owedPotential[0] = Quad.wrap(bytes16(0x3fff0000000000000000000000000000));
        // int256 midBin = 16392;
        NewLoan.NewLoanParams memory params = NewLoan.NewLoanParams({
            owedPotential: owedPotential, // owedPotential = 1e+00
            startBin: 16402, // startBin
            strikeBin: 16402, // strikeBin
            tokenMix: Quad.wrap(bytes16(0x3ffe0000000000000000000000000000)), // tokenMix = 5e-01
            lockinEnd: POSITIVE_INFINITY,
            deadEra: OptInt256.wrap(OPT_INT256_NONE), // deadEra
            token: false, // token, unused for non-twap
            twapUntil: OptInt256.wrap(OPT_INT256_NONE) // twapUntil, disabled
        });
        UserPay.Info memory userPay = pool.newLoanOnly(params);
        Quad expectedToken0 = -Quad.wrap(bytes16(0x3ff32a5c75658bbfd2692c6250a8065e)); // expecting userPay.token0 = -2.84539381342818599033189739648023732e-04
        assertTokenAmount(userPay.token0, expectedToken0, newLoanTestEpsilon);
        Quad expectedToken1 = Quad.wrap(bytes16(0x3ff349d34b20db33c17b3d71d4bcfa8c)); // expecting userPay.token1 = 3.14545979611935904394652078827108055e-04
        assertTokenAmount(userPay.token1, expectedToken1, newLoanTestEpsilon);

        console.log(
            "testNewLoan_test_newloan_nontwap_with_whole_range_pour_far_above_mid_price_1_01000000000000000000000000000000001_and_token_mix_0_5 testing done."
        );
    }

    function testNewLoan_test_newloan_nontwap_with_whole_range_pour_immediate_below_mid_price_1_01000000000000000000000000000000001_and_token_mix_0_75(
    ) public {
        console.log(
            "testNewLoan_test_newloan_nontwap_with_whole_range_pour_immediate_below_mid_price_1_01000000000000000000000000000000001_and_token_mix_0_75 starting ......"
        );
        testLimitedRangePour(
            Quad.wrap(bytes16(0x3fff028f5c28f5c28f5c28f5c28f5c29)), // price = 1.01000000000000000000000000000000001e+00
            Quad.wrap(bytes16(0x3ff847ae147ae147ae147ae147ae147b)), // quadVar = 1.00000000000000000000000000000000002e-02
            0, // startingTub
            4096, // stoppingTub
            Quad.wrap(bytes16(0x40059000000000000000000000000000)), // liquidityPerTub = 1e+02
            Quad.wrap(bytes16(0x40058dfff5e1708f004dd48b06f1bcce)), // expected token0 = 9.94999613976431194686472991361695447e+01
            Quad.wrap(bytes16(0x400591fae0e8e994c568d4a0eb3df54b)), // expected token1 = 1.00494998587853108604312572889908098e+02
            false // skip the checks
        );
        Quad[] memory owedPotential = new Quad[](1);
        owedPotential[0] = Quad.wrap(bytes16(0x3fff0000000000000000000000000000));
        // int256 midBin = 16392;
        NewLoan.NewLoanParams memory params = NewLoan.NewLoanParams({
            owedPotential: owedPotential, // owedPotential = 1e+00
            startBin: 16391, // startBin
            strikeBin: 16391, // strikeBin
            tokenMix: Quad.wrap(bytes16(0x3ffe8000000000000000000000000000)), // tokenMix = 7.5e-01
            lockinEnd: POSITIVE_INFINITY,
            deadEra: OptInt256.wrap(OPT_INT256_NONE), // deadEra
            token: false, // token, unused for non-twap
            twapUntil: OptInt256.wrap(OPT_INT256_NONE) // twapUntil, disabled
        });
        UserPay.Info memory userPay = pool.newLoanOnly(params);
        Quad expectedToken0 = Quad.wrap(bytes16(0x3ff244890367c0a903d5b3fbd651ebdd)); // expecting userPay.token0 = 1.54750446419955635631200669350971415e-04
        assertTokenAmount(userPay.token0, expectedToken0, newLoanTestEpsilon);
        Quad expectedToken1 = -Quad.wrap(bytes16(0x3ff21050b2efab77fa9b46569ff2218a)); // expecting userPay.token1 = -1.29850020575469201367364845970107984e-04
        assertTokenAmount(userPay.token1, expectedToken1, newLoanTestEpsilon);

        console.log(
            "testNewLoan_test_newloan_nontwap_with_whole_range_pour_immediate_below_mid_price_1_01000000000000000000000000000000001_and_token_mix_0_75 testing done."
        );
    }

    function testNewLoan_test_newloan_nontwap_with_whole_range_pour_immediate_above_mid_price_1_01000000000000000000000000000000001_and_token_mix_0_75(
    ) public {
        console.log(
            "testNewLoan_test_newloan_nontwap_with_whole_range_pour_immediate_above_mid_price_1_01000000000000000000000000000000001_and_token_mix_0_75 starting ......"
        );
        testLimitedRangePour(
            Quad.wrap(bytes16(0x3fff028f5c28f5c28f5c28f5c28f5c29)), // price = 1.01000000000000000000000000000000001e+00
            Quad.wrap(bytes16(0x3ff847ae147ae147ae147ae147ae147b)), // quadVar = 1.00000000000000000000000000000000002e-02
            0, // startingTub
            4096, // stoppingTub
            Quad.wrap(bytes16(0x40059000000000000000000000000000)), // liquidityPerTub = 1e+02
            Quad.wrap(bytes16(0x40058dfff5e1708f004dd48b06f1bcce)), // expected token0 = 9.94999613976431194686472991361695447e+01
            Quad.wrap(bytes16(0x400591fae0e8e994c568d4a0eb3df54b)), // expected token1 = 1.00494998587853108604312572889908098e+02
            false // skip the checks
        );
        Quad[] memory owedPotential = new Quad[](1);
        owedPotential[0] = Quad.wrap(bytes16(0x3fff0000000000000000000000000000));
        // int256 midBin = 16392;
        NewLoan.NewLoanParams memory params = NewLoan.NewLoanParams({
            owedPotential: owedPotential, // owedPotential = 1e+00
            startBin: 16393, // startBin
            strikeBin: 16393, // strikeBin
            tokenMix: Quad.wrap(bytes16(0x3ffe8000000000000000000000000000)), // tokenMix = 7.5e-01
            lockinEnd: POSITIVE_INFINITY,
            deadEra: OptInt256.wrap(OPT_INT256_NONE), // deadEra
            token: false, // token, unused for non-twap
            twapUntil: OptInt256.wrap(OPT_INT256_NONE) // twapUntil, disabled
        });
        UserPay.Info memory userPay = pool.newLoanOnly(params);
        Quad expectedToken0 = -Quad.wrap(bytes16(0x3ff3cadb86036a3f9d3aef9889d27356)); // expecting userPay.token0 = -4.37600625640188421548501521961097002e-04
        assertTokenAmount(userPay.token0, expectedToken0, newLoanTestEpsilon);
        Quad expectedToken1 = Quad.wrap(bytes16(0x3ff3ebfa093db5ea83d3608e8db7fa0a)); // expecting userPay.token1 = 4.69185546405163317107518101385746609e-04
        assertTokenAmount(userPay.token1, expectedToken1, newLoanTestEpsilon);

        console.log(
            "testNewLoan_test_newloan_nontwap_with_whole_range_pour_immediate_above_mid_price_1_01000000000000000000000000000000001_and_token_mix_0_75 testing done."
        );
    }

    function testNewLoan_test_newloan_nontwap_with_whole_range_pour_far_below_mid_price_1_01000000000000000000000000000000001_and_token_mix_0_75()
        public
    {
        console.log(
            "testNewLoan_test_newloan_nontwap_with_whole_range_pour_far_below_mid_price_1_01000000000000000000000000000000001_and_token_mix_0_75 starting ......"
        );
        testLimitedRangePour(
            Quad.wrap(bytes16(0x3fff028f5c28f5c28f5c28f5c28f5c29)), // price = 1.01000000000000000000000000000000001e+00
            Quad.wrap(bytes16(0x3ff847ae147ae147ae147ae147ae147b)), // quadVar = 1.00000000000000000000000000000000002e-02
            0, // startingTub
            4096, // stoppingTub
            Quad.wrap(bytes16(0x40059000000000000000000000000000)), // liquidityPerTub = 1e+02
            Quad.wrap(bytes16(0x40058dfff5e1708f004dd48b06f1bcce)), // expected token0 = 9.94999613976431194686472991361695447e+01
            Quad.wrap(bytes16(0x400591fae0e8e994c568d4a0eb3df54b)), // expected token1 = 1.00494998587853108604312572889908098e+02
            false // skip the checks
        );
        Quad[] memory owedPotential = new Quad[](1);
        owedPotential[0] = Quad.wrap(bytes16(0x3fff0000000000000000000000000000));
        // int256 midBin = 16392;
        NewLoan.NewLoanParams memory params = NewLoan.NewLoanParams({
            owedPotential: owedPotential, // owedPotential = 1e+00
            startBin: 16382, // startBin
            strikeBin: 16382, // strikeBin
            tokenMix: Quad.wrap(bytes16(0x3ffe8000000000000000000000000000)), // tokenMix = 7.5e-01
            lockinEnd: POSITIVE_INFINITY,
            deadEra: OptInt256.wrap(OPT_INT256_NONE), // deadEra
            token: false, // token, unused for non-twap
            twapUntil: OptInt256.wrap(OPT_INT256_NONE) // twapUntil, disabled
        });
        UserPay.Info memory userPay = pool.newLoanOnly(params);
        Quad expectedToken0 = Quad.wrap(bytes16(0x3ff2465b539b0c9861af7816fcda4537)); // expecting userPay.token0 = 1.55619022594044058634001057875664262e-04
        assertTokenAmount(userPay.token0, expectedToken0, newLoanTestEpsilon);
        Quad expectedToken1 = -Quad.wrap(bytes16(0x3ff21550e8a7996f51ccd0223aac155c)); // expecting userPay.token1 = -1.32234597219830756422678408526514663e-04
        assertTokenAmount(userPay.token1, expectedToken1, newLoanTestEpsilon);

        console.log(
            "testNewLoan_test_newloan_nontwap_with_whole_range_pour_far_below_mid_price_1_01000000000000000000000000000000001_and_token_mix_0_75 testing done."
        );
    }

    function testNewLoan_test_newloan_nontwap_with_whole_range_pour_far_above_mid_price_1_01000000000000000000000000000000001_and_token_mix_0_75()
        public
    {
        console.log(
            "testNewLoan_test_newloan_nontwap_with_whole_range_pour_far_above_mid_price_1_01000000000000000000000000000000001_and_token_mix_0_75 starting ......"
        );
        testLimitedRangePour(
            Quad.wrap(bytes16(0x3fff028f5c28f5c28f5c28f5c28f5c29)), // price = 1.01000000000000000000000000000000001e+00
            Quad.wrap(bytes16(0x3ff847ae147ae147ae147ae147ae147b)), // quadVar = 1.00000000000000000000000000000000002e-02
            0, // startingTub
            4096, // stoppingTub
            Quad.wrap(bytes16(0x40059000000000000000000000000000)), // liquidityPerTub = 1e+02
            Quad.wrap(bytes16(0x40058dfff5e1708f004dd48b06f1bcce)), // expected token0 = 9.94999613976431194686472991361695447e+01
            Quad.wrap(bytes16(0x400591fae0e8e994c568d4a0eb3df54b)), // expected token1 = 1.00494998587853108604312572889908098e+02
            false // skip the checks
        );
        Quad[] memory owedPotential = new Quad[](1);
        owedPotential[0] = Quad.wrap(bytes16(0x3fff0000000000000000000000000000));
        // int256 midBin = 16392;
        NewLoan.NewLoanParams memory params = NewLoan.NewLoanParams({
            owedPotential: owedPotential, // owedPotential = 1e+00
            startBin: 16402, // startBin
            strikeBin: 16402, // strikeBin
            tokenMix: Quad.wrap(bytes16(0x3ffe8000000000000000000000000000)), // tokenMix = 7.5e-01
            lockinEnd: POSITIVE_INFINITY,
            deadEra: OptInt256.wrap(OPT_INT256_NONE), // deadEra
            token: false, // token, unused for non-twap
            twapUntil: OptInt256.wrap(OPT_INT256_NONE) // twapUntil, disabled
        });
        UserPay.Info memory userPay = pool.newLoanOnly(params);
        Quad expectedToken0 = -Quad.wrap(bytes16(0x3ff3cb85c3355a51645a9cbf1491c6da)); // expecting userPay.token0 = -4.38234815496389526485692044568527573e-04
        assertTokenAmount(userPay.token0, expectedToken0, newLoanTestEpsilon);
        Quad expectedToken1 = Quad.wrap(bytes16(0x3ff3eebcf0b148cda238dc2abf1b77d2)); // expecting userPay.token1 = 4.71818969417903856591978118240662082e-04
        assertTokenAmount(userPay.token1, expectedToken1, newLoanTestEpsilon);

        console.log(
            "testNewLoan_test_newloan_nontwap_with_whole_range_pour_far_above_mid_price_1_01000000000000000000000000000000001_and_token_mix_0_75 testing done."
        );
    }

    function testNewLoan_test_newloan_nontwap_with_whole_range_pour_immediate_below_mid_price_1_01000000000000000000000000000000001_and_token_mix_1()
        public
    {
        console.log(
            "testNewLoan_test_newloan_nontwap_with_whole_range_pour_immediate_below_mid_price_1_01000000000000000000000000000000001_and_token_mix_1 starting ......"
        );
        testLimitedRangePour(
            Quad.wrap(bytes16(0x3fff028f5c28f5c28f5c28f5c28f5c29)), // price = 1.01000000000000000000000000000000001e+00
            Quad.wrap(bytes16(0x3ff847ae147ae147ae147ae147ae147b)), // quadVar = 1.00000000000000000000000000000000002e-02
            0, // startingTub
            4096, // stoppingTub
            Quad.wrap(bytes16(0x40059000000000000000000000000000)), // liquidityPerTub = 1e+02
            Quad.wrap(bytes16(0x40058dfff5e1708f004dd48b06f1bcce)), // expected token0 = 9.94999613976431194686472991361695447e+01
            Quad.wrap(bytes16(0x400591fae0e8e994c568d4a0eb3df54b)), // expected token1 = 1.00494998587853108604312572889908098e+02
            false // skip the checks
        );
        Quad[] memory owedPotential = new Quad[](1);
        owedPotential[0] = Quad.wrap(bytes16(0x3fff0000000000000000000000000000));
        // int256 midBin = 16392;
        NewLoan.NewLoanParams memory params = NewLoan.NewLoanParams({
            owedPotential: owedPotential, // owedPotential = 1e+00
            startBin: 16391, // startBin
            strikeBin: 16391, // strikeBin
            tokenMix: Quad.wrap(bytes16(0x3fff0000000000000000000000000000)), // tokenMix = 1e+00
            lockinEnd: POSITIVE_INFINITY,
            deadEra: OptInt256.wrap(OPT_INT256_NONE), // deadEra
            token: false, // token, unused for non-twap
            twapUntil: OptInt256.wrap(OPT_INT256_NONE) // twapUntil, disabled
        });
        UserPay.Info memory userPay = pool.newLoanOnly(params);
        Quad expectedToken0 = POSITIVE_ZERO; // expecting userPay.token0 = 0e+00
        assertTokenAmount(userPay.token0, expectedToken0, newLoanTestEpsilon);
        Quad expectedToken1 = Quad.wrap(bytes16(0x3fefba17a67a73a39eb0da6408c5a280)); // expecting userPay.token1 = 2.63507595066830738209087333703816386e-05
        assertTokenAmount(userPay.token1, expectedToken1, newLoanTestEpsilon);

        console.log(
            "testNewLoan_test_newloan_nontwap_with_whole_range_pour_immediate_below_mid_price_1_01000000000000000000000000000000001_and_token_mix_1 testing done."
        );
    }

    function testNewLoan_test_newloan_nontwap_with_whole_range_pour_immediate_above_mid_price_1_01000000000000000000000000000000001_and_token_mix_1()
        public
    {
        console.log(
            "testNewLoan_test_newloan_nontwap_with_whole_range_pour_immediate_above_mid_price_1_01000000000000000000000000000000001_and_token_mix_1 starting ......"
        );
        testLimitedRangePour(
            Quad.wrap(bytes16(0x3fff028f5c28f5c28f5c28f5c28f5c29)), // price = 1.01000000000000000000000000000000001e+00
            Quad.wrap(bytes16(0x3ff847ae147ae147ae147ae147ae147b)), // quadVar = 1.00000000000000000000000000000000002e-02
            0, // startingTub
            4096, // stoppingTub
            Quad.wrap(bytes16(0x40059000000000000000000000000000)), // liquidityPerTub = 1e+02
            Quad.wrap(bytes16(0x40058dfff5e1708f004dd48b06f1bcce)), // expected token0 = 9.94999613976431194686472991361695447e+01
            Quad.wrap(bytes16(0x400591fae0e8e994c568d4a0eb3df54b)), // expected token1 = 1.00494998587853108604312572889908098e+02
            false // skip the checks
        );
        Quad[] memory owedPotential = new Quad[](1);
        owedPotential[0] = Quad.wrap(bytes16(0x3fff0000000000000000000000000000));
        // int256 midBin = 16392;
        NewLoan.NewLoanParams memory params = NewLoan.NewLoanParams({
            owedPotential: owedPotential, // owedPotential = 1e+00
            startBin: 16393, // startBin
            strikeBin: 16393, // strikeBin
            tokenMix: Quad.wrap(bytes16(0x3fff0000000000000000000000000000)), // tokenMix = 1e+00
            lockinEnd: POSITIVE_INFINITY,
            deadEra: OptInt256.wrap(OPT_INT256_NONE), // deadEra
            token: false, // token, unused for non-twap
            twapUntil: OptInt256.wrap(OPT_INT256_NONE) // twapUntil, disabled
        });
        UserPay.Info memory userPay = pool.newLoanOnly(params);
        Quad expectedToken0 = -Quad.wrap(bytes16(0x3ff436763280283c7ed9a9240ac72664)); // expecting userPay.token0 = -5.92158714443618588143985337407496034e-04
        assertTokenAmount(userPay.token0, expectedToken0, newLoanTestEpsilon);
        Quad expectedToken1 = Quad.wrap(bytes16(0x3ff447fc062923f1ad3795b45e7aa6b2)); // expecting userPay.token1 = 6.25580728540217756143357468514328875e-04
        assertTokenAmount(userPay.token1, expectedToken1, newLoanTestEpsilon);

        console.log(
            "testNewLoan_test_newloan_nontwap_with_whole_range_pour_immediate_above_mid_price_1_01000000000000000000000000000000001_and_token_mix_1 testing done."
        );
    }

    function testNewLoan_test_newloan_nontwap_with_whole_range_pour_far_below_mid_price_1_01000000000000000000000000000000001_and_token_mix_1()
        public
    {
        console.log(
            "testNewLoan_test_newloan_nontwap_with_whole_range_pour_far_below_mid_price_1_01000000000000000000000000000000001_and_token_mix_1 starting ......"
        );
        testLimitedRangePour(
            Quad.wrap(bytes16(0x3fff028f5c28f5c28f5c28f5c28f5c29)), // price = 1.01000000000000000000000000000000001e+00
            Quad.wrap(bytes16(0x3ff847ae147ae147ae147ae147ae147b)), // quadVar = 1.00000000000000000000000000000000002e-02
            0, // startingTub
            4096, // stoppingTub
            Quad.wrap(bytes16(0x40059000000000000000000000000000)), // liquidityPerTub = 1e+02
            Quad.wrap(bytes16(0x40058dfff5e1708f004dd48b06f1bcce)), // expected token0 = 9.94999613976431194686472991361695447e+01
            Quad.wrap(bytes16(0x400591fae0e8e994c568d4a0eb3df54b)), // expected token1 = 1.00494998587853108604312572889908098e+02
            false // skip the checks
        );
        Quad[] memory owedPotential = new Quad[](1);
        owedPotential[0] = Quad.wrap(bytes16(0x3fff0000000000000000000000000000));
        // int256 midBin = 16392;
        NewLoan.NewLoanParams memory params = NewLoan.NewLoanParams({
            owedPotential: owedPotential, // owedPotential = 1e+00
            startBin: 16382, // startBin
            strikeBin: 16382, // strikeBin
            tokenMix: Quad.wrap(bytes16(0x3fff0000000000000000000000000000)), // tokenMix = 1e+00
            lockinEnd: POSITIVE_INFINITY,
            deadEra: OptInt256.wrap(OPT_INT256_NONE), // deadEra
            token: false, // token, unused for non-twap
            twapUntil: OptInt256.wrap(OPT_INT256_NONE) // twapUntil, disabled
        });
        UserPay.Info memory userPay = pool.newLoanOnly(params);
        Quad expectedToken0 = POSITIVE_ZERO; // expecting userPay.token0 = 0e+00
        assertTokenAmount(userPay.token0, expectedToken0, newLoanTestEpsilon);
        Quad expectedToken1 = Quad.wrap(bytes16(0x3fef837584f908cf93aa4e1423c5fb80)); // expecting userPay.token1 = 2.30943596514322897337157095913326479e-05
        assertTokenAmount(userPay.token1, expectedToken1, newLoanTestEpsilon);

        console.log(
            "testNewLoan_test_newloan_nontwap_with_whole_range_pour_far_below_mid_price_1_01000000000000000000000000000000001_and_token_mix_1 testing done."
        );
    }

    function testNewLoan_test_newloan_nontwap_with_whole_range_pour_far_above_mid_price_1_01000000000000000000000000000000001_and_token_mix_1()
        public
    {
        console.log(
            "testNewLoan_test_newloan_nontwap_with_whole_range_pour_far_above_mid_price_1_01000000000000000000000000000000001_and_token_mix_1 starting ......"
        );
        testLimitedRangePour(
            Quad.wrap(bytes16(0x3fff028f5c28f5c28f5c28f5c28f5c29)), // price = 1.01000000000000000000000000000000001e+00
            Quad.wrap(bytes16(0x3ff847ae147ae147ae147ae147ae147b)), // quadVar = 1.00000000000000000000000000000000002e-02
            0, // startingTub
            4096, // stoppingTub
            Quad.wrap(bytes16(0x40059000000000000000000000000000)), // liquidityPerTub = 1e+02
            Quad.wrap(bytes16(0x40058dfff5e1708f004dd48b06f1bcce)), // expected token0 = 9.94999613976431194686472991361695447e+01
            Quad.wrap(bytes16(0x400591fae0e8e994c568d4a0eb3df54b)), // expected token1 = 1.00494998587853108604312572889908098e+02
            false // skip the checks
        );
        Quad[] memory owedPotential = new Quad[](1);
        owedPotential[0] = Quad.wrap(bytes16(0x3fff0000000000000000000000000000));
        // int256 midBin = 16392;
        NewLoan.NewLoanParams memory params = NewLoan.NewLoanParams({
            owedPotential: owedPotential, // owedPotential = 1e+00
            startBin: 16402, // startBin
            strikeBin: 16402, // strikeBin
            tokenMix: Quad.wrap(bytes16(0x3fff0000000000000000000000000000)), // tokenMix = 1e+00
            lockinEnd: POSITIVE_INFINITY,
            deadEra: OptInt256.wrap(OPT_INT256_NONE), // deadEra
            token: false, // token, unused for non-twap
            twapUntil: OptInt256.wrap(OPT_INT256_NONE) // twapUntil, disabled
        });
        UserPay.Info memory userPay = pool.newLoanOnly(params);
        Quad expectedToken0 = -Quad.wrap(bytes16(0x3ff43657888294717b26068dec3dc3ab)); // expecting userPay.token0 = -5.91930249649960453938194349489031414e-04
        assertTokenAmount(userPay.token0, expectedToken0, newLoanTestEpsilon);
        Quad expectedToken1 = Quad.wrap(bytes16(0x3ff449d34b20db33c17b3d71d4bcfa8c)); // expecting userPay.token1 = 6.2909195922387180878930415765421611e-04
        assertTokenAmount(userPay.token1, expectedToken1, newLoanTestEpsilon);

        console.log(
            "testNewLoan_test_newloan_nontwap_with_whole_range_pour_far_above_mid_price_1_01000000000000000000000000000000001_and_token_mix_1 testing done."
        );
    }

    function testNewLoan_test_newloan_nontwap_with_whole_range_pour_immediate_below_mid_price_1_01000000010000000000000000000000008_and_token_mix_0()
        public
    {
        console.log(
            "testNewLoan_test_newloan_nontwap_with_whole_range_pour_immediate_below_mid_price_1_01000000010000000000000000000000008_and_token_mix_0 starting ......"
        );
        testLimitedRangePour(
            Quad.wrap(bytes16(0x3fff028f5c2963b60ec387ecad6eb6e3)), // price = 1.01000000010000000000000000000000008e+00
            Quad.wrap(bytes16(0x3ff847ae147ae147ae147ae147ae147b)), // quadVar = 1.00000000000000000000000000000000002e-02
            0, // startingTub
            4096, // stoppingTub
            Quad.wrap(bytes16(0x40059000000000000000000000000000)), // liquidityPerTub = 1e+02
            Quad.wrap(bytes16(0x40058dfff5e11bf5481994e97fd03d01)), // expected token0 = 9.94999613927187241734703956751371456e+01
            Quad.wrap(bytes16(0x400591fae0e93f14acf66aefe129ef90)), // expected token1 = 1.00494998592829841899182623144569888e+02
            false // skip the checks
        );
        Quad[] memory owedPotential = new Quad[](1);
        owedPotential[0] = Quad.wrap(bytes16(0x3fff0000000000000000000000000000));
        // int256 midBin = 16392;
        NewLoan.NewLoanParams memory params = NewLoan.NewLoanParams({
            owedPotential: owedPotential, // owedPotential = 1e+00
            startBin: 16391, // startBin
            strikeBin: 16391, // strikeBin
            tokenMix: POSITIVE_ZERO, // tokenMix = 0e+00
            lockinEnd: POSITIVE_INFINITY,
            deadEra: OptInt256.wrap(OPT_INT256_NONE), // deadEra
            token: false, // token, unused for non-twap
            twapUntil: OptInt256.wrap(OPT_INT256_NONE) // twapUntil, disabled
        });
        UserPay.Info memory userPay = pool.newLoanOnly(params);
        Quad expectedToken0 = Quad.wrap(bytes16(0x3ff444890367c0a903d5b3fbd651ebdd)); // expecting userPay.token0 = 6.19001785679822542524802677403885662e-04
        assertTokenAmount(userPay.token0, expectedToken0, newLoanTestEpsilon);
        Quad expectedToken1 = -Quad.wrap(bytes16(0x3ff439c2ea8b264f517bdad000c4a8c8)); // expecting userPay.token1 = -5.98452360821926026932185583991577042e-04
        assertTokenAmount(userPay.token1, expectedToken1, newLoanTestEpsilon);

        console.log(
            "testNewLoan_test_newloan_nontwap_with_whole_range_pour_immediate_below_mid_price_1_01000000010000000000000000000000008_and_token_mix_0 testing done."
        );
    }

    function testNewLoan_test_newloan_nontwap_with_whole_range_pour_immediate_above_mid_price_1_01000000010000000000000000000000008_and_token_mix_0()
        public
    {
        console.log(
            "testNewLoan_test_newloan_nontwap_with_whole_range_pour_immediate_above_mid_price_1_01000000010000000000000000000000008_and_token_mix_0 starting ......"
        );
        testLimitedRangePour(
            Quad.wrap(bytes16(0x3fff028f5c2963b60ec387ecad6eb6e3)), // price = 1.01000000010000000000000000000000008e+00
            Quad.wrap(bytes16(0x3ff847ae147ae147ae147ae147ae147b)), // quadVar = 1.00000000000000000000000000000000002e-02
            0, // startingTub
            4096, // stoppingTub
            Quad.wrap(bytes16(0x40059000000000000000000000000000)), // liquidityPerTub = 1e+02
            Quad.wrap(bytes16(0x40058dfff5e11bf5481994e97fd03d01)), // expected token0 = 9.94999613927187241734703956751371456e+01
            Quad.wrap(bytes16(0x400591fae0e93f14acf66aefe129ef90)), // expected token1 = 1.00494998592829841899182623144569888e+02
            false // skip the checks
        );
        Quad[] memory owedPotential = new Quad[](1);
        owedPotential[0] = Quad.wrap(bytes16(0x3fff0000000000000000000000000000));
        // int256 midBin = 16392;
        NewLoan.NewLoanParams memory params = NewLoan.NewLoanParams({
            owedPotential: owedPotential, // owedPotential = 1e+00
            startBin: 16393, // startBin
            strikeBin: 16393, // strikeBin
            tokenMix: POSITIVE_ZERO, // tokenMix = 0e+00
            lockinEnd: POSITIVE_INFINITY,
            deadEra: OptInt256.wrap(OPT_INT256_NONE), // deadEra
            token: false, // token, unused for non-twap
            twapUntil: OptInt256.wrap(OPT_INT256_NONE) // twapUntil, disabled
        });
        UserPay.Info memory userPay = pool.newLoanOnly(params);
        Quad expectedToken0 = Quad.wrap(bytes16(0x3fefb5716f3486c842e3876196118fe0)); // expecting userPay.token0 = 2.6073640770102078237949924378100002e-05
        assertTokenAmount(userPay.token0, expectedToken0, newLoanTestEpsilon);
        Quad expectedToken1 = POSITIVE_ZERO; // expecting userPay.token1 = 0e+00
        assertTokenAmount(userPay.token1, expectedToken1, newLoanTestEpsilon);

        console.log(
            "testNewLoan_test_newloan_nontwap_with_whole_range_pour_immediate_above_mid_price_1_01000000010000000000000000000000008_and_token_mix_0 testing done."
        );
    }

    function testNewLoan_test_newloan_nontwap_with_whole_range_pour_far_below_mid_price_1_01000000010000000000000000000000008_and_token_mix_0()
        public
    {
        console.log(
            "testNewLoan_test_newloan_nontwap_with_whole_range_pour_far_below_mid_price_1_01000000010000000000000000000000008_and_token_mix_0 starting ......"
        );
        testLimitedRangePour(
            Quad.wrap(bytes16(0x3fff028f5c2963b60ec387ecad6eb6e3)), // price = 1.01000000010000000000000000000000008e+00
            Quad.wrap(bytes16(0x3ff847ae147ae147ae147ae147ae147b)), // quadVar = 1.00000000000000000000000000000000002e-02
            0, // startingTub
            4096, // stoppingTub
            Quad.wrap(bytes16(0x40059000000000000000000000000000)), // liquidityPerTub = 1e+02
            Quad.wrap(bytes16(0x40058dfff5e11bf5481994e97fd03d01)), // expected token0 = 9.94999613927187241734703956751371456e+01
            Quad.wrap(bytes16(0x400591fae0e93f14acf66aefe129ef90)), // expected token1 = 1.00494998592829841899182623144569888e+02
            false // skip the checks
        );
        Quad[] memory owedPotential = new Quad[](1);
        owedPotential[0] = Quad.wrap(bytes16(0x3fff0000000000000000000000000000));
        // int256 midBin = 16392;
        NewLoan.NewLoanParams memory params = NewLoan.NewLoanParams({
            owedPotential: owedPotential, // owedPotential = 1e+00
            startBin: 16382, // startBin
            strikeBin: 16382, // strikeBin
            tokenMix: POSITIVE_ZERO, // tokenMix = 0e+00
            lockinEnd: POSITIVE_INFINITY,
            deadEra: OptInt256.wrap(OPT_INT256_NONE), // deadEra
            token: false, // token, unused for non-twap
            twapUntil: OptInt256.wrap(OPT_INT256_NONE) // twapUntil, disabled
        });
        UserPay.Info memory userPay = pool.newLoanOnly(params);
        Quad expectedToken0 = Quad.wrap(bytes16(0x3ff4465b539b0c9861af7816fcda4537)); // expecting userPay.token0 = 6.22476090376176234536004231502657049e-04
        assertTokenAmount(userPay.token0, expectedToken0, newLoanTestEpsilon);
        Quad expectedToken1 = -Quad.wrap(bytes16(0x3ff439a3ed1ef242c7a4c7741e06a4ef)); // expecting userPay.token1 = -5.98221467833619894891860762880056501e-04
        assertTokenAmount(userPay.token1, expectedToken1, newLoanTestEpsilon);

        console.log(
            "testNewLoan_test_newloan_nontwap_with_whole_range_pour_far_below_mid_price_1_01000000010000000000000000000000008_and_token_mix_0 testing done."
        );
    }

    function testNewLoan_test_newloan_nontwap_with_whole_range_pour_far_above_mid_price_1_01000000010000000000000000000000008_and_token_mix_0()
        public
    {
        console.log(
            "testNewLoan_test_newloan_nontwap_with_whole_range_pour_far_above_mid_price_1_01000000010000000000000000000000008_and_token_mix_0 starting ......"
        );
        testLimitedRangePour(
            Quad.wrap(bytes16(0x3fff028f5c2963b60ec387ecad6eb6e3)), // price = 1.01000000010000000000000000000000008e+00
            Quad.wrap(bytes16(0x3ff847ae147ae147ae147ae147ae147b)), // quadVar = 1.00000000000000000000000000000000002e-02
            0, // startingTub
            4096, // stoppingTub
            Quad.wrap(bytes16(0x40059000000000000000000000000000)), // liquidityPerTub = 1e+02
            Quad.wrap(bytes16(0x40058dfff5e11bf5481994e97fd03d01)), // expected token0 = 9.94999613927187241734703956751371456e+01
            Quad.wrap(bytes16(0x400591fae0e93f14acf66aefe129ef90)), // expected token1 = 1.00494998592829841899182623144569888e+02
            false // skip the checks
        );
        Quad[] memory owedPotential = new Quad[](1);
        owedPotential[0] = Quad.wrap(bytes16(0x3fff0000000000000000000000000000));
        // int256 midBin = 16392;
        NewLoan.NewLoanParams memory params = NewLoan.NewLoanParams({
            owedPotential: owedPotential, // owedPotential = 1e+00
            startBin: 16402, // startBin
            strikeBin: 16402, // strikeBin
            tokenMix: POSITIVE_ZERO, // tokenMix = 0e+00
            lockinEnd: POSITIVE_INFINITY,
            deadEra: OptInt256.wrap(OPT_INT256_NONE), // deadEra
            token: false, // token, unused for non-twap
            twapUntil: OptInt256.wrap(OPT_INT256_NONE) // twapUntil, disabled
        });
        UserPay.Info memory userPay = pool.newLoanOnly(params);
        Quad expectedToken0 = Quad.wrap(bytes16(0x3fef7f6263a11635179b457372b7a9a0)); // expecting userPay.token0 = 2.28514869643232558718148701929839499e-05
        assertTokenAmount(userPay.token0, expectedToken0, newLoanTestEpsilon);
        Quad expectedToken1 = POSITIVE_ZERO; // expecting userPay.token1 = 0e+00
        assertTokenAmount(userPay.token1, expectedToken1, newLoanTestEpsilon);

        console.log(
            "testNewLoan_test_newloan_nontwap_with_whole_range_pour_far_above_mid_price_1_01000000010000000000000000000000008_and_token_mix_0 testing done."
        );
    }

    function testNewLoan_test_newloan_nontwap_with_whole_range_pour_immediate_below_mid_price_1_01000000010000000000000000000000008_and_token_mix_0_25(
    ) public {
        console.log(
            "testNewLoan_test_newloan_nontwap_with_whole_range_pour_immediate_below_mid_price_1_01000000010000000000000000000000008_and_token_mix_0_25 starting ......"
        );
        testLimitedRangePour(
            Quad.wrap(bytes16(0x3fff028f5c2963b60ec387ecad6eb6e3)), // price = 1.01000000010000000000000000000000008e+00
            Quad.wrap(bytes16(0x3ff847ae147ae147ae147ae147ae147b)), // quadVar = 1.00000000000000000000000000000000002e-02
            0, // startingTub
            4096, // stoppingTub
            Quad.wrap(bytes16(0x40059000000000000000000000000000)), // liquidityPerTub = 1e+02
            Quad.wrap(bytes16(0x40058dfff5e11bf5481994e97fd03d01)), // expected token0 = 9.94999613927187241734703956751371456e+01
            Quad.wrap(bytes16(0x400591fae0e93f14acf66aefe129ef90)), // expected token1 = 1.00494998592829841899182623144569888e+02
            false // skip the checks
        );
        Quad[] memory owedPotential = new Quad[](1);
        owedPotential[0] = Quad.wrap(bytes16(0x3fff0000000000000000000000000000));
        // int256 midBin = 16392;
        NewLoan.NewLoanParams memory params = NewLoan.NewLoanParams({
            owedPotential: owedPotential, // owedPotential = 1e+00
            startBin: 16391, // startBin
            strikeBin: 16391, // strikeBin
            tokenMix: Quad.wrap(bytes16(0x3ffd0000000000000000000000000000)), // tokenMix = 2.5e-01
            lockinEnd: POSITIVE_INFINITY,
            deadEra: OptInt256.wrap(OPT_INT256_NONE), // deadEra
            token: false, // token, unused for non-twap
            twapUntil: OptInt256.wrap(OPT_INT256_NONE) // twapUntil, disabled
        });
        UserPay.Info memory userPay = pool.newLoanOnly(params);
        Quad expectedToken0 = Quad.wrap(bytes16(0x3ff3e6cd851ba0fd85c08df9c17ae1cb)); // expecting userPay.token0 = 4.64251339259866906893602008052914223e-04
        assertTokenAmount(userPay.token0, expectedToken0, newLoanTestEpsilon);
        Quad expectedToken1 = -Quad.wrap(bytes16(0x3ff3cfbc0136cfa86bbf04ce7103e6a2)); // expecting userPay.token1 = -4.42251580739773751743912004651087372e-04
        assertTokenAmount(userPay.token1, expectedToken1, newLoanTestEpsilon);

        console.log(
            "testNewLoan_test_newloan_nontwap_with_whole_range_pour_immediate_below_mid_price_1_01000000010000000000000000000000008_and_token_mix_0_25 testing done."
        );
    }

    function testNewLoan_test_newloan_nontwap_with_whole_range_pour_immediate_above_mid_price_1_01000000010000000000000000000000008_and_token_mix_0_25(
    ) public {
        console.log(
            "testNewLoan_test_newloan_nontwap_with_whole_range_pour_immediate_above_mid_price_1_01000000010000000000000000000000008_and_token_mix_0_25 starting ......"
        );
        testLimitedRangePour(
            Quad.wrap(bytes16(0x3fff028f5c2963b60ec387ecad6eb6e3)), // price = 1.01000000010000000000000000000000008e+00
            Quad.wrap(bytes16(0x3ff847ae147ae147ae147ae147ae147b)), // quadVar = 1.00000000000000000000000000000000002e-02
            0, // startingTub
            4096, // stoppingTub
            Quad.wrap(bytes16(0x40059000000000000000000000000000)), // liquidityPerTub = 1e+02
            Quad.wrap(bytes16(0x40058dfff5e11bf5481994e97fd03d01)), // expected token0 = 9.94999613927187241734703956751371456e+01
            Quad.wrap(bytes16(0x400591fae0e93f14acf66aefe129ef90)), // expected token1 = 1.00494998592829841899182623144569888e+02
            false // skip the checks
        );
        Quad[] memory owedPotential = new Quad[](1);
        owedPotential[0] = Quad.wrap(bytes16(0x3fff0000000000000000000000000000));
        // int256 midBin = 16392;
        NewLoan.NewLoanParams memory params = NewLoan.NewLoanParams({
            owedPotential: owedPotential, // owedPotential = 1e+00
            startBin: 16393, // startBin
            strikeBin: 16393, // strikeBin
            tokenMix: Quad.wrap(bytes16(0x3ffd0000000000000000000000000000)), // tokenMix = 2.5e-01
            lockinEnd: POSITIVE_INFINITY,
            deadEra: OptInt256.wrap(OPT_INT256_NONE), // deadEra
            token: false, // token, unused for non-twap
            twapUntil: OptInt256.wrap(OPT_INT256_NONE) // twapUntil, disabled
        });
        UserPay.Info memory userPay = pool.newLoanOnly(params);
        Quad expectedToken0 = -Quad.wrap(bytes16(0x3ff20d7390133b99b8945472e4b580e4)); // expecting userPay.token0 = -1.28484448033328088357533891068298937e-04
        assertTokenAmount(userPay.token0, expectedToken0, newLoanTestEpsilon);
        Quad expectedToken1 = Quad.wrap(bytes16(0x3ff247fc062923f1ad3795b45e7aa6b2)); // expecting userPay.token1 = 1.56395182135054439035839367128582219e-04
        assertTokenAmount(userPay.token1, expectedToken1, newLoanTestEpsilon);

        console.log(
            "testNewLoan_test_newloan_nontwap_with_whole_range_pour_immediate_above_mid_price_1_01000000010000000000000000000000008_and_token_mix_0_25 testing done."
        );
    }

    function testNewLoan_test_newloan_nontwap_with_whole_range_pour_far_below_mid_price_1_01000000010000000000000000000000008_and_token_mix_0_25()
        public
    {
        console.log(
            "testNewLoan_test_newloan_nontwap_with_whole_range_pour_far_below_mid_price_1_01000000010000000000000000000000008_and_token_mix_0_25 starting ......"
        );
        testLimitedRangePour(
            Quad.wrap(bytes16(0x3fff028f5c2963b60ec387ecad6eb6e3)), // price = 1.01000000010000000000000000000000008e+00
            Quad.wrap(bytes16(0x3ff847ae147ae147ae147ae147ae147b)), // quadVar = 1.00000000000000000000000000000000002e-02
            0, // startingTub
            4096, // stoppingTub
            Quad.wrap(bytes16(0x40059000000000000000000000000000)), // liquidityPerTub = 1e+02
            Quad.wrap(bytes16(0x40058dfff5e11bf5481994e97fd03d01)), // expected token0 = 9.94999613927187241734703956751371456e+01
            Quad.wrap(bytes16(0x400591fae0e93f14acf66aefe129ef90)), // expected token1 = 1.00494998592829841899182623144569888e+02
            false // skip the checks
        );
        Quad[] memory owedPotential = new Quad[](1);
        owedPotential[0] = Quad.wrap(bytes16(0x3fff0000000000000000000000000000));
        // int256 midBin = 16392;
        NewLoan.NewLoanParams memory params = NewLoan.NewLoanParams({
            owedPotential: owedPotential, // owedPotential = 1e+00
            startBin: 16382, // startBin
            strikeBin: 16382, // strikeBin
            tokenMix: Quad.wrap(bytes16(0x3ffd0000000000000000000000000000)), // tokenMix = 2.5e-01
            lockinEnd: POSITIVE_INFINITY,
            deadEra: OptInt256.wrap(OPT_INT256_NONE), // deadEra
            token: false, // token, unused for non-twap
            twapUntil: OptInt256.wrap(OPT_INT256_NONE) // twapUntil, disabled
        });
        UserPay.Info memory userPay = pool.newLoanOnly(params);
        Quad expectedToken0 = Quad.wrap(bytes16(0x3ff3e988fd6892e4928734227b4767d2)); // expecting userPay.token0 = 4.66857067782132175902003173626992763e-04
        assertTokenAmount(userPay.token0, expectedToken0, newLoanTestEpsilon);
        Quad expectedToken1 = -Quad.wrap(bytes16(0x3ff3d0680d9a8740ed2881f5dc7adf78)); // expecting userPay.token1 = -4.4289251096235684873546664476220919e-04
        assertTokenAmount(userPay.token1, expectedToken1, newLoanTestEpsilon);

        console.log(
            "testNewLoan_test_newloan_nontwap_with_whole_range_pour_far_below_mid_price_1_01000000010000000000000000000000008_and_token_mix_0_25 testing done."
        );
    }

    function testNewLoan_test_newloan_nontwap_with_whole_range_pour_far_above_mid_price_1_01000000010000000000000000000000008_and_token_mix_0_25()
        public
    {
        console.log(
            "testNewLoan_test_newloan_nontwap_with_whole_range_pour_far_above_mid_price_1_01000000010000000000000000000000008_and_token_mix_0_25 starting ......"
        );
        testLimitedRangePour(
            Quad.wrap(bytes16(0x3fff028f5c2963b60ec387ecad6eb6e3)), // price = 1.01000000010000000000000000000000008e+00
            Quad.wrap(bytes16(0x3ff847ae147ae147ae147ae147ae147b)), // quadVar = 1.00000000000000000000000000000000002e-02
            0, // startingTub
            4096, // stoppingTub
            Quad.wrap(bytes16(0x40059000000000000000000000000000)), // liquidityPerTub = 1e+02
            Quad.wrap(bytes16(0x40058dfff5e11bf5481994e97fd03d01)), // expected token0 = 9.94999613927187241734703956751371456e+01
            Quad.wrap(bytes16(0x400591fae0e93f14acf66aefe129ef90)), // expected token1 = 1.00494998592829841899182623144569888e+02
            false // skip the checks
        );
        Quad[] memory owedPotential = new Quad[](1);
        owedPotential[0] = Quad.wrap(bytes16(0x3fff0000000000000000000000000000));
        // int256 midBin = 16392;
        NewLoan.NewLoanParams memory params = NewLoan.NewLoanParams({
            owedPotential: owedPotential, // owedPotential = 1e+00
            startBin: 16402, // startBin
            strikeBin: 16402, // strikeBin
            tokenMix: Quad.wrap(bytes16(0x3ffd0000000000000000000000000000)), // tokenMix = 2.5e-01
            lockinEnd: POSITIVE_INFINITY,
            deadEra: OptInt256.wrap(OPT_INT256_NONE), // deadEra
            token: false, // token, unused for non-twap
            twapUntil: OptInt256.wrap(OPT_INT256_NONE) // twapUntil, disabled
        });
        UserPay.Info memory userPay = pool.newLoanOnly(params);
        Quad expectedToken0 = -Quad.wrap(bytes16(0x3ff212664f2b7a5c80ef780b197c8bc6)); // expecting userPay.token0 = -1.30843947189247671580687434727519938e-04
        assertTokenAmount(userPay.token0, expectedToken0, newLoanTestEpsilon);
        Quad expectedToken1 = Quad.wrap(bytes16(0x3ff249d34b20db33c17b3d71d4bcfa8c)); // expecting userPay.token1 = 1.57272989805967952197326039413554027e-04
        assertTokenAmount(userPay.token1, expectedToken1, newLoanTestEpsilon);

        console.log(
            "testNewLoan_test_newloan_nontwap_with_whole_range_pour_far_above_mid_price_1_01000000010000000000000000000000008_and_token_mix_0_25 testing done."
        );
    }

    function testNewLoan_test_newloan_nontwap_with_whole_range_pour_immediate_below_mid_price_1_01000000010000000000000000000000008_and_token_mix_0_5(
    ) public {
        console.log(
            "testNewLoan_test_newloan_nontwap_with_whole_range_pour_immediate_below_mid_price_1_01000000010000000000000000000000008_and_token_mix_0_5 starting ......"
        );
        testLimitedRangePour(
            Quad.wrap(bytes16(0x3fff028f5c2963b60ec387ecad6eb6e3)), // price = 1.01000000010000000000000000000000008e+00
            Quad.wrap(bytes16(0x3ff847ae147ae147ae147ae147ae147b)), // quadVar = 1.00000000000000000000000000000000002e-02
            0, // startingTub
            4096, // stoppingTub
            Quad.wrap(bytes16(0x40059000000000000000000000000000)), // liquidityPerTub = 1e+02
            Quad.wrap(bytes16(0x40058dfff5e11bf5481994e97fd03d01)), // expected token0 = 9.94999613927187241734703956751371456e+01
            Quad.wrap(bytes16(0x400591fae0e93f14acf66aefe129ef90)), // expected token1 = 1.00494998592829841899182623144569888e+02
            false // skip the checks
        );
        Quad[] memory owedPotential = new Quad[](1);
        owedPotential[0] = Quad.wrap(bytes16(0x3fff0000000000000000000000000000));
        // int256 midBin = 16392;
        NewLoan.NewLoanParams memory params = NewLoan.NewLoanParams({
            owedPotential: owedPotential, // owedPotential = 1e+00
            startBin: 16391, // startBin
            strikeBin: 16391, // strikeBin
            tokenMix: Quad.wrap(bytes16(0x3ffe0000000000000000000000000000)), // tokenMix = 5e-01
            lockinEnd: POSITIVE_INFINITY,
            deadEra: OptInt256.wrap(OPT_INT256_NONE), // deadEra
            token: false, // token, unused for non-twap
            twapUntil: OptInt256.wrap(OPT_INT256_NONE) // twapUntil, disabled
        });
        UserPay.Info memory userPay = pool.newLoanOnly(params);
        Quad expectedToken0 = Quad.wrap(bytes16(0x3ff344890367c0a903d5b3fbd651ebdd)); // expecting userPay.token0 = 3.09500892839911271262401338701942831e-04
        assertTokenAmount(userPay.token0, expectedToken0, newLoanTestEpsilon);
        Quad expectedToken1 = -Quad.wrap(bytes16(0x3ff32bf22d5752b2348653fce07e7bb4)); // expecting userPay.token1 = -2.86050800657621476555638425310597702e-04
        assertTokenAmount(userPay.token1, expectedToken1, newLoanTestEpsilon);

        console.log(
            "testNewLoan_test_newloan_nontwap_with_whole_range_pour_immediate_below_mid_price_1_01000000010000000000000000000000008_and_token_mix_0_5 testing done."
        );
    }

    function testNewLoan_test_newloan_nontwap_with_whole_range_pour_immediate_above_mid_price_1_01000000010000000000000000000000008_and_token_mix_0_5(
    ) public {
        console.log(
            "testNewLoan_test_newloan_nontwap_with_whole_range_pour_immediate_above_mid_price_1_01000000010000000000000000000000008_and_token_mix_0_5 starting ......"
        );
        testLimitedRangePour(
            Quad.wrap(bytes16(0x3fff028f5c2963b60ec387ecad6eb6e3)), // price = 1.01000000010000000000000000000000008e+00
            Quad.wrap(bytes16(0x3ff847ae147ae147ae147ae147ae147b)), // quadVar = 1.00000000000000000000000000000000002e-02
            0, // startingTub
            4096, // stoppingTub
            Quad.wrap(bytes16(0x40059000000000000000000000000000)), // liquidityPerTub = 1e+02
            Quad.wrap(bytes16(0x40058dfff5e11bf5481994e97fd03d01)), // expected token0 = 9.94999613927187241734703956751371456e+01
            Quad.wrap(bytes16(0x400591fae0e93f14acf66aefe129ef90)), // expected token1 = 1.00494998592829841899182623144569888e+02
            false // skip the checks
        );
        Quad[] memory owedPotential = new Quad[](1);
        owedPotential[0] = Quad.wrap(bytes16(0x3fff0000000000000000000000000000));
        // int256 midBin = 16392;
        NewLoan.NewLoanParams memory params = NewLoan.NewLoanParams({
            owedPotential: owedPotential, // owedPotential = 1e+00
            startBin: 16393, // startBin
            strikeBin: 16393, // strikeBin
            tokenMix: Quad.wrap(bytes16(0x3ffe0000000000000000000000000000)), // tokenMix = 5e-01
            lockinEnd: POSITIVE_INFINITY,
            deadEra: OptInt256.wrap(OPT_INT256_NONE), // deadEra
            token: false, // token, unused for non-twap
            twapUntil: OptInt256.wrap(OPT_INT256_NONE) // twapUntil, disabled
        });
        UserPay.Info memory userPay = pool.newLoanOnly(params);
        Quad expectedToken0 = -Quad.wrap(bytes16(0x3ff328caa70684063cc28ce8fe1699e5)); // expecting userPay.token0 = -2.83042536836758254953017706514698016e-04
        assertTokenAmount(userPay.token0, expectedToken0, newLoanTestEpsilon);
        Quad expectedToken1 = Quad.wrap(bytes16(0x3ff347fc062923f1ad3795b45e7aa6b2)); // expecting userPay.token1 = 3.12790364270108878071678734257164438e-04
        assertTokenAmount(userPay.token1, expectedToken1, newLoanTestEpsilon);

        console.log(
            "testNewLoan_test_newloan_nontwap_with_whole_range_pour_immediate_above_mid_price_1_01000000010000000000000000000000008_and_token_mix_0_5 testing done."
        );
    }

    function testNewLoan_test_newloan_nontwap_with_whole_range_pour_far_below_mid_price_1_01000000010000000000000000000000008_and_token_mix_0_5()
        public
    {
        console.log(
            "testNewLoan_test_newloan_nontwap_with_whole_range_pour_far_below_mid_price_1_01000000010000000000000000000000008_and_token_mix_0_5 starting ......"
        );
        testLimitedRangePour(
            Quad.wrap(bytes16(0x3fff028f5c2963b60ec387ecad6eb6e3)), // price = 1.01000000010000000000000000000000008e+00
            Quad.wrap(bytes16(0x3ff847ae147ae147ae147ae147ae147b)), // quadVar = 1.00000000000000000000000000000000002e-02
            0, // startingTub
            4096, // stoppingTub
            Quad.wrap(bytes16(0x40059000000000000000000000000000)), // liquidityPerTub = 1e+02
            Quad.wrap(bytes16(0x40058dfff5e11bf5481994e97fd03d01)), // expected token0 = 9.94999613927187241734703956751371456e+01
            Quad.wrap(bytes16(0x400591fae0e93f14acf66aefe129ef90)), // expected token1 = 1.00494998592829841899182623144569888e+02
            false // skip the checks
        );
        Quad[] memory owedPotential = new Quad[](1);
        owedPotential[0] = Quad.wrap(bytes16(0x3fff0000000000000000000000000000));
        // int256 midBin = 16392;
        NewLoan.NewLoanParams memory params = NewLoan.NewLoanParams({
            owedPotential: owedPotential, // owedPotential = 1e+00
            startBin: 16382, // startBin
            strikeBin: 16382, // strikeBin
            tokenMix: Quad.wrap(bytes16(0x3ffe0000000000000000000000000000)), // tokenMix = 5e-01
            lockinEnd: POSITIVE_INFINITY,
            deadEra: OptInt256.wrap(OPT_INT256_NONE), // deadEra
            token: false, // token, unused for non-twap
            twapUntil: OptInt256.wrap(OPT_INT256_NONE) // twapUntil, disabled
        });
        UserPay.Info memory userPay = pool.newLoanOnly(params);
        Quad expectedToken0 = Quad.wrap(bytes16(0x3ff3465b539b0c9861af7816fcda4537)); // expecting userPay.token0 = 3.11238045188088117268002115751328524e-04
        assertTokenAmount(userPay.token0, expectedToken0, newLoanTestEpsilon);
        Quad expectedToken1 = -Quad.wrap(bytes16(0x3ff32d8840f729fc4b0775037ce87513)); // expecting userPay.token1 = -2.87563554091093802579072526644361927e-04
        assertTokenAmount(userPay.token1, expectedToken1, newLoanTestEpsilon);

        console.log(
            "testNewLoan_test_newloan_nontwap_with_whole_range_pour_far_below_mid_price_1_01000000010000000000000000000000008_and_token_mix_0_5 testing done."
        );
    }

    function testNewLoan_test_newloan_nontwap_with_whole_range_pour_far_above_mid_price_1_01000000010000000000000000000000008_and_token_mix_0_5()
        public
    {
        console.log(
            "testNewLoan_test_newloan_nontwap_with_whole_range_pour_far_above_mid_price_1_01000000010000000000000000000000008_and_token_mix_0_5 starting ......"
        );
        testLimitedRangePour(
            Quad.wrap(bytes16(0x3fff028f5c2963b60ec387ecad6eb6e3)), // price = 1.01000000010000000000000000000000008e+00
            Quad.wrap(bytes16(0x3ff847ae147ae147ae147ae147ae147b)), // quadVar = 1.00000000000000000000000000000000002e-02
            0, // startingTub
            4096, // stoppingTub
            Quad.wrap(bytes16(0x40059000000000000000000000000000)), // liquidityPerTub = 1e+02
            Quad.wrap(bytes16(0x40058dfff5e11bf5481994e97fd03d01)), // expected token0 = 9.94999613927187241734703956751371456e+01
            Quad.wrap(bytes16(0x400591fae0e93f14acf66aefe129ef90)), // expected token1 = 1.00494998592829841899182623144569888e+02
            false // skip the checks
        );
        Quad[] memory owedPotential = new Quad[](1);
        owedPotential[0] = Quad.wrap(bytes16(0x3fff0000000000000000000000000000));
        // int256 midBin = 16392;
        NewLoan.NewLoanParams memory params = NewLoan.NewLoanParams({
            owedPotential: owedPotential, // owedPotential = 1e+00
            startBin: 16402, // startBin
            strikeBin: 16402, // strikeBin
            tokenMix: Quad.wrap(bytes16(0x3ffe0000000000000000000000000000)), // tokenMix = 5e-01
            lockinEnd: POSITIVE_INFINITY,
            deadEra: OptInt256.wrap(OPT_INT256_NONE), // deadEra
            token: false, // token, unused for non-twap
            twapUntil: OptInt256.wrap(OPT_INT256_NONE) // twapUntil, disabled
        });
        UserPay.Info memory userPay = pool.newLoanOnly(params);
        Quad expectedToken0 = -Quad.wrap(bytes16(0x3ff32a5c75658bbfd2692c6250a8065e)); // expecting userPay.token0 = -2.84539381342818599033189739648023732e-04
        assertTokenAmount(userPay.token0, expectedToken0, newLoanTestEpsilon);
        Quad expectedToken1 = Quad.wrap(bytes16(0x3ff349d34b20db33c17b3d71d4bcfa8c)); // expecting userPay.token1 = 3.14545979611935904394652078827108055e-04
        assertTokenAmount(userPay.token1, expectedToken1, newLoanTestEpsilon);

        console.log(
            "testNewLoan_test_newloan_nontwap_with_whole_range_pour_far_above_mid_price_1_01000000010000000000000000000000008_and_token_mix_0_5 testing done."
        );
    }

    function testNewLoan_test_newloan_nontwap_with_whole_range_pour_immediate_below_mid_price_1_01000000010000000000000000000000008_and_token_mix_0_75(
    ) public {
        console.log(
            "testNewLoan_test_newloan_nontwap_with_whole_range_pour_immediate_below_mid_price_1_01000000010000000000000000000000008_and_token_mix_0_75 starting ......"
        );
        testLimitedRangePour(
            Quad.wrap(bytes16(0x3fff028f5c2963b60ec387ecad6eb6e3)), // price = 1.01000000010000000000000000000000008e+00
            Quad.wrap(bytes16(0x3ff847ae147ae147ae147ae147ae147b)), // quadVar = 1.00000000000000000000000000000000002e-02
            0, // startingTub
            4096, // stoppingTub
            Quad.wrap(bytes16(0x40059000000000000000000000000000)), // liquidityPerTub = 1e+02
            Quad.wrap(bytes16(0x40058dfff5e11bf5481994e97fd03d01)), // expected token0 = 9.94999613927187241734703956751371456e+01
            Quad.wrap(bytes16(0x400591fae0e93f14acf66aefe129ef90)), // expected token1 = 1.00494998592829841899182623144569888e+02
            false // skip the checks
        );
        Quad[] memory owedPotential = new Quad[](1);
        owedPotential[0] = Quad.wrap(bytes16(0x3fff0000000000000000000000000000));
        // int256 midBin = 16392;
        NewLoan.NewLoanParams memory params = NewLoan.NewLoanParams({
            owedPotential: owedPotential, // owedPotential = 1e+00
            startBin: 16391, // startBin
            strikeBin: 16391, // strikeBin
            tokenMix: Quad.wrap(bytes16(0x3ffe8000000000000000000000000000)), // tokenMix = 7.5e-01
            lockinEnd: POSITIVE_INFINITY,
            deadEra: OptInt256.wrap(OPT_INT256_NONE), // deadEra
            token: false, // token, unused for non-twap
            twapUntil: OptInt256.wrap(OPT_INT256_NONE) // twapUntil, disabled
        });
        UserPay.Info memory userPay = pool.newLoanOnly(params);
        Quad expectedToken0 = Quad.wrap(bytes16(0x3ff244890367c0a903d5b3fbd651ebdd)); // expecting userPay.token0 = 1.54750446419955635631200669350971415e-04
        assertTokenAmount(userPay.token0, expectedToken0, newLoanTestEpsilon);
        Quad expectedToken1 = -Quad.wrap(bytes16(0x3ff21050b2efab77fa9b46569ff2218a)); // expecting userPay.token1 = -1.29850020575469201367364845970107984e-04
        assertTokenAmount(userPay.token1, expectedToken1, newLoanTestEpsilon);

        console.log(
            "testNewLoan_test_newloan_nontwap_with_whole_range_pour_immediate_below_mid_price_1_01000000010000000000000000000000008_and_token_mix_0_75 testing done."
        );
    }

    function testNewLoan_test_newloan_nontwap_with_whole_range_pour_immediate_above_mid_price_1_01000000010000000000000000000000008_and_token_mix_0_75(
    ) public {
        console.log(
            "testNewLoan_test_newloan_nontwap_with_whole_range_pour_immediate_above_mid_price_1_01000000010000000000000000000000008_and_token_mix_0_75 starting ......"
        );
        testLimitedRangePour(
            Quad.wrap(bytes16(0x3fff028f5c2963b60ec387ecad6eb6e3)), // price = 1.01000000010000000000000000000000008e+00
            Quad.wrap(bytes16(0x3ff847ae147ae147ae147ae147ae147b)), // quadVar = 1.00000000000000000000000000000000002e-02
            0, // startingTub
            4096, // stoppingTub
            Quad.wrap(bytes16(0x40059000000000000000000000000000)), // liquidityPerTub = 1e+02
            Quad.wrap(bytes16(0x40058dfff5e11bf5481994e97fd03d01)), // expected token0 = 9.94999613927187241734703956751371456e+01
            Quad.wrap(bytes16(0x400591fae0e93f14acf66aefe129ef90)), // expected token1 = 1.00494998592829841899182623144569888e+02
            false // skip the checks
        );
        Quad[] memory owedPotential = new Quad[](1);
        owedPotential[0] = Quad.wrap(bytes16(0x3fff0000000000000000000000000000));
        // int256 midBin = 16392;
        NewLoan.NewLoanParams memory params = NewLoan.NewLoanParams({
            owedPotential: owedPotential, // owedPotential = 1e+00
            startBin: 16393, // startBin
            strikeBin: 16393, // strikeBin
            tokenMix: Quad.wrap(bytes16(0x3ffe8000000000000000000000000000)), // tokenMix = 7.5e-01
            lockinEnd: POSITIVE_INFINITY,
            deadEra: OptInt256.wrap(OPT_INT256_NONE), // deadEra
            token: false, // token, unused for non-twap
            twapUntil: OptInt256.wrap(OPT_INT256_NONE) // twapUntil, disabled
        });
        UserPay.Info memory userPay = pool.newLoanOnly(params);
        Quad expectedToken0 = -Quad.wrap(bytes16(0x3ff3cadb86036a3f9d3aef9889d27356)); // expecting userPay.token0 = -4.37600625640188421548501521961097002e-04
        assertTokenAmount(userPay.token0, expectedToken0, newLoanTestEpsilon);
        Quad expectedToken1 = Quad.wrap(bytes16(0x3ff3ebfa093db5ea83d3608e8db7fa0a)); // expecting userPay.token1 = 4.69185546405163317107518101385746609e-04
        assertTokenAmount(userPay.token1, expectedToken1, newLoanTestEpsilon);

        console.log(
            "testNewLoan_test_newloan_nontwap_with_whole_range_pour_immediate_above_mid_price_1_01000000010000000000000000000000008_and_token_mix_0_75 testing done."
        );
    }

    function testNewLoan_test_newloan_nontwap_with_whole_range_pour_far_below_mid_price_1_01000000010000000000000000000000008_and_token_mix_0_75()
        public
    {
        console.log(
            "testNewLoan_test_newloan_nontwap_with_whole_range_pour_far_below_mid_price_1_01000000010000000000000000000000008_and_token_mix_0_75 starting ......"
        );
        testLimitedRangePour(
            Quad.wrap(bytes16(0x3fff028f5c2963b60ec387ecad6eb6e3)), // price = 1.01000000010000000000000000000000008e+00
            Quad.wrap(bytes16(0x3ff847ae147ae147ae147ae147ae147b)), // quadVar = 1.00000000000000000000000000000000002e-02
            0, // startingTub
            4096, // stoppingTub
            Quad.wrap(bytes16(0x40059000000000000000000000000000)), // liquidityPerTub = 1e+02
            Quad.wrap(bytes16(0x40058dfff5e11bf5481994e97fd03d01)), // expected token0 = 9.94999613927187241734703956751371456e+01
            Quad.wrap(bytes16(0x400591fae0e93f14acf66aefe129ef90)), // expected token1 = 1.00494998592829841899182623144569888e+02
            false // skip the checks
        );
        Quad[] memory owedPotential = new Quad[](1);
        owedPotential[0] = Quad.wrap(bytes16(0x3fff0000000000000000000000000000));
        // int256 midBin = 16392;
        NewLoan.NewLoanParams memory params = NewLoan.NewLoanParams({
            owedPotential: owedPotential, // owedPotential = 1e+00
            startBin: 16382, // startBin
            strikeBin: 16382, // strikeBin
            tokenMix: Quad.wrap(bytes16(0x3ffe8000000000000000000000000000)), // tokenMix = 7.5e-01
            lockinEnd: POSITIVE_INFINITY,
            deadEra: OptInt256.wrap(OPT_INT256_NONE), // deadEra
            token: false, // token, unused for non-twap
            twapUntil: OptInt256.wrap(OPT_INT256_NONE) // twapUntil, disabled
        });
        UserPay.Info memory userPay = pool.newLoanOnly(params);
        Quad expectedToken0 = Quad.wrap(bytes16(0x3ff2465b539b0c9861af7816fcda4537)); // expecting userPay.token0 = 1.55619022594044058634001057875664262e-04
        assertTokenAmount(userPay.token0, expectedToken0, newLoanTestEpsilon);
        Quad expectedToken1 = -Quad.wrap(bytes16(0x3ff21550e8a7996f51ccd0223aac155c)); // expecting userPay.token1 = -1.32234597219830756422678408526514663e-04
        assertTokenAmount(userPay.token1, expectedToken1, newLoanTestEpsilon);

        console.log(
            "testNewLoan_test_newloan_nontwap_with_whole_range_pour_far_below_mid_price_1_01000000010000000000000000000000008_and_token_mix_0_75 testing done."
        );
    }

    function testNewLoan_test_newloan_nontwap_with_whole_range_pour_far_above_mid_price_1_01000000010000000000000000000000008_and_token_mix_0_75()
        public
    {
        console.log(
            "testNewLoan_test_newloan_nontwap_with_whole_range_pour_far_above_mid_price_1_01000000010000000000000000000000008_and_token_mix_0_75 starting ......"
        );
        testLimitedRangePour(
            Quad.wrap(bytes16(0x3fff028f5c2963b60ec387ecad6eb6e3)), // price = 1.01000000010000000000000000000000008e+00
            Quad.wrap(bytes16(0x3ff847ae147ae147ae147ae147ae147b)), // quadVar = 1.00000000000000000000000000000000002e-02
            0, // startingTub
            4096, // stoppingTub
            Quad.wrap(bytes16(0x40059000000000000000000000000000)), // liquidityPerTub = 1e+02
            Quad.wrap(bytes16(0x40058dfff5e11bf5481994e97fd03d01)), // expected token0 = 9.94999613927187241734703956751371456e+01
            Quad.wrap(bytes16(0x400591fae0e93f14acf66aefe129ef90)), // expected token1 = 1.00494998592829841899182623144569888e+02
            false // skip the checks
        );
        Quad[] memory owedPotential = new Quad[](1);
        owedPotential[0] = Quad.wrap(bytes16(0x3fff0000000000000000000000000000));
        // int256 midBin = 16392;
        NewLoan.NewLoanParams memory params = NewLoan.NewLoanParams({
            owedPotential: owedPotential, // owedPotential = 1e+00
            startBin: 16402, // startBin
            strikeBin: 16402, // strikeBin
            tokenMix: Quad.wrap(bytes16(0x3ffe8000000000000000000000000000)), // tokenMix = 7.5e-01
            lockinEnd: POSITIVE_INFINITY,
            deadEra: OptInt256.wrap(OPT_INT256_NONE), // deadEra
            token: false, // token, unused for non-twap
            twapUntil: OptInt256.wrap(OPT_INT256_NONE) // twapUntil, disabled
        });
        UserPay.Info memory userPay = pool.newLoanOnly(params);
        Quad expectedToken0 = -Quad.wrap(bytes16(0x3ff3cb85c3355a51645a9cbf1491c6da)); // expecting userPay.token0 = -4.38234815496389526485692044568527573e-04
        assertTokenAmount(userPay.token0, expectedToken0, newLoanTestEpsilon);
        Quad expectedToken1 = Quad.wrap(bytes16(0x3ff3eebcf0b148cda238dc2abf1b77d2)); // expecting userPay.token1 = 4.71818969417903856591978118240662082e-04
        assertTokenAmount(userPay.token1, expectedToken1, newLoanTestEpsilon);

        console.log(
            "testNewLoan_test_newloan_nontwap_with_whole_range_pour_far_above_mid_price_1_01000000010000000000000000000000008_and_token_mix_0_75 testing done."
        );
    }

    function testNewLoan_test_newloan_nontwap_with_whole_range_pour_immediate_below_mid_price_1_01000000010000000000000000000000008_and_token_mix_1()
        public
    {
        console.log(
            "testNewLoan_test_newloan_nontwap_with_whole_range_pour_immediate_below_mid_price_1_01000000010000000000000000000000008_and_token_mix_1 starting ......"
        );
        testLimitedRangePour(
            Quad.wrap(bytes16(0x3fff028f5c2963b60ec387ecad6eb6e3)), // price = 1.01000000010000000000000000000000008e+00
            Quad.wrap(bytes16(0x3ff847ae147ae147ae147ae147ae147b)), // quadVar = 1.00000000000000000000000000000000002e-02
            0, // startingTub
            4096, // stoppingTub
            Quad.wrap(bytes16(0x40059000000000000000000000000000)), // liquidityPerTub = 1e+02
            Quad.wrap(bytes16(0x40058dfff5e11bf5481994e97fd03d01)), // expected token0 = 9.94999613927187241734703956751371456e+01
            Quad.wrap(bytes16(0x400591fae0e93f14acf66aefe129ef90)), // expected token1 = 1.00494998592829841899182623144569888e+02
            false // skip the checks
        );
        Quad[] memory owedPotential = new Quad[](1);
        owedPotential[0] = Quad.wrap(bytes16(0x3fff0000000000000000000000000000));
        // int256 midBin = 16392;
        NewLoan.NewLoanParams memory params = NewLoan.NewLoanParams({
            owedPotential: owedPotential, // owedPotential = 1e+00
            startBin: 16391, // startBin
            strikeBin: 16391, // strikeBin
            tokenMix: Quad.wrap(bytes16(0x3fff0000000000000000000000000000)), // tokenMix = 1e+00
            lockinEnd: POSITIVE_INFINITY,
            deadEra: OptInt256.wrap(OPT_INT256_NONE), // deadEra
            token: false, // token, unused for non-twap
            twapUntil: OptInt256.wrap(OPT_INT256_NONE) // twapUntil, disabled
        });
        UserPay.Info memory userPay = pool.newLoanOnly(params);
        Quad expectedToken0 = POSITIVE_ZERO; // expecting userPay.token0 = 0e+00
        assertTokenAmount(userPay.token0, expectedToken0, newLoanTestEpsilon);
        Quad expectedToken1 = Quad.wrap(bytes16(0x3fefba17a67a73a39eb0da6408c5a280)); // expecting userPay.token1 = 2.63507595066830738209087333703816386e-05
        assertTokenAmount(userPay.token1, expectedToken1, newLoanTestEpsilon);

        console.log(
            "testNewLoan_test_newloan_nontwap_with_whole_range_pour_immediate_below_mid_price_1_01000000010000000000000000000000008_and_token_mix_1 testing done."
        );
    }

    function testNewLoan_test_newloan_nontwap_with_whole_range_pour_immediate_above_mid_price_1_01000000010000000000000000000000008_and_token_mix_1()
        public
    {
        console.log(
            "testNewLoan_test_newloan_nontwap_with_whole_range_pour_immediate_above_mid_price_1_01000000010000000000000000000000008_and_token_mix_1 starting ......"
        );
        testLimitedRangePour(
            Quad.wrap(bytes16(0x3fff028f5c2963b60ec387ecad6eb6e3)), // price = 1.01000000010000000000000000000000008e+00
            Quad.wrap(bytes16(0x3ff847ae147ae147ae147ae147ae147b)), // quadVar = 1.00000000000000000000000000000000002e-02
            0, // startingTub
            4096, // stoppingTub
            Quad.wrap(bytes16(0x40059000000000000000000000000000)), // liquidityPerTub = 1e+02
            Quad.wrap(bytes16(0x40058dfff5e11bf5481994e97fd03d01)), // expected token0 = 9.94999613927187241734703956751371456e+01
            Quad.wrap(bytes16(0x400591fae0e93f14acf66aefe129ef90)), // expected token1 = 1.00494998592829841899182623144569888e+02
            false // skip the checks
        );
        Quad[] memory owedPotential = new Quad[](1);
        owedPotential[0] = Quad.wrap(bytes16(0x3fff0000000000000000000000000000));
        // int256 midBin = 16392;
        NewLoan.NewLoanParams memory params = NewLoan.NewLoanParams({
            owedPotential: owedPotential, // owedPotential = 1e+00
            startBin: 16393, // startBin
            strikeBin: 16393, // strikeBin
            tokenMix: Quad.wrap(bytes16(0x3fff0000000000000000000000000000)), // tokenMix = 1e+00
            lockinEnd: POSITIVE_INFINITY,
            deadEra: OptInt256.wrap(OPT_INT256_NONE), // deadEra
            token: false, // token, unused for non-twap
            twapUntil: OptInt256.wrap(OPT_INT256_NONE) // twapUntil, disabled
        });
        UserPay.Info memory userPay = pool.newLoanOnly(params);
        Quad expectedToken0 = -Quad.wrap(bytes16(0x3ff436763280283c7ed9a9240ac72664)); // expecting userPay.token0 = -5.92158714443618588143985337407496034e-04
        assertTokenAmount(userPay.token0, expectedToken0, newLoanTestEpsilon);
        Quad expectedToken1 = Quad.wrap(bytes16(0x3ff447fc062923f1ad3795b45e7aa6b2)); // expecting userPay.token1 = 6.25580728540217756143357468514328875e-04
        assertTokenAmount(userPay.token1, expectedToken1, newLoanTestEpsilon);

        console.log(
            "testNewLoan_test_newloan_nontwap_with_whole_range_pour_immediate_above_mid_price_1_01000000010000000000000000000000008_and_token_mix_1 testing done."
        );
    }

    function testNewLoan_test_newloan_nontwap_with_whole_range_pour_far_below_mid_price_1_01000000010000000000000000000000008_and_token_mix_1()
        public
    {
        console.log(
            "testNewLoan_test_newloan_nontwap_with_whole_range_pour_far_below_mid_price_1_01000000010000000000000000000000008_and_token_mix_1 starting ......"
        );
        testLimitedRangePour(
            Quad.wrap(bytes16(0x3fff028f5c2963b60ec387ecad6eb6e3)), // price = 1.01000000010000000000000000000000008e+00
            Quad.wrap(bytes16(0x3ff847ae147ae147ae147ae147ae147b)), // quadVar = 1.00000000000000000000000000000000002e-02
            0, // startingTub
            4096, // stoppingTub
            Quad.wrap(bytes16(0x40059000000000000000000000000000)), // liquidityPerTub = 1e+02
            Quad.wrap(bytes16(0x40058dfff5e11bf5481994e97fd03d01)), // expected token0 = 9.94999613927187241734703956751371456e+01
            Quad.wrap(bytes16(0x400591fae0e93f14acf66aefe129ef90)), // expected token1 = 1.00494998592829841899182623144569888e+02
            false // skip the checks
        );
        Quad[] memory owedPotential = new Quad[](1);
        owedPotential[0] = Quad.wrap(bytes16(0x3fff0000000000000000000000000000));
        // int256 midBin = 16392;
        NewLoan.NewLoanParams memory params = NewLoan.NewLoanParams({
            owedPotential: owedPotential, // owedPotential = 1e+00
            startBin: 16382, // startBin
            strikeBin: 16382, // strikeBin
            tokenMix: Quad.wrap(bytes16(0x3fff0000000000000000000000000000)), // tokenMix = 1e+00
            lockinEnd: POSITIVE_INFINITY,
            deadEra: OptInt256.wrap(OPT_INT256_NONE), // deadEra
            token: false, // token, unused for non-twap
            twapUntil: OptInt256.wrap(OPT_INT256_NONE) // twapUntil, disabled
        });
        UserPay.Info memory userPay = pool.newLoanOnly(params);
        Quad expectedToken0 = POSITIVE_ZERO; // expecting userPay.token0 = 0e+00
        assertTokenAmount(userPay.token0, expectedToken0, newLoanTestEpsilon);
        Quad expectedToken1 = Quad.wrap(bytes16(0x3fef837584f908cf93aa4e1423c5fb80)); // expecting userPay.token1 = 2.30943596514322897337157095913326479e-05
        assertTokenAmount(userPay.token1, expectedToken1, newLoanTestEpsilon);

        console.log(
            "testNewLoan_test_newloan_nontwap_with_whole_range_pour_far_below_mid_price_1_01000000010000000000000000000000008_and_token_mix_1 testing done."
        );
    }

    function testNewLoan_test_newloan_nontwap_with_whole_range_pour_far_above_mid_price_1_01000000010000000000000000000000008_and_token_mix_1()
        public
    {
        console.log(
            "testNewLoan_test_newloan_nontwap_with_whole_range_pour_far_above_mid_price_1_01000000010000000000000000000000008_and_token_mix_1 starting ......"
        );
        testLimitedRangePour(
            Quad.wrap(bytes16(0x3fff028f5c2963b60ec387ecad6eb6e3)), // price = 1.01000000010000000000000000000000008e+00
            Quad.wrap(bytes16(0x3ff847ae147ae147ae147ae147ae147b)), // quadVar = 1.00000000000000000000000000000000002e-02
            0, // startingTub
            4096, // stoppingTub
            Quad.wrap(bytes16(0x40059000000000000000000000000000)), // liquidityPerTub = 1e+02
            Quad.wrap(bytes16(0x40058dfff5e11bf5481994e97fd03d01)), // expected token0 = 9.94999613927187241734703956751371456e+01
            Quad.wrap(bytes16(0x400591fae0e93f14acf66aefe129ef90)), // expected token1 = 1.00494998592829841899182623144569888e+02
            false // skip the checks
        );
        Quad[] memory owedPotential = new Quad[](1);
        owedPotential[0] = Quad.wrap(bytes16(0x3fff0000000000000000000000000000));
        // int256 midBin = 16392;
        NewLoan.NewLoanParams memory params = NewLoan.NewLoanParams({
            owedPotential: owedPotential, // owedPotential = 1e+00
            startBin: 16402, // startBin
            strikeBin: 16402, // strikeBin
            tokenMix: Quad.wrap(bytes16(0x3fff0000000000000000000000000000)), // tokenMix = 1e+00
            lockinEnd: POSITIVE_INFINITY,
            deadEra: OptInt256.wrap(OPT_INT256_NONE), // deadEra
            token: false, // token, unused for non-twap
            twapUntil: OptInt256.wrap(OPT_INT256_NONE) // twapUntil, disabled
        });
        UserPay.Info memory userPay = pool.newLoanOnly(params);
        Quad expectedToken0 = -Quad.wrap(bytes16(0x3ff43657888294717b26068dec3dc3ab)); // expecting userPay.token0 = -5.91930249649960453938194349489031414e-04
        assertTokenAmount(userPay.token0, expectedToken0, newLoanTestEpsilon);
        Quad expectedToken1 = Quad.wrap(bytes16(0x3ff449d34b20db33c17b3d71d4bcfa8c)); // expecting userPay.token1 = 6.2909195922387180878930415765421611e-04
        assertTokenAmount(userPay.token1, expectedToken1, newLoanTestEpsilon);

        console.log(
            "testNewLoan_test_newloan_nontwap_with_whole_range_pour_far_above_mid_price_1_01000000010000000000000000000000008_and_token_mix_1 testing done."
        );
    }

    function testNewLoan_test_newloan_nontwap_with_whole_range_pour_immediate_below_mid_price_2_and_token_mix_0() public {
        console.log("testNewLoan_test_newloan_nontwap_with_whole_range_pour_immediate_below_mid_price_2_and_token_mix_0 starting ......");
        testLimitedRangePour(
            Quad.wrap(bytes16(0x40000000000000000000000000000000)), // price = 2e+00
            Quad.wrap(bytes16(0x3ff847ae147ae147ae147ae147ae147b)), // quadVar = 1.00000000000000000000000000000000002e-02
            0, // startingTub
            4096, // stoppingTub
            Quad.wrap(bytes16(0x40059000000000000000000000000000)), // liquidityPerTub = 1e+02
            Quad.wrap(bytes16(0x40051ad3e3b2a4504826fe33545ba1b8)), // expected token0 = 7.07069232857502997478571876931418406e+01
            Quad.wrap(bytes16(0x40061ad5d03797ade615ebe5ad4dd249)), // expected token1 = 1.41417604195848024924996542572977972e+02
            false // skip the checks
        );
        Quad[] memory owedPotential = new Quad[](1);
        owedPotential[0] = Quad.wrap(bytes16(0x3fff0000000000000000000000000000));
        // int256 midBin = 16941;
        NewLoan.NewLoanParams memory params = NewLoan.NewLoanParams({
            owedPotential: owedPotential, // owedPotential = 1e+00
            startBin: 16940, // startBin
            strikeBin: 16940, // strikeBin
            tokenMix: POSITIVE_ZERO, // tokenMix = 0e+00
            lockinEnd: POSITIVE_INFINITY,
            deadEra: OptInt256.wrap(OPT_INT256_NONE), // deadEra
            token: false, // token, unused for non-twap
            twapUntil: OptInt256.wrap(OPT_INT256_NONE) // twapUntil, disabled
        });
        UserPay.Info memory userPay = pool.newLoanOnly(params);
        Quad expectedToken0 = Quad.wrap(bytes16(0x3ff3cd554a525f4c095e51042106b985)); // expecting userPay.token0 = 4.39961591062697947130022681790776238e-04
        assertTokenAmount(userPay.token0, expectedToken0, newLoanTestEpsilon);
        Quad expectedToken1 = -Quad.wrap(bytes16(0x3ff4b971ee0bbccba5a97b07982c9d9f)); // expecting userPay.token1 = -8.41989590723810853024400449398090495e-04
        assertTokenAmount(userPay.token1, expectedToken1, newLoanTestEpsilon);

        console.log("testNewLoan_test_newloan_nontwap_with_whole_range_pour_immediate_below_mid_price_2_and_token_mix_0 testing done.");
    }

    function testNewLoan_test_newloan_nontwap_with_whole_range_pour_immediate_above_mid_price_2_and_token_mix_0() public {
        console.log("testNewLoan_test_newloan_nontwap_with_whole_range_pour_immediate_above_mid_price_2_and_token_mix_0 starting ......");
        testLimitedRangePour(
            Quad.wrap(bytes16(0x40000000000000000000000000000000)), // price = 2e+00
            Quad.wrap(bytes16(0x3ff847ae147ae147ae147ae147ae147b)), // quadVar = 1.00000000000000000000000000000000002e-02
            0, // startingTub
            4096, // stoppingTub
            Quad.wrap(bytes16(0x40059000000000000000000000000000)), // liquidityPerTub = 1e+02
            Quad.wrap(bytes16(0x40051ad3e3b2a4504826fe33545ba1b8)), // expected token0 = 7.07069232857502997478571876931418406e+01
            Quad.wrap(bytes16(0x40061ad5d03797ade615ebe5ad4dd249)), // expected token1 = 1.41417604195848024924996542572977972e+02
            false // skip the checks
        );
        Quad[] memory owedPotential = new Quad[](1);
        owedPotential[0] = Quad.wrap(bytes16(0x3fff0000000000000000000000000000));
        // int256 midBin = 16941;
        NewLoan.NewLoanParams memory params = NewLoan.NewLoanParams({
            owedPotential: owedPotential, // owedPotential = 1e+00
            startBin: 16942, // startBin
            strikeBin: 16942, // strikeBin
            tokenMix: POSITIVE_ZERO, // tokenMix = 0e+00
            lockinEnd: POSITIVE_INFINITY,
            deadEra: OptInt256.wrap(OPT_INT256_NONE), // deadEra
            token: false, // token, unused for non-twap
            twapUntil: OptInt256.wrap(OPT_INT256_NONE) // twapUntil, disabled
        });
        UserPay.Info memory userPay = pool.newLoanOnly(params);
        Quad expectedToken0 = Quad.wrap(bytes16(0x3fef36eabef88c490ba7846c66f79360)); // expecting userPay.token0 = 1.85320959379992785409847433518844934e-05
        assertTokenAmount(userPay.token0, expectedToken0, newLoanTestEpsilon);
        Quad expectedToken1 = POSITIVE_ZERO; // expecting userPay.token1 = 0e+00
        assertTokenAmount(userPay.token1, expectedToken1, newLoanTestEpsilon);

        console.log("testNewLoan_test_newloan_nontwap_with_whole_range_pour_immediate_above_mid_price_2_and_token_mix_0 testing done.");
    }

    function testNewLoan_test_newloan_nontwap_with_whole_range_pour_far_below_mid_price_2_and_token_mix_0() public {
        console.log("testNewLoan_test_newloan_nontwap_with_whole_range_pour_far_below_mid_price_2_and_token_mix_0 starting ......");
        testLimitedRangePour(
            Quad.wrap(bytes16(0x40000000000000000000000000000000)), // price = 2e+00
            Quad.wrap(bytes16(0x3ff847ae147ae147ae147ae147ae147b)), // quadVar = 1.00000000000000000000000000000000002e-02
            0, // startingTub
            4096, // stoppingTub
            Quad.wrap(bytes16(0x40059000000000000000000000000000)), // liquidityPerTub = 1e+02
            Quad.wrap(bytes16(0x40051ad3e3b2a4504826fe33545ba1b8)), // expected token0 = 7.07069232857502997478571876931418406e+01
            Quad.wrap(bytes16(0x40061ad5d03797ade615ebe5ad4dd249)), // expected token1 = 1.41417604195848024924996542572977972e+02
            false // skip the checks
        );
        Quad[] memory owedPotential = new Quad[](1);
        owedPotential[0] = Quad.wrap(bytes16(0x3fff0000000000000000000000000000));
        // int256 midBin = 16941;
        NewLoan.NewLoanParams memory params = NewLoan.NewLoanParams({
            owedPotential: owedPotential, // owedPotential = 1e+00
            startBin: 16931, // startBin
            strikeBin: 16931, // strikeBin
            tokenMix: POSITIVE_ZERO, // tokenMix = 0e+00
            lockinEnd: POSITIVE_INFINITY,
            deadEra: OptInt256.wrap(OPT_INT256_NONE), // deadEra
            token: false, // token, unused for non-twap
            twapUntil: OptInt256.wrap(OPT_INT256_NONE) // twapUntil, disabled
        });
        UserPay.Info memory userPay = pool.newLoanOnly(params);
        Quad expectedToken0 = Quad.wrap(bytes16(0x3ff3cfec29eebc922f7ae4e58b7c68e2)); // expecting userPay.token0 = 4.42430987205659995040318123547246571e-04
        assertTokenAmount(userPay.token0, expectedToken0, newLoanTestEpsilon);
        Quad expectedToken1 = -Quad.wrap(bytes16(0x3ff4b9465427f26608d689769b1b736c)); // expecting userPay.token1 = -8.41664736975288795209998294462288287e-04
        assertTokenAmount(userPay.token1, expectedToken1, newLoanTestEpsilon);

        console.log("testNewLoan_test_newloan_nontwap_with_whole_range_pour_far_below_mid_price_2_and_token_mix_0 testing done.");
    }

    function testNewLoan_test_newloan_nontwap_with_whole_range_pour_far_above_mid_price_2_and_token_mix_0() public {
        console.log("testNewLoan_test_newloan_nontwap_with_whole_range_pour_far_above_mid_price_2_and_token_mix_0 starting ......");
        testLimitedRangePour(
            Quad.wrap(bytes16(0x40000000000000000000000000000000)), // price = 2e+00
            Quad.wrap(bytes16(0x3ff847ae147ae147ae147ae147ae147b)), // quadVar = 1.00000000000000000000000000000000002e-02
            0, // startingTub
            4096, // stoppingTub
            Quad.wrap(bytes16(0x40059000000000000000000000000000)), // liquidityPerTub = 1e+02
            Quad.wrap(bytes16(0x40051ad3e3b2a4504826fe33545ba1b8)), // expected token0 = 7.07069232857502997478571876931418406e+01
            Quad.wrap(bytes16(0x40061ad5d03797ade615ebe5ad4dd249)), // expected token1 = 1.41417604195848024924996542572977972e+02
            false // skip the checks
        );
        Quad[] memory owedPotential = new Quad[](1);
        owedPotential[0] = Quad.wrap(bytes16(0x3fff0000000000000000000000000000));
        // int256 midBin = 16941;
        NewLoan.NewLoanParams memory params = NewLoan.NewLoanParams({
            owedPotential: owedPotential, // owedPotential = 1e+00
            startBin: 16951, // startBin
            strikeBin: 16951, // strikeBin
            tokenMix: POSITIVE_ZERO, // tokenMix = 0e+00
            lockinEnd: POSITIVE_INFINITY,
            deadEra: OptInt256.wrap(OPT_INT256_NONE), // deadEra
            token: false, // token, unused for non-twap
            twapUntil: OptInt256.wrap(OPT_INT256_NONE) // twapUntil, disabled
        });
        UserPay.Info memory userPay = pool.newLoanOnly(params);
        Quad expectedToken0 = Quad.wrap(bytes16(0x3fef107e82436feea487914f6a43dac0)); // expecting userPay.token0 = 1.62419185139030558265564036737647298e-05
        assertTokenAmount(userPay.token0, expectedToken0, newLoanTestEpsilon);
        Quad expectedToken1 = POSITIVE_ZERO; // expecting userPay.token1 = 0e+00
        assertTokenAmount(userPay.token1, expectedToken1, newLoanTestEpsilon);

        console.log("testNewLoan_test_newloan_nontwap_with_whole_range_pour_far_above_mid_price_2_and_token_mix_0 testing done.");
    }

    function testNewLoan_test_newloan_nontwap_with_whole_range_pour_immediate_below_mid_price_2_and_token_mix_0_25() public {
        console.log("testNewLoan_test_newloan_nontwap_with_whole_range_pour_immediate_below_mid_price_2_and_token_mix_0_25 starting ......");
        testLimitedRangePour(
            Quad.wrap(bytes16(0x40000000000000000000000000000000)), // price = 2e+00
            Quad.wrap(bytes16(0x3ff847ae147ae147ae147ae147ae147b)), // quadVar = 1.00000000000000000000000000000000002e-02
            0, // startingTub
            4096, // stoppingTub
            Quad.wrap(bytes16(0x40059000000000000000000000000000)), // liquidityPerTub = 1e+02
            Quad.wrap(bytes16(0x40051ad3e3b2a4504826fe33545ba1b8)), // expected token0 = 7.07069232857502997478571876931418406e+01
            Quad.wrap(bytes16(0x40061ad5d03797ade615ebe5ad4dd249)), // expected token1 = 1.41417604195848024924996542572977972e+02
            false // skip the checks
        );
        Quad[] memory owedPotential = new Quad[](1);
        owedPotential[0] = Quad.wrap(bytes16(0x3fff0000000000000000000000000000));
        // int256 midBin = 16941;
        NewLoan.NewLoanParams memory params = NewLoan.NewLoanParams({
            owedPotential: owedPotential, // owedPotential = 1e+00
            startBin: 16940, // startBin
            strikeBin: 16940, // strikeBin
            tokenMix: Quad.wrap(bytes16(0x3ffd0000000000000000000000000000)), // tokenMix = 2.5e-01
            lockinEnd: POSITIVE_INFINITY,
            deadEra: OptInt256.wrap(OPT_INT256_NONE), // deadEra
            token: false, // token, unused for non-twap
            twapUntil: OptInt256.wrap(OPT_INT256_NONE) // twapUntil, disabled
        });
        UserPay.Info memory userPay = pool.newLoanOnly(params);
        Quad expectedToken0 = Quad.wrap(bytes16(0x3ff359fff7bdc7790706bcc318c50b23)); // expecting userPay.token0 = 3.29971193297023460347517011343082144e-04
        assertTokenAmount(userPay.token0, expectedToken0, newLoanTestEpsilon);
        Quad expectedToken1 = -Quad.wrap(bytes16(0x3ff4463972b0dfd67486544e68173e41)); // expecting userPay.token1 = -6.22223675335859079072423731542681932e-04
        assertTokenAmount(userPay.token1, expectedToken1, newLoanTestEpsilon);

        console.log("testNewLoan_test_newloan_nontwap_with_whole_range_pour_immediate_below_mid_price_2_and_token_mix_0_25 testing done.");
    }

    function testNewLoan_test_newloan_nontwap_with_whole_range_pour_immediate_above_mid_price_2_and_token_mix_0_25() public {
        console.log("testNewLoan_test_newloan_nontwap_with_whole_range_pour_immediate_above_mid_price_2_and_token_mix_0_25 starting ......");
        testLimitedRangePour(
            Quad.wrap(bytes16(0x40000000000000000000000000000000)), // price = 2e+00
            Quad.wrap(bytes16(0x3ff847ae147ae147ae147ae147ae147b)), // quadVar = 1.00000000000000000000000000000000002e-02
            0, // startingTub
            4096, // stoppingTub
            Quad.wrap(bytes16(0x40059000000000000000000000000000)), // liquidityPerTub = 1e+02
            Quad.wrap(bytes16(0x40051ad3e3b2a4504826fe33545ba1b8)), // expected token0 = 7.07069232857502997478571876931418406e+01
            Quad.wrap(bytes16(0x40061ad5d03797ade615ebe5ad4dd249)), // expected token1 = 1.41417604195848024924996542572977972e+02
            false // skip the checks
        );
        Quad[] memory owedPotential = new Quad[](1);
        owedPotential[0] = Quad.wrap(bytes16(0x3fff0000000000000000000000000000));
        // int256 midBin = 16941;
        NewLoan.NewLoanParams memory params = NewLoan.NewLoanParams({
            owedPotential: owedPotential, // owedPotential = 1e+00
            startBin: 16942, // startBin
            strikeBin: 16942, // strikeBin
            tokenMix: Quad.wrap(bytes16(0x3ffd0000000000000000000000000000)), // tokenMix = 2.5e-01
            lockinEnd: POSITIVE_INFINITY,
            deadEra: OptInt256.wrap(OPT_INT256_NONE), // deadEra
            token: false, // token, unused for non-twap
            twapUntil: OptInt256.wrap(OPT_INT256_NONE) // twapUntil, disabled
        });
        UserPay.Info memory userPay = pool.newLoanOnly(params);
        Quad expectedToken0 = -Quad.wrap(bytes16(0x3ff17f07cd411c78089364e9605fee0c)); // expecting userPay.token0 = -9.13215817648620964894596086505812173e-05
        assertTokenAmount(userPay.token0, expectedToken0, newLoanTestEpsilon);
        Quad expectedToken1 = Quad.wrap(bytes16(0x3ff2cd74c4c2dfb7eedfcfa6a51a7f42)); // expecting userPay.token1 = 2.20039428395293167182387180184569879e-04
        assertTokenAmount(userPay.token1, expectedToken1, newLoanTestEpsilon);

        console.log("testNewLoan_test_newloan_nontwap_with_whole_range_pour_immediate_above_mid_price_2_and_token_mix_0_25 testing done.");
    }

    function testNewLoan_test_newloan_nontwap_with_whole_range_pour_far_below_mid_price_2_and_token_mix_0_25() public {
        console.log("testNewLoan_test_newloan_nontwap_with_whole_range_pour_far_below_mid_price_2_and_token_mix_0_25 starting ......");
        testLimitedRangePour(
            Quad.wrap(bytes16(0x40000000000000000000000000000000)), // price = 2e+00
            Quad.wrap(bytes16(0x3ff847ae147ae147ae147ae147ae147b)), // quadVar = 1.00000000000000000000000000000000002e-02
            0, // startingTub
            4096, // stoppingTub
            Quad.wrap(bytes16(0x40059000000000000000000000000000)), // liquidityPerTub = 1e+02
            Quad.wrap(bytes16(0x40051ad3e3b2a4504826fe33545ba1b8)), // expected token0 = 7.07069232857502997478571876931418406e+01
            Quad.wrap(bytes16(0x40061ad5d03797ade615ebe5ad4dd249)), // expected token1 = 1.41417604195848024924996542572977972e+02
            false // skip the checks
        );
        Quad[] memory owedPotential = new Quad[](1);
        owedPotential[0] = Quad.wrap(bytes16(0x3fff0000000000000000000000000000));
        // int256 midBin = 16941;
        NewLoan.NewLoanParams memory params = NewLoan.NewLoanParams({
            owedPotential: owedPotential, // owedPotential = 1e+00
            startBin: 16931, // startBin
            strikeBin: 16931, // strikeBin
            tokenMix: Quad.wrap(bytes16(0x3ffd0000000000000000000000000000)), // tokenMix = 2.5e-01
            lockinEnd: POSITIVE_INFINITY,
            deadEra: OptInt256.wrap(OPT_INT256_NONE), // deadEra
            token: false, // token, unused for non-twap
            twapUntil: OptInt256.wrap(OPT_INT256_NONE) // twapUntil, disabled
        });
        UserPay.Info memory userPay = pool.newLoanOnly(params);
        Quad expectedToken0 = Quad.wrap(bytes16(0x3ff35bf11f730d6da39c2bac289d4eaa)); // expecting userPay.token0 = 3.31823240404244996280238592660434952e-04
        assertTokenAmount(userPay.token0, expectedToken0, newLoanTestEpsilon);
        Quad expectedToken1 = -Quad.wrap(bytes16(0x3ff446b27ab57f1acad531208689472d)); // expecting userPay.token1 = -6.23125428944206597440310988698740771e-04
        assertTokenAmount(userPay.token1, expectedToken1, newLoanTestEpsilon);

        console.log("testNewLoan_test_newloan_nontwap_with_whole_range_pour_far_below_mid_price_2_and_token_mix_0_25 testing done.");
    }

    function testNewLoan_test_newloan_nontwap_with_whole_range_pour_far_above_mid_price_2_and_token_mix_0_25() public {
        console.log("testNewLoan_test_newloan_nontwap_with_whole_range_pour_far_above_mid_price_2_and_token_mix_0_25 starting ......");
        testLimitedRangePour(
            Quad.wrap(bytes16(0x40000000000000000000000000000000)), // price = 2e+00
            Quad.wrap(bytes16(0x3ff847ae147ae147ae147ae147ae147b)), // quadVar = 1.00000000000000000000000000000000002e-02
            0, // startingTub
            4096, // stoppingTub
            Quad.wrap(bytes16(0x40059000000000000000000000000000)), // liquidityPerTub = 1e+02
            Quad.wrap(bytes16(0x40051ad3e3b2a4504826fe33545ba1b8)), // expected token0 = 7.07069232857502997478571876931418406e+01
            Quad.wrap(bytes16(0x40061ad5d03797ade615ebe5ad4dd249)), // expected token1 = 1.41417604195848024924996542572977972e+02
            false // skip the checks
        );
        Quad[] memory owedPotential = new Quad[](1);
        owedPotential[0] = Quad.wrap(bytes16(0x3fff0000000000000000000000000000));
        // int256 midBin = 16941;
        NewLoan.NewLoanParams memory params = NewLoan.NewLoanParams({
            owedPotential: owedPotential, // owedPotential = 1e+00
            startBin: 16951, // startBin
            strikeBin: 16951, // strikeBin
            tokenMix: Quad.wrap(bytes16(0x3ffd0000000000000000000000000000)), // tokenMix = 2.5e-01
            lockinEnd: POSITIVE_INFINITY,
            deadEra: OptInt256.wrap(OPT_INT256_NONE), // deadEra
            token: false, // token, unused for non-twap
            twapUntil: OptInt256.wrap(OPT_INT256_NONE) // twapUntil, disabled
        });
        UserPay.Info memory userPay = pool.newLoanOnly(params);
        Quad expectedToken0 = -Quad.wrap(bytes16(0x3ff1861081b8b038e9fa1ed28b9f0178)); // expecting userPay.token0 = -9.29986189346489089516783569143994975e-05
        assertTokenAmount(userPay.token0, expectedToken0, newLoanTestEpsilon);
        Quad expectedToken1 = Quad.wrap(bytes16(0x3ff2d00bd19a20bd18a4b4875fe23eb2)); // expecting userPay.token1 = 2.21274455558610878256124086133524623e-04
        assertTokenAmount(userPay.token1, expectedToken1, newLoanTestEpsilon);

        console.log("testNewLoan_test_newloan_nontwap_with_whole_range_pour_far_above_mid_price_2_and_token_mix_0_25 testing done.");
    }

    function testNewLoan_test_newloan_nontwap_with_whole_range_pour_immediate_below_mid_price_2_and_token_mix_0_5() public {
        console.log("testNewLoan_test_newloan_nontwap_with_whole_range_pour_immediate_below_mid_price_2_and_token_mix_0_5 starting ......");
        testLimitedRangePour(
            Quad.wrap(bytes16(0x40000000000000000000000000000000)), // price = 2e+00
            Quad.wrap(bytes16(0x3ff847ae147ae147ae147ae147ae147b)), // quadVar = 1.00000000000000000000000000000000002e-02
            0, // startingTub
            4096, // stoppingTub
            Quad.wrap(bytes16(0x40059000000000000000000000000000)), // liquidityPerTub = 1e+02
            Quad.wrap(bytes16(0x40051ad3e3b2a4504826fe33545ba1b8)), // expected token0 = 7.07069232857502997478571876931418406e+01
            Quad.wrap(bytes16(0x40061ad5d03797ade615ebe5ad4dd249)), // expected token1 = 1.41417604195848024924996542572977972e+02
            false // skip the checks
        );
        Quad[] memory owedPotential = new Quad[](1);
        owedPotential[0] = Quad.wrap(bytes16(0x3fff0000000000000000000000000000));
        // int256 midBin = 16941;
        NewLoan.NewLoanParams memory params = NewLoan.NewLoanParams({
            owedPotential: owedPotential, // owedPotential = 1e+00
            startBin: 16940, // startBin
            strikeBin: 16940, // strikeBin
            tokenMix: Quad.wrap(bytes16(0x3ffe0000000000000000000000000000)), // tokenMix = 5e-01
            lockinEnd: POSITIVE_INFINITY,
            deadEra: OptInt256.wrap(OPT_INT256_NONE), // deadEra
            token: false, // token, unused for non-twap
            twapUntil: OptInt256.wrap(OPT_INT256_NONE) // twapUntil, disabled
        });
        UserPay.Info memory userPay = pool.newLoanOnly(params);
        Quad expectedToken0 = Quad.wrap(bytes16(0x3ff2cd554a525f4c095e51042106b985)); // expecting userPay.token0 = 2.19980795531348973565011340895388119e-04
        assertTokenAmount(userPay.token0, expectedToken0, newLoanTestEpsilon);
        Quad expectedToken1 = -Quad.wrap(bytes16(0x3ff3a601eeac05c286c65b2a7003bdc7)); // expecting userPay.token1 = -4.02457759947907305120447013687273416e-04
        assertTokenAmount(userPay.token1, expectedToken1, newLoanTestEpsilon);

        console.log("testNewLoan_test_newloan_nontwap_with_whole_range_pour_immediate_below_mid_price_2_and_token_mix_0_5 testing done.");
    }

    function testNewLoan_test_newloan_nontwap_with_whole_range_pour_immediate_above_mid_price_2_and_token_mix_0_5() public {
        console.log("testNewLoan_test_newloan_nontwap_with_whole_range_pour_immediate_above_mid_price_2_and_token_mix_0_5 starting ......");
        testLimitedRangePour(
            Quad.wrap(bytes16(0x40000000000000000000000000000000)), // price = 2e+00
            Quad.wrap(bytes16(0x3ff847ae147ae147ae147ae147ae147b)), // quadVar = 1.00000000000000000000000000000000002e-02
            0, // startingTub
            4096, // stoppingTub
            Quad.wrap(bytes16(0x40059000000000000000000000000000)), // liquidityPerTub = 1e+02
            Quad.wrap(bytes16(0x40051ad3e3b2a4504826fe33545ba1b8)), // expected token0 = 7.07069232857502997478571876931418406e+01
            Quad.wrap(bytes16(0x40061ad5d03797ade615ebe5ad4dd249)), // expected token1 = 1.41417604195848024924996542572977972e+02
            false // skip the checks
        );
        Quad[] memory owedPotential = new Quad[](1);
        owedPotential[0] = Quad.wrap(bytes16(0x3fff0000000000000000000000000000));
        // int256 midBin = 16941;
        NewLoan.NewLoanParams memory params = NewLoan.NewLoanParams({
            owedPotential: owedPotential, // owedPotential = 1e+00
            startBin: 16942, // startBin
            strikeBin: 16942, // strikeBin
            tokenMix: Quad.wrap(bytes16(0x3ffe0000000000000000000000000000)), // tokenMix = 5e-01
            lockinEnd: POSITIVE_INFINITY,
            deadEra: OptInt256.wrap(OPT_INT256_NONE), // deadEra
            token: false, // token, unused for non-twap
            twapUntil: OptInt256.wrap(OPT_INT256_NONE) // twapUntil, disabled
        });
        UserPay.Info memory userPay = pool.newLoanOnly(params);
        Quad expectedToken0 = -Quad.wrap(bytes16(0x3ff2a5e525202e012a085576ed3ee07d)); // expecting userPay.token0 = -2.01175259467723471519903960653047046e-04
        assertTokenAmount(userPay.token0, expectedToken0, newLoanTestEpsilon);
        Quad expectedToken1 = Quad.wrap(bytes16(0x3ff3cd74c4c2dfb7eedfcfa6a51a7f42)); // expecting userPay.token1 = 4.40078856790586334364774360369139758e-04
        assertTokenAmount(userPay.token1, expectedToken1, newLoanTestEpsilon);

        console.log("testNewLoan_test_newloan_nontwap_with_whole_range_pour_immediate_above_mid_price_2_and_token_mix_0_5 testing done.");
    }

    function testNewLoan_test_newloan_nontwap_with_whole_range_pour_far_below_mid_price_2_and_token_mix_0_5() public {
        console.log("testNewLoan_test_newloan_nontwap_with_whole_range_pour_far_below_mid_price_2_and_token_mix_0_5 starting ......");
        testLimitedRangePour(
            Quad.wrap(bytes16(0x40000000000000000000000000000000)), // price = 2e+00
            Quad.wrap(bytes16(0x3ff847ae147ae147ae147ae147ae147b)), // quadVar = 1.00000000000000000000000000000000002e-02
            0, // startingTub
            4096, // stoppingTub
            Quad.wrap(bytes16(0x40059000000000000000000000000000)), // liquidityPerTub = 1e+02
            Quad.wrap(bytes16(0x40051ad3e3b2a4504826fe33545ba1b8)), // expected token0 = 7.07069232857502997478571876931418406e+01
            Quad.wrap(bytes16(0x40061ad5d03797ade615ebe5ad4dd249)), // expected token1 = 1.41417604195848024924996542572977972e+02
            false // skip the checks
        );
        Quad[] memory owedPotential = new Quad[](1);
        owedPotential[0] = Quad.wrap(bytes16(0x3fff0000000000000000000000000000));
        // int256 midBin = 16941;
        NewLoan.NewLoanParams memory params = NewLoan.NewLoanParams({
            owedPotential: owedPotential, // owedPotential = 1e+00
            startBin: 16931, // startBin
            strikeBin: 16931, // strikeBin
            tokenMix: Quad.wrap(bytes16(0x3ffe0000000000000000000000000000)), // tokenMix = 5e-01
            lockinEnd: POSITIVE_INFINITY,
            deadEra: OptInt256.wrap(OPT_INT256_NONE), // deadEra
            token: false, // token, unused for non-twap
            twapUntil: OptInt256.wrap(OPT_INT256_NONE) // twapUntil, disabled
        });
        UserPay.Info memory userPay = pool.newLoanOnly(params);
        Quad expectedToken0 = Quad.wrap(bytes16(0x3ff2cfec29eebc922f7ae4e58b7c68e2)); // expecting userPay.token0 = 2.21215493602829997520159061773623285e-04
        assertTokenAmount(userPay.token0, expectedToken0, newLoanTestEpsilon);
        Quad expectedToken1 = -Quad.wrap(bytes16(0x3ff3a83d4286179f19a7b194e3ee35dd)); // expecting userPay.token1 = -4.04586120913124399670623682935193302e-04
        assertTokenAmount(userPay.token1, expectedToken1, newLoanTestEpsilon);

        console.log("testNewLoan_test_newloan_nontwap_with_whole_range_pour_far_below_mid_price_2_and_token_mix_0_5 testing done.");
    }

    function testNewLoan_test_newloan_nontwap_with_whole_range_pour_far_above_mid_price_2_and_token_mix_0_5() public {
        console.log("testNewLoan_test_newloan_nontwap_with_whole_range_pour_far_above_mid_price_2_and_token_mix_0_5 starting ......");
        testLimitedRangePour(
            Quad.wrap(bytes16(0x40000000000000000000000000000000)), // price = 2e+00
            Quad.wrap(bytes16(0x3ff847ae147ae147ae147ae147ae147b)), // quadVar = 1.00000000000000000000000000000000002e-02
            0, // startingTub
            4096, // stoppingTub
            Quad.wrap(bytes16(0x40059000000000000000000000000000)), // liquidityPerTub = 1e+02
            Quad.wrap(bytes16(0x40051ad3e3b2a4504826fe33545ba1b8)), // expected token0 = 7.07069232857502997478571876931418406e+01
            Quad.wrap(bytes16(0x40061ad5d03797ade615ebe5ad4dd249)), // expected token1 = 1.41417604195848024924996542572977972e+02
            false // skip the checks
        );
        Quad[] memory owedPotential = new Quad[](1);
        owedPotential[0] = Quad.wrap(bytes16(0x3fff0000000000000000000000000000));
        // int256 midBin = 16941;
        NewLoan.NewLoanParams memory params = NewLoan.NewLoanParams({
            owedPotential: owedPotential, // owedPotential = 1e+00
            startBin: 16951, // startBin
            strikeBin: 16951, // strikeBin
            tokenMix: Quad.wrap(bytes16(0x3ffe0000000000000000000000000000)), // tokenMix = 5e-01
            lockinEnd: POSITIVE_INFINITY,
            deadEra: OptInt256.wrap(OPT_INT256_NONE), // deadEra
            token: false, // token, unused for non-twap
            twapUntil: OptInt256.wrap(OPT_INT256_NONE) // twapUntil, disabled
        });
        UserPay.Info memory userPay = pool.newLoanOnly(params);
        Quad expectedToken0 = -Quad.wrap(bytes16(0x3ff2a82052011e36be8b10fc78e77cca)); // expecting userPay.token0 = -2.02239156383200873729913117502563584e-04
        assertTokenAmount(userPay.token0, expectedToken0, newLoanTestEpsilon);
        Quad expectedToken1 = Quad.wrap(bytes16(0x3ff3d00bd19a20bd18a4b4875fe23eb2)); // expecting userPay.token1 = 4.42548911117221756512248172267049246e-04
        assertTokenAmount(userPay.token1, expectedToken1, newLoanTestEpsilon);

        console.log("testNewLoan_test_newloan_nontwap_with_whole_range_pour_far_above_mid_price_2_and_token_mix_0_5 testing done.");
    }

    function testNewLoan_test_newloan_nontwap_with_whole_range_pour_immediate_below_mid_price_2_and_token_mix_0_75() public {
        console.log("testNewLoan_test_newloan_nontwap_with_whole_range_pour_immediate_below_mid_price_2_and_token_mix_0_75 starting ......");
        testLimitedRangePour(
            Quad.wrap(bytes16(0x40000000000000000000000000000000)), // price = 2e+00
            Quad.wrap(bytes16(0x3ff847ae147ae147ae147ae147ae147b)), // quadVar = 1.00000000000000000000000000000000002e-02
            0, // startingTub
            4096, // stoppingTub
            Quad.wrap(bytes16(0x40059000000000000000000000000000)), // liquidityPerTub = 1e+02
            Quad.wrap(bytes16(0x40051ad3e3b2a4504826fe33545ba1b8)), // expected token0 = 7.07069232857502997478571876931418406e+01
            Quad.wrap(bytes16(0x40061ad5d03797ade615ebe5ad4dd249)), // expected token1 = 1.41417604195848024924996542572977972e+02
            false // skip the checks
        );
        Quad[] memory owedPotential = new Quad[](1);
        owedPotential[0] = Quad.wrap(bytes16(0x3fff0000000000000000000000000000));
        // int256 midBin = 16941;
        NewLoan.NewLoanParams memory params = NewLoan.NewLoanParams({
            owedPotential: owedPotential, // owedPotential = 1e+00
            startBin: 16940, // startBin
            strikeBin: 16940, // strikeBin
            tokenMix: Quad.wrap(bytes16(0x3ffe8000000000000000000000000000)), // tokenMix = 7.5e-01
            lockinEnd: POSITIVE_INFINITY,
            deadEra: OptInt256.wrap(OPT_INT256_NONE), // deadEra
            token: false, // token, unused for non-twap
            twapUntil: OptInt256.wrap(OPT_INT256_NONE) // twapUntil, disabled
        });
        UserPay.Info memory userPay = pool.newLoanOnly(params);
        Quad expectedToken0 = Quad.wrap(bytes16(0x3ff1cd554a525f4c095e51042106b985)); // expecting userPay.token0 = 1.0999039776567448678250567044769406e-04
        assertTokenAmount(userPay.token0, expectedToken0, newLoanTestEpsilon);
        Quad expectedToken1 = -Quad.wrap(bytes16(0x3ff27f21efec97b049001b701fb1fe18)); // expecting userPay.token1 = -1.826918445599555311684702958318649e-04
        assertTokenAmount(userPay.token1, expectedToken1, newLoanTestEpsilon);

        console.log("testNewLoan_test_newloan_nontwap_with_whole_range_pour_immediate_below_mid_price_2_and_token_mix_0_75 testing done.");
    }

    function testNewLoan_test_newloan_nontwap_with_whole_range_pour_immediate_above_mid_price_2_and_token_mix_0_75() public {
        console.log("testNewLoan_test_newloan_nontwap_with_whole_range_pour_immediate_above_mid_price_2_and_token_mix_0_75 starting ......");
        testLimitedRangePour(
            Quad.wrap(bytes16(0x40000000000000000000000000000000)), // price = 2e+00
            Quad.wrap(bytes16(0x3ff847ae147ae147ae147ae147ae147b)), // quadVar = 1.00000000000000000000000000000000002e-02
            0, // startingTub
            4096, // stoppingTub
            Quad.wrap(bytes16(0x40059000000000000000000000000000)), // liquidityPerTub = 1e+02
            Quad.wrap(bytes16(0x40051ad3e3b2a4504826fe33545ba1b8)), // expected token0 = 7.07069232857502997478571876931418406e+01
            Quad.wrap(bytes16(0x40061ad5d03797ade615ebe5ad4dd249)), // expected token1 = 1.41417604195848024924996542572977972e+02
            false // skip the checks
        );
        Quad[] memory owedPotential = new Quad[](1);
        owedPotential[0] = Quad.wrap(bytes16(0x3fff0000000000000000000000000000));
        // int256 midBin = 16941;
        NewLoan.NewLoanParams memory params = NewLoan.NewLoanParams({
            owedPotential: owedPotential, // owedPotential = 1e+00
            startBin: 16942, // startBin
            strikeBin: 16942, // strikeBin
            tokenMix: Quad.wrap(bytes16(0x3ffe8000000000000000000000000000)), // tokenMix = 7.5e-01
            lockinEnd: POSITIVE_INFINITY,
            deadEra: OptInt256.wrap(OPT_INT256_NONE), // deadEra
            token: false, // token, unused for non-twap
            twapUntil: OptInt256.wrap(OPT_INT256_NONE) // twapUntil, disabled
        });
        UserPay.Info memory userPay = pool.newLoanOnly(params);
        Quad expectedToken0 = -Quad.wrap(bytes16(0x3ff3462331cfe6e327e37c3c9526e4f9)); // expecting userPay.token0 = -3.11028937170584846550348312655512827e-04
        assertTokenAmount(userPay.token0, expectedToken0, newLoanTestEpsilon);
        Quad expectedToken1 = Quad.wrap(bytes16(0x3ff45a17939227c9f327dbbcfbd3df72)); // expecting userPay.token1 = 6.60118285185879501547161540553709684e-04
        assertTokenAmount(userPay.token1, expectedToken1, newLoanTestEpsilon);

        console.log("testNewLoan_test_newloan_nontwap_with_whole_range_pour_immediate_above_mid_price_2_and_token_mix_0_75 testing done.");
    }

    function testNewLoan_test_newloan_nontwap_with_whole_range_pour_far_below_mid_price_2_and_token_mix_0_75() public {
        console.log("testNewLoan_test_newloan_nontwap_with_whole_range_pour_far_below_mid_price_2_and_token_mix_0_75 starting ......");
        testLimitedRangePour(
            Quad.wrap(bytes16(0x40000000000000000000000000000000)), // price = 2e+00
            Quad.wrap(bytes16(0x3ff847ae147ae147ae147ae147ae147b)), // quadVar = 1.00000000000000000000000000000000002e-02
            0, // startingTub
            4096, // stoppingTub
            Quad.wrap(bytes16(0x40059000000000000000000000000000)), // liquidityPerTub = 1e+02
            Quad.wrap(bytes16(0x40051ad3e3b2a4504826fe33545ba1b8)), // expected token0 = 7.07069232857502997478571876931418406e+01
            Quad.wrap(bytes16(0x40061ad5d03797ade615ebe5ad4dd249)), // expected token1 = 1.41417604195848024924996542572977972e+02
            false // skip the checks
        );
        Quad[] memory owedPotential = new Quad[](1);
        owedPotential[0] = Quad.wrap(bytes16(0x3fff0000000000000000000000000000));
        // int256 midBin = 16941;
        NewLoan.NewLoanParams memory params = NewLoan.NewLoanParams({
            owedPotential: owedPotential, // owedPotential = 1e+00
            startBin: 16931, // startBin
            strikeBin: 16931, // strikeBin
            tokenMix: Quad.wrap(bytes16(0x3ffe8000000000000000000000000000)), // tokenMix = 7.5e-01
            lockinEnd: POSITIVE_INFINITY,
            deadEra: OptInt256.wrap(OPT_INT256_NONE), // deadEra
            token: false, // token, unused for non-twap
            twapUntil: OptInt256.wrap(OPT_INT256_NONE) // twapUntil, disabled
        });
        UserPay.Info memory userPay = pool.newLoanOnly(params);
        Quad expectedToken0 = Quad.wrap(bytes16(0x3ff1cfec29eebc922f7ae4e58b7c68e2)); // expecting userPay.token0 = 1.10607746801414998760079530886811643e-04
        assertTokenAmount(userPay.token0, expectedToken0, newLoanTestEpsilon);
        Quad expectedToken1 = -Quad.wrap(bytes16(0x3ff2862b1f4262113b4a01d17593babc)); // expecting userPay.token1 = -1.86046812882042201900936377171645739e-04
        assertTokenAmount(userPay.token1, expectedToken1, newLoanTestEpsilon);

        console.log("testNewLoan_test_newloan_nontwap_with_whole_range_pour_far_below_mid_price_2_and_token_mix_0_75 testing done.");
    }

    function testNewLoan_test_newloan_nontwap_with_whole_range_pour_far_above_mid_price_2_and_token_mix_0_75() public {
        console.log("testNewLoan_test_newloan_nontwap_with_whole_range_pour_far_above_mid_price_2_and_token_mix_0_75 starting ......");
        testLimitedRangePour(
            Quad.wrap(bytes16(0x40000000000000000000000000000000)), // price = 2e+00
            Quad.wrap(bytes16(0x3ff847ae147ae147ae147ae147ae147b)), // quadVar = 1.00000000000000000000000000000000002e-02
            0, // startingTub
            4096, // stoppingTub
            Quad.wrap(bytes16(0x40059000000000000000000000000000)), // liquidityPerTub = 1e+02
            Quad.wrap(bytes16(0x40051ad3e3b2a4504826fe33545ba1b8)), // expected token0 = 7.07069232857502997478571876931418406e+01
            Quad.wrap(bytes16(0x40061ad5d03797ade615ebe5ad4dd249)), // expected token1 = 1.41417604195848024924996542572977972e+02
            false // skip the checks
        );
        Quad[] memory owedPotential = new Quad[](1);
        owedPotential[0] = Quad.wrap(bytes16(0x3fff0000000000000000000000000000));
        // int256 midBin = 16941;
        NewLoan.NewLoanParams memory params = NewLoan.NewLoanParams({
            owedPotential: owedPotential, // owedPotential = 1e+00
            startBin: 16951, // startBin
            strikeBin: 16951, // strikeBin
            tokenMix: Quad.wrap(bytes16(0x3ffe8000000000000000000000000000)), // tokenMix = 7.5e-01
            lockinEnd: POSITIVE_INFINITY,
            deadEra: OptInt256.wrap(OPT_INT256_NONE), // deadEra
            token: false, // token, unused for non-twap
            twapUntil: OptInt256.wrap(OPT_INT256_NONE) // twapUntil, disabled
        });
        UserPay.Info memory userPay = pool.newLoanOnly(params);
        Quad expectedToken0 = -Quad.wrap(bytes16(0x3ff3469c3192f228840c8947d5ffbc6e)); // expecting userPay.token0 = -3.11479693831752838508147878090727764e-04
        assertTokenAmount(userPay.token0, expectedToken0, newLoanTestEpsilon);
        Quad expectedToken1 = Quad.wrap(bytes16(0x3ff45c08dd33988dd27b876587e9af05)); // expecting userPay.token1 = 6.63823366675832634768372258400573822e-04
        assertTokenAmount(userPay.token1, expectedToken1, newLoanTestEpsilon);

        console.log("testNewLoan_test_newloan_nontwap_with_whole_range_pour_far_above_mid_price_2_and_token_mix_0_75 testing done.");
    }

    function testNewLoan_test_newloan_nontwap_with_whole_range_pour_immediate_below_mid_price_2_and_token_mix_1() public {
        console.log("testNewLoan_test_newloan_nontwap_with_whole_range_pour_immediate_below_mid_price_2_and_token_mix_1 starting ......");
        testLimitedRangePour(
            Quad.wrap(bytes16(0x40000000000000000000000000000000)), // price = 2e+00
            Quad.wrap(bytes16(0x3ff847ae147ae147ae147ae147ae147b)), // quadVar = 1.00000000000000000000000000000000002e-02
            0, // startingTub
            4096, // stoppingTub
            Quad.wrap(bytes16(0x40059000000000000000000000000000)), // liquidityPerTub = 1e+02
            Quad.wrap(bytes16(0x40051ad3e3b2a4504826fe33545ba1b8)), // expected token0 = 7.07069232857502997478571876931418406e+01
            Quad.wrap(bytes16(0x40061ad5d03797ade615ebe5ad4dd249)), // expected token1 = 1.41417604195848024924996542572977972e+02
            false // skip the checks
        );
        Quad[] memory owedPotential = new Quad[](1);
        owedPotential[0] = Quad.wrap(bytes16(0x3fff0000000000000000000000000000));
        // int256 midBin = 16941;
        NewLoan.NewLoanParams memory params = NewLoan.NewLoanParams({
            owedPotential: owedPotential, // owedPotential = 1e+00
            startBin: 16940, // startBin
            strikeBin: 16940, // strikeBin
            tokenMix: Quad.wrap(bytes16(0x3fff0000000000000000000000000000)), // tokenMix = 1e+00
            lockinEnd: POSITIVE_INFINITY,
            deadEra: OptInt256.wrap(OPT_INT256_NONE), // deadEra
            token: false, // token, unused for non-twap
            twapUntil: OptInt256.wrap(OPT_INT256_NONE) // twapUntil, disabled
        });
        UserPay.Info memory userPay = pool.newLoanOnly(params);
        Quad expectedToken0 = POSITIVE_ZERO; // expecting userPay.token0 = 0e+00
        assertTokenAmount(userPay.token0, expectedToken0, newLoanTestEpsilon);
        Quad expectedToken1 = Quad.wrap(bytes16(0x3ff036fff5fb7091ee31fdd2828dfd80)); // expecting userPay.token1 = 3.70740708279962427835064220235436623e-05
        assertTokenAmount(userPay.token1, expectedToken1, newLoanTestEpsilon);

        console.log("testNewLoan_test_newloan_nontwap_with_whole_range_pour_immediate_below_mid_price_2_and_token_mix_1 testing done.");
    }

    function testNewLoan_test_newloan_nontwap_with_whole_range_pour_immediate_above_mid_price_2_and_token_mix_1() public {
        console.log("testNewLoan_test_newloan_nontwap_with_whole_range_pour_immediate_above_mid_price_2_and_token_mix_1 starting ......");
        testLimitedRangePour(
            Quad.wrap(bytes16(0x40000000000000000000000000000000)), // price = 2e+00
            Quad.wrap(bytes16(0x3ff847ae147ae147ae147ae147ae147b)), // quadVar = 1.00000000000000000000000000000000002e-02
            0, // startingTub
            4096, // stoppingTub
            Quad.wrap(bytes16(0x40059000000000000000000000000000)), // liquidityPerTub = 1e+02
            Quad.wrap(bytes16(0x40051ad3e3b2a4504826fe33545ba1b8)), // expected token0 = 7.07069232857502997478571876931418406e+01
            Quad.wrap(bytes16(0x40061ad5d03797ade615ebe5ad4dd249)), // expected token1 = 1.41417604195848024924996542572977972e+02
            false // skip the checks
        );
        Quad[] memory owedPotential = new Quad[](1);
        owedPotential[0] = Quad.wrap(bytes16(0x3fff0000000000000000000000000000));
        // int256 midBin = 16941;
        NewLoan.NewLoanParams memory params = NewLoan.NewLoanParams({
            owedPotential: owedPotential, // owedPotential = 1e+00
            startBin: 16942, // startBin
            strikeBin: 16942, // strikeBin
            tokenMix: Quad.wrap(bytes16(0x3fff0000000000000000000000000000)), // tokenMix = 1e+00
            lockinEnd: POSITIVE_INFINITY,
            deadEra: OptInt256.wrap(OPT_INT256_NONE), // deadEra
            token: false, // token, unused for non-twap
            twapUntil: OptInt256.wrap(OPT_INT256_NONE) // twapUntil, disabled
        });
        UserPay.Info memory userPay = pool.newLoanOnly(params);
        Quad expectedToken0 = -Quad.wrap(bytes16(0x3ff3b953d10fb6c5bac2cdbdb3ae59b3)); // expecting userPay.token0 = -4.20882614873446221580792664657978585e-04
        assertTokenAmount(userPay.token0, expectedToken0, newLoanTestEpsilon);
        Quad expectedToken1 = Quad.wrap(bytes16(0x3ff4cd74c4c2dfb7eedfcfa6a51a7f42)); // expecting userPay.token1 = 8.80157713581172668729548720738279517e-04
        assertTokenAmount(userPay.token1, expectedToken1, newLoanTestEpsilon);

        console.log("testNewLoan_test_newloan_nontwap_with_whole_range_pour_immediate_above_mid_price_2_and_token_mix_1 testing done.");
    }

    function testNewLoan_test_newloan_nontwap_with_whole_range_pour_far_below_mid_price_2_and_token_mix_1() public {
        console.log("testNewLoan_test_newloan_nontwap_with_whole_range_pour_far_below_mid_price_2_and_token_mix_1 starting ......");
        testLimitedRangePour(
            Quad.wrap(bytes16(0x40000000000000000000000000000000)), // price = 2e+00
            Quad.wrap(bytes16(0x3ff847ae147ae147ae147ae147ae147b)), // quadVar = 1.00000000000000000000000000000000002e-02
            0, // startingTub
            4096, // stoppingTub
            Quad.wrap(bytes16(0x40059000000000000000000000000000)), // liquidityPerTub = 1e+02
            Quad.wrap(bytes16(0x40051ad3e3b2a4504826fe33545ba1b8)), // expected token0 = 7.07069232857502997478571876931418406e+01
            Quad.wrap(bytes16(0x40061ad5d03797ade615ebe5ad4dd249)), // expected token1 = 1.41417604195848024924996542572977972e+02
            false // skip the checks
        );
        Quad[] memory owedPotential = new Quad[](1);
        owedPotential[0] = Quad.wrap(bytes16(0x3fff0000000000000000000000000000));
        // int256 midBin = 16941;
        NewLoan.NewLoanParams memory params = NewLoan.NewLoanParams({
            owedPotential: owedPotential, // owedPotential = 1e+00
            startBin: 16931, // startBin
            strikeBin: 16931, // strikeBin
            tokenMix: Quad.wrap(bytes16(0x3fff0000000000000000000000000000)), // tokenMix = 1e+00
            lockinEnd: POSITIVE_INFINITY,
            deadEra: OptInt256.wrap(OPT_INT256_NONE), // deadEra
            token: false, // token, unused for non-twap
            twapUntil: OptInt256.wrap(OPT_INT256_NONE) // twapUntil, disabled
        });
        UserPay.Info memory userPay = pool.newLoanOnly(params);
        Quad expectedToken0 = POSITIVE_ZERO; // expecting userPay.token0 = 0e+00
        assertTokenAmount(userPay.token0, expectedToken0, newLoanTestEpsilon);
        Quad expectedToken1 = Quad.wrap(bytes16(0x3ff010911a1dac6ef2ed7e1b72d3d8f0)); // expecting userPay.token1 = 3.24924951490399958687509285919016828e-05
        assertTokenAmount(userPay.token1, expectedToken1, newLoanTestEpsilon);

        console.log("testNewLoan_test_newloan_nontwap_with_whole_range_pour_far_below_mid_price_2_and_token_mix_1 testing done.");
    }

    function testNewLoan_test_newloan_nontwap_with_whole_range_pour_far_above_mid_price_2_and_token_mix_1() public {
        console.log("testNewLoan_test_newloan_nontwap_with_whole_range_pour_far_above_mid_price_2_and_token_mix_1 starting ......");
        testLimitedRangePour(
            Quad.wrap(bytes16(0x40000000000000000000000000000000)), // price = 2e+00
            Quad.wrap(bytes16(0x3ff847ae147ae147ae147ae147ae147b)), // quadVar = 1.00000000000000000000000000000000002e-02
            0, // startingTub
            4096, // stoppingTub
            Quad.wrap(bytes16(0x40059000000000000000000000000000)), // liquidityPerTub = 1e+02
            Quad.wrap(bytes16(0x40051ad3e3b2a4504826fe33545ba1b8)), // expected token0 = 7.07069232857502997478571876931418406e+01
            Quad.wrap(bytes16(0x40061ad5d03797ade615ebe5ad4dd249)), // expected token1 = 1.41417604195848024924996542572977972e+02
            false // skip the checks
        );
        Quad[] memory owedPotential = new Quad[](1);
        owedPotential[0] = Quad.wrap(bytes16(0x3fff0000000000000000000000000000));
        // int256 midBin = 16941;
        NewLoan.NewLoanParams memory params = NewLoan.NewLoanParams({
            owedPotential: owedPotential, // owedPotential = 1e+00
            startBin: 16951, // startBin
            strikeBin: 16951, // strikeBin
            tokenMix: Quad.wrap(bytes16(0x3fff0000000000000000000000000000)), // tokenMix = 1e+00
            lockinEnd: POSITIVE_INFINITY,
            deadEra: OptInt256.wrap(OPT_INT256_NONE), // deadEra
            token: false, // token, unused for non-twap
            twapUntil: OptInt256.wrap(OPT_INT256_NONE) // twapUntil, disabled
        });
        UserPay.Info memory userPay = pool.newLoanOnly(params);
        Quad expectedToken0 = -Quad.wrap(bytes16(0x3ff3b9283a255535a8d38a116f8bba76)); // expecting userPay.token0 = -4.20720231280304803286382638678891897e-04
        assertTokenAmount(userPay.token0, expectedToken0, newLoanTestEpsilon);
        Quad expectedToken1 = Quad.wrap(bytes16(0x3ff4d00bd19a20bd18a4b4875fe23eb2)); // expecting userPay.token1 = 8.85097822234443513024496344534098493e-04
        assertTokenAmount(userPay.token1, expectedToken1, newLoanTestEpsilon);

        console.log("testNewLoan_test_newloan_nontwap_with_whole_range_pour_far_above_mid_price_2_and_token_mix_1 testing done.");
    }
}
