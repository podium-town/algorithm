// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.0;

/*
   ___          _ _                 
  / _ \___   __| (_)_   _ _ __ ___  
 / /_)/ _ \ / _` | | | | | '_ ` _ \ 
/ ___/ (_) | (_| | | |_| | | | | | |
\/    \___/ \__,_|_|\__,_|_| |_| |_|
                                     
*/

contract PodiumContract {

    struct StoryStruct {
        uint index;
        address owner;
        string text;
        string[] images;
        uint256 timestamp;
    }

    struct UserStruct {
        uint index;
        address userAddress;
        string username;
        string avatar;
        address[] following;
        string bio;
    }

    struct PostsStruct {
        StoryStruct[] post;
        UserStruct profile;
    }
  
    mapping(address => UserStruct) private userStructs;
    mapping(string => UserStruct) private usernames;
    mapping(address => StoryStruct[]) private stories;
    
    address[] private userIndex;
    StoryStruct[] private storyIndex;

    function store(address adminAddress) public {
        address[] memory emptyFollowing;
        UserStruct memory adminUser = UserStruct(1, adminAddress, 'admin', '', emptyFollowing, '');
        userStructs[adminAddress] = adminUser;
        usernames['admin'] = adminUser;
        userIndex.push(adminAddress);
    }
    
    function isUser(address userAddress) public view returns(bool isIndeed) {
        return userStructs[userAddress].index > 0;
    }
    
    function getIndexByUsername(string memory username) public view returns(uint index) {
        require(userIndex.length != 0);
        return usernames[username].index;
    }
    
    function getUserByUsername(string memory username) public view returns(UserStruct memory user) {
        require(userIndex.length != 0);
        return usernames[username];
    }

    function getUsernameByAddress(address userAddress) public view returns(string memory username) {
        require(userIndex.length != 0);
        return userStructs[userAddress].username;
    }
    
    function getUser(address userAddress) public view returns(UserStruct memory userStruct) {
        return userStructs[userAddress];
    }

    function addStory(string memory text, string[] memory images, uint256 timestamp) public returns(uint index) {
        bytes memory bytesText = bytes(text);
        require(bytesText.length != 0);
        uint idx = storyIndex.length + 1;
        StoryStruct memory story = StoryStruct(idx, msg.sender, text, images, timestamp);
        storyIndex.push(story);
        stories[msg.sender].push(story);
        return idx;
    }

    function updateProfile(string memory username, string memory avatar, address[] memory following, string memory bio) public returns(bool index) {
        require(!isUsernameTaken(username));
        if(!isUser(msg.sender)) {
            userIndex.push(msg.sender);
        }

        string memory oldUsername = userStructs[msg.sender].username;
        UserStruct memory user = UserStruct(userIndex.length, msg.sender, username, avatar, following, bio);
        userStructs[msg.sender] = user;
        delete usernames[oldUsername];
        usernames[username] = user;

        return true;
    }

    function getProfiles() public view returns(UserStruct[] memory profiles) {
        UserStruct[] memory users = new UserStruct[](userIndex.length);
        for (uint i=0; i<userIndex.length; i++) {
            users[i] = userStructs[userIndex[i]];
        }
        return users;
    }

    function getStories(address[] memory following) public view returns(PostsStruct[] memory resultStories) {
        PostsStruct[] memory data = new PostsStruct[](storyIndex.length+1);
        for (uint i=0; i<following.length; i++) {
            StoryStruct[] memory story = stories[following[i]];
            UserStruct memory user = userStructs[following[i]];
            data[i] = PostsStruct(story, user);
        }
        return data;
    }

    function getStoriesForAddress(address userAddress) public view returns(UserStruct memory profile, StoryStruct[] memory userStories) {
        return (userStructs[userAddress], stories[userAddress]);
    }
    
    function isUsernameTaken(string memory username) public view returns(bool isTaken) {
        return msg.sender != usernames[username].userAddress && usernames[username].index > 0;
    }
}