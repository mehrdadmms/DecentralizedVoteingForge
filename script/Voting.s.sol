// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console2} from "forge-std/Script.sol";
import {Voting} from "../src/Voting.sol";

contract VotingScript is Script {
    function setUp() public {}

    function run() public {
        vm.startBroadcast();
        new Voting();
        vm.stopBroadcast();
    }
}