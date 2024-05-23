// SPDX-License-Identifier: MIT
pragma solidity ^0.6.12;
pragma experimental ABIEncoderV2;

interface IGambitVault {
    function inManagerMode() external view returns (bool);

    function isSwapEnabled() external view returns (bool);

    function getMinPrice(address) external view returns (uint256);

    function getMaxPrice(address) external view returns (uint256);

    function stableTokens(address) external view returns (bool);

    function usdgAmounts(address) external view returns (uint256);

    function getTargetUsdgAmount(address) external view returns (uint256);

    function stableSwapFeeBasisPoints() external view returns (uint256);

    function swapFeeBasisPoints() external view returns (uint256);

    function stableTaxBasisPoints() external view returns (uint256);

    function taxBasisPoints() external view returns (uint256);

    function mintBurnFeeBasisPoints() external view returns (uint256);

    function hasDynamicFees() external view returns (bool);

    function whitelistedTokens(address) external view returns (bool);
}

interface IGambitState {
    struct GambitStateFee {
        uint256 stableSwapFeeBasisPoints;
        uint256 swapFeeBasisPoints;
        uint256 stableTaxBasisPoints;
        uint256 taxBasisPoints;
        uint256 mintBurnFeeBasisPoints;
        bool hasDynamicFees;
    }

    function gambitState(IGambitVault vault, address[] calldata tokens)
        external
        view
        returns (
            bool inManagerMode,
            bool isSwapEnabled,
            uint256[] memory minPrices,
            uint256[] memory maxPrices,
            uint256 stableFlag,
            uint256[] memory usdgAmounts,
            uint256[] memory targetUsdgAmounts,
            GambitStateFee memory fee,
            uint256 whitelistFlag
        );
}
