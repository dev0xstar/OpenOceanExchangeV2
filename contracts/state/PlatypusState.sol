// SPDX-License-Identifier: MIT
pragma solidity ^0.6.12;

import "../interfaces/state/IPlatypusState.sol";

abstract contract PlatypusState is IPlatypusState {
    function platypusPoolState(address pool)
        external
        view
        override
        returns (
            bool paused,
            uint256 c1,
            uint256 xThreshold,
            uint256 slippageParamK,
            uint256 slippageParamN,
            uint256 haircutRate,
            uint256 maxPriceDeviation
        )
    {
        paused = IPlatypusPool(pool).paused();
        c1 = IPlatypusPool(pool).getC1();
        xThreshold = IPlatypusPool(pool).getXThreshold();
        slippageParamK = IPlatypusPool(pool).getSlippageParamK();
        slippageParamN = IPlatypusPool(pool).getSlippageParamN();
        haircutRate = IPlatypusPool(pool).getHaircutRate();
        maxPriceDeviation = IPlatypusPool(pool).getMaxPriceDeviation();

        return (paused, c1, xThreshold, slippageParamK, slippageParamN, haircutRate, maxPriceDeviation);
    }

    function platypusAssetState(address pool, address token)
        external
        view
        override
        returns (
            uint8 decimals,
            uint256 price,
            uint256 cash,
            uint256 liability
        )
    {
        try IPlatypusPool(pool).assetOf(token) returns (address asset) {
            address oracle = IPlatypusPool(pool).getPriceOracle();
            decimals = IPlatypusAsset(asset).decimals();
            price = IPriceOracleGetter(oracle).getAssetPrice(token);
            cash = IPlatypusAsset(asset).cash();
            liability = IPlatypusAsset(asset).liability();
        } catch {
            decimals = 0;
            price = 0;
            cash = 0;
            liability = 0;
        }
        return (decimals, price, cash, liability);
    }
}
