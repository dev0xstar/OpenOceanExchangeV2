// SPDX-License-Identifier: MIT
pragma solidity ^0.6.12;

import "../interfaces/state/ISmoothyState.sol";

abstract contract SmoothyState is ISmoothyState {
    function smoothyV1State(address smoothyV1)
        external
        view
        override
        returns (
            uint256[] memory tokenInfos,
            uint256[] memory tokenBalances,
            uint256 totalBalance,
            uint256 swapFee
        )
    {
        uint256 nTokens = ISmoothyV1(smoothyV1)._ntokens();

        tokenInfos = new uint256[](nTokens);
        tokenBalances = new uint256[](nTokens);
        for (uint256 tid = 0; tid < nTokens; tid++) {
            tokenInfos[tid] = ISmoothyV1(smoothyV1)._tokenInfos(tid);
            tokenBalances[tid] = ISmoothyV1(smoothyV1).getBalance(tid);
        }
        totalBalance = ISmoothyV1(smoothyV1)._totalBalance();
        swapFee = ISmoothyV1(smoothyV1)._swapFee();

        return (tokenInfos, tokenBalances, totalBalance, swapFee);
    }
}
