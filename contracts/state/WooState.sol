// SPDX-License-Identifier: MIT
pragma solidity ^0.6.12;
pragma experimental ABIEncoderV2;

import "@openzeppelin/contracts/math/SafeMath.sol";
import "../interfaces/state/IWooState.sol";

abstract contract WooState is IWooState {
    using SafeMath for uint256;

    function wooState(address woo, address token)
        external
        view
        override
        returns (
            uint112, // Token balance
            uint64, // Rebalance coefficient [0, 1]
            uint112, // Targeted balance for pricing
            bool, // is this token info valid
            uint256,
            uint256,
            uint256,
            bool,
            uint256 // Fee rate: e.g. 0.001 = 0.1%
        )
    {
        Result memory result;

        (result.reserve, , , result.R, result.target, result.isValid) = IWooPP(woo).tokenInfo(token);
        result.lpFeeRate = IWooPP(woo).feeManager().feeRate(token);
        (result.p, result.s, result.k, result.isFeasible) = IWooracle(IWooPP(woo).wooracle()).state(token);

        return (
            result.reserve,
            result.R,
            result.target,
            result.isValid,
            result.p,
            result.s,
            result.k,
            result.isFeasible,
            result.lpFeeRate
        );
    }
}
