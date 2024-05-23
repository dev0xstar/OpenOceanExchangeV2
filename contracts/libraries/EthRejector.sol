// SPDX-License-Identifier: MIT
pragma solidity ^0.6.12;

abstract contract EthRejector {
    receive() external payable {
        require(msg.sender != tx.origin, "ETH deposit rejected");
    }
}
