//SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

import  "./ERC721.sol";
import  "./ERC20.sol";

contract Plot is ERC721 
{
    uint256 public id_plot;
    uint256 public max_height;
    uint256 public min_height;
    address public owner;
    string public pesticide;

    bool atendido;


    constructor (uint256 maxheight, uint256 minheight, uint256 id, string memory _pesticide) 
    {
        max_height = maxheight;
        min_height = minheight;
        owner = msg.sender;
        id_plot = id;
        pesticide = _pesticide;
        atendido = false;

    }

    function _mintPlot(address to, uint256 tokenId) public 
    {
        //identificador unico ascendente
        ERC721._safeMint(to, tokenId);
    }
    
    /****************************************************/
    function getMaxHeight()  public view returns (uint256)
    {
        return max_height;
    } 

    function getMinHeight()  public view returns (uint256)
    {
        return min_height;
    }

    function getAtendido() public view returns(bool)
    {
        return atendido;
    }
    function setAtendido(bool estado) public  
    {
         atendido=estado;
    }
}