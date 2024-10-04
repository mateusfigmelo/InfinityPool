// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import "./Casting.sol" as Casting;
import "./Helpers.sol" as Helpers;
import "./Math.sol" as Math;
import "./Constants.sol" as Constants;

type Quad is bytes16;

error OptQuadValueIsUndefined();

library LibOptQuad {
    struct Raw {
        Quad val;
    }

    function isDefined(Raw memory self) internal pure returns (bool) {
        return !self.val.isNaN();
    }

    function get(Raw memory self) internal pure returns (Quad) {
        if (!isDefined(self)) revert OptQuadValueIsUndefined();
        return self.val;
    }
}

using {Casting.unwrap} for Quad global;

using {Math.exp2, Math.exp, Math.log, Math.sqrt, Math.max} for Quad global;

using {
    Helpers.add,
    Helpers.sub,
    Helpers.mul,
    Helpers.div,
    Helpers.eq,
    Helpers.neq,
    Helpers.neg,
    Helpers.lt,
    Helpers.lte,
    Helpers.gt,
    Helpers.gte,
    Helpers.abs,
    Helpers.isNaN
} for Quad global;

using {
    Helpers.add as +,
    Helpers.sub as -,
    Helpers.mul as *,
    Helpers.div as /,
    Helpers.eq as ==,
    Helpers.neq as !=,
    Helpers.neg as -,
    Helpers.lt as <,
    Helpers.lte as <=,
    Helpers.gt as >,
    Helpers.gte as >=
} for Quad global;
