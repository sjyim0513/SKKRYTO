// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

interface Itest {
    function getCount() external view returns (uint256);
    function increment() external;
    function setAddress(address) external;
    function getAddress() external view returns (address);
}

contract testInterface is Itest {
    uint256 private count;
    address private add;

    constructor() {
        count = 0;
    }

    function increment() external override {
        count += 1;
    }

    function getCount() external view override returns (uint256) {
        return count;
    }

    function setAddress(address _add) external override{
        add = _add;
    }

    function getAddress() external view override returns (address) {
        return add;
    }
}

contract testContract_0408 {
    uint256 public cnt;
    bool public isActive;
    Itest public inter;
    
    constructor(address _counterAddress) {
        inter = Itest(_counterAddress);
        cnt = 0;
    }

    event Check_isActive_Called(address indexed caller, bool isActive, uint256 timestamp);

    modifier check_isActive() {
        require(isActive, "Available only when isActive is true");
        _;
        emit Check_isActive_Called(msg.sender, isActive, block.timestamp);
    }

    //interface
    function increase_Itest() public {
        inter.increment();
    }

    function getCnt_Itest() public view returns (uint256) {
        return inter.getCount();
    }

    function setAdd_Itest(address _add) public {
        inter.setAddress(_add);
    }

    function getAdd_Itest() public view returns (address) {
        return inter.getAddress();
    }

    function increaseCnt_asset() public check_isActive {
        cnt++;
        assert(cnt < 0);
    }

    function increaseCnt() public check_isActive {
        cnt++;
    }
    
    function isActivate_require() public view returns (string memory) {
        require(isActive, "isActive is false");
        return "isActive is true";
    }

    function isActivate_revert() public view returns (string memory){
        if(!isActive) {
            revert("isActive is false");
        }
        return "isActive is true";
    }

    function toggle_isActive() public {
        isActive = !isActive;
    }
}