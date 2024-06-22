// SPDX-License-Identifier: MIT


pragma solidity ^0.8.0;


import "./TokenTimelock.sol";

/**
 * @dev A factory to create TokenTimelock(s)
 */
contract TokenTimelockFactory {
    using SafeERC20 for IERC20;
    
    address[] public deployedTimelocks;

    event TimelockCreated(address indexed timelockAddress);

    function createNewTokenTimelock( address token_, address beneficiary_, uint256 releaseTime_) public {
        TokenTimelock tl = new TokenTimelock(IERC20(token_), beneficiary_, releaseTime_ );
        deployedTimelocks.push(address(tl));
        emit TimelockCreated(address(tl));
    }

    function getDeployedTimelocks() public view returns (address[] memory){
        return deployedTimelocks;
    }

}