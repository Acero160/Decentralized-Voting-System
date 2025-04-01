// SPDX-License-Identifier:MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract Voting is Ownable {

    using SafeMath for uint256;

    //Structs
    struct Voter {
        address voter; //Address of the voter
        address delegate; //Address of the delegate
        uint vote; 
        bool voted; 
    }

    struct Proposal {
        bytes32 name; //Name of the proposal
        uint voteCount; //Number of votes
    }

    //Mappings
    mapping(address => Voter) public voters;


    //Events
    event VotingStarted(address indexed owner, uint256 _proposalCount);
    event VoteCasted (uint256 _proposalVoted, address indexed _voter);
    event DelegationSuccesfull(address indexed voter, address indexed delegate);
    
    //Arrays
    Proposal[] proposals;
    uint proposalCount; //Store the number of proposals
    uint256[] winningProposal; //Store the winning proposal

    //Modifiers
    modifier proposalExists(uint256 _proposalIndex) {
        require(_proposalIndex < proposalCount, "Voting System: Proposal index out of bounds");
        _;
    }

    modifier notYetVoted(address _voter) {
        require(!voters[_voter].voted, "Voting System: Voter has already voted");
        _;
    }
    

    constructor(string[] memory proposalNames, address[] memory voterAddress) {
        proposalCount = proposalNames.length;

        for(uint i = 0; i < proposalCount; i = i.add(1)){
            Proposal memory proposal = Proposal(stringToBytes32(proposalNames[i]), 0); //Create a new proposal
            proposals.push(proposal); //Add the proposal to the array
        }

        for(uint i= 0; i< voterAddress.length; i=i.add(1)) {
            Voter memory voter = Voter(voterAddress[i], address(0), 0, false); //Create a new voter
            voters[voterAddress[i]] = voter; //Add the voter to the mapping
        }


        emit VotingStarted(owner(), proposalCount);
    }



    //Functions
    function getProposal(uint256 _proposalIndex) public view proposalExists(_proposalIndex) returns (string memory _proposalName, uint256 _voteCount) {
        (_proposalName, _voteCount) = (bytes32ToString(proposals[_proposalIndex].name), proposals[_proposalIndex].voteCount);
    }

    function vote (address _voter, uint256 _proposalIndex) public proposalExists(_proposalIndex) notYetVoted(_voter) returns (bool) {
        Voter storage sender = voters[_voter];
        require (msg.sender == _voter || msg.sender == sender.delegate, "Voting system: This address does not have right to vote");
        

        sender.vote = _proposalIndex; //Store the proposal index
        proposals[_proposalIndex].voteCount = (proposals[_proposalIndex].voteCount).add(1); //Increment the vote count of the proposal
        sender.voted = true; 


        emit VoteCasted(_proposalIndex, _voter);
        return true;
    }

    //Function to delegate the vote
    function delegate(address _to) external notYetVoted(msg.sender)  {
        require (_to != msg.sender, "Voting System: Delegate cannot be the sender");
        Voter storage sender = voters[msg.sender];
        require (sender.voter != address(0), "Voting System: Voter does not exist");


        sender.delegate = _to; //Store the address of the delegate
        emit DelegationSuccesfull(msg.sender, _to);
    }

    function computeWinners() external onlyOwner {
        delete winningProposal;
        uint256 winningVoteCount = 0;
        uint256 winner = 0;

        for (uint256 i = 0; i<proposals.length; i=i.add(1)) {
            if (proposals[i].voteCount > winningVoteCount) {
                winningVoteCount = proposals[i].voteCount;
                winner = i;
            }
        }

        winningProposal.push(winner);

        for (uint256 i = 0; i<proposals.length; i=i.add(1)) {
            if (proposals[i].voteCount == proposals[winner].voteCount && i!= winner) {
                winningProposal.push(i);
            }
        }
    }

    function getWinningProposals() external view returns (uint256[] memory) {
        return winningProposal;
    }




    // Function to convert bytes32 to string
    function stringToBytes32(string memory str) internal pure returns (bytes32) {  
        return bytes32(abi.encodePacked(str));
    }

    // Function to convert bytes32 to string
    function bytes32ToString(bytes32 byt) internal pure returns (string memory) {
        return string(abi.encodePacked(byt));
    }

}