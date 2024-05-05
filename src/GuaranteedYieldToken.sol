//SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import {IGuaranteedYieldToken} from "@main/interfaces/IGuaranteedYieldToken.sol";

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {Initializable} from "@openzeppelin-upgradable/contracts/proxy/utils/Initializable.sol";

contract PrincipalToken is ERC20, Initializable, IGuaranteedYieldToken {
    address public immutable SY;
    address public VT;

    modifier onlyGT() {
        if (msg.sender != VT) revert OnlyGT();
        _;
    }

    //TO DO customized decimal
    constructor(
        address _SY,
        string memory _name,
        string memory _symbol
    ) ERC20(_name, _symbol) {
        SY = _SY;

    }

    /**
     * @dev only callable by the factory
     */

    function initialize(address _YT) external initializer {
    }

    /**
     * @dev only callable by the YT correspond to this PT
     */
    function burnByVT(address user, uint256 amount) external onlyGT {
        _burn(user, amount);
    }

    /**
     * @dev only callable by the YT correspond to this PT
     */
    function mintByVT(address user, uint256 amount) external onlyGT {
        _mint(user, amount);
    }

}

