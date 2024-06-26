// SPDX-License-Identifier: MIT
// Copyright 2024 Uncommon Digital Srl
// Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the “Software”), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

// The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

// THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.


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