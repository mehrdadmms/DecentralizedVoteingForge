// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "@openzeppelin/contracts/access/Ownable.sol";

/**
 * @title Voting
 * @dev A simple voting contract that allows participants to vote for candidates.
 * Participants can register as candidates and/or vote for their preferred candidates.
 * The contract owner can monitor and control the voting process.
 */
contract Voting is Ownable {
    address[] public candidates;             // List of candidate addresses
    mapping(address => address) public votes; // Mapping of participant addresses to their voted candidates
    address[] private participants;          // List of participants who have voted
    mapping(address => uint256) public tally; // Tally of votes for each candidate

    /**
     * @dev Constructor initializes the contract and sets the owner to the deploying address.
     */
    constructor() Ownable(msg.sender) {}

    /**
     * @dev Register as a candidate.
     * @param candidate The address of the candidate to register.
     */
    function registerAsCandidate(address candidate) public {
        require(!isRegistered(candidate), "Already registered");
        candidates.push(candidate);
        tally[candidate] = 0;
    }

    /**
     * @dev Check if an address is registered as a candidate.
     * @param candidate The address of the candidate to check.
     * @return true if the candidate is registered, false otherwise.
     */
    function isRegistered(address candidate) internal view returns(bool) {
        for (uint256 i = 0; i < candidates.length; i++){
            if (candidates[i] == candidate){
                return true;
            }
        }
        return false;
    }

    /**
     * @dev Simulate an external oracle call to check if voting is in progress.
     * @return true if voting is in progress, false otherwise.
     */
    function oracleCallForCheckingIsVotingInProgress() public pure returns(bool) {
        // For simplicity, this function always returns true.
        // In a real implementation, it would perform an external call.
        return true;
    }

    /**
     * @dev Vote for a candidate.
     * @param candidate The address of the candidate to vote for.
     */
    function vote(address candidate) public {
        require(oracleCallForCheckingIsVotingInProgress() == true, "Voting is not in progress");
        require(isRegistered(candidate), "Candidate not found");
        require(votes[msg.sender] == address(0), "Participant has voted before");
        votes[msg.sender] = candidate;
        tally[candidate] += 1;
        participants.push(msg.sender);
    }

    /**
     * @dev Change a participant's vote to a different candidate.
     * @param candidate The new candidate to vote for.
     */
    function changeVote(address candidate) public {
        require(votes[msg.sender] != address(0), "Participant hadn't voted");
        tally[votes[msg.sender]] -= 1;
        votes[msg.sender] = candidate;
        tally[candidate] += 1;
    }

    /**
     * @dev Get a participant's address by index.
     * @param index The index of the participant to retrieve.
     * @return The address of the participant.
     */
    function getParticipants(uint256 index) public view onlyOwner returns(address) {
        return participants[index];
    }

    /**
     * @dev Get the total number of participants.
     * @return The total number of participants.
     */
    function getParticipantsLength() public view onlyOwner returns(uint256) {
        return participants.length;
    }

    /**
     * @dev Check the total votes invariant.
     * @return true if the total number of participants matches the total votes counted.
     */
    function totalVotesInvariant() public view returns (bool) {
        uint256 totalVotes = 0;
        for (uint256 i = 0; i < candidates.length; i++){
            totalVotes += tally[candidates[i]];
        }
        return participants.length == totalVotes;
    }
}
