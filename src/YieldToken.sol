// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.17;

import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";

import {IStandardizedYield} from "@main/interfaces/IStandardizedYield.sol";
import {IYieldToken} from "@main/interfaces/IYieldToken.sol";
import {IPrincipalToken} from "@main/interfaces/IPrincipalToken.sol";

import {Math } from "@main/libraries/math/Math.sol";
import {ArrayLib } from "@main/libraries/ArrayLib.sol";
import {IYieldContractFactory } from "@main/interfaces/IYieldContractFactory.sol";
import {SYUtils } from "@main/libraries/SYUtils.sol";

import {ExpiryHelpers} from "@main/libraries/ExpiryHelpers.sol";
import {RewardManager} from "@main/RewardManager/RewardManager.sol";
import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {InterestManagerYT} from "@main/InterestManagerYT.sol";