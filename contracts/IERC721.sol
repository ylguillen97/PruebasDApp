//SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

import "./IERC165.sol";

interface IERC721 is IERC165 {
    
    event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
    
    function balanceOf(address owner) external view returns (uint256 balance);

    function ownerOf(uint256 tokenId) external view returns (address owner);

}