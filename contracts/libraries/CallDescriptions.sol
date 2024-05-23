// SPDX-License-Identifier: MIT
pragma solidity ^0.6.12;
pragma experimental ABIEncoderV2;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "../interfaces/IOpenOceanCaller.sol";
import "./RevertReasonParser.sol";

library CallDescriptions {
    function execute(IOpenOceanCaller.CallDescription memory desc) internal returns (bool, string memory) {
        require(!isTransferFrom(desc.data), "OpenOcean: Not allowed");
        address target = address(desc.target);
        if (target == address(0)) {
            target = address(this);
        }
        require(target.balance >= desc.value, "OpenOcean: Insufficient balance for external call");
        bool success;
        bytes memory returnData;
        if (desc.gasLimit > 0) {
            (success, returnData) = target.call{value: desc.value, gas: desc.gasLimit}(desc.data);
        } else {
            (success, returnData) = target.call{value: desc.value}(desc.data);
        }
        return (success, RevertReasonParser.parse(returnData, "OpenOcean external call failed: "));
    }

    function encodeAmount(
        IOpenOceanCaller.CallDescription memory desc,
        uint256 amount,
        uint256 bias
    ) internal pure {
        bytes memory amountToEncode = abi.encode(amount);
        bytes memory data = desc.data;
        assembly {
            mstore(add(add(data, 32), bias), mload(add(amountToEncode, 32)))
        }
    }

    function isTransferFrom(bytes memory data) internal pure returns (bool) {
        // ERC20.transferFrom(address sender, address recipient, uint256 amount)
        // data.length = 4 + 32 + 32 + 32
        return data.length == 100 && data[0] == "\x23" && data[1] == "\xb8" && data[2] == "\x72" && data[3] == "\xdd";
    }
}
