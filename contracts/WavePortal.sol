// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.17;

import "hardhat/console.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

contract WavePortal {
    struct LeaderboardData {
        address addr;
        uint256 noOfWaves;
    }

    mapping(address => uint256) leaderBoardIndex;
    LeaderboardData[] leaderBoard;
    uint256 totalWaves;

    constructor() {
        console.log("Yo, I am a contract and I am smart");
    }

    function wave() public {
        if (leaderBoardIndex[msg.sender] == 0) {
            initWaver(msg.sender);
        }

        addWave(msg.sender);
        console.log(
            "%s has waved %d times",
            msg.sender,
            getNoOfWaves(msg.sender)
        );
    }

    function getTotalWaves() public view returns (uint256) {
        console.log("We have %d total waves!", totalWaves);
        return totalWaves;
    }

    function getAllWavesData() public view returns (string memory) {
        bytes memory data = "[";

        for (uint256 i = 0; i < leaderBoard.length; i++) {
            if (i > 0) {
                data = bytes.concat(data, ",");
            }
            data = bytes.concat(data, '{"address":');
            data = bytes.concat(data, '"');
            data = bytes.concat(
                data,
                bytes(toAsciiString(leaderBoard[i].addr))
            );
            data = bytes.concat(data, '",');
            data = bytes.concat(data, '"waves":');
            data = bytes.concat(
                data,
                bytes(Strings.toString(leaderBoard[i].noOfWaves))
            );
            data = bytes.concat(data, "}");
        }

        data = bytes.concat(data, "]");

        return string(abi.encodePacked(data));
    }

    function initWaver(address addr) private {
        leaderBoardIndex[addr] = leaderBoard.length + 1;
        leaderBoard.push(LeaderboardData(addr, 0));
    }

    function getNoOfWaves(address addr) private view returns (uint256) {
        return leaderBoard[leaderBoardIndex[addr] - 1].noOfWaves;
    }

    function addWave(address addr) private {
        leaderBoard[leaderBoardIndex[addr] - 1].noOfWaves += 1;
        totalWaves += 1;
    }

    function removeLastByte(bytes memory b)
        internal
        pure
        returns (bytes memory)
    {
        delete b[b.length - 1];
        delete b[b.length - 1];
        return b;
    }

    function toAsciiString(address x) internal pure returns (string memory) {
        bytes memory s = new bytes(40);
        for (uint256 i = 0; i < 20; i++) {
            bytes1 b = bytes1(uint8(uint256(uint160(x)) / (2**(8 * (19 - i)))));
            bytes1 hi = bytes1(uint8(b) / 16);
            bytes1 lo = bytes1(uint8(b) - 16 * uint8(hi));
            s[2 * i] = char(hi);
            s[2 * i + 1] = char(lo);
        }
        return string(s);
    }

    function char(bytes1 b) internal pure returns (bytes1 c) {
        if (uint8(b) < 10) return bytes1(uint8(b) + 0x30);
        else return bytes1(uint8(b) + 0x57);
    }
}
