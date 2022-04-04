//SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;



contract SafeMath {
    function safeAdd(uint a, uint b) public pure returns (uint c) {
        c = a + b;
        require(c >= a);
    }
    function safeSub(uint a, uint b) public pure returns (uint c) {
        require(b <= a); c = a - b; } 
        
        function safeMul(uint a, uint b) public pure returns (uint c) { c = a * b; require(a == 0 || c / a == b); } function safeDiv(uint a, uint b) public pure returns (uint c) { require(b > 0);
        c = a / b;
    }
    function Safemul (uint256 a, uint256 b) internal pure returns (uint256)
    {
        if (a==0)
        {
            return 0;
        }

        uint256 c = a * b;
        require (c/a == b);
        return c;
    }
}