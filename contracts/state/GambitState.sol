// SPDX-License-Identifier: MIT
pragma solidity ^0.6.12;
pragma experimental ABIEncoderV2;

import "../interfaces/state/IGambitState.sol";

abstract contract GambitState is IGambitState {
    function gambitState(IGambitVault vault, address[] calldata tokens)
        external
        view
        override
        returns (
            bool inManagerMode,
            bool isSwapEnabled,
            uint256[] memory minPrices,
            uint256[] memory maxPrices,
            uint256 stableFlag,
            uint256[] memory usdgAmounts,
            uint256[] memory targetUsdgAmounts,
            IGambitState.GambitStateFee memory fee,
            uint256 whitelistFlag
        )
    {
        inManagerMode = vault.inManagerMode();
        isSwapEnabled = vault.isSwapEnabled();
        minPrices = new uint256[](tokens.length);
        maxPrices = new uint256[](tokens.length);
        stableFlag = 0;
        usdgAmounts = new uint256[](tokens.length);
        targetUsdgAmounts = new uint256[](tokens.length);

        fee.stableSwapFeeBasisPoints = vault.stableSwapFeeBasisPoints();
        fee.swapFeeBasisPoints = vault.swapFeeBasisPoints();
        fee.stableTaxBasisPoints = vault.stableTaxBasisPoints();
        fee.taxBasisPoints = vault.taxBasisPoints();
        fee.mintBurnFeeBasisPoints = vault.mintBurnFeeBasisPoints();
        fee.hasDynamicFees = vault.hasDynamicFees();

        whitelistFlag = 0;

        for (uint256 i = 0; i < tokens.length; i++) {
            minPrices[i] = vault.getMinPrice(tokens[i]);
            maxPrices[i] = vault.getMaxPrice(tokens[i]);
            if (vault.stableTokens(tokens[i])) {
                stableFlag = stableFlag | (1 << i);
            }
            usdgAmounts[i] = vault.usdgAmounts(tokens[i]);
            targetUsdgAmounts[i] = vault.getTargetUsdgAmount(tokens[i]);
            if (vault.whitelistedTokens(tokens[i])) {
                whitelistFlag = whitelistFlag | (1 << i);
            }
        }
    }
}
