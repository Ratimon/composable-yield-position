// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.0;

import {IERC20Metadata} from "@openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol";

interface IPrincipalToken is IERC20Metadata {

    error OnlyYT();
    error OnlyYContractFactory();

    function burnByYT(address user, uint256 amount) external;

    function mintByYT(address user, uint256 amount) external;

    function initialize(address _YT) external;

    function SY() external view returns (address);

    function YT() external view returns (address);

    function factory() external view returns (address);

    function expiry() external view returns (uint256);

    function isExpired() external view returns (bool);
}
