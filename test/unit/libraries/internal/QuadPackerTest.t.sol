// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "src/libraries/internal/SparseFloat.sol";
import {Quad} from "src/types/ABDKMathQuad/ValueType.sol";

//Correct answer is generated from Scala
contract QuadPackerTest is Test {
    function test_unpack() public {
        assertEq(QuadPacker.unpack(Quad.wrap(0x4045086d396a11737d010d2c9de3e308)).significand, 5363209773952203113811856024920840);
        assertEq(QuadPacker.unpack(Quad.wrap(0x4045086d396a11737d010d2c9de3e308)).exponent, -42);
        assertEq(QuadPacker.unpack(Quad.wrap(0x2d1e61fedeee482129ee20bce2925746)).significand, 7179883537104810358998582858766150);
        assertEq(QuadPacker.unpack(Quad.wrap(0x2d1e61fedeee482129ee20bce2925746)).exponent, -4945);
        assertEq(QuadPacker.unpack(Quad.wrap(0x29f964ab232e44ffd7e6a8b34785d0d2)).significand, 7234096722601705719885447437865170);
        assertEq(QuadPacker.unpack(Quad.wrap(0x29f964ab232e44ffd7e6a8b34785d0d2)).exponent, -5750);
        assertEq(QuadPacker.unpack(Quad.wrap(0x4c37ca6c0535caa154fe3cb0adabff56)).significand, 9297901852479017228663442086035286);
        assertEq(QuadPacker.unpack(Quad.wrap(0x4c37ca6c0535caa154fe3cb0adabff56)).exponent, 3016);
        assertEq(QuadPacker.unpack(Quad.wrap(0x78ecd54d5a081a1d097e6d6459ce67a7)).significand, 9518578536071839429036401895565223);
        assertEq(QuadPacker.unpack(Quad.wrap(0x78ecd54d5a081a1d097e6d6459ce67a7)).exponent, 14461);
        assertEq(QuadPacker.unpack(Quad.wrap(0x273ff92b7da8d3c9f7b55433ebfd6eb5)).significand, 10246062550558117266710767129685685);
        assertEq(QuadPacker.unpack(Quad.wrap(0x273ff92b7da8d3c9f7b55433ebfd6eb5)).exponent, -6448);
        assertEq(QuadPacker.unpack(Quad.wrap(0x198d4970a96bcdc27b8a0377a7d9a2d3)).significand, 6681838747096392380641061602173651);
        assertEq(QuadPacker.unpack(Quad.wrap(0x198d4970a96bcdc27b8a0377a7d9a2d3)).exponent, -9954);
        assertEq(QuadPacker.unpack(Quad.wrap(0x578b7e81987be668304d8dc4f00ebdf4)).significand, 7758148093066713091584900016815604);
        assertEq(QuadPacker.unpack(Quad.wrap(0x578b7e81987be668304d8dc4f00ebdf4)).exponent, 5916);
        assertEq(QuadPacker.unpack(Quad.wrap(0x6f343898524b9322db6354aa32648bcf)).significand, 6340179946176562043831135555062735);
        assertEq(QuadPacker.unpack(Quad.wrap(0x6f343898524b9322db6354aa32648bcf)).exponent, 11973);
        assertEq(QuadPacker.unpack(Quad.wrap(0x18d9ee911edd411c4421351eac63b6da)).significand, 10031007979798869533050180835981018);
        assertEq(QuadPacker.unpack(Quad.wrap(0x18d9ee911edd411c4421351eac63b6da)).exponent, -10134);
        assertEq(QuadPacker.unpack(Quad.wrap(0x2908a3cd39cc3ada568a2c649dee0575)).significand, 8514589284789825996953796561732981);
        assertEq(QuadPacker.unpack(Quad.wrap(0x2908a3cd39cc3ada568a2c649dee0575)).exponent, -5991);
        assertEq(QuadPacker.unpack(Quad.wrap(0x1779a9415dd1f8729eb56787a2912fb5)).significand, 8625202948060058049406786996350901);
        assertEq(QuadPacker.unpack(Quad.wrap(0x1779a9415dd1f8729eb56787a2912fb5)).exponent, -10486);
        assertEq(QuadPacker.unpack(Quad.wrap(0x591adea0635e5461600d5f4de87c70f3)).significand, 9707699049601255153627889902842099);
        assertEq(QuadPacker.unpack(Quad.wrap(0x591adea0635e5461600d5f4de87c70f3)).exponent, 6315);
        assertEq(QuadPacker.unpack(Quad.wrap(0x56ad7e183382c7bc1259a6d70ef5a6a8)).significand, 7749797886334358124798717724042920);
        assertEq(QuadPacker.unpack(Quad.wrap(0x56ad7e183382c7bc1259a6d70ef5a6a8)).exponent, 5694);
        assertEq(QuadPacker.unpack(Quad.wrap(0x4101c429bcd6b117fbafc9928ffe24d1)).significand, 9170955938241912958386534814196945);
        assertEq(QuadPacker.unpack(Quad.wrap(0x4101c429bcd6b117fbafc9928ffe24d1)).exponent, 146);
        assertEq(QuadPacker.unpack(Quad.wrap(0x487c9bbadf0c20176f1df9b613846404)).significand, 8350875815144337715756392083907588);
        assertEq(QuadPacker.unpack(Quad.wrap(0x487c9bbadf0c20176f1df9b613846404)).exponent, 2061);
        assertEq(QuadPacker.unpack(Quad.wrap(0x38d5f15e2236f098069c20c082cdb362)).significand, 10087815609199721570637479595062114);
        assertEq(QuadPacker.unpack(Quad.wrap(0x38d5f15e2236f098069c20c082cdb362)).exponent, -1946);
        assertEq(QuadPacker.unpack(Quad.wrap(0x46e022cb8fcd73589f6f6d7503ba481b)).significand, 5898026606780284504350020180002843);
        assertEq(QuadPacker.unpack(Quad.wrap(0x46e022cb8fcd73589f6f6d7503ba481b)).exponent, 1649);
        assertEq(QuadPacker.unpack(Quad.wrap(0x0c24facbbe6f0d90f4ddf59a8c9e991c)).significand, 10279041512844837667788573477083420);
        assertEq(QuadPacker.unpack(Quad.wrap(0x0c24facbbe6f0d90f4ddf59a8c9e991c)).exponent, -13387);
        assertEq(QuadPacker.unpack(Quad.wrap(0x37439dfaab1af6c142dbc2faf77994c9)).significand, 8396495161470723923526479467091145);
        assertEq(QuadPacker.unpack(Quad.wrap(0x37439dfaab1af6c142dbc2faf77994c9)).exponent, -2348);
        assertEq(QuadPacker.unpack(Quad.wrap(0x482f8b950352e5eda085327a436223f9)).significand, 8023357818329787245824737393386489);
        assertEq(QuadPacker.unpack(Quad.wrap(0x482f8b950352e5eda085327a436223f9)).exponent, 1984);
        assertEq(QuadPacker.unpack(Quad.wrap(0x168b70612f91e5b4f465140bbf66ee75)).significand, 7471626588082163753112997697351285);
        assertEq(QuadPacker.unpack(Quad.wrap(0x168b70612f91e5b4f465140bbf66ee75)).exponent, -10724);
        assertEq(QuadPacker.unpack(Quad.wrap(0x019c79281297414febdc9f2e5922ffc8)).significand, 7649643300663653979154563115188168);
        assertEq(QuadPacker.unpack(Quad.wrap(0x019c79281297414febdc9f2e5922ffc8)).exponent, -16083);
        assertEq(QuadPacker.unpack(Quad.wrap(0x1954a8a09835419c22da1e9cb3c1ccd3)).significand, 8612465284054985862609820224441555);
        assertEq(QuadPacker.unpack(Quad.wrap(0x1954a8a09835419c22da1e9cb3c1ccd3)).exponent, -10011);
        assertEq(QuadPacker.unpack(Quad.wrap(0x77ea446b3acc8ba620d0fc6b79abeb4d)).significand, 6579996322383077806182215669508941);
        assertEq(QuadPacker.unpack(Quad.wrap(0x77ea446b3acc8ba620d0fc6b79abeb4d)).exponent, 14203);
        assertEq(QuadPacker.unpack(Quad.wrap(0x67928594870b77fb8c057dbac840aacd)).significand, 7901624898213722648057294270540493);
        assertEq(QuadPacker.unpack(Quad.wrap(0x67928594870b77fb8c057dbac840aacd)).exponent, 10019);
        assertEq(QuadPacker.unpack(Quad.wrap(0x33a8cf7b9517e0b34db4c24293d2557c)).significand, 9400546852612852810029116731577724);
        assertEq(QuadPacker.unpack(Quad.wrap(0x33a8cf7b9517e0b34db4c24293d2557c)).exponent, -3271);
        assertEq(QuadPacker.unpack(Quad.wrap(0x5dd333a4ac3159126a062c6766569a39)).significand, 6239746458053086902197163262384697);
        assertEq(QuadPacker.unpack(Quad.wrap(0x5dd333a4ac3159126a062c6766569a39)).exponent, 7524);
        assertEq(QuadPacker.unpack(Quad.wrap(0x38c3f41f1acb59084867e41a02f2ab47)).significand, 10143669167306417551498016617311047);
        assertEq(QuadPacker.unpack(Quad.wrap(0x38c3f41f1acb59084867e41a02f2ab47)).exponent, -1964);
        assertEq(QuadPacker.unpack(Quad.wrap(0x3b0d75fb34082b17c175c4d8b5ac9daa)).significand, 7585241154048570657870658046565802);
        assertEq(QuadPacker.unpack(Quad.wrap(0x3b0d75fb34082b17c175c4d8b5ac9daa)).exponent, -1378);
        assertEq(QuadPacker.unpack(Quad.wrap(0x248e37a8ccc0ce368f5fb4a525ee091a)).significand, 6321203086067640781791950772504858);
        assertEq(QuadPacker.unpack(Quad.wrap(0x248e37a8ccc0ce368f5fb4a525ee091a)).exponent, -7137);
        assertEq(QuadPacker.unpack(Quad.wrap(0x726737bdbd8e66ef0fe829fc00d14c39)).significand, 6322862174271279380446694631099449);
        assertEq(QuadPacker.unpack(Quad.wrap(0x726737bdbd8e66ef0fe829fc00d14c39)).exponent, 12792);
        assertEq(QuadPacker.unpack(Quad.wrap(0x28d7f583535ca6278f9101245f340190)).significand, 10171891899980488691035225934004624);
        assertEq(QuadPacker.unpack(Quad.wrap(0x28d7f583535ca6278f9101245f340190)).exponent, -6040);
        assertEq(QuadPacker.unpack(Quad.wrap(0x2bc54c58c0da48289b162284e74a05b3)).significand, 6740791751722083648388116953826739);
        assertEq(QuadPacker.unpack(Quad.wrap(0x2bc54c58c0da48289b162284e74a05b3)).exponent, -5290);
        assertEq(QuadPacker.unpack(Quad.wrap(0x1d049dceec2290c4899e44e5af944ff2)).significand, 8393029248035520294778954606465010);
        assertEq(QuadPacker.unpack(Quad.wrap(0x1d049dceec2290c4899e44e5af944ff2)).exponent, -9067);
        assertEq(QuadPacker.unpack(Quad.wrap(0x3eda692aed7a3cd02976f8ec3281fe00)).significand, 7325350945467311676578540097240576);
        assertEq(QuadPacker.unpack(Quad.wrap(0x3eda692aed7a3cd02976f8ec3281fe00)).exponent, -405);
        assertEq(QuadPacker.unpack(Quad.wrap(0x5e09dd486ae5be04cd3b44eed479b7b4)).significand, 9680446891795265786068061249976244);
        assertEq(QuadPacker.unpack(Quad.wrap(0x5e09dd486ae5be04cd3b44eed479b7b4)).exponent, 7578);
        assertEq(QuadPacker.unpack(Quad.wrap(0x74c8b8ee5c694a7f8e763ef153a25844)).significand, 8943145128195052643857761757714500);
        assertEq(QuadPacker.unpack(Quad.wrap(0x74c8b8ee5c694a7f8e763ef153a25844)).exponent, 13401);
        assertEq(QuadPacker.unpack(Quad.wrap(0x06f7a1675dfcf7476563fc272ef1e6b3)).significand, 8465954393384677267594383736301235);
        assertEq(QuadPacker.unpack(Quad.wrap(0x06f7a1675dfcf7476563fc272ef1e6b3)).exponent, -14712);
        assertEq(QuadPacker.unpack(Quad.wrap(0x35093063dae017a51f9bb26f2063aa10)).significand, 6173763846242205044692033214851600);
        assertEq(QuadPacker.unpack(Quad.wrap(0x35093063dae017a51f9bb26f2063aa10)).exponent, -2918);
        assertEq(QuadPacker.unpack(Quad.wrap(0x6c83b3153a72e747d44b7bf033dfa423)).significand, 8824530058041580933417182995391523);
        assertEq(QuadPacker.unpack(Quad.wrap(0x6c83b3153a72e747d44b7bf033dfa423)).exponent, 11284);
        assertEq(QuadPacker.unpack(Quad.wrap(0x624d36e3ed3bde926545bb4484c259a6)).significand, 6305605190347772733378288471398822);
        assertEq(QuadPacker.unpack(Quad.wrap(0x624d36e3ed3bde926545bb4484c259a6)).exponent, 8670);
        assertEq(QuadPacker.unpack(Quad.wrap(0x12bced47948b481082be64d099c58a21)).significand, 10004899106301243728228874465937953);
        assertEq(QuadPacker.unpack(Quad.wrap(0x12bced47948b481082be64d099c58a21)).exponent, -11699);
        assertEq(QuadPacker.unpack(Quad.wrap(0x0396c58f4b8381f66c31a7a6fe39fe30)).significand, 9199284548052496444249640271478320);
        assertEq(QuadPacker.unpack(Quad.wrap(0x0396c58f4b8381f66c31a7a6fe39fe30)).exponent, -15577);
        assertEq(QuadPacker.unpack(Quad.wrap(0x28888d35300eaa485df62abeaa8efef3)).significand, 8056330578272539305674858791108339);
        assertEq(QuadPacker.unpack(Quad.wrap(0x28888d35300eaa485df62abeaa8efef3)).exponent, -6119);
        assertEq(QuadPacker.unpack(Quad.wrap(0x44df9439409f9cf0e67ac1d38ced20f9)).significand, 8198629485139554801033003863449849);
        assertEq(QuadPacker.unpack(Quad.wrap(0x44df9439409f9cf0e67ac1d38ced20f9)).exponent, 1136);
        assertEq(QuadPacker.unpack(Quad.wrap(0x7a09f315ea6453437d4745ba3bcb156d)).significand, 10122658724413064626039905233605997);
        assertEq(QuadPacker.unpack(Quad.wrap(0x7a09f315ea6453437d4745ba3bcb156d)).exponent, 14746);

        assertEq(QuadPacker.unpack(Quad.wrap(0x4045086d396a11737d010d2c9de3e308)).significand, 5363209773952203113811856024920840);
        assertEq(QuadPacker.unpack(Quad.wrap(0x4045086d396a11737d010d2c9de3e308)).exponent, -42);
        assertEq(QuadPacker.unpack(Quad.wrap(0x2b47beb6f3e17d867270ba53f6d65172)).significand, 9060449686264713039026133736509810);
        assertEq(QuadPacker.unpack(Quad.wrap(0x2b47beb6f3e17d867270ba53f6d65172)).exponent, -5416);
        assertEq(QuadPacker.unpack(Quad.wrap(0x0a26305d3a92b46c1cc4c136333d7797)).significand, 6173238866109693982296673322104727);
        assertEq(QuadPacker.unpack(Quad.wrap(0x0a26305d3a92b46c1cc4c136333d7797)).exponent, -13897);
        assertEq(QuadPacker.unpack(Quad.wrap(0x6a4594959d4f46f3dde14187cfb7f48e)).significand, 8205947161076646139050612449866894);
        assertEq(QuadPacker.unpack(Quad.wrap(0x6a4594959d4f46f3dde14187cfb7f48e)).exponent, 10710);
        assertEq(QuadPacker.unpack(Quad.wrap(0x08111fc41efba3164bab6ef58c1c86d7)).significand, 5836589864861657603116328866842327);
        assertEq(QuadPacker.unpack(Quad.wrap(0x08111fc41efba3164bab6ef58c1c86d7)).exponent, -14430);
        assertEq(QuadPacker.unpack(Quad.wrap(0x0fd311894e716bcd5ce37e3f32082b2f)).significand, 5547976357009825410890815983069999);
        assertEq(QuadPacker.unpack(Quad.wrap(0x0fd311894e716bcd5ce37e3f32082b2f)).exponent, -12444);
        assertEq(QuadPacker.unpack(Quad.wrap(0x6f7b094dc67a4ecb628e3fa4ec6da91b)).significand, 5381000539374282012043526645066011);
        assertEq(QuadPacker.unpack(Quad.wrap(0x6f7b094dc67a4ecb628e3fa4ec6da91b)).exponent, 12044);
        assertEq(QuadPacker.unpack(Quad.wrap(0x75585464575da30daf9e7974aabfa530)).significand, 6903969119888948258149167475434800);
        assertEq(QuadPacker.unpack(Quad.wrap(0x75585464575da30daf9e7974aabfa530)).exponent, 13545);
        assertEq(QuadPacker.unpack(Quad.wrap(0x474439cfced05dc61123103d2023cec4)).significand, 6364858441394853010586427938033348);
        assertEq(QuadPacker.unpack(Quad.wrap(0x474439cfced05dc61123103d2023cec4)).exponent, 1749);
        assertEq(QuadPacker.unpack(Quad.wrap(0x101b99339ae418783a52087dc130f5f3)).significand, 8299594100623914651196187093300723);
        assertEq(QuadPacker.unpack(Quad.wrap(0x101b99339ae418783a52087dc130f5f3)).exponent, -12372);
        assertEq(QuadPacker.unpack(Quad.wrap(0x6a654971bb4fbd82955f0ce89ffdd010)).significand, 6681923512062423886038045357363216);
        assertEq(QuadPacker.unpack(Quad.wrap(0x6a654971bb4fbd82955f0ce89ffdd010)).exponent, 10742);
        assertEq(QuadPacker.unpack(Quad.wrap(0x0ad8cc825565b744b33b687ffe3b81d1)).significand, 9340234507999425714304697230918097);
        assertEq(QuadPacker.unpack(Quad.wrap(0x0ad8cc825565b744b33b687ffe3b81d1)).exponent, -13719);
        assertEq(QuadPacker.unpack(Quad.wrap(0x05009063701987e47fe000ccd3e283f5)).significand, 8120842122735560367216013118440437);
        assertEq(QuadPacker.unpack(Quad.wrap(0x05009063701987e47fe000ccd3e283f5)).exponent, -15215);
        assertEq(QuadPacker.unpack(Quad.wrap(0x4a3742a2bcf0e4e92c34ff261c840cc1)).significand, 6543829329108192654499920266661057);
        assertEq(QuadPacker.unpack(Quad.wrap(0x4a3742a2bcf0e4e92c34ff261c840cc1)).exponent, 2504);
        assertEq(QuadPacker.unpack(Quad.wrap(0x166530025e3b8dfff04472931bb1fa7a)).significand, 6166040139423257808166992496163450);
        assertEq(QuadPacker.unpack(Quad.wrap(0x166530025e3b8dfff04472931bb1fa7a)).exponent, -10762);
        assertEq(QuadPacker.unpack(Quad.wrap(0x37efcf49582c287a5fdcbc7f81a5490c)).significand, 9396566590419017114036600196909324);
        assertEq(QuadPacker.unpack(Quad.wrap(0x37efcf49582c287a5fdcbc7f81a5490c)).exponent, -2176);
        assertEq(QuadPacker.unpack(Quad.wrap(0x21e17e604a528aa6aa436fc001c4699f)).significand, 7755509373873712469216435336669599);
        assertEq(QuadPacker.unpack(Quad.wrap(0x21e17e604a528aa6aa436fc001c4699f)).exponent, -7822);
        assertEq(QuadPacker.unpack(Quad.wrap(0x3f3d146cc514ad957fd6f7edbf6c6494)).significand, 5606562685704579960966786046518420);
        assertEq(QuadPacker.unpack(Quad.wrap(0x3f3d146cc514ad957fd6f7edbf6c6494)).exponent, -306);
        assertEq(QuadPacker.unpack(Quad.wrap(0x173edd7ddd5f60415549d045285e74c2)).significand, 9684681412745805581464430664643778);
        assertEq(QuadPacker.unpack(Quad.wrap(0x173edd7ddd5f60415549d045285e74c2)).exponent, -10545);
        assertEq(QuadPacker.unpack(Quad.wrap(0x378d4fbd227cfe91e0dee0b74bf082e6)).significand, 6809592013537813177949028246127334);
        assertEq(QuadPacker.unpack(Quad.wrap(0x378d4fbd227cfe91e0dee0b74bf082e6)).exponent, -2274);
        assertEq(QuadPacker.unpack(Quad.wrap(0x7b824e8022fe4c77a582fcd38b0d3448)).significand, 6784476842340082806274115777672264);
        assertEq(QuadPacker.unpack(Quad.wrap(0x7b824e8022fe4c77a582fcd38b0d3448)).exponent, 15123);
        assertEq(QuadPacker.unpack(Quad.wrap(0x39c7689a8c2fcc1f017177a474228ae8)).significand, 7313911980026621286375116144544488);
        assertEq(QuadPacker.unpack(Quad.wrap(0x39c7689a8c2fcc1f017177a474228ae8)).exponent, -1704);
        assertEq(QuadPacker.unpack(Quad.wrap(0x194e597d9ddc4713ae67d2eda8f418e8)).significand, 7007383689019982680521551589415144);
        assertEq(QuadPacker.unpack(Quad.wrap(0x194e597d9ddc4713ae67d2eda8f418e8)).exponent, -10017);
        assertEq(QuadPacker.unpack(Quad.wrap(0x4c2241cdb20d50cb1afd2e230e26095a)).significand, 6526950360516930202144033300941146);
        assertEq(QuadPacker.unpack(Quad.wrap(0x4c2241cdb20d50cb1afd2e230e26095a)).exponent, 2995);
        assertEq(QuadPacker.unpack(Quad.wrap(0x0379cffb3fb4171f4ba4042ae4bacaaa)).significand, 9410661630553261759054456119020202);
        assertEq(QuadPacker.unpack(Quad.wrap(0x0379cffb3fb4171f4ba4042ae4bacaaa)).exponent, -15606);
        assertEq(QuadPacker.unpack(Quad.wrap(0x2751225e6f92b5c1386e74217b86149d)).significand, 5889380762532897725037816406480029);
        assertEq(QuadPacker.unpack(Quad.wrap(0x2751225e6f92b5c1386e74217b86149d)).exponent, -6430);
        assertEq(QuadPacker.unpack(Quad.wrap(0x7dcb5267dcc4229f9d2c966ed78f7ceb)).significand, 6863683270588359988766597148802283);
        assertEq(QuadPacker.unpack(Quad.wrap(0x7dcb5267dcc4229f9d2c966ed78f7ceb)).exponent, 15708);
        assertEq(QuadPacker.unpack(Quad.wrap(0x7fb418196cd15fe2bc0388902a283b6b)).significand, 5681089070584688659725520227285867);
        assertEq(QuadPacker.unpack(Quad.wrap(0x7fb418196cd15fe2bc0388902a283b6b)).exponent, 16197);
        assertEq(QuadPacker.unpack(Quad.wrap(0x3d80ea3e5faaffa8d280f140e8c79f38)).significand, 9943322459665842933458390212910904);
        assertEq(QuadPacker.unpack(Quad.wrap(0x3d80ea3e5faaffa8d280f140e8c79f38)).exponent, -751);
        assertEq(QuadPacker.unpack(Quad.wrap(0x1f36bcf68f1574f28d1cada69a006dc8)).significand, 9024924274295966151804338007207368);
        assertEq(QuadPacker.unpack(Quad.wrap(0x1f36bcf68f1574f28d1cada69a006dc8)).exponent, -8505);
        assertEq(QuadPacker.unpack(Quad.wrap(0x775ab125eedf3cee0b6c6947b0d8563d)).significand, 8785288727704729465459093509002813);
        assertEq(QuadPacker.unpack(Quad.wrap(0x775ab125eedf3cee0b6c6947b0d8563d)).exponent, 14059);
        assertEq(QuadPacker.unpack(Quad.wrap(0x4540c526a2fa6babad46c7e8e6fe628f)).significand, 9190992659941254801225563017994895);
        assertEq(QuadPacker.unpack(Quad.wrap(0x4540c526a2fa6babad46c7e8e6fe628f)).exponent, 1233);
        assertEq(QuadPacker.unpack(Quad.wrap(0x7ac461d9f7b87fee5f10075f01293f9c)).significand, 7176959767198549420632047576760220);
        assertEq(QuadPacker.unpack(Quad.wrap(0x7ac461d9f7b87fee5f10075f01293f9c)).exponent, 14933);
        assertEq(QuadPacker.unpack(Quad.wrap(0x0154dc6e8c5e9df7826b48edf0cdd4c4)).significand, 9663185511501143512300920119350468);
        assertEq(QuadPacker.unpack(Quad.wrap(0x0154dc6e8c5e9df7826b48edf0cdd4c4)).exponent, -16155);
        assertEq(QuadPacker.unpack(Quad.wrap(0x7ac278d5c7b332aa83773fe1090d9235)).significand, 7643123413742506285745479682462261);
        assertEq(QuadPacker.unpack(Quad.wrap(0x7ac278d5c7b332aa83773fe1090d9235)).exponent, 14931);
        assertEq(QuadPacker.unpack(Quad.wrap(0x20568c81a30d3918452d9ff56d0d7e69)).significand, 8042105098052660717866637910179433);
        assertEq(QuadPacker.unpack(Quad.wrap(0x20568c81a30d3918452d9ff56d0d7e69)).exponent, -8217);
        assertEq(QuadPacker.unpack(Quad.wrap(0x69600d1c91f420705bcb69ee189c0f00)).significand, 5458231742390211203783946724445952);
        assertEq(QuadPacker.unpack(Quad.wrap(0x69600d1c91f420705bcb69ee189c0f00)).exponent, 10481);
        assertEq(QuadPacker.unpack(Quad.wrap(0x54cb4ffc448b6eb938c8a87375ef857c)).significand, 6814593927721138035468803385558396);
        assertEq(QuadPacker.unpack(Quad.wrap(0x54cb4ffc448b6eb938c8a87375ef857c)).exponent, 5212);
        assertEq(QuadPacker.unpack(Quad.wrap(0x2ab6b12b91c6d2b318fbf28c3bd96d43)).significand, 8785735285058023767708203564494147);
        assertEq(QuadPacker.unpack(Quad.wrap(0x2ab6b12b91c6d2b318fbf28c3bd96d43)).exponent, -5561);
        assertEq(QuadPacker.unpack(Quad.wrap(0x6687377de1c97e53c4916149c43bb218)).significand, 6317802784767815510036681034805784);
        assertEq(QuadPacker.unpack(Quad.wrap(0x6687377de1c97e53c4916149c43bb218)).exponent, 9752);
        assertEq(QuadPacker.unpack(Quad.wrap(0x3563d1077791e97d23f06d79a423a38c)).significand, 9431912067948659004891031216038796);
        assertEq(QuadPacker.unpack(Quad.wrap(0x3563d1077791e97d23f06d79a423a38c)).exponent, -2828);
        assertEq(QuadPacker.unpack(Quad.wrap(0x7040bec0749b1bd8a19eaf4283a5f25b)).significand, 9061202578207525115889716988080731);
        assertEq(QuadPacker.unpack(Quad.wrap(0x7040bec0749b1bd8a19eaf4283a5f25b)).exponent, 12241);
        assertEq(QuadPacker.unpack(Quad.wrap(0x6c0ae1752c2dcdb4150101cbc3200590)).significand, 9765122387084123479672878687847824);
        assertEq(QuadPacker.unpack(Quad.wrap(0x6c0ae1752c2dcdb4150101cbc3200590)).exponent, 11163);
        assertEq(QuadPacker.unpack(Quad.wrap(0x7fa3ab1819db6d3037e0efd4af6daf36)).significand, 8662498379055233061188321745415990);
        assertEq(QuadPacker.unpack(Quad.wrap(0x7fa3ab1819db6d3037e0efd4af6daf36)).exponent, 16180);
        assertEq(QuadPacker.unpack(Quad.wrap(0x7bf12c7a0bc04b5c288d65749b35f6c3)).significand, 6094392353726984285948434661635779);
        assertEq(QuadPacker.unpack(Quad.wrap(0x7bf12c7a0bc04b5c288d65749b35f6c3)).exponent, 15234);
        assertEq(QuadPacker.unpack(Quad.wrap(0x739287acef6d11ac6bd10f387ba19344)).significand, 7944123497753979080492499547034436);
        assertEq(QuadPacker.unpack(Quad.wrap(0x739287acef6d11ac6bd10f387ba19344)).exponent, 13091);
        assertEq(QuadPacker.unpack(Quad.wrap(0x55e9cd81b37724a08e9be2e15b2467eb)).significand, 9360466802099657668388956594792427);
        assertEq(QuadPacker.unpack(Quad.wrap(0x55e9cd81b37724a08e9be2e15b2467eb)).exponent, 5498);
        assertEq(QuadPacker.unpack(Quad.wrap(0x460a6892bc283a5b64f324e09bcec62f)).significand, 7313293000856146327283272357168687);
        assertEq(QuadPacker.unpack(Quad.wrap(0x460a6892bc283a5b64f324e09bcec62f)).exponent, 1435);
        assertEq(QuadPacker.unpack(Quad.wrap(0x0a629799cadbbfc2fe2d9b508e4ac2e1)).significand, 8267125399183219695550446925693665);
        assertEq(QuadPacker.unpack(Quad.wrap(0x0a629799cadbbfc2fe2d9b508e4ac2e1)).exponent, -13837);
        assertEq(QuadPacker.unpack(Quad.wrap(0x588b6a602c8524130737530bad0620d3)).significand, 7349851958421196419302888617418963);
        assertEq(QuadPacker.unpack(Quad.wrap(0x588b6a602c8524130737530bad0620d3)).exponent, 6172);
        assertEq(QuadPacker.unpack(Quad.wrap(0x18bc203939af58999a562d1e4030a97c)).significand, 5845867823740974122030407389063548);
        assertEq(QuadPacker.unpack(Quad.wrap(0x18bc203939af58999a562d1e4030a97c)).exponent, -10163);
        assertEq(QuadPacker.unpack(Quad.wrap(0x4f13d310e8bb5b496292234b15f9de7a)).significand, 9473224962528054202413349099658874);
        assertEq(QuadPacker.unpack(Quad.wrap(0x4f13d310e8bb5b496292234b15f9de7a)).exponent, 3748);
        assertEq(QuadPacker.unpack(Quad.wrap(0x57f72fe1e88a2ff92eefd0e48ab4bd59)).significand, 6163468414052755119410086967295321);
        assertEq(QuadPacker.unpack(Quad.wrap(0x57f72fe1e88a2ff92eefd0e48ab4bd59)).exponent, 6024);
    }

    function test_unpack_error_1() public {
        vm.expectRevert(QuadPacker.UnpackInvalidFloat.selector);
        QuadPacker.unpack(Quad.wrap(0x8b7b9fe58b1f0990061d5042f1d3643a));
    }

    function test_unpack_error_2() public {
        vm.expectRevert(QuadPacker.UnpackInvalidFloat.selector);
        QuadPacker.unpack(Quad.wrap(0xcef4d53a7f60e5ee76deee2e4aa149c6));
    }

    function test_unpack_error_3() public {
        vm.expectRevert(QuadPacker.UnpackInvalidFloat.selector);
        QuadPacker.unpack(Quad.wrap(0xc196bea02acd09f35d6570684541f78e));
    }

    function test_unpack_error_4() public {
        vm.expectRevert(QuadPacker.UnpackInvalidFloat.selector);
        QuadPacker.unpack(Quad.wrap(0x8bb4951a0fc50baea163936a0a4ecd9b));
    }

    function test_unpack_error_5() public {
        vm.expectRevert(QuadPacker.UnpackInvalidFloat.selector);
        QuadPacker.unpack(Quad.wrap(0xe92d1723815c024e0723dc3c6c797796));
    }

    function test_unpack_error_6() public {
        vm.expectRevert(QuadPacker.UnpackInvalidFloat.selector);
        QuadPacker.unpack(Quad.wrap(0xcae0327ca2f6a607319bb9485f0be9a8));
    }

    function test_unpack_error_7() public {
        vm.expectRevert(QuadPacker.UnpackInvalidFloat.selector);
        QuadPacker.unpack(Quad.wrap(0xb421e5f0f061bb7924cb1690b5add49a));
    }

    function test_unpack_error_8() public {
        vm.expectRevert(QuadPacker.UnpackInvalidFloat.selector);
        QuadPacker.unpack(Quad.wrap(0xaf257fc166b5ddf5f9a857abf4df3db2));
    }

    function test_unpack_error_9() public {
        vm.expectRevert(QuadPacker.UnpackInvalidFloat.selector);
        QuadPacker.unpack(Quad.wrap(0xad0cc59c1227613cbec6e59e87bfe0ec));
    }

    function test_unpack_error_10() public {
        vm.expectRevert(QuadPacker.UnpackInvalidFloat.selector);
        QuadPacker.unpack(Quad.wrap(0xe9a3cb5104947dad630fbbac9f9835d2));
    }

    function test_unpack_error_11() public {
        vm.expectRevert(QuadPacker.UnpackInvalidFloat.selector);
        QuadPacker.unpack(Quad.wrap(0xd1070844cb460a94db049b09387edd49));
    }

    function test_unpack_error_12() public {
        vm.expectRevert(QuadPacker.UnpackInvalidFloat.selector);
        QuadPacker.unpack(Quad.wrap(0x93513b9a8e957adf4e0f190d596623ae));
    }

    function test_unpack_error_13() public {
        vm.expectRevert(QuadPacker.UnpackInvalidFloat.selector);
        QuadPacker.unpack(Quad.wrap(0xb1ec9b8781312d21d3dd1069c56eaba7));
    }

    function test_unpack_error_14() public {
        vm.expectRevert(QuadPacker.UnpackInvalidFloat.selector);
        QuadPacker.unpack(Quad.wrap(0xc26d37229630ac227616ad8f1961081c));
    }

    function test_unpack_error_15() public {
        vm.expectRevert(QuadPacker.UnpackInvalidFloat.selector);
        QuadPacker.unpack(Quad.wrap(0xf3f9a6d522b483041b6d07b20a1ded8f));
    }

    function test_unpack_error_16() public {
        vm.expectRevert(QuadPacker.UnpackInvalidFloat.selector);
        QuadPacker.unpack(Quad.wrap(0xd1ebd3a4ff725d2dc89cadf3821d47fc));
    }

    function test_unpack_error_17() public {
        vm.expectRevert(QuadPacker.UnpackInvalidFloat.selector);
        QuadPacker.unpack(Quad.wrap(0xdb08afc76c90c30df425b26a9ab3e4e1));
    }

    function test_unpack_error_18() public {
        vm.expectRevert(QuadPacker.UnpackInvalidFloat.selector);
        QuadPacker.unpack(Quad.wrap(0xc62254c43ee8b0941cff56e3b367b182));
    }

    function test_unpack_error_19() public {
        vm.expectRevert(QuadPacker.UnpackInvalidFloat.selector);
        QuadPacker.unpack(Quad.wrap(0x8a5003e29315b7ca54ad00f5312abf9b));
    }

    function test_unpack_error_20() public {
        vm.expectRevert(QuadPacker.UnpackInvalidFloat.selector);
        QuadPacker.unpack(Quad.wrap(0xd30ef4416f57695075a22e11667fe2e3));
    }

    function test_unpack_error_21() public {
        vm.expectRevert(QuadPacker.UnpackInvalidFloat.selector);
        QuadPacker.unpack(Quad.wrap(0x94eaef0fe32e7c70b4cf82c4c7b50703));
    }

    function test_unpack_error_22() public {
        vm.expectRevert(QuadPacker.UnpackInvalidFloat.selector);
        QuadPacker.unpack(Quad.wrap(0x9675ff0b8bc009c9104fc43c8abb427c));
    }

    function test_unpack_error_23() public {
        vm.expectRevert(QuadPacker.UnpackInvalidFloat.selector);
        QuadPacker.unpack(Quad.wrap(0xd1bcae002ea7ab7182fdd851f19785ad));
    }

    function test_unpack_error_24() public {
        vm.expectRevert(QuadPacker.UnpackInvalidFloat.selector);
        QuadPacker.unpack(Quad.wrap(0xaf15b5c553b9c6fa559d449159326733));
    }

    function test_unpack_error_25() public {
        vm.expectRevert(QuadPacker.UnpackInvalidFloat.selector);
        QuadPacker.unpack(Quad.wrap(0x82c60ae22e6195029f407473f1f6c1e7));
    }

    function test_unpack_error_26() public {
        vm.expectRevert(QuadPacker.UnpackInvalidFloat.selector);
        QuadPacker.unpack(Quad.wrap(0xf22ea786783f88f732d529adedcfcb88));
    }

    function test_unpack_error_27() public {
        vm.expectRevert(QuadPacker.UnpackInvalidFloat.selector);
        QuadPacker.unpack(Quad.wrap(0x8dc9188b3ce12dd63a7a862ceb3eb0db));
    }

    function test_unpack_error_28() public {
        vm.expectRevert(QuadPacker.UnpackInvalidFloat.selector);
        QuadPacker.unpack(Quad.wrap(0x86bb9043b3b1d5d861daf3f6def86646));
    }

    function test_unpack_error_29() public {
        vm.expectRevert(QuadPacker.UnpackInvalidFloat.selector);
        QuadPacker.unpack(Quad.wrap(0xc2ca152baa9af46f5bf180fab158ceb5));
    }

    function test_unpack_error_30() public {
        vm.expectRevert(QuadPacker.UnpackInvalidFloat.selector);
        QuadPacker.unpack(Quad.wrap(0xff61604bb2cb6c2d8cc9ffaf6c33c4ae));
    }

    function test_unpack_error_31() public {
        vm.expectRevert(QuadPacker.UnpackInvalidFloat.selector);
        QuadPacker.unpack(Quad.wrap(0xa79b48296fce6fefc3770476f4583cd6));
    }

    function test_unpack_error_32() public {
        vm.expectRevert(QuadPacker.UnpackInvalidFloat.selector);
        QuadPacker.unpack(Quad.wrap(0xc870c8a0db97afb48aed1af4b4f7ac7d));
    }

    function test_unpack_error_33() public {
        vm.expectRevert(QuadPacker.UnpackInvalidFloat.selector);
        QuadPacker.unpack(Quad.wrap(0xb83b234c83c98006bc3ce1c75c52fb6a));
    }

    function test_unpack_error_34() public {
        vm.expectRevert(QuadPacker.UnpackInvalidFloat.selector);
        QuadPacker.unpack(Quad.wrap(0xc9110e8cfa69069599a5e284ad95a5c1));
    }

    function test_unpack_error_35() public {
        vm.expectRevert(QuadPacker.UnpackInvalidFloat.selector);
        QuadPacker.unpack(Quad.wrap(0xf2636e3581858f8612848c75f5666cea));
    }

    function test_unpack_error_36() public {
        vm.expectRevert(QuadPacker.UnpackInvalidFloat.selector);
        QuadPacker.unpack(Quad.wrap(0xb57e0f0d17d5afabfb3efe3ef26f6dde));
    }

    function test_unpack_error_37() public {
        vm.expectRevert(QuadPacker.UnpackInvalidFloat.selector);
        QuadPacker.unpack(Quad.wrap(0x9b4eaf192749427b71d800b2afa17e04));
    }

    function test_unpack_error_38() public {
        vm.expectRevert(QuadPacker.UnpackInvalidFloat.selector);
        QuadPacker.unpack(Quad.wrap(0xe256ea15e104007a3a04c49382a5c432));
    }

    function test_unpack_error_39() public {
        vm.expectRevert(QuadPacker.UnpackInvalidFloat.selector);
        QuadPacker.unpack(Quad.wrap(0xe3696dcf7e50421b92eec5ca7ad52d33));
    }

    function test_unpack_error_40() public {
        vm.expectRevert(QuadPacker.UnpackInvalidFloat.selector);
        QuadPacker.unpack(Quad.wrap(0x9690942093c05dc6ba1d734ddda92097));
    }

    function test_unpack_error_41() public {
        vm.expectRevert(QuadPacker.UnpackInvalidFloat.selector);
        QuadPacker.unpack(Quad.wrap(0x9f485e5a50fd8c7a080b4afeebb605c2));
    }

    function test_unpack_error_42() public {
        vm.expectRevert(QuadPacker.UnpackInvalidFloat.selector);
        QuadPacker.unpack(Quad.wrap(0xfccce8d0db9133e125eef8522461d378));
    }

    function test_unpack_error_43() public {
        vm.expectRevert(QuadPacker.UnpackInvalidFloat.selector);
        QuadPacker.unpack(Quad.wrap(0xdc49aed2d9e16ecfa26f79ec1ee0f333));
    }

    function test_unpack_error_44() public {
        vm.expectRevert(QuadPacker.UnpackInvalidFloat.selector);
        QuadPacker.unpack(Quad.wrap(0xdc1ff8b5b11a1250c7b685033b123d89));
    }

    function test_unpack_error_45() public {
        vm.expectRevert(QuadPacker.UnpackInvalidFloat.selector);
        QuadPacker.unpack(Quad.wrap(0x99367f189c218d5b47c0cc5676a7c212));
    }

    function test_unpack_error_46() public {
        vm.expectRevert(QuadPacker.UnpackInvalidFloat.selector);
        QuadPacker.unpack(Quad.wrap(0x98b4969b5a2ef823fdb28aaa139292c1));
    }

    function test_unpack_error_47() public {
        vm.expectRevert(QuadPacker.UnpackInvalidFloat.selector);
        QuadPacker.unpack(Quad.wrap(0xe299d692dda52279c62f6ae5715edd63));
    }

    function test_unpack_error_48() public {
        vm.expectRevert(QuadPacker.UnpackInvalidFloat.selector);
        QuadPacker.unpack(Quad.wrap(0xe61a3aec505266cd18323c5787c69c6b));
    }

    function test_unpack_error_49() public {
        vm.expectRevert(QuadPacker.UnpackInvalidFloat.selector);
        QuadPacker.unpack(Quad.wrap(0x83287779e60a995801ccfe33a924299f));
    }

    function test_unpack_error_50() public {
        vm.expectRevert(QuadPacker.UnpackInvalidFloat.selector);
        QuadPacker.unpack(Quad.wrap(0x997409ac79a2bcbee8cb1c8a01a3be60));
    }

    function test_repack() public {
        assertTrue(QuadPacker.repack(FloatBits.Info(-14756, 8833779479032562245326199630545798)) == Quad.wrap(0x06cbb389f8f09fe093db0b82bb9b4386));
        assertTrue(QuadPacker.repack(FloatBits.Info(-5856, 6017426734782949769774779040272104)) == Quad.wrap(0x298f28ae9a6c788178f5c9f6c6340ee8));
        assertTrue(QuadPacker.repack(FloatBits.Info(-4443, 7927906127750184358870339491242106)) == Quad.wrap(0x2f1486e03e4703eaa589e372596ca07a));
        assertTrue(QuadPacker.repack(FloatBits.Info(-10502, 5732370784809047415854931948013099)) == Quad.wrap(0x17691aa0b0f928d043291be91bd7062b));
        assertTrue(QuadPacker.repack(FloatBits.Info(10434, 7511349835322505068682125768699150)) == Quad.wrap(0x69317256904de1d4cc5e9f46f160ad0e));
        assertTrue(QuadPacker.repack(FloatBits.Info(-6596, 8093850271560952453897434536108145)) == Quad.wrap(0x26ab8f0ec0b98ad2bbda1e6e4edc6071));
        assertTrue(QuadPacker.repack(FloatBits.Info(15638, 9024389223777175401266394615856892)) == Quad.wrap(0x7d85bcefce3e0a7b6e08c8e4d75d3efc));
        assertTrue(QuadPacker.repack(FloatBits.Info(5593, 8295256145100677366258215146764796)) == Quad.wrap(0x564898fcda33637e428b910c8cd839fc));
        assertTrue(QuadPacker.repack(FloatBits.Info(15263, 8412476196457296130807916144082488)) == Quad.wrap(0x7c0e9ec4609d45f7aee8438cead3be38));
        assertTrue(QuadPacker.repack(FloatBits.Info(15546, 10126336784755394887957107621991776)) == Quad.wrap(0x7d29f34456d8883fda0de6b5295f9560));
        assertTrue(QuadPacker.repack(FloatBits.Info(-5376, 9411819526385907637548324546687144)) == Quad.wrap(0x2b6fd009dd11130e9fc8297267ac30a8));
        assertTrue(QuadPacker.repack(FloatBits.Info(-2897, 5610666649962972291289806605092859)) == Quad.wrap(0x351e14a091b458e317386676875387fb));
        assertTrue(QuadPacker.repack(FloatBits.Info(828, 10260962259805423305615314806037560)) == Quad.wrap(0x43abf9e78d3773088bc57f27cb4adc38));
        assertTrue(QuadPacker.repack(FloatBits.Info(-5366, 6877518553658649447395375268625721)) == Quad.wrap(0x2b7953167cfa0f6799fca20a3dcdfd39));
        assertTrue(QuadPacker.repack(FloatBits.Info(9871, 7214035778355389282251049352144168)) == Quad.wrap(0x66fe63adeec61e9580110bcd12f1a528));
        assertTrue(QuadPacker.repack(FloatBits.Info(6654, 6747212106019675210287608929605056)) == Quad.wrap(0x5a6d4ca9ca22e1ef606a2272c37655c0));
        assertTrue(QuadPacker.repack(FloatBits.Info(-7079, 9577578523076913616168413566245029)) == Quad.wrap(0x24c8d83609457e54ef6ee2ae629298a5));
        assertTrue(QuadPacker.repack(FloatBits.Info(6388, 9948944292519065067588403998378063)) == Quad.wrap(0x5963ea8554ca24518365a9819606484f));
        assertTrue(QuadPacker.repack(FloatBits.Info(-885, 5338167555851584918675209984848045)) == Quad.wrap(0x3cfa073125a4c2902f501237401ab0ad));
        assertTrue(QuadPacker.repack(FloatBits.Info(13909, 7843305166107531865484886469628690)) == Quad.wrap(0x76c482b46dd3bdbc50400490ffc9d312));
        assertTrue(QuadPacker.repack(FloatBits.Info(13220, 8378984455147093026367143780791036)) == Quad.wrap(0x74139d1da6f62e4d727c1d511affb2fc));
        assertTrue(QuadPacker.repack(FloatBits.Info(15173, 6002984347431368078659423643133407)) == Quad.wrap(0x7bb427f8508da78e5ed854fc269c65df));
        assertTrue(QuadPacker.repack(FloatBits.Info(-13906, 10026225108657186329405586463489642)) == Quad.wrap(0x0a1dee54c092f93db55ae1f103777e6a));
        assertTrue(QuadPacker.repack(FloatBits.Info(2353, 10111618965613310762348785370692743)) == Quad.wrap(0x49a0f28a9301e0fb08bf8646e0307c87));
        assertTrue(QuadPacker.repack(FloatBits.Info(-7115, 10034879900422698961172936889966439)) == Quad.wrap(0x24a4eec1fdb6ed7ea1834bc00d739f67));
        assertTrue(QuadPacker.repack(FloatBits.Info(128, 7723497760741387637401315124262747)) == Quad.wrap(0x40ef7ccc3f38c8310f8f71ff08a5375b));
        assertTrue(QuadPacker.repack(FloatBits.Info(16205, 5339028634579740658505948423758162)) == Quad.wrap(0x7fbc073c03f063cb8f6b01110d37a152));
        assertTrue(QuadPacker.repack(FloatBits.Info(-12701, 5236471758333131612659208800764357)) == Quad.wrap(0x0ed2022d90ccacb48855f56db93d01c5));
        assertTrue(QuadPacker.repack(FloatBits.Info(2508, 6395811005788306880119877148402148)) == Quad.wrap(0x4a3b3b567bf18a97131f9470b438e1e4));
        assertTrue(QuadPacker.repack(FloatBits.Info(-16193, 6717514078502235258567186096296238)) == Quad.wrap(0x012e4b32f2a24a003e037c6bb263912e));
        assertTrue(QuadPacker.repack(FloatBits.Info(-11988, 7313264072721314451724887451914185)) == Quad.wrap(0x119b68925eaf6f87dc559e5a660e4fc9));
        assertTrue(QuadPacker.repack(FloatBits.Info(-12045, 8362820673409797825612845954539134)) == Quad.wrap(0x11629c51a2f74d5f992b5e4d06129e7e));
        assertTrue(QuadPacker.repack(FloatBits.Info(15136, 5252162764441225574130278378755837)) == Quad.wrap(0x7b8f02f39d2cb7fc78e25bb52e13d6fd));
        assertTrue(QuadPacker.repack(FloatBits.Info(10697, 9667757244337747560831024220509221)) == Quad.wrap(0x6a38dca8406f62a0fb15f3d2171a9425));
        assertTrue(QuadPacker.repack(FloatBits.Info(-5218, 6860695144731100301901519634191601)) == Quad.wrap(0x2c0d5242259c5bb68f91f034a0e254f1));
        assertTrue(QuadPacker.repack(FloatBits.Info(14207, 10145777465433998474510422694614618)) == Quad.wrap(0x77eef439b712af34ccfcbd531866d65a));
        assertTrue(QuadPacker.repack(FloatBits.Info(7866, 8028388311218684462163589013466757)) == Quad.wrap(0x5f298bd481b9166263a240c5f1b46e85));
        assertTrue(QuadPacker.repack(FloatBits.Info(-770, 8190194169068523130014524445190545)) == Quad.wrap(0x3d6d93cec8a5b2c62dcf344e1dfe6991));
        assertTrue(QuadPacker.repack(FloatBits.Info(-1630, 9315510378211409140817197658105317)) == Quad.wrap(0x3a11cb4a456ce49ba4996a685b5165e5));
        assertTrue(QuadPacker.repack(FloatBits.Info(8099, 8546593327961968993442143850048213)) == Quad.wrap(0x6012a5612c7043e43420ac0200d5aad5));
        assertTrue(QuadPacker.repack(FloatBits.Info(-3483, 7174473473261638029274523563401014)) == Quad.wrap(0x32d461ba96125ba687264591ef4f1f36));
        assertTrue(QuadPacker.repack(FloatBits.Info(-7656, 9786489556890423611200460641938743)) == Quad.wrap(0x2287e282dd3a6994f2282559899a2d37));
        assertTrue(QuadPacker.repack(FloatBits.Info(3965, 5571637771238666274724793541440450)) == Quad.wrap(0x4fec12b3f498896acc2299fcdfefb3c2));
        assertTrue(QuadPacker.repack(FloatBits.Info(-7399, 8731154450863366251613201620696721)) == Quad.wrap(0x2388ae7aa996f5d328837e4fcfbe7e91));
        assertTrue(QuadPacker.repack(FloatBits.Info(-2676, 7199409550924979587337839152579489)) == Quad.wrap(0x35fb62f552e25aafa30822141cc1c3a1));
        assertTrue(QuadPacker.repack(FloatBits.Info(-7206, 5691550095186706005187486597698541)) == Quad.wrap(0x2449189d76361cdf4f6910bb28f6d3ed));
        assertTrue(QuadPacker.repack(FloatBits.Info(10398, 9947515797551011857106265336382957)) == Quad.wrap(0x690dea734d12cc961e40336f80cf05ed));
        assertTrue(QuadPacker.repack(FloatBits.Info(15413, 8265531832879180652015905693466259)) == Quad.wrap(0x7ca49785adc498f90d31b028d0737e93));
        assertTrue(QuadPacker.repack(FloatBits.Info(14174, 8815726546969198361680406221397815)) == Quad.wrap(0x77cdb2a61cc538d2f5de07f1fc039f37));
        assertTrue(QuadPacker.repack(FloatBits.Info(-10177, 8325619095714016469303105403838895)) == Quad.wrap(0x18ae9a7c162f79d4e06e63f0711561af));
    }

    function test_unpack_repack() public {
        assertTrue(
            QuadPacker.repack(QuadPacker.unpack(Quad.wrap(0x5f91302a45dc35d24d73237ed129497a))) == Quad.wrap(0x5f91302a45dc35d24d73237ed129497a)
        );
        assertTrue(
            QuadPacker.repack(QuadPacker.unpack(Quad.wrap(0x7978334f4f3bf4bdcb93fee540d10011))) == Quad.wrap(0x7978334f4f3bf4bdcb93fee540d10011)
        );
        assertTrue(
            QuadPacker.repack(QuadPacker.unpack(Quad.wrap(0x10b4adbf6ef91067e382c2316181bb03))) == Quad.wrap(0x10b4adbf6ef91067e382c2316181bb03)
        );
        assertTrue(
            QuadPacker.repack(QuadPacker.unpack(Quad.wrap(0x6c80d5fa27954d17e72a4cd08ef3591e))) == Quad.wrap(0x6c80d5fa27954d17e72a4cd08ef3591e)
        );
        assertTrue(
            QuadPacker.repack(QuadPacker.unpack(Quad.wrap(0x77b053772daf9941899590d7548d4039))) == Quad.wrap(0x77b053772daf9941899590d7548d4039)
        );
        assertTrue(
            QuadPacker.repack(QuadPacker.unpack(Quad.wrap(0x02da015690f0dffd5cc452bd636601b8))) == Quad.wrap(0x02da015690f0dffd5cc452bd636601b8)
        );
        assertTrue(
            QuadPacker.repack(QuadPacker.unpack(Quad.wrap(0x15694b1bedae4bd91a9e153027b21121))) == Quad.wrap(0x15694b1bedae4bd91a9e153027b21121)
        );
        assertTrue(
            QuadPacker.repack(QuadPacker.unpack(Quad.wrap(0x2f17ef5441ff6978548174f20a6fc0e6))) == Quad.wrap(0x2f17ef5441ff6978548174f20a6fc0e6)
        );
        assertTrue(
            QuadPacker.repack(QuadPacker.unpack(Quad.wrap(0x245a8e7fe44b75ced2cd816e0fc27507))) == Quad.wrap(0x245a8e7fe44b75ced2cd816e0fc27507)
        );
        assertTrue(
            QuadPacker.repack(QuadPacker.unpack(Quad.wrap(0x7f6e95f666e6b875c56f8ba828307296))) == Quad.wrap(0x7f6e95f666e6b875c56f8ba828307296)
        );
        assertTrue(
            QuadPacker.repack(QuadPacker.unpack(Quad.wrap(0x2416d77a6bb6254278448a512c782226))) == Quad.wrap(0x2416d77a6bb6254278448a512c782226)
        );
        assertTrue(
            QuadPacker.repack(QuadPacker.unpack(Quad.wrap(0x5dd5afd19475e11202d6510a53b23f7e))) == Quad.wrap(0x5dd5afd19475e11202d6510a53b23f7e)
        );
        assertTrue(
            QuadPacker.repack(QuadPacker.unpack(Quad.wrap(0x67515ed939e10dd9f76384d42c73460a))) == Quad.wrap(0x67515ed939e10dd9f76384d42c73460a)
        );
        assertTrue(
            QuadPacker.repack(QuadPacker.unpack(Quad.wrap(0x382310738cf8ad107b5c1d50a9e2e5ab))) == Quad.wrap(0x382310738cf8ad107b5c1d50a9e2e5ab)
        );
        assertTrue(
            QuadPacker.repack(QuadPacker.unpack(Quad.wrap(0x5caf7e02cc8f4afb2741444d01296053))) == Quad.wrap(0x5caf7e02cc8f4afb2741444d01296053)
        );
        assertTrue(
            QuadPacker.repack(QuadPacker.unpack(Quad.wrap(0x3b98a06f231873eb93d4285129555327))) == Quad.wrap(0x3b98a06f231873eb93d4285129555327)
        );
        assertTrue(
            QuadPacker.repack(QuadPacker.unpack(Quad.wrap(0x24612c9691255c9dab6a88c38fd38026))) == Quad.wrap(0x24612c9691255c9dab6a88c38fd38026)
        );
        assertTrue(
            QuadPacker.repack(QuadPacker.unpack(Quad.wrap(0x29eacdc0b00820d8669f04738fde737b))) == Quad.wrap(0x29eacdc0b00820d8669f04738fde737b)
        );
        assertTrue(
            QuadPacker.repack(QuadPacker.unpack(Quad.wrap(0x1d3a378ff352f87df32f504523bf174e))) == Quad.wrap(0x1d3a378ff352f87df32f504523bf174e)
        );
        assertTrue(
            QuadPacker.repack(QuadPacker.unpack(Quad.wrap(0x014e5449506f513ef80829b65fe155a6))) == Quad.wrap(0x014e5449506f513ef80829b65fe155a6)
        );
        assertTrue(
            QuadPacker.repack(QuadPacker.unpack(Quad.wrap(0x4501f4cfc95a76df9a31674423595919))) == Quad.wrap(0x4501f4cfc95a76df9a31674423595919)
        );
        assertTrue(
            QuadPacker.repack(QuadPacker.unpack(Quad.wrap(0x7906e8671a58fa529e9952034370264b))) == Quad.wrap(0x7906e8671a58fa529e9952034370264b)
        );
        assertTrue(
            QuadPacker.repack(QuadPacker.unpack(Quad.wrap(0x0c33422c6cf60534fd2094e27482c1d4))) == Quad.wrap(0x0c33422c6cf60534fd2094e27482c1d4)
        );
        assertTrue(
            QuadPacker.repack(QuadPacker.unpack(Quad.wrap(0x7fbe313ad566a06e585ba518123b0757))) == Quad.wrap(0x7fbe313ad566a06e585ba518123b0757)
        );
        assertTrue(
            QuadPacker.repack(QuadPacker.unpack(Quad.wrap(0x38a29ac63fec5645c8fc37bb5079680f))) == Quad.wrap(0x38a29ac63fec5645c8fc37bb5079680f)
        );
        assertTrue(
            QuadPacker.repack(QuadPacker.unpack(Quad.wrap(0x5a1d4dae9da9d007bac78f8c0c7fad51))) == Quad.wrap(0x5a1d4dae9da9d007bac78f8c0c7fad51)
        );
        assertTrue(
            QuadPacker.repack(QuadPacker.unpack(Quad.wrap(0x3ec14e77a2191f9876872a1655247f65))) == Quad.wrap(0x3ec14e77a2191f9876872a1655247f65)
        );
        assertTrue(
            QuadPacker.repack(QuadPacker.unpack(Quad.wrap(0x31b844d02bff7c8b073cdded407cdeaf))) == Quad.wrap(0x31b844d02bff7c8b073cdded407cdeaf)
        );
        assertTrue(
            QuadPacker.repack(QuadPacker.unpack(Quad.wrap(0x2881aec26561592127b4a95bae90be39))) == Quad.wrap(0x2881aec26561592127b4a95bae90be39)
        );
        assertTrue(
            QuadPacker.repack(QuadPacker.unpack(Quad.wrap(0x053b854e073ac9726a7af9df8a6536c5))) == Quad.wrap(0x053b854e073ac9726a7af9df8a6536c5)
        );
        assertTrue(
            QuadPacker.repack(QuadPacker.unpack(Quad.wrap(0x1bd0e971cddf0301a1722efee4378105))) == Quad.wrap(0x1bd0e971cddf0301a1722efee4378105)
        );
        assertTrue(
            QuadPacker.repack(QuadPacker.unpack(Quad.wrap(0x259434e2707eb3f0f8911bc0592e5626))) == Quad.wrap(0x259434e2707eb3f0f8911bc0592e5626)
        );
        assertTrue(
            QuadPacker.repack(QuadPacker.unpack(Quad.wrap(0x6a759909c44d07ca627d701813a40986))) == Quad.wrap(0x6a759909c44d07ca627d701813a40986)
        );
        assertTrue(
            QuadPacker.repack(QuadPacker.unpack(Quad.wrap(0x378bcbea59dd3edce1929ef39d4495b5))) == Quad.wrap(0x378bcbea59dd3edce1929ef39d4495b5)
        );
        assertTrue(
            QuadPacker.repack(QuadPacker.unpack(Quad.wrap(0x344838c97a019176f4099514588a9b3c))) == Quad.wrap(0x344838c97a019176f4099514588a9b3c)
        );
        assertTrue(
            QuadPacker.repack(QuadPacker.unpack(Quad.wrap(0x4a76c3234cd001fa75c5ba02539b3e75))) == Quad.wrap(0x4a76c3234cd001fa75c5ba02539b3e75)
        );
        assertTrue(
            QuadPacker.repack(QuadPacker.unpack(Quad.wrap(0x19518c3b3faa43633523a6d9238e1a7a))) == Quad.wrap(0x19518c3b3faa43633523a6d9238e1a7a)
        );
        assertTrue(
            QuadPacker.repack(QuadPacker.unpack(Quad.wrap(0x649ed32257dffeaa3fe7f513fcc4cc92))) == Quad.wrap(0x649ed32257dffeaa3fe7f513fcc4cc92)
        );
        assertTrue(
            QuadPacker.repack(QuadPacker.unpack(Quad.wrap(0x6714a71be24191f08983af0d5bf32799))) == Quad.wrap(0x6714a71be24191f08983af0d5bf32799)
        );
        assertTrue(
            QuadPacker.repack(QuadPacker.unpack(Quad.wrap(0x1f64723ff5179ede89db4db9ebcfa7c9))) == Quad.wrap(0x1f64723ff5179ede89db4db9ebcfa7c9)
        );
        assertTrue(
            QuadPacker.repack(QuadPacker.unpack(Quad.wrap(0x0c0446b89ac86126855ac22799d26a03))) == Quad.wrap(0x0c0446b89ac86126855ac22799d26a03)
        );
        assertTrue(
            QuadPacker.repack(QuadPacker.unpack(Quad.wrap(0x004382e2dead32bce65ca1c5a883357f))) == Quad.wrap(0x004382e2dead32bce65ca1c5a883357f)
        );
        assertTrue(
            QuadPacker.repack(QuadPacker.unpack(Quad.wrap(0x3b57a157146d089fe1b52ae440601468))) == Quad.wrap(0x3b57a157146d089fe1b52ae440601468)
        );
        assertTrue(
            QuadPacker.repack(QuadPacker.unpack(Quad.wrap(0x6cd8d3b79a19a3582b109dbf37099525))) == Quad.wrap(0x6cd8d3b79a19a3582b109dbf37099525)
        );
        assertTrue(
            QuadPacker.repack(QuadPacker.unpack(Quad.wrap(0x6d28ad6a508f0a2af5ad0730ca806a90))) == Quad.wrap(0x6d28ad6a508f0a2af5ad0730ca806a90)
        );
        assertTrue(
            QuadPacker.repack(QuadPacker.unpack(Quad.wrap(0x23412b5e35a16df36e1b14b0830ddd30))) == Quad.wrap(0x23412b5e35a16df36e1b14b0830ddd30)
        );
        assertTrue(
            QuadPacker.repack(QuadPacker.unpack(Quad.wrap(0x5a0abf4b3c27d51c7554fa864da8eb3b))) == Quad.wrap(0x5a0abf4b3c27d51c7554fa864da8eb3b)
        );
        assertTrue(
            QuadPacker.repack(QuadPacker.unpack(Quad.wrap(0x1edc52b47dde522fb35834accbdfd479))) == Quad.wrap(0x1edc52b47dde522fb35834accbdfd479)
        );
        assertTrue(
            QuadPacker.repack(QuadPacker.unpack(Quad.wrap(0x61d279b4e89150cb8b9092ac4cef53fb))) == Quad.wrap(0x61d279b4e89150cb8b9092ac4cef53fb)
        );
        assertTrue(
            QuadPacker.repack(QuadPacker.unpack(Quad.wrap(0x0bead2fd00f15e4236fbd6864f50d983))) == Quad.wrap(0x0bead2fd00f15e4236fbd6864f50d983)
        );
        assertTrue(
            QuadPacker.repack(QuadPacker.unpack(Quad.wrap(0x23f5120ad2a99e75d43bf6fd25e39e32))) == Quad.wrap(0x23f5120ad2a99e75d43bf6fd25e39e32)
        );
        assertTrue(
            QuadPacker.repack(QuadPacker.unpack(Quad.wrap(0x15c0e305fdb65875cb75fd72433cc0bb))) == Quad.wrap(0x15c0e305fdb65875cb75fd72433cc0bb)
        );
        assertTrue(
            QuadPacker.repack(QuadPacker.unpack(Quad.wrap(0x7da18bfbb3f67f2bd61914fcfd8583cc))) == Quad.wrap(0x7da18bfbb3f67f2bd61914fcfd8583cc)
        );
        assertTrue(
            QuadPacker.repack(QuadPacker.unpack(Quad.wrap(0x7c626fa0b1148b87d2a5d185477a56ec))) == Quad.wrap(0x7c626fa0b1148b87d2a5d185477a56ec)
        );
        assertTrue(
            QuadPacker.repack(QuadPacker.unpack(Quad.wrap(0x06bf29b6105e2b38506f7b3e24d00a59))) == Quad.wrap(0x06bf29b6105e2b38506f7b3e24d00a59)
        );
        assertTrue(
            QuadPacker.repack(QuadPacker.unpack(Quad.wrap(0x474721b9124b4b68a4a19f20971eb971))) == Quad.wrap(0x474721b9124b4b68a4a19f20971eb971)
        );
        assertTrue(
            QuadPacker.repack(QuadPacker.unpack(Quad.wrap(0x76883c1f54487b48a1845fe1b0d902d3))) == Quad.wrap(0x76883c1f54487b48a1845fe1b0d902d3)
        );
        assertTrue(
            QuadPacker.repack(QuadPacker.unpack(Quad.wrap(0x0e4fafdc700024c13da6de9e37f78a48))) == Quad.wrap(0x0e4fafdc700024c13da6de9e37f78a48)
        );
        assertTrue(
            QuadPacker.repack(QuadPacker.unpack(Quad.wrap(0x1bc516da0183fc4b332aee3ba0240d3e))) == Quad.wrap(0x1bc516da0183fc4b332aee3ba0240d3e)
        );
    }
}
