// SPDX-License-Identifier: MIT
pragma solidity ^0.6.12;

/**
 * @notice Uniswap V2 pair pool interface. See https://uniswap.org/docs/v2/smart-contracts/pair/
 */
interface IUniswapV2Pair {
    function getReserves()
        external
        view
        returns (
            uint112 reserve0,
            uint112 reserve1,
            uint32 blockTimestampLast
        );
}

/**
 * @notice Uniswap V2 factory contract interface. See https://uniswap.org/docs/v2/smart-contracts/factory/
 */
interface IMdexFactory {
    function getPairFees(address) external view returns (uint256);
}

interface IUniswapV2LikeState {
    function uniswapV2LikeState(address pair, address mdexFactory)
        external
        view
        returns (
            uint112 reserve0,
            uint112 reserve1,
            uint256 pairFee
        );
}
