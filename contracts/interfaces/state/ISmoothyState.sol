// SPDX-License-Identifier: MIT
pragma solidity ^0.6.12;

interface ISmoothyV1 {
    function _ntokens() external view returns (uint256);

    function _tokenInfos(uint256) external view returns (uint256);

    function getBalance(uint256 tid) external view returns (uint256);

    function _totalBalance() external view returns (uint256);

    function _swapFee() external view returns (uint256);
}

interface ISmoothyState {
    function smoothyV1State(address smoothyV1)
        external
        view
        returns (
            uint256[] memory tokenInfos,
            uint256[] memory tokenBalances,
            uint256 totalBalance,
            uint256 swapFee
        );
}
