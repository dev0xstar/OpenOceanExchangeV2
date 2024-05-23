// SPDX-License-Identifier: MIT
pragma solidity ^0.6.12;
pragma experimental ABIEncoderV2;

import "./IBalancerV2State.sol";
import "./ICurveState.sol";
import "./ISmoothyState.sol";
import "./IWooState.sol";
import "./IPlatypusState.sol";
import "./IGambitState.sol";

interface IOpenOceanState is IBalancerV2State, ICurveState, ISmoothyState, IWooState, IPlatypusState, IGambitState {}
