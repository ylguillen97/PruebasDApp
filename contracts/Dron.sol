//SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;
import  "./ERC721.sol";

contract Dron is ERC721 
{
    uint256 public id_dron;
    uint256 public max_height;
    uint256 public min_height;
    uint256 public  cost;
    string[] public pesticide;
    address public owner;

    bool disponible;

    event fumigacion_plot (uint256 idplot) ;

    constructor (uint256 maxheight, uint256 minheight, uint256 _cost, uint256 id) 
    {
        max_height = maxheight;
        min_height = minheight;
        cost = _cost;
        id_dron = id;
        pesticide = ["Pesticida A", "Pesticida B", "Pesticida C", "Pesticida D", "Pesticida E"];
        owner = msg.sender;
        disponible = true;
    }

    function _mintDron(address to, uint256 tokenId) public 
    {
        //identificador unico ascendente
        ERC721._safeMint(to, tokenId);
    }
    
    function fumigacion (uint256 idplot) public
    {
       // comprobar que quien manda la accion es el owner
        require (msg.sender == owner); 
        emit fumigacion_plot (idplot);
    }
    

    /****************************************************/
    function getCost()  public view returns (uint256)
    {
        return cost;
    }
 
    function getMaxHeight()  public view returns (uint256)
    {
        return max_height;
    }

    function getMinHeight()  public view returns (uint256)
    {
        return min_height;
    }

    function getDisponible() public view returns(bool)
    {
        return disponible;
    }

    function setDisponible(bool estado) public  
    {
         disponible=estado;
    }
}
