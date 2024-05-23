// SPDX-License-Identifier: MIT
pragma solidity ^0.6.12;

interface IPriceOracleGetter {
    /**
    @dev returns the asset price in ETH
     */
    function getAssetPrice(address _asset) external view returns (uint256);
}

interface IPlatypusPool {
    function paused() external view returns (bool);

    function assetOf(address token) external view returns (address);

    function getPriceOracle() external view returns (address);

    function getC1() external view returns (uint256);

    function getXThreshold() external view returns (uint256);

    function getSlippageParamK() external view returns (uint256);

    function getSlippageParamN() external view returns (uint256);

    function getHaircutRate() external view returns (uint256);

    function getMaxPriceDeviation() external view returns (uint256);
}

interface IPlatypusAsset {
    function decimals() external view returns (uint8);

    function cash() external view returns (uint256);

    function liability() external view returns (uint256);
}

interface IPlatypusState {
    function platypusPoolState(address pool)
        external
        view
        returns (
            bool paused,
            uint256 c1,
            uint256 xThreshold,
            uint256 slippageParamK,
            uint256 slippageParamN,
            uint256 haircutRate,
            uint256 maxPriceDeviation
        );

    function platypusAssetState(address pool, address token)
        external
        view
        returns (
            uint8 decimals,
            uint256 price,
            uint256 cash,
            uint256 liability
        );
}
