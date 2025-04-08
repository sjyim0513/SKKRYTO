// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract testContract {
    int256 public cnt;
    uint256 public num;
    address public ownerAddresssss;

    constructor(uint256 initValue) {
        num = initValue;
        cnt = 0;
        ownerAddresssss = msg.sender;
    }

    function getOwner() public view returns (address) {
        return ownerAddresssss;
    }

    function increaseCnt() public {
        cnt++;
    }

    function decreaseCnt() public {
        cnt--;
    }

    function getCnt() public view returns (int256) {
        return cnt;
    }

    function setNum(uint256 input) external {
        num = input;
    }

    function getNum() public view returns (uint256) {
        return num;
    }

    function add(int256 a, int256 b) public pure returns(int256) {
        return a + b;
    }

    function mul(int256 a, int256 b) public pure returns(int256) {
        return a * b;
    }

    function sumArrayMem(uint256[] memory data) public pure returns(uint256 sum) {
        for (uint256 i = 0; i < data.length; i++) {
            sum += data[i] * 2;
        }
    }

    function sumArrayCall(uint256[] calldata data) public pure returns(uint256 sum) {
        for (uint256 i = 0; i < data.length; i++) {
            sum += data[i];
        }
    }

    function sumNumAndCnt() public view returns(uint256) {
        return num * uint256(cnt);
    }
}