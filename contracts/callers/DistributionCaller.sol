// SPDX-License-Identifier: MIT
pragma solidity ^0.6.12;
pragma experimental ABIEncoderV2;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/math/SafeMath.sol";
import "../interfaces/IDistributionCaller.sol";
import "../libraries/CallDescriptions.sol";
import "../libraries/UniversalERC20.sol";

abstract contract DistributionCaller is IDistributionCaller {
    using CallDescriptions for IOpenOceanCaller.CallDescription;
    using UniversalERC20 for IERC20;
    using SafeMath for uint256;

    function singleDistributionCall(
        IERC20 token,
        uint256 distribution,
        IOpenOceanCaller.CallDescription memory desc,
        uint256 amountBias
    ) external override {
        uint256 balance = token.universalBalanceOf(address(this));
        (uint128 numerator, uint128 denominator) = getDistribution(distribution);
        uint256 amount = balance.mul(numerator).div(denominator);
        require(amount > 0, "OpenOcean: Insufficient token balance");

        if (token.isETH() && desc.target != 0) {
            desc.value = amount;
        }
        if (amountBias > 0) {
            desc.encodeAmount(amount, amountBias);
        }
        (bool success, string memory errorMessage) = desc.execute();
        if (!success) {
            revert(errorMessage);
        }
    }

    function multiDistributionCall(
        IERC20 token,
        uint256 distribution,
        IOpenOceanCaller.CallDescription[] memory descs,
        uint256[] memory amountBiases
    ) external override {
        require(descs.length == amountBiases.length, "OpenOcean: Invalid call parameters");

        uint256 balance = token.universalBalanceOf(address(this));
        require(balance > 0, "OpenOcean: Insufficient token balance");
        (uint128 numerator, uint128 denominator) = getDistribution(distribution);
        uint256 amount = balance.mul(numerator).div(denominator);

        for (uint256 i = 0; i < descs.length; i++) {
            if (token.isETH() && descs[i].target != 0) {
                descs[i].value = amount;
            }
            if (amountBiases[i] > 0) {
                descs[i].encodeAmount(amount, amountBiases[i]);
            }
            (bool success, string memory errorMessage) = descs[i].execute();
            if (!success) {
                revert(errorMessage);
            }
        }
    }

    function getDistribution(uint256 distribution) private pure returns (uint128, uint128) {
        uint128 numerator = uint128(distribution >> 128);
        uint128 denominator = uint128(distribution);
        require(numerator > 0 && denominator > 0, "OpenOcean: Invalid call parameters");
        return (numerator, denominator);
    }
}
