//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {IERC20Metadata} from "@openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol";

interface IGuaranteedYieldToken is IERC20Metadata {

    error OnlyVT();
    // error OnlyContractFactory();

    function burnByVT(address user, uint256 amount) external;

    function mintByVT(address user, uint256 amount) external;

    function initialize(address _YT) external;

    function SY() external view returns (address);

    function VT() external view returns (address);

    // function factory() external view returns (address);

    // function expiry() external view returns (uint256);

    // function isExpired() external view returns (bool);
}
