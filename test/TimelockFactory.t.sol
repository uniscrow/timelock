// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "../src/TokenTimelockFactory.sol";
import "../src/TokenTimelock.sol";
import "openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";
import "openzeppelin-contracts/contracts/token/ERC20/utils/SafeERC20.sol";

contract ERC20Mock is ERC20 {
    constructor() ERC20("MockToken", "MKT") {
        _mint(msg.sender, 1000000 * 10**18);
    }
}

contract TokenTimelockFactoryTest is Test {
    TokenTimelockFactory public factory;
    ERC20Mock public token;

    address public beneficiary = address(0x123);
    uint256 public releaseTime = block.timestamp + 365 days;

    event TimelockCreated(address indexed timelockAddress);

    function setUp() public {
        token = new ERC20Mock();
        factory = new TokenTimelockFactory();
    }

    function testCreateNewTokenTimelock() public {
        vm.prank(address(this));
        
        factory.createNewTokenTimelock(address(token), beneficiary, releaseTime);
        // Check that the TimelockCreated event was emitted with the correct address

        

        // Check that the new TokenTimelock address is stored in deployedTimelocks array
        address[] memory deployedTimelocks = factory.getDeployedTimelocks();
        assertEq(deployedTimelocks.length, 1);
        assertEq(deployedTimelocks[0], address(factory.deployedTimelocks(0)));
    }

    function testTokenTimelockDetails() public {
        factory.createNewTokenTimelock(address(token), beneficiary, releaseTime);

        // Get the address of the newly created TokenTimelock
        address timelockAddress = factory.deployedTimelocks(0);

        // Check the details of the TokenTimelock
        TokenTimelock timelock = TokenTimelock(timelockAddress);
        assertEq(address(timelock.token()), address(token));
        assertEq(timelock.beneficiary(), beneficiary);
        assertEq(timelock.releaseTime(), releaseTime);
    }

    function testTokenRelease() public {
        factory.createNewTokenTimelock(address(token), beneficiary, releaseTime);

        // Get the address of the newly created TokenTimelock
        address timelockAddress = factory.deployedTimelocks(0);

        // Transfer tokens to the timelock contract
        uint256 amount = 1000 * 10**18;
        token.transfer(timelockAddress, amount);

        // Fast forward time to the release time
        vm.warp(releaseTime + 1);

        // Release the tokens after the release time
        TokenTimelock(timelockAddress).release();

        // Check the beneficiary's balance
        assertEq(token.balanceOf(beneficiary), amount);
    }


    function testTokenReleaseTooEarly() public {
        factory.createNewTokenTimelock(address(token), beneficiary, releaseTime);

        // Get the address of the newly created TokenTimelock
        address timelockAddress = factory.deployedTimelocks(0);

        // Transfer tokens to the timelock contract
        uint256 amount = 1000 * 10**18;
        token.transfer(timelockAddress, amount);

        // Try to release the tokens before the release time
        vm.expectRevert("TokenTimelock: current time is before release time");
        TokenTimelock(timelockAddress).release();
    }
}
