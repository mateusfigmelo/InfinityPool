// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import {ABDKMathQuad} from "../../../lib/abdk-libraries-solidity/ABDKMathQuad.sol";
import {Quad} from "./ValueType.sol";

Quad constant POSITIVE_ZERO = Quad.wrap(bytes16(0));
Quad constant NEGATIVE_ZERO = Quad.wrap(bytes16(0x80000000000000000000000000000000));
Quad constant HALF = Quad.wrap(0x3ffe0000000000000000000000000000);
Quad constant POSITIVE_ONE = Quad.wrap(bytes16(0x3fff0000000000000000000000000000));
Quad constant NEGATIVE_ONE = Quad.wrap(bytes16(0xbfff0000000000000000000000000000));
Quad constant NEGATIVE_TWO = Quad.wrap(bytes16(0xc0000000000000000000000000000000));
Quad constant POSITIVE_TWO = Quad.wrap(bytes16(0x40000000000000000000000000000000));
Quad constant POSITIVE_THREE = Quad.wrap(bytes16(0x40008000000000000000000000000000));
Quad constant POSITIVE_FOUR = Quad.wrap(bytes16(0x40010000000000000000000000000000));
Quad constant POSITIVE_EIGHT = Quad.wrap(bytes16(0x40020000000000000000000000000000));
Quad constant POSITIVE_NINE = Quad.wrap(bytes16(0x40022000000000000000000000000000));
Quad constant POSITIVE_TEN = Quad.wrap(bytes16(0x40024000000000000000000000000000));
Quad constant NEGATIVE_INFINITY = Quad.wrap(bytes16(0xFFFF0000000000000000000000000000));
Quad constant POSITIVE_INFINITY = Quad.wrap(bytes16(0x7FFF0000000000000000000000000000));

Quad constant POSITIVE_EIGHT_OVER_NINE = Quad.wrap(bytes16(0x3ffec71c71c71c71c71c71c71c71c71c));
Quad constant POSITIVE_ONE_OVER_FOUR = Quad.wrap(bytes16(0x3ffd0000000000000000000000000000));

Quad constant EXP1MQ_THRESHOLD = Quad.wrap(0x40060000000000000000000000000000);

Quad constant EXP1MQ_P0 = Quad.wrap(0x401b18b74db8e974042c1eac2c0a7a5e);
Quad constant EXP1MQ_P1 = Quad.wrap(0xC018b49e5c6b648d31976b98b3e697c3);
Quad constant EXP1MQ_P2 = Quad.wrap(0x401610f7ed9cdae66efa8978bd75c0a5);
Quad constant EXP1MQ_P3 = Quad.wrap(0xC012602b68aef25d83c39ea400d894a2);
Quad constant EXP1MQ_P4 = Quad.wrap(0x400e65bb3fe055cce75e048a64c689c0);
Quad constant EXP1MQ_P5 = Quad.wrap(0xC009ad3170bea3194cbe8d312eb34724);
Quad constant EXP1MQ_P6 = Quad.wrap(0x4004601acdf8f4a35cb7b3af79c1ce70);
Quad constant EXP1MQ_P7 = Quad.wrap(0xbffdf49b524a2c731e1a0a08790ae2ce);

Quad constant EXP1MQ_Q0 = Quad.wrap(0x401da512f4955e2e06422e02420fb8ce);
Quad constant EXP1MQ_Q1 = Quad.wrap(0xc01c7644dcf2f4cbf5b9df5a647e501b);
Quad constant EXP1MQ_Q2 = Quad.wrap(0x401a3433da9ed469900a26e6c4460f28);
Quad constant EXP1MQ_Q3 = Quad.wrap(0xc017342de8ba7627efc2e1ebcb9f9029);
Quad constant EXP1MQ_Q4 = Quad.wrap(0x40139ade0baac376535af72a52fad173);
Quad constant EXP1MQ_Q5 = Quad.wrap(0xc00f779b1d90dd705e51381c74ca5bae);
Quad constant EXP1MQ_Q6 = Quad.wrap(0x400ace36e0e390d4c5b2a0885cb5703e);
Quad constant EXP1MQ_Q7 = Quad.wrap(0xc0056017f7f4f644ac4924ea19c21ecb);

Quad constant EXP1MQ_C1 = Quad.wrap(0x3ffe62e4000000000000000000000000);
Quad constant EXP1MQ_C2 = Quad.wrap(0x3feb7f7d1cf79abc9e3b39803f2f6af4);

Quad constant EXP1MQ_MINARG = Quad.wrap(0xc0053c133ab16db990b9ff9d97e6c709);
Quad constant EXP1MQ_MAXLOG = Quad.wrap(0x400c62e42fefa39ef35793c7673007e6);
Quad constant EXP1MQ_TWO114 = Quad.wrap(0x40710000000000000000000000000000);
Quad constant EXP1MQ_HUGE_VALQ = Quad.wrap(0x400effffffffffffffffffffffffffff);

