// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/WaifuToken.sol";

contract WaifuTokenTest is Test {
    address public constant ADMIN_ADDR = address(1);

    WaifuToken public token;

    function setUp() public {
        vm.prank(ADMIN_ADDR);
        token = new WaifuToken();

    }

    function testUpdateEmotion() public {
        (,,uint8 old_emotion) = token.waifus(1);
        assertEq(old_emotion, 1);
        // non owner call the method
        vm.expectRevert('You do not own this Waifu');
        token.updateEmotion(1, 2);
        // owner call the method
        vm.prank(ADMIN_ADDR);
        token.updateEmotion(1, 2);
        
        (,,uint8 new_emotion) = token.waifus(1);
        assertEq(new_emotion, 2);
    }
}
