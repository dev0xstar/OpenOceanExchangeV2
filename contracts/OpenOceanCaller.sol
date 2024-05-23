// SPDX-License-Identifier: MIT
pragma solidity ^0.6.12;
pragma experimental ABIEncoderV2;

import "./interfaces/IOpenOceanCaller.sol";
import "./callers/DistributionCaller.sol";
import "./callers/SafeERC20Extension.sol";
import "./callers/UniswapCaller.sol";
import "./callers/DMMCaller.sol";
import "./callers/SolidlyCaller.sol";
import "./libraries/CallDescriptions.sol";

contract OpenOceanCaller is
    IOpenOceanCaller,
    DistributionCaller,
    SafeERC20Extension,
    UniswapV2LikeCaller,
    UniswapV3Caller,
    DMMCaller,
    SolidlyCaller
{
    using CallDescriptions for CallDescription;

    receive() external payable {
        // cannot directly send eth to this contract
        require(msg.sender != tx.origin);
    }

    function makeCall(CallDescription memory desc) external override {
        (bool success, string memory errorMessage) = desc.execute();
        if (!success) {
            revert(errorMessage);
        }
    }

    function makeCalls(CallDescription[] memory desc) external payable override {
        require(desc.length > 0, "OpenOcean: Invalid call parameter");
        for (uint256 i = 0; i < desc.length; i++) {
            this.makeCall(desc[i]);
        }
    }
}
