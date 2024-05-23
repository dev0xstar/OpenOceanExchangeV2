// SPDX-License-Identifier: MIT
pragma solidity ^0.6.12;
pragma experimental ABIEncoderV2;

import "@openzeppelin/contracts/utils/Address.sol";
import "@openzeppelin/contracts/math/SafeMath.sol";

import "../interfaces/state/ICurveState.sol";

abstract contract CurveState is ICurveState {
    using Address for address;
    using SafeMath for uint256;

    function curvePoolState(ICurveState.CurvePoolStateQuery memory query)
        external
        view
        override
        returns (
            uint256[] memory balances,
            uint256[] memory underlying_balances,
            uint256[] memory rates,
            uint256 A,
            uint256 fee
        )
    {
        balances = new uint256[](8);
        for (uint256 i = 0; i < query.nCoins; i++) {
            balances[i] = query.version == 1 ? ICurvePoolV1(query.pool).balances(int128(i)) : ICurvePoolV2(query.pool).balances(i);
        }

        rates = new uint256[](8);
        if (query.underlyingDecimals > 0) {
            address callee = query.rateCallee;
            bytes memory data = query.rateCalldata;
            address[] memory coins = new address[](query.nCoins);
            if (data.length > 0 && callee == address(0)) {
                for (uint256 i = 0; i < query.nCoins; i++) {
                    coins[i] = query.version == 1 ? ICurvePoolV1(query.pool).coins(int128(i)) : ICurvePoolV2(query.pool).coins(i);
                }
            }
            for (uint256 i = 0; i < query.nCoins; i++) {
                if (data.length == 0) {
                    rates[i] = 1e18;
                } else {
                    bytes memory result = (callee == address(0) ? coins[i] : callee).functionStaticCall(data);
                    rates[i] = abi.decode(result, (uint256));
                }
            }
        } else {
            for (uint256 i = 0; i < query.nCoins; i++) {
                rates[i] = 1e18;
            }
        }

        underlying_balances = new uint256[](8);
        if (query.underlyingDecimals > 0) {
            for (uint256 i = 0; i < query.nCoins; i++) {
                uint256 decimal = (query.underlyingDecimals >> (8 * i)) % 256;
                underlying_balances[i] = balances[i].mul(rates[i]).div(10**decimal);
            }
        }

        A = ICurvePool(query.pool).A();
        fee = ICurvePool(query.pool).fee();

        return (balances, underlying_balances, rates, A, fee);
    }
}
