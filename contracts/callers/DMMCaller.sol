// SPDX-License-Identifier: MIT
pragma solidity ^0.6.12;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/math/SafeMath.sol";
import "../interfaces/IDMMCaller.sol";

abstract contract DMMCaller is IDMMCaller {
    using SafeMath for uint256;

    uint256 private constant PRECISION = 1e18;

    function dmmSwap(
        address pool,
        IERC20 from,
        IERC20 to,
        address target
    ) external override {
        bool reverse = from > to;

        (uint112 reserve0, uint112 reserve1, uint112 vReserve0, uint112 vReserve1, uint256 feeInPrecision) = IDMMPool(pool)
            .getTradeInfo();
        (reserve0, reserve1) = reverse ? (reserve1, reserve0) : (reserve0, reserve1);
        (vReserve0, vReserve1) = reverse ? (vReserve1, vReserve0) : (vReserve0, vReserve1);
        uint256 inAmount = from.balanceOf(pool).sub(reserve0);
        uint256 outAmount = calculateDmmOutAmount(vReserve0, vReserve1, inAmount, feeInPrecision);

        (uint256 amount0Out, uint256 amount1Out) = reverse ? (outAmount, uint256(0)) : (uint256(0), outAmount);
        IDMMPool(pool).swap(amount0Out, amount1Out, target, new bytes(0));
    }

    function calculateDmmOutAmount(
        uint256 vReserveIn,
        uint256 vReserveOut,
        uint256 amount,
        uint256 feeInPrecision
    ) private pure returns (uint256) {
        uint256 amountInWithFee = amount.mul(PRECISION.sub(feeInPrecision)).div(PRECISION);
        uint256 numerator = amountInWithFee.mul(vReserveOut);
        uint256 denominator = vReserveIn.add(amountInWithFee);
        return (denominator == 0) ? 0 : numerator.div(denominator);
    }
}
