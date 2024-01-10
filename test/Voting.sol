// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console2} from "forge-std/Test.sol";
import {Voting} from "../src/Voting.sol";

contract VotingTest is Test {

    Voting votingContract;

    function setUp() public {
        votingContract = new Voting();
    }

    function testRegisterAsCandidateSuccessfully() public{
        address candidate = address(0x1);
        votingContract.registerAsCandidate(candidate);
        assertEq(votingContract.tally(candidate), 0);
        assertEq(votingContract.candidates(0), candidate);
    }

    function testCandidateRegisteredAlready() public {
        address candidate1 = address(0x1);
        address candidate2 = address(0x2);
        address candidate3 = address(0x3);
        address candidate4 = address(0x4);
        address candidate5 = address(0x5);
        votingContract.registerAsCandidate(candidate1);
        votingContract.registerAsCandidate(candidate2);
        votingContract.registerAsCandidate(candidate3);
        votingContract.registerAsCandidate(candidate4);
        votingContract.registerAsCandidate(candidate5);
        vm.expectRevert("Already registered");
        votingContract.registerAsCandidate(candidate4);
    }

    function testVoteToACandidateThatHasNotRegistered() public {
        address candidate = address(0x1);
        vm.expectRevert("Candidate not found");
        votingContract.vote(candidate);
    }

    function testVotingSuccessfully() public {
        address candidate = address(0x1);
        votingContract.registerAsCandidate(candidate);
        votingContract.vote(candidate);
        assertEq(votingContract.tally(candidate), 1);
    }

    function testReparticipation() public {
        address candidate = address(0x1);
        votingContract.registerAsCandidate(candidate);
        votingContract.vote(candidate);
        vm.expectRevert("Participant has voted before");
        votingContract.vote(candidate);
    }

    function testChangingVoteWithoutVotingFirst() public {
        address candidate = address(0x1);
        vm.expectRevert("Participant hadn't vote");
        votingContract.changeVote(candidate);
    }

    function testChangingVote() public {
        address candidate = address(0x1);
        address candidate2 = address(0x2);
        votingContract.registerAsCandidate(candidate);
        votingContract.vote(candidate);
        votingContract.changeVote(candidate2);
        assertEq(votingContract.tally(candidate), 0);
        assertEq(votingContract.tally(candidate2), 1);
    }
}
