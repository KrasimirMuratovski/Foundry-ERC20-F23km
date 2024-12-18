// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Test} from "forge-std/Test.sol";
import {DeployOurToken} from "../script/DeployOurToken.s.sol";
import {OurToken} from "../src/OurToken.sol";


contract OurTokenTest is Test{
    OurToken public ourToken;
    DeployOurToken public deployer;

    address bob = makeAddr("bob");
    address alice = makeAddr("alice");
    address public carol = address(0x3);


    uint256 public constant STARTING_BALANCE = 100 ether;

    function setUp() public{
        deployer = new DeployOurToken();
        ourToken = deployer.run();

        vm.prank(msg.sender);
        ourToken.transfer(bob, STARTING_BALANCE);
    }

    function testBobBalance() public{
        // ERC20 comes with standart functions(ourToken.****) https://docs.openzeppelin.com/contracts/2.x/api/token/erc20#ERC20Detailed
        assertEq(STARTING_BALANCE, ourToken.balanceOf(bob));
    }

function testAllowancesWorks() public{
    // ERC20 have function transferFrom - 
    uint256 initialAllowance = 1000;

    vm.prank(bob);
    ourToken.approve(alice, initialAllowance);

    uint256 transferAmount = 500;

    vm.prank(alice);
    ourToken.transferFrom(bob, alice, transferAmount);
    // below  with "transfer" whoever is calling is set to from
    // ourToken.transfer(alice, transferAmount);

    assertEq(ourToken.balanceOf(alice), transferAmount);
    assertEq(ourToken.balanceOf(bob), STARTING_BALANCE - transferAmount);

}

 /// @dev Test transfers within allowance
    // function testTransferFromWithinAllowance() public {
    //     vm.startPrank(alice);
    //     ourToken.approve(bob, 500 ether);
    //     vm.stopPrank();

    //     vm.startPrank(bob);
    //     ourToken.transferFrom(alice, carol, 400 ether);
    //     vm.stopPrank();

    //     // Verify balances
    //     assertEq(ourToken.balanceOf(carol), 400 ether);
    //     assertEq(ourToken.balanceOf(alice), 600 ether); // 1000 - 400
    //     assertEq(ourToken.allowance(alice, bob), 100 ether); // 500 - 400
    // }


    function testTransfer() public{
        uint256 amount = 1000;
        address receiver = address(0x1);
        vm.prank(msg.sender);

        ourToken.transfer(receiver, amount);
        assertEq(ourToken.balanceOf(receiver), amount);
    }

    function testBalanceAfterTransfer() public{
        uint256 amount = 1000;
        address receiver = address(0x1);
        uint256 initialBalance = ourToken.balanceOf(msg.sender);
        vm.prank(msg.sender);
        ourToken.transfer(receiver, amount);
        assertEq(ourToken.balanceOf(msg.sender), initialBalance - amount);
    }
    function testTransferFrom() public{
        uint256 amount = 1000;
        address receiver = address(0x1);
        vm.prank(msg.sender);
        ourToken.approve(address(this), amount);
        ourToken.transferFrom(msg.sender,receiver, amount);
        assertEq(ourToken.balanceOf(receiver), amount);
    }

}