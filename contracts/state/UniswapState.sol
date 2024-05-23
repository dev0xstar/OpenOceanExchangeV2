// SPDX-License-Identifier: MIT
pragma solidity ^0.6.12;
pragma experimental ABIEncoderV2;

import "../interfaces/state/IUniswapState.sol";

abstract contract UniswapV2LikeState is IUniswapV2LikeState {
    function uniswapV2LikeState(address pair, address mdexFactory)
        external
        view
        override
        returns (
            uint112 reserve0,
            uint112 reserve1,
            uint256 pairFee
        )
    {
        (reserve0, reserve1, ) = IUniswapV2Pair(pair).getReserves();
        if (mdexFactory != address(0)) {
            pairFee = IMdexFactory(mdexFactory).getPairFees(pair);
        }
        return (reserve0, reserve1, pairFee);
    }
}
