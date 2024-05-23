// SPDX-License-Identifier: MIT
pragma solidity ^0.6.12;

/**
 * @notice Uniswap V2 pair pool interface. See https://uniswap.org/docs/v2/smart-contracts/pair/
 */
interface ISolidlyPair {
    function swap(
        uint256 amount0Out,
        uint256 amount1Out,
        address to,
        bytes calldata data
    ) external;

    function metadata()
        external
        view
        returns (
            uint256 decimals0,
            uint256 decimals1,
            uint256 reserve0,
            uint256 reserve1,
            bool stable,
            address token0,
            address token1
        );
}

interface ISolidlyCaller {
    function solidlySwap(
        uint256 pool,
        address srcToken,
        address receiver
    ) external;
}
