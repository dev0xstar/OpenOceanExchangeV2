// SPDX-License-Identifier: MIT
pragma solidity ^0.6.12;
pragma experimental ABIEncoderV2;

interface IWooPP {
    /// @dev struct info to store the token info
    struct TokenInfo {
        uint112 reserve; // Token balance
        uint112 threshold; // Threshold for reserve update
        uint32 lastResetTimestamp; // Timestamp for last param update
        uint64 R; // Rebalance coefficient [0, 1]
        uint112 target; // Targeted balance for pricing
        bool isValid; // is this token info valid
    }

    function tokenInfo(address)
        external
        view
        returns (
            uint112 reserve, // Token balance
            uint112 threshold, // Threshold for reserve update
            uint32 lastResetTimestamp, // Timestamp for last param update
            uint64 R, // Rebalance coefficient [0, 1]
            uint112 target, // Targeted balance for pricing
            bool isValid // is this token info valid
        );

    function wooracle() external view returns (address);

    function feeManager() external view returns (IWooFeeManager);
}

interface IWooracle {
    /// @dev returns the state for the given base token.
    /// @param base baseToken address
    /// @return priceNow the current price of base token
    /// @return spreadNow the current spread of base token
    /// @return coeffNow the slippage coefficient of base token
    /// @return feasible whether the current state is feasible and valid
    function state(address base)
        external
        view
        returns (
            uint256 priceNow,
            uint256 spreadNow,
            uint256 coeffNow,
            bool feasible
        );

    /// @dev returns the last updated timestamp
    /// @return the last updated timestamp
    function timestamp() external view returns (uint256);
}

interface IWooGuardian {
    function refInfo(address)
        external
        view
        returns (
            address chainlinkRefOracle, // chainlink oracle for price checking
            uint96 refPriceFixCoeff // chainlink price fix coeff
        );
}

interface AggregatorV3Interface {
    function latestRoundData()
        external
        view
        returns (
            uint80 roundId,
            int256 answer,
            uint256 startedAt,
            uint256 updatedAt,
            uint80 answeredInRound
        );
}

interface IWooFeeManager {
    function feeRate(address token) external view returns (uint256);
}

interface IWooState {
    struct Result {
        uint112 reserve; // Token balance
        uint64 R; // Rebalance coefficient [0; 1]
        uint112 target; // Targeted balance for pricing
        bool isValid; // is this token info valid
        uint256 p;
        uint256 s;
        uint256 k;
        bool isFeasible;
        uint256 lpFeeRate; // Fee rate: e.g. 0.001 = 0.1%
    }

    function wooState(address woo, address token)
        external
        view
        returns (
            uint112 reserve, // Token balance
            uint64 R, // Rebalance coefficient [0, 1]
            uint112 target, // Targeted balance for pricing
            bool isValid, // is this token info valid
            uint256 p,
            uint256 s,
            uint256 k,
            bool isFeasible,
            uint256 lpFeeRate // Fee rate: e.g. 0.001 = 0.1%
        );
}
