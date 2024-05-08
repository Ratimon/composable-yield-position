//SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import {IStandardizedYield} from "@main/interfaces/IStandardizedYield.sol";
import {IGuaranteedYieldToken} from "@main/interfaces/IGuaranteedYieldToken.sol";

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {Initializable} from "@openzeppelin-upgradable/contracts/proxy/utils/Initializable.sol";

import {Math } from "@main/libraries/math/Math.sol";

import {InterestManagerSpilt} from "@main/InterestManagerSpilt.sol";


// contract GuaranteedYieldToken is ERC20, Initializable, IGuaranteedYieldToken, InterestManagerSpilt {
contract GuaranteedYieldToken is ERC20, Initializable, IGuaranteedYieldToken {


    using Math for uint256;

    address public immutable SY;
    address public VT;

    bool public immutable doCacheIndexSameBlock;


    uint128 public grossIndexLastUpdatedBlock;
    uint128 internal _grossIndexStored;

    uint128 public revenueIndexLastUpdatedBlock;
    uint128 internal _revenueIndexStored;

    // to do : Adding states to dermine the guaruntee rate each moonth
    // -- TWAP Oracle (hook to snapshot)

     //  fees from interest/rewards in GT / VT contract? how to allocate

    //  runaway

    // dependncy : volatillity oracle (core trading pair like ETH: usd ) of fee per time window,
    // differ in implied yield vs actual yield
    // differ in averaged yield vs actual yield (ei. actual > average => positive buffer funding )
    //   differ in 2- months averaged yield vs 3months


    // if pepole long GT (short VT), reduce the average time window (or reduce guranteed rate / allocate less to buffering fund)
    // dynaic AMM high fee (pair of ST: GT) when inplied yield is much lower than the actual and the tick is moving downward in undesired direction / allocate more to buffering fund
   


    // if pepole short GT (long VT), increase the average time window (or increased guranteed rate /or allocate more to buffering fund) -> draining?
    // dynaic AMM high fee (pair of ST: GT)  when inplied yield is much grater than the actual and the tick is moving upward in undesired direction / allocate more to buffering fund

    // (?? or we assume that the positive difference is nt that bad (airdrop farming) allocate more to VT )




    // MAin objectve : high availabillity  low slippage 



    modifier onlyVT() {
        if (msg.sender != VT) revert OnlyVT();
        _;
    }

    //TO DO customized decimal
    constructor(
        address _SY,
        string memory _name,
        string memory _symbol,
        bool _doCacheIndexSameBlock
    ) ERC20(_name, _symbol) {
        SY = _SY;
        doCacheIndexSameBlock = _doCacheIndexSameBlock;
    }

    /**
     * @dev only callable by the factory ?
     */
    function initialize(address _YT) external initializer {
    }

    /**
     * @dev only callable by the VT correspond to this GT (PT + guarunteedYT)
     */
    function burnByVT(address user, uint256 amount) external onlyVT {
        _burn(user, amount);
    }

    /**
     * @dev only callable by the VT correspond to this GT (PT + guarunteedYT)
     */
    function mintByVT(address user, uint256 amount) external onlyVT {
        _mint(user, amount);
    }

    /*///////////////////////////////////////////////////////////////
                               INTEREST-RELATED
    //////////////////////////////////////////////////////////////*/

    /**
     * @dev call to update 
     */
    function _grossIndexCurrent() internal returns (uint256 currentIndex) {

        if (doCacheIndexSameBlock && grossIndexLastUpdatedBlock == block.number) return _grossIndexStored;

        // if duration pass raise by constant rate
        uint128 index128 = Math.max(IStandardizedYield(SY).exchangeRate(), _grossIndexStored).Uint128();

        currentIndex = index128;
        _grossIndexStored = index128;
        grossIndexLastUpdatedBlock = uint128(block.number);

    }

    /**
     * @dev call to update / must have to used later whencalculate rewardShareUser
     * @dev  based on volatality oracle in some period of time (goal to avearage the return or gurantee in some range)
     */
    function _revenueIndexCurrent() internal returns (uint256 currentIndex) {
        if (doCacheIndexSameBlock && revenueIndexLastUpdatedBlock == block.number) return _revenueIndexStored;

        // already right 
        uint128 index128 = Math.max(IStandardizedYield(SY).exchangeRate(), _revenueIndexStored).Uint128();

        currentIndex = index128;
        _revenueIndexStored = index128;
        revenueIndexLastUpdatedBlock = uint128(block.number);
    }

    // function _getGlobalGrossIndex() internal view virtual override returns (uint256) {
    //     return _grossIndexStored;
    // }

    // function _getGlobalRevenuelIndex() internal view virtual override returns (uint256) {
    //     return _revenueIndexStored;
    // }

}

