// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.17;

import {IPrincipalToken} from "@main/interfaces/IPrincipalToken.sol";
import {IYieldToken} from "@main/interfaces/IYieldToken.sol";

import {ExpiryHelpers} from "@main/libraries/ExpiryHelpers.sol";

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";

import {Initializable} from "@openzeppelin-upgradable/contracts/proxy/utils/Initializable.sol";

contract PrincipalTokenV2 is ERC20, Initializable, IPrincipalToken {
    address public immutable SY;
    address public immutable factory;
    uint256 public immutable expiry;
    address public YT;

    modifier onlyYT() {
        if (msg.sender != YT) revert OnlyYT();
        _;
    }

    modifier onlyYieldFactory() {
        if (msg.sender != factory) revert OnlyYContractFactory();
        _;
    }

    //TO DO customized decimal
    constructor(
        address _SY,
        string memory _name,
        string memory _symbol,
        uint256 _expiry
    ) ERC20(_name, _symbol) {
        SY = _SY;
        expiry = _expiry;
        factory = msg.sender;
    }

    function initialize(address _YT) external initializer onlyYieldFactory {
        YT = _YT;
    }

    /**
     * @dev only callable by the YT correspond to this PT
     */
    function burnByYT(address user, uint256 amount) external onlyYT {
        _burn(user, amount);
    }

    /**
     * @dev only callable by the YT correspond to this PT
     */
    function mintByYT(address user, uint256 amount) external onlyYT {
        _mint(user, amount);
    }

    function isExpired() public view returns (bool) {
        return ExpiryHelpers.isCurrentlyExpired(expiry);
    }
}

