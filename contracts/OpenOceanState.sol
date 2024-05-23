// SPDX-License-Identifier: MIT
pragma solidity ^0.6.12;
pragma experimental ABIEncoderV2;

import "./interfaces/state/IOpenOceanState.sol";
import "./state/BalancerV2State.sol";
import "./state/CurveState.sol";
import "./state/SmoothyState.sol";
import "./state/WooState.sol";
import "./state/PlatypusState.sol";
import "./state/GambitState.sol";

contract OpenOceanState is IOpenOceanState, BalancerV2State, CurveState, SmoothyState, WooState, PlatypusState, GambitState {}
