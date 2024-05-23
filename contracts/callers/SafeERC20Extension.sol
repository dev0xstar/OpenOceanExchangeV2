// SPDX-License-Identifier: MIT
pragma solidity ^0.6.12;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "../interfaces/ISafeERC20Extension.sol";
import "../libraries/UniversalERC20.sol";

abstract contract SafeERC20Extension is ISafeERC20Extension {
    using UniversalERC20 for IERC20;

    function safeApprove(
        IERC20 token,
        address spender,
        uint256 amount
    ) external override {
        token.universalApprove(spender, amount);
    }

    function safeTransfer(
        IERC20 token,
        address payable target,
        uint256 amount
    ) external override {
        token.universalTransfer(target, amount);
    }
}