Quad constant LOG1PQ_P12 = Quad.wrap(0x3feb9d04a0d6ed8295434922008560fc);
Quad constant LOG1PQ_P11 = Quad.wrap(0x3ffdffd7e21347cc2e9cb5e91a8c2fa0);
Quad constant LOG1PQ_P10 = Quad.wrap(0x400373615178fe96674c43ea62a592e7);
Quad constant LOG1PQ_P9 = Quad.wrap(0x40079b73a8639c28fa539715d5fd0560);
Quad constant LOG1PQ_P8 = Quad.wrap(0x400ade1e79b3ae125ec5c60d38b7fa2a);
Quad constant LOG1PQ_P7 = Quad.wrap(0x400d4ca24f0550cf6369f0cada64eeec);
Quad constant LOG1PQ_P6 = Quad.wrap(0x400f28a791822d40115104b644c1f464);
Quad constant LOG1PQ_P5 = Quad.wrap(0x40105f196a49f17195ec43488121aff8);
Quad constant LOG1PQ_P4 = Quad.wrap(0x401116caba9f2757a2484b7171ab5034);
Quad constant LOG1PQ_P3 = Quad.wrap(0x401125a72eb05ba7e49b2bf8646a8a1e);
Quad constant LOG1PQ_P2 = Quad.wrap(0x4010897ca319418d17ac5c737d1b8ad4);
Quad constant LOG1PQ_P1 = Quad.wrap(0x400f2f8f8bfbf9a19ff15925da76d408);
Quad constant LOG1PQ_P0 = Quad.wrap(0x400c9a7dcad5d0efe740b8544d79077c);

Quad constant LOG1PQ_Q11 = Quad.wrap(0x40048322fbda4d3f4a2113daac8d7fa5);
Quad constant LOG1PQ_Q10 = Quad.wrap(0x4008c73f14777e569efb2fe2c778f56f);
Quad constant LOG1PQ_Q9 = Quad.wrap(0x400c1dd933ea5565f23a98d434d3a705);
Quad constant LOG1PQ_Q8 = Quad.wrap(0x400eb5f4d77aed024b44059a3b76f461);
Quad constant LOG1PQ_Q7 = Quad.wrap(0x4010b71bb67f5eff2962234d48fff0bc);
Quad constant LOG1PQ_Q6 = Quad.wrap(0x40122b6c5ddac3b8e673c713bcf24ee3);
Quad constant LOG1PQ_Q5 = Quad.wrap(0x40131ab83fa3b03b34d8d36e8de37c71);
Quad constant LOG1PQ_Q4 = Quad.wrap(0x401371d8273f762a061338bb0e95b314);
Quad constant LOG1PQ_Q3 = Quad.wrap(0x401348fbe89d38e2e379b5d8e7071d74);
Quad constant LOG1PQ_Q2 = Quad.wrap(0x40127bc5211688c1412eafafea233277);
Quad constant LOG1PQ_Q1 = Quad.wrap(0x40110088814003ea16378fd2514ba129);
Quad constant LOG1PQ_Q0 = Quad.wrap(0x400e33de58205cb3ed708a3f3a1ac5ca);

Quad constant LOG1PQ_R5 = Quad.wrap(0xbffec40a1c874f5a68479d54e4ced708);
Quad constant LOG1PQ_R4 = Quad.wrap(0x40054247b533971e565b5611a30df628);
Quad constant LOG1PQ_R3 = Quad.wrap(0xc009fa1350a9210eb690eddd457e03b0);
Quad constant LOG1PQ_R2 = Quad.wrap(0x400d4020cbb3c4edea1230d4dc2a41c8);
Quad constant LOG1PQ_R1 = Quad.wrap(0xc00f5eac94780e23388e5d3ae806c32a);
Quad constant LOG1PQ_R0 = Quad.wrap(0x401014fab5e2e8c16802a6fb3250b4fd);

Quad constant LOG1PQ_S5 = Quad.wrap(0xc005da8b34108b632575cd7cadd52c63);
Quad constant LOG1PQ_S4 = Quad.wrap(0x400af3d0db24df089022bf51e9d20aec);
Quad constant LOG1PQ_S3 = Quad.wrap(0xc00ec11ad77cc51ceb27fc1032bb267d);
Quad constant LOG1PQ_S2 = Quad.wrap(0x401186c6f13df72eaeec5bd6a5211cbd);
Quad constant LOG1PQ_S1 = Quad.wrap(0xc013455371e04bc5ee9e91e4b3020178);
Quad constant LOG1PQ_S0 = Quad.wrap(0x40139f7810d45d221c03fa78cb791730);

Quad constant LOG1PQ_C1 = Quad.wrap(0x3ffe62e4000000000000000000000000);
Quad constant LOG1PQ_C2 = Quad.wrap(0x3feb7f7d1cf79abc9e3b39803f2f6af4);
Quad constant LOG1PQ_SQRTH = Quad.wrap(0x3ffe6a09e667f3bcc908b2fb1366ea95);
Quad constant LOG1PQ_THRESHOLD = Quad.wrap(0x3f8e0000000000000000000000000000);

// Corresponds to Int128(-1L, 0L)
bytes16 constant FREXP_H128 = bytes16(0xFFFFFFFFFFFFFFFF0000000000000000);
// Corresponds to Int128(0L, -1L)
bytes16 constant FREXP_L128 = bytes16(0x0000000000000000FFFFFFFFFFFFFFFF);
