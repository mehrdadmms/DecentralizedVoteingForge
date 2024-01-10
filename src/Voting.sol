// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "@openzeppelin/contracts/access/Ownable.sol";

contract Voting is Ownable{
    address[] public candidates;
    mapping(address => address) public votes;
    address[] private participants;
    mapping(address => uint256) public tally;

    constructor() Ownable(msg.sender) {}

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
        participants.push(msg.sender);
    }

    function changeVote(address candidate) public{
        require(votes[msg.sender] != address(0), "Participant hadn't vote");
        tally[votes[msg.sender]] -= 1;
        votes[msg.sender] = candidate;
        tally[candidate] += 1;
    }

    function getParticipants(uint256 index) public view onlyOwner returns(address) {
        return participants[index];
    }

    function getParticipantsLength() public view onlyOwner returns(uint256) {
        return participants.length;
    }

}
