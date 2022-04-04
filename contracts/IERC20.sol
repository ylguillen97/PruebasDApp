//SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

// ----------------------------------------------------------------------------
// ERC Token Standard #20 Interface
//
// ----------------------------------------------------------------------------
interface IERC20 {
    function totalSupply() external view returns (uint);
    function balanceOf(address _owner) external view returns (uint balance);
    function allowance(address _owner, address _spender) external view returns (uint remaining);
    function transfer(address to, uint tokens) external returns (bool success);
    function approve(address _spender, uint tokens) external returns (bool success);
    function transferFrom(address _from, address _to, uint tokens) external returns (bool success);

    event Transfer(address indexed from, address indexed to, uint tokens);
    event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
}
