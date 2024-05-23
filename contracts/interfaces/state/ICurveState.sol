// SPDX-License-Identifier: MIT
pragma solidity ^0.6.12;
pragma experimental ABIEncoderV2;

interface ICurvePool {
    function A() external view returns (uint256);

    function fee() external view returns (uint256);
}

/**
 * @notice Pool contracts of curve.fi
 * See https://github.com/curvefi/curve-vue/blob/master/src/docs/README.md#how-to-integrate-curve-smart-contracts
 */
interface ICurvePoolV1 is ICurvePool {
    function balances(int128 i) external view returns (uint256); // v1 version

    function coins(int128 i) external view returns (address);

    function underlying_coins(int128 i) external view returns (address);
}

interface ICurvePoolV2 is ICurvePool {
    function balances(uint256 i) external view returns (uint256);

    function coins(uint256 i) external view returns (address);

    function underlying_coins(uint256 i) external view returns (address);
}

interface ICurveState {
    struct CurvePoolStateQuery {
        address pool;
        uint8 nCoins;
        uint8 version;
        uint256 underlyingDecimals;
        address rateCallee;
        bytes rateCalldata;
    }

    function curvePoolState(CurvePoolStateQuery memory query)
        external
        view
        returns (
            uint256[] memory balances,
            uint256[] memory underlying_balances,
            uint256[] memory rates,
            uint256 A,
            uint256 fee
        );
}
