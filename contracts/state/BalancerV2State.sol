// SPDX-License-Identifier: MIT
pragma solidity ^0.6.12;
pragma experimental ABIEncoderV2;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "../interfaces/state/IBalancerV2State.sol";

abstract contract BalancerV2State is IBalancerV2State {
    function balancerV2WeightedPoolState(
        address vault,
        bytes32 poolId,
        address pool
    )
        external
        view
        override
        returns (
            IERC20[] memory tokens,
            uint256[] memory balances,
            uint256 totalSupply,
            uint256[] memory weights,
            uint256 swapFee
        )
    {
        (tokens, balances, ) = IVault(vault).getPoolTokens(poolId);
        totalSupply = IERC20(pool).totalSupply();
        weights = IWeightedPool(pool).getNormalizedWeights();
        swapFee = IWeightedPool(pool).getSwapFeePercentage();
        return (tokens, balances, totalSupply, weights, swapFee);
    }

    function balancerV2StablePoolState(
        address vault,
        bytes32 poolId,
        address pool
    )
        external
        view
        override
        returns (
            IERC20[] memory tokens,
            uint256[] memory balances,
            uint256 totalSupply,
            uint256 amp,
            uint256 swapFee
        )
    {
        (tokens, balances, ) = IVault(vault).getPoolTokens(poolId);
        totalSupply = IERC20(pool).totalSupply();
        (amp, , ) = IStablePool(pool).getAmplificationParameter();
        swapFee = IStablePool(pool).getSwapFeePercentage();
        return (tokens, balances, totalSupply, amp, swapFee);
    }
}
