
## newLoan
`newLoan` is a bit more complicated. At a high level, you want to borrow liquidity
from multiple bins, in varying amounts across the bins.

`startBin` to `startBin + owedPotential.length` are the bins borrowed from.

`owedPotential` is the maximum amounts owed (ie. borrowed/lent + interest), in liquidity units.

`lockinEnd` is the amount of time (in days) the periodic loan has to be held before
being able to abandon it (so =0 for revolving loan, and =+Inf for fixed term loan).

`deadEra` is the era up to which collateral will be provided to cover upcoming interest
payments (None representing for all time up to +Inf).

`twapFixed` is Some when the TWAP (fixed exposure) feature is enabled, its Int content
being the era at which the TWAP ends and the swapper reverts to being without TWAP.

`token` is the token (false = token 0, true = token 1) for which the exposure is fixed.
If fixed exposure (aka. TWAP) is not enabled, this argument remains unused.

`tokenMix`has two different interpretations depending on whether TWAP is enabled.
If TWAP is enabled, it is the fixed exposure level which the swapper will maintain
(while TWAP is in effect), in token units - of whichever token the exposure is fixed
for (as specified by the `token` argument). Without TWAP, `tokenMix` is the proportion
of token 0 and 1 backing the swapper - a number between 0 and 1, where 0 means fully
backed by token 0, and 1 fully backed by token 1.

`strikeBin` is a bit of a technicality, but you need to set it to one of the bins
being borrowed, and it should be towards the middle on the range (more precisely close
to the weighted mean of `owedPotential`)
