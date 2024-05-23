// SPDX-License-Identifier: MIT
pragma solidity 0.6.9;
pragma experimental ABIEncoderV2;

// need 

contract APIproxy {
    using SafeERC20 for IERC20;
    
    address constant _ETH_ADDRESS_ = 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE;


    receive() external payable {}

    //Compatible with ETH=>ERC20, ERC20=>ETH
    function useAPIData(
        address fromToken, //fromTokenaddress
        address toToken, //toTokenaddress
        uint256 fromAmount, //inamout with dicimals
        address OOApprove, // 0x6352a56caadc4f1e25cd6c75970fa768a3304e64
        address OOProxy, // 0x6352a56caadc4f1e25cd6c75970fa768a3304e64
        bytes memory OOApiData // data param from swap_quote API 
    )
        external
        payable
    {
        if (fromToken != _ETH_ADDRESS_) {
            IERC20(fromToken).transferFrom(msg.sender, address(this), fromAmount);
            _approveMax(fromToken, OOApprove, fromAmount);
        } else {
            require(fromAmount == msg.value);
        }

        (bool success, bytes memory result ) = OOProxy.call{value: fromToken == _ETH_ADDRESS_ ? fromAmount : 0}(OOApiData);
        require(success, "API_SWAP_FAILED");

        uint256 returnAmount = _balanceOf(toToken, address(this));

        _transfer(toToken, msg.sender, returnAmount);
    }


    function _approveMax(
        address token,
        address to,
        uint256 amount
    ) internal {
        uint256 allowance = IERC20(token).allowance(address(this), to);
        if (allowance < amount) {
            if (allowance > 0) {
                IERC20(token).safeApprove(to, 0);
            }
            IERC20(token).safeApprove(to, uint256(-1));
        }
    }

    function _transfer(
        address token,
        address payable to,
        uint256 amount
    ) internal {
        if (amount > 0) {
            if (token == _ETH_ADDRESS_) {
                to.transfer(amount);
            } else {
                IERC20(token).safeTransfer(to, amount);
            }
        }
    }

    

}