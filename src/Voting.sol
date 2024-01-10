// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "@openzeppelin/contracts/access/Ownable.sol";

contract Voting {
    address[] public candidates;
    mapping(address => address) public votes;
    mapping(address => uint256) public tally;

    function registerAsCandidate(address candidate) public {
        require(!isRegistered(candidate), "Already registered");
        candidates.push(candidate);
        tally[candidate] = 0;
    }

    function isRegistered(address candidate) internal view returns(bool) {
        for (uint256 i = 0; i < candidates.length; i++){
            if (candidates[i] == candidate){
                return true;
            }
        }
        return false;
    }

    function vote(address candidate) public {
        require(isRegistered(candidate), "Candidate not found");
        require(votes[msg.sender] == address(0), "Participant has voted before");
        votes[msg.sender] = candidate;
        tally[candidate] += 1;
    }

    function changeVote(address candidate) public{
        require(votes[msg.sender] != address(0), "Participant hadn't vote");
        tally[votes[msg.sender]] -= 1;
        votes[msg.sender] = candidate;
        tally[candidate] += 1;
    }

}
