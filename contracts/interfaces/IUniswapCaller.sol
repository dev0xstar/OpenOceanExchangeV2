// SPDX-License-Identifier: MIT
pragma solidity ^0.6.12;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

import "./IUniswapV3.sol";

/**
 * @notice Uniswap V2 pair pool interface. See https://uniswap.org/docs/v2/smart-contracts/pair/
 */
interface IUniswapV2Pair {
    function swap(
        uint256 amount0Out,
        uint256 amount1Out,
        address to,
        bytes calldata data
    ) external;

    function getReserves()
        external
        view
        returns (
            uint112 reserve0,
            uint112 reserve1,
            uint32 blockTimestampLast
        );
}

interface IUniswapV2NoCalldataPair {
    function swap(
        uint256 amount0Out,
        uint256 amount1Out,
        address to
    ) external;
}

interface IUniswapV2SimpleReservesPair {
    function getReserves() external view returns (uint112 reserve0, uint112 reserve1);
}

interface IUniswapV2LikeCaller {
    function uniswapV2Swap(
        uint256 pool,
        address srcToken,
        address receiver
    ) external;
}

interface IUniswapV3Caller is IUniswapV3SwapCallback {
    struct SwapCallbackData {
        bytes path;
        uint256 amount;
    }

    function uniswapV3Swap(
        address pool,
        bool zeroForOne,
        int256 amount,
        address recipient,
        bytes calldata path
    ) external;
}
