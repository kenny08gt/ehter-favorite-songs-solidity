// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

import "hardhat/console.sol";

contract EtherFavoriteSongs {
    uint256 counter;
    uint256 private seed;

    mapping(address => string) public songsToContributor;
    mapping(address => uint256) contributorSongsCount;
    mapping(address => uint256) public lastContributionAt;

    event NewSong(address indexed from, uint256 timestamp, string url);

    struct Song {
        address contributor; // The address of the user who waved.
        string url; // The message the user sent.
        uint256 timestamp; // The timestamp when the user waved.
    }

    Song[] songs;

    constructor() payable {
        console.log("Smart contract here, move out");
        seed = (block.timestamp + block.difficulty) % 100;
    }

    function addSong(string memory url) public {
        //        require(songs[url]);
        require(
            lastContributionAt[msg.sender] + 1 minutes < block.timestamp,
            "Wait 1m"
        );

        lastContributionAt[msg.sender] = block.timestamp;

        counter += 1;
        // songsToContributor[msg.sender] = url;
        contributorSongsCount[msg.sender]++;
        songs.push(Song(msg.sender, url, block.timestamp));

        seed = (block.difficulty + block.timestamp + seed) % 100;

        console.log("%s added the %s song!", msg.sender, url);

        if (seed <= 50) {
            console.log("%s won!", msg.sender);
            uint256 prizeAmount = 0.0001 ether;
            require(
                prizeAmount <= address(this).balance,
                "Trying to withdraw more money than the contract has."
            );
            (bool success, ) = (msg.sender).call{value: prizeAmount}("");
            require(success, "Failed to withdraw money from contract.");
            console.log("all good in sent eth");
        }

        emit NewSong(msg.sender, block.timestamp, url);
    }

    function getAllSongs() public view returns (Song[] memory) {
        return songs;
    }

    function getSongsByUser() public view returns (uint256) {
        return contributorSongsCount[msg.sender];
    }

    function getTotalSongs() public view returns (uint256) {
        console.log("We have %d total songs!", counter);
        return counter;
    }
}
