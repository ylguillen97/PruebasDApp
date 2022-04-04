//SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;


import "./IERC20.sol";
import "./SafeMath.sol";

contract ERC20 is IERC20, SafeMath {
    string public name;
    string public symbol;
    uint8 public decimals; // 18 decimals is the strongly suggested default

    uint256 public _totalSupply;

    mapping(address => uint) balances;
    mapping(address => mapping(address => uint)) allowed;

    /**
     * Constructor function
     */
    constructor()  {
        name = "UNIRTOKEN";
        symbol = "UNTK";
        decimals = 18;
        _totalSupply = 100000000000000000000000;

        balances[msg.sender] = _totalSupply;
        emit Transfer(address(0), address(this), _totalSupply);
    }

    function totalSupply() public view returns (uint) {
        return _totalSupply  - balances[address(0)];
    }

    function balanceOf(address _owner) public view returns (uint balance) {
        return balances[_owner];
    }

    function allowance(address _owner, address _spender) public view returns (uint remaining) {
        return allowed[_owner][_spender];
    }

    function approve(address _spender, uint tokens) public returns (bool success) {
        allowed[msg.sender][_spender] = tokens;
		emit Approval(msg.sender, _spender, tokens);
        return true;
    }

    function transfer(address to, uint tokens) public returns (bool success) {
        require(balances[msg.sender] >= tokens && tokens > 0);
	    balances[msg.sender] = safeSub(balances[msg.sender], tokens);
	    balances[to] = safeAdd(balances[to], tokens);
	    emit Transfer(msg.sender, to, tokens);       
        return true; 
    }

    function transferFrom(address _from, address _to, uint _amount) public returns (bool success) {
        require(_to != address(0));
        require(allowed[msg.sender][_from]>=_amount);
        require(balances[_from]>=_amount && _amount>0);
        balances[_from]-=_amount;
        balances[_to]+=_amount;
        return true;
    }

}
