// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.0;

/*
   ___          _ _                 
  / _ \___   __| (_)_   _ _ __ ___  
 / /_)/ _ \ / _` | | | | | '_ ` _ \ 
/ ___/ (_) | (_| | | |_| | | | | | |
\/    \___/ \__,_|_|\__,_|_| |_| |_|

                                v1.0
*/

contract PodiumContract {
    struct Voter {
        bool voteSpent; // if true, that person already used their vote
        uint256 voteIndex; // index of the proposal that was voted for
    }

    struct VoteProposal {
        string proposalName;
        uint256 voteYesCount;
        uint256 voteNoCount;
    }

    mapping(address => Voter) public voters;

    // Vote proposal
    VoteProposal[] public proposals;

    // Contract creator address
    address creator;

    // Minimum and maximum length of profile username
    uint256 usernameMinLength;
    uint256 usernameMaxLength;

    // Banned profiles
    string[] bannedProfiles;

    function createVoting(string memory title) public {
        proposals.push(VoteProposal(title, 0, 0));
    }

    function voteIndex(uint256 proposal) public {
        Voter storage sender = voters[msg.sender];
        require(!sender.voteSpent);
        sender.voteSpent = true;
        sender.voteIndex = proposal;

        // If 'proposal' is out of the range of the array,
        // this will throw automatically and revert all
        // changes.
        proposals[proposal].voteYesCount += 1;
    }

    function getVotingStatus(uint256 proposal)
        public
        view
        returns (VoteProposal memory)
    {
        return proposals[proposal];
    }

    function setUsernameMinLength(uint256 length) public onlyOwner {
        usernameMinLength = length;
    }

    function getUsernameMinimumLength() public view returns (uint256) {
        return usernameMinLength;
    }

    function setUsernameMaxLength(uint256 length) public onlyOwner {
        usernameMaxLength = length;
    }

    function getUsernameMaxLength() public view returns (uint256) {
        return usernameMaxLength;
    }

    function banProfile(string memory id) public onlyOwner {
        bannedProfiles.push(id);
    }

    function getBannedProfiles() public view returns (string[] memory) {
        return bannedProfiles;
    }

    function store() public onlyOwner {
        usernameMinLength = 3;
        usernameMaxLength = 24;
    }

    // Modifier to check that the caller is the owner of the contract.
    modifier onlyOwner() {
        require(msg.sender == creator, "Not owner");
        _;
    }
}
