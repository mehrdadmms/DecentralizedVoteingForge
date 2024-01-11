// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import { Test, console2 } from "forge-std/Test.sol";
import { Voting } from "../src/Voting.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract VotingTest is Test {
    Voting votingContract;
    address[] uniqueCandidates;

    function setUp() public {
        votingContract = new Voting();
    }

    function testRegisterAsCandidateSuccessfully(address candidate) public {
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

    function testVoteToACandidateThatHasNotRegistered(address candidate) public {
        vm.expectRevert("Candidate not found");
        votingContract.vote(candidate);
    }

    function testVotingSuccessfully(address candidate) public {
        votingContract.registerAsCandidate(candidate);
        votingContract.vote(candidate);
        assertEq(votingContract.tally(candidate), 1);
        assertEq(votingContract.getParticipants(0), address(this));
    }

    function testFuzzVotingSuccessfully(address[] memory candidates, address[] memory participants) public {
        if (candidates.length == 0) return;
        for (uint256 i = 0; i < candidates.length; i++) {
            // might have duplicates, which we ignore the revert
            try votingContract.registerAsCandidate(candidates[i]) {
                uniqueCandidates.push(candidates[i]);
            } catch {}
        }
        uint256 numberOfUniqueParticipants = 0;
        for (uint256 i = 0; i < participants.length; i++) {
            vm.startPrank(participants[i]);
            try votingContract.vote(candidates[i % candidates.length]) {
                numberOfUniqueParticipants++;
            } catch {}
        }
        uint totalVotes = 0;
        for (uint256 i = 0; i < uniqueCandidates.length; i++) {
            totalVotes += votingContract.tally(uniqueCandidates[i]);
        }
        assertEq(totalVotes, numberOfUniqueParticipants);
        // vm.startPrank(address(this)); // owner
        // assertEq(votingContract.getParticipantsLength(), numberOfUniqueParticipants);
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

    function testNonOwnerGetParticipants() public {
        address nonOwner = address(0x1);
        vm.startPrank(nonOwner);
        vm.expectRevert();
        votingContract.getParticipants(0);
    }

    function testNonOwnerGetParticipantsLength() public {
        address nonOwner = address(0x1);
        vm.startPrank(nonOwner);
        vm.expectRevert();
        votingContract.getParticipantsLength();
    }

    function testOwnerGetParticipantsLength() public {
        assertEq(votingContract.getParticipantsLength(), 0);
    }

    function testOracleCallForCheckingIsVotingInProgressReturnsTrue() public {
        assertTrue(votingContract.oracleCallForCheckingIsVotingInProgress());
    }

    function testMockingOracleCallForCheckingIsVotingInProgresswithFFI() public {
        string[] memory inputs = new string[](2);
        inputs[0] = "node";
        inputs[1] = "oracle.js";
        bytes memory oracleResponse = vm.ffi(inputs);
        bool result = !(keccak256(abi.encodePacked("false")) == keccak256(oracleResponse));
        vm.mockCall(
            address(votingContract),
            abi.encodeWithSelector(votingContract.oracleCallForCheckingIsVotingInProgress.selector),
            abi.encode(result)
        );
        assertFalse(votingContract.oracleCallForCheckingIsVotingInProgress());
        // vm.expectRevert("Voting is not in progress");
        // votingContract.vote(candidate);
    }
}
