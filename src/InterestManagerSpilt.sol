// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.17;

import {IVaribleYieldToken} from "@main/interfaces/IVaribleYieldToken.sol";
import {IGuaranteedYieldToken} from "@main/interfaces/IGuaranteedYieldToken.sol";
import {IInterestManagerSpilt} from "@main/interfaces/IInterestManagerSpilt.sol";

import {SafeERC20} from "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";

import {Math } from "@main/libraries/math/Math.sol";
import {TokenHelper } from "@main/libraries/TokenHelper.sol";
import {SYUtils } from "@main/libraries/SYUtils.sol";

abstract contract InterestManagerSpilt is TokenHelper, IInterestManagerSpilt {
    using Math for uint256;

    // needs to account fot VT and GT
    struct UserInterest {
        // accumulated interest index
        uint128 netIndex;
        // amount to distribute
        uint128 accrued;
        // exchange rate ? (fee not accounted)
        // data type to optimiza
        uint256 grossIndex;

        // // invaraint total = gy + vy index
        // uint256 gyIndex;
        // uint256 vyIndex;
    }

    uint256 public lastInterestBlock;

    uint256 public globalNetInterestIndex;

    mapping(address => UserInterest) public userInterest;

    uint256 internal constant INITIAL_INTEREST_INDEX = 1;

    function _updateAndDistributeInterest(address user) internal virtual {
        _updateAndDistributeInterestForTwo(user, address(0));
    }

    function _updateAndDistributeInterestForTwo(address user1, address user2) internal virtual {
        (uint256 netIndex, uint256 grossIndex) = _updateInterestIndex();

        if (user1 != address(0) && user1 != address(this)) _distributeInterestPrivate(user1, netIndex, grossIndex);
        if (user2 != address(0) && user2 != address(this)) _distributeInterestPrivate(user2, netIndex, grossIndex);
    }

    function _doTransferOutInterest(address user, address SY) internal returns (uint256 interestAmount) {
        interestAmount = userInterest[user].accrued;
        userInterest[user].accrued = 0;
        _transferOut(SY, user, interestAmount);
    }

    // should only be callable from `_distributeInterestForTwo` & make sure user != address(0) && user != address(this)
    function _distributeInterestPrivate(address user, uint256 currentNetIndex, uint256 grossIndex) private {
        assert(user != address(0) && user != address(this));

        uint256 prevNetIndex = userInterest[user].netIndex;

        if (prevNetIndex == currentNetIndex) return;

        if (prevNetIndex == 0) {
            userInterest[user].netIndex = currentNetIndex.Uint128();
            userInterest[user].grossIndex = grossIndex;
            return;
        }

        userInterest[user].accrued += _yieldTokenbalance(user).mulDown(currentNetIndex - prevNetIndex).Uint128();
        userInterest[user].netIndex = currentNetIndex.Uint128();
        userInterest[user].grossIndex = grossIndex;
    }

    function _updateInterestIndex() internal returns (uint256 netIndex, uint256 grossIndex) {
        if (lastInterestBlock != block.number) {
            // if we have not yet update the index for this block
            lastInterestBlock = block.number;

            uint256 totalShares = _yieldTokenSupply();
            uint256 accrued;

            // accrued = total interest amount in that round (to be divided)
            (accrued, grossIndex) = _collectInterest();
            netIndex = globalNetInterestIndex;

            if (netIndex == 0) netIndex = INITIAL_INTEREST_INDEX;
            // netIndex = accrued / totalShares (accumulated interest index)
            if (totalShares != 0) netIndex += accrued.divDown(totalShares);

            globalNetInterestIndex = netIndex;
        } else {
            netIndex = globalNetInterestIndex;
            grossIndex = _getGlobalGrossIndex();
        }
    }

    function _getGlobalGrossIndex() internal view virtual returns (uint256);

    function _collectInterest() internal virtual returns (uint256, uint256);

    function _yieldTokenbalance(address user) internal view virtual returns (uint256);

    function _yieldTokenSupply() internal view virtual returns (uint256);
}
