// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./IERC20.sol";

contract ERC20 is IERC20 {
    string private _name;
    string private _symbol;
    uint8 private _decimals = 18;

    uint256 private _totalSupply;
    mapping(address => uint256) public _balances;
    mapping(address => mapping(address => uint256)) public _allowances;

    constructor(string memory name_, string memory symbol_) {
        _name = name_;
        _symbol = symbol_;
    }

    function name() public view override returns (string memory) {
        return _name;
    }

    function symbol() public view override returns (string memory) {
        return _symbol;
    }

    function decimals() public view override returns (uint8) {
        return _decimals;
    }

    function totalSupply() public view override returns (uint256) {
        return _totalSupply;
    }

    function balanceOf(address _account) public view override returns(uint256) {
        return _balances[_account];
    }

    function transfer(address _to, uint256 _value) public override returns(bool) {
        _balances[msg.sender] -= _value;
        _balances[_to] += _value;
        return true;
    }

    function allowance(address _owner, address _spender) public view override returns (uint256) {
        return _allowances[_owner][_spender];
    }

    function approve(address _spender, uint256 _value) public override returns (bool) {
        _allowances[msg.sender][_spender] = _value;
        emit Approval(msg.sender, _spender, _value);
        return true;
    }

    function transferFrom(address _from, address _to, uint256 _value) public override returns (bool) {
        _allowances[_from][_to] -= _value;
        _balances[_from] -= _value;
        _balances[_to] += _value;
        emit Transfer(_from, _to, _value);
        return true;
    }

    function mint(address sender, uint256 _value) internal {
        _balances[sender] += _value;
        _totalSupply += _value;
        emit Transfer(address(0), sender, _value);
    }

    function burn(address sender, uint256 _value) internal {
        _balances[sender] -= _value;
        _totalSupply -= _value;
        emit Transfer(sender, address(0), _value);
    }
}