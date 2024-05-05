// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.0;

import {IERC20Metadata} from "@openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol";
import {IRewardManager} from "@main/interfaces/IRewardManager.sol";
import {IInterestManagerYT} from "@main/interfaces/IInterestManagerYT.sol";

// interface IVaribleYieldToken is IERC20Metadata, IRewardManager, IInterestManagerYT {
interface IVaribleYieldToken {

    // // YIELD CONTRACT
    // error YTExpired();
    // error YTNotExpired();
    // error YieldContractInsufficientSy(uint256 actualSy, uint256 requiredSy);
    // error YTNothingToRedeem();
    // error YTPostExpiryDataNotSet();
    // error YTNoFloatingSy();
    
    // event Mint(
    //     address indexed caller,
    //     address indexed receiverPT,
    //     address indexed receiverYT,
    //     uint256 amountSyToMint,
    //     uint256 amountPYOut
    // );

    // event Burn(address indexed caller, address indexed receiver, uint256 amountPYToRedeem, uint256 amountSyOut);

    // event RedeemRewards(address indexed user, uint256[] amountRewardsOut);

    // event RedeemInterest(address indexed user, uint256 interestOut);

    // event WithdrawFeeToTreasury(uint256[] amountRewardsOut, uint256 syOut);

    // event CollectInterestFee(uint256 amountInterestFee);

    // event CollectRewardFee(address indexed rewardToken, uint256 amountRewardFee);

    // function mintPY(address receiverPT, address receiverYT) external returns (uint256 amountPYOut);

    // function redeemPY(address receiver) external returns (uint256 amountSyOut);

    // function redeemPYMulti(
    //     address[] calldata receivers,
    //     uint256[] calldata amountPYToRedeems
    // ) external returns (uint256[] memory amountSyOuts);

    // function redeemDueInterestAndRewards(
    //     address user,
    //     bool redeemInterest,
    //     bool redeemRewards
    // ) external returns (uint256 interestOut, uint256[] memory rewardsOut);

    // function rewardIndexesCurrent() external returns (uint256[] memory);

    // function pyIndexCurrent() external returns (uint256);

    // function pyIndexStored() external view returns (uint256);

    // function getRewardTokens() external view returns (address[] memory);

    // function SY() external view returns (address);

    // function GT() external view returns (address);

    // // function factory() external view returns (address);

    // // function expiry() external view returns (uint256);

    // // function isExpired() external view returns (bool);

    // function doCacheIndexSameBlock() external view returns (bool);
}
