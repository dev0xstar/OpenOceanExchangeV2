// SPDX-License-Identifier: MIT
pragma solidity ^0.6.12;
pragma experimental ABIEncoderV2;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/math/SafeMath.sol";
import "@openzeppelin/contracts/token/ERC20/SafeERC20.sol";
import "../interfaces/IUniswapCaller.sol";
import "../libraries/PoolAddress.sol";

abstract contract UniswapV2LikeCaller is IUniswapV2LikeCaller {
    using SafeMath for uint256;

    uint256 private constant ADDRESS_MASK = 0x000000000000000000000000ffffffffffffffffffffffffffffffffffffffff;
    uint256 private constant REVERSE_MASK = 0x8000000000000000000000000000000000000000000000000000000000000000;
    uint256 private constant NO_CALLDATA_MASK = 0x2000000000000000000000000000000000000000000000000000000000000000;
    uint256 private constant SIMPLE_RESERVES_MASK = 0x1000000000000000000000000000000000000000000000000000000000000000;
    uint256 private constant NUMERATOR_MASK = 0x0000000000000000ffffffff0000000000000000000000000000000000000000;
    uint256 private constant DENOMINATOR = 1000000000;
    uint256 private constant NUMERATOR_OFFSET = 160;

    function uniswapV2Swap(
        uint256 pool,
        address srcToken,
        address receiver
    ) external override {
        address pair = address(pool & ADDRESS_MASK);
        bool reverse = (pool & REVERSE_MASK) != 0;

        uint256 inReserve;
        uint256 outReserve;
        {
            // avoid stack too deep error
            uint112 reserve0;
            uint112 reserve1;
            if ((pool & SIMPLE_RESERVES_MASK) == 0) {
                (reserve0, reserve1, ) = IUniswapV2Pair(pair).getReserves();
            } else {
                (reserve0, reserve1) = IUniswapV2SimpleReservesPair(pair).getReserves();
            }
            (inReserve, outReserve) = reverse ? (reserve1, reserve0) : (reserve0, reserve1);
        }

        uint256 inAmount = IERC20(srcToken).balanceOf(pair).sub(inReserve);
        uint256 outAmount = calculateOutAmount(inReserve, outReserve, inAmount, (pool & NUMERATOR_MASK) >> NUMERATOR_OFFSET);

        (uint256 amount0Out, uint256 amount1Out) = reverse ? (outAmount, uint256(0)) : (uint256(0), outAmount);
        if ((pool & NO_CALLDATA_MASK) == 0) {
            IUniswapV2Pair(pair).swap(amount0Out, amount1Out, receiver, new bytes(0));
        } else {
            IUniswapV2NoCalldataPair(pair).swap(amount0Out, amount1Out, receiver);
        }
    }

    function calculateOutAmount(
        uint256 inReserve,
        uint256 outReserve,
        uint256 amount,
        uint256 feeNumerator
    ) private pure returns (uint256) {
        uint256 inAmountWithFee = amount.mul(feeNumerator);
        uint256 numerator = inAmountWithFee.mul(outReserve);
        uint256 denominator = inReserve.mul(DENOMINATOR).add(inAmountWithFee);
        return (denominator == 0) ? 0 : numerator.div(denominator);
    }
}

abstract contract UniswapV3Caller is IUniswapV3Caller {
    using SafeERC20 for IERC20;

    /// @dev The minimum value that can be returned from #getSqrtRatioAtTick. Equivalent to getSqrtRatioAtTick(MIN_TICK)
    uint160 private constant MIN_SQRT_RATIO = 4295128739;
    /// @dev The maximum value that can be returned from #getSqrtRatioAtTick. Equivalent to getSqrtRatioAtTick(MAX_TICK)
    uint160 private constant MAX_SQRT_RATIO = 1461446703485210103287273052203988822378723970342;

    function uniswapV3SwapCallback(
        int256 amount0Delta,
        int256 amount1Delta,
        bytes calldata callback
    ) external override {
        require(amount0Delta > 0 || amount1Delta > 0, "UniswapV3: DELTA");
        IUniswapV3Caller.SwapCallbackData memory data = abi.decode(callback, (IUniswapV3Caller.SwapCallbackData));

        (address tokenIn, address tokenOut, uint24 fee) = PoolAddress.decodePool(data.path);
        address pool = PoolAddress.computeAddress(PoolAddress.getPoolKey(tokenIn, tokenOut, fee));
        require(msg.sender == pool, "OpenOcean: Access Denied");

        (bool isExactInput, uint256 amountToPay) = amount0Delta > 0
            ? (tokenIn < tokenOut, uint256(amount0Delta))
            : (tokenOut < tokenIn, uint256(amount1Delta));
        require(isExactInput && amountToPay == data.amount, "UniswapV3: TIA");

        IERC20(tokenIn).safeTransfer(msg.sender, amountToPay);
    }

    function uniswapV3Swap(
        address pool,
        bool zeroForOne,
        int256 amount,
        address recipient,
        bytes calldata path
    ) external override {
        uint160 sqrtPriceLimitX96 = zeroForOne ? MIN_SQRT_RATIO + 1 : MAX_SQRT_RATIO - 1;
        IUniswapV3Caller.SwapCallbackData memory data = IUniswapV3Caller.SwapCallbackData({path: path, amount: uint256(amount)});
        IUniswapV3Pool(pool).swap(recipient, zeroForOne, amount, sqrtPriceLimitX96, abi.encode(data));
    }
}
