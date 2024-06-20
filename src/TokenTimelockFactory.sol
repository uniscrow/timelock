// SPDX-License-Identifier: MIT
// OpenZeppelin Contracts (last updated v4.9.0) (token/ERC20/utils/TokenTimelock.sol)

pragma solidity ^0.8.0;


import "./TokenTimelock.sol";

/**
 * @dev A token holder contract that will allow a beneficiary to extract the
 * tokens after a given release time.
 *
 * Useful for simple vesting schedules like "advisors get all of their tokens
 * after 1 year".
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