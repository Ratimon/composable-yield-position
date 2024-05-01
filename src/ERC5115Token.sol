// SPDX-License-Identifier: MIT
pragma solidity =0.8.25;

import {IStandardizedYield} from "@main/interfaces/IStandardizedYield.sol";

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {ERC20Permit} from "@openzeppelin/contracts/token/ERC20/extensions/ERC20Permit.sol";

import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {Pausable } from "@openzeppelin/contracts/utils/Pausable.sol";

import {ReentrancyGuard } from  "@openzeppelin/contracts/utils/ReentrancyGuard.sol";

import  {TokenHelper } from "@main/libraries/TokenHelper.sol";


// import "../libraries/Errors.sol";


// permit ?

abstract contract ERC5115Token is IStandardizedYield,ERC20, ERC20Permit, TokenHelper,  Ownable, Pausable, ReentrancyGuard {

    address public immutable yieldToken;

        // SY
    error SYInvalidTokenIn(address token);
    error SYInvalidTokenOut(address token);
    error SYZeroDeposit();
    error SYZeroRedeem();
    error SYInsufficientSharesOut(uint256 actualSharesOut, uint256 requiredSharesOut);
    error SYInsufficientTokenOut(uint256 actualTokenOut, uint256 requiredTokenOut);

    constructor(
        string memory _name,
        string memory _symbol,
        address initialOwner,
        address _yieldToken
     )
        ERC20(_name, _symbol) ERC20Permit(_name)
        Ownable(initialOwner)
    {
        yieldToken = _yieldToken;
    }

    receive() external payable {}

    function pause() external onlyOwner {
        _pause();
    }

    function unpause() external onlyOwner {
        _unpause();
    }

    function deposit(
        address receiver,
        address tokenIn,
        uint256 amountTokenToDeposit,
        uint256 minSharesOut
    ) external payable nonReentrant returns (uint256 amountSharesOut) {
        if (!isValidTokenIn(tokenIn)) revert SYInvalidTokenIn(tokenIn);
        if (amountTokenToDeposit == 0) revert SYZeroDeposit();

        _transferIn(tokenIn, msg.sender, amountTokenToDeposit);

        amountSharesOut = _deposit(tokenIn, amountTokenToDeposit);
        if (amountSharesOut < minSharesOut) revert SYInsufficientSharesOut(amountSharesOut, minSharesOut);

        _mint(receiver, amountSharesOut);
        emit Deposit(msg.sender, receiver, tokenIn, amountTokenToDeposit, amountSharesOut);
    }

    /**
     * @notice mint shares based on the deposited base tokens
     * @param tokenIn base token address used to mint shares
     * @param amountDeposited amount of base tokens deposited
     * @return amountSharesOut amount of shares minted
     */
    function _deposit(address tokenIn, uint256 amountDeposited) internal virtual returns (uint256 amountSharesOut);

    function isValidTokenIn(address token) public view virtual returns (bool);


}