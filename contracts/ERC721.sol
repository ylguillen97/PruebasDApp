//SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

import  "./ERC165.sol";
import  "./IERC721.sol"; 
import  "./IERC721Receiver.sol"; 


contract ERC721 is ERC165, IERC721 
{
    //address propietaria del token, int256 es el identificador único del token
    mapping(uint256 => address) private _owners;
    //cuantos tokens tiene la direccion
    mapping(address => uint256) private _balances;
    //a traves de un id, y devuelve la direccion del owner
    // mapping(uint256 => address) private _tokenApprovals;
    // mapping(address => mapping(address => bool)) private _operatorApprovals;
      
    function ownerOf (uint256 tokenId) public view virtual override returns (address)
    {
        address owner = _owners[tokenId];
        require (owner != address(0), "Token id does not exist");
        return owner;
    } 
  
    function balanceOf (address owner) public view returns  (uint256 balance)
    {
        return _balances[owner];
    }

    function _safeMint (address to, uint256 tokenId) public 
    {
        _safeMint (to,tokenId, "");
    } 

    function _safeMint (address  to, uint256 tokenId, bytes memory _data) public 
    {
        _mint(to, tokenId);
        require(_checkOnERC721Received(address(0), to, tokenId, _data));
    }

    function _mint(address to, uint256 tokenId) internal virtual 
    {
        require(to != address(0), "ERC721 ERROR: mint to the zero address");
        require (!_exists(tokenId), "ERC721 ERROR: Token already minted");
        //require (msg.sender == owner, "ERC721 ERROR: Not authorized ");

       // _beforeTokenTransfer(address(0), to, tokenId);

        _balances[to]+=1;
        _owners[tokenId] = to;

        emit Transfer(address(0), to, tokenId);
    }
   
    function _exists(uint256 tokenId) internal view virtual returns (bool)
    {
        return _owners[tokenId]!= address(0); //devuelve true si ya existe
    }

    function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory _data) private returns (bool) 
    {
        if (isContract(to)) 
        {
            try IERC721Receiver(to).onERC721Received(msg.sender, from, tokenId, _data) returns (bytes4 retval) {
                return retval == IERC721Receiver.onERC721Received.selector;
            } catch (bytes memory reason) {
                if (reason.length == 0) {
                    revert("ERC721: transfer to non ERC721Receiver implementer");
                } else {
                    assembly {
                        revert(add(32, reason), mload(reason))
                    }
                }
            }
        } 
        else 
        {
            return true;
        }
    }

    function isContract(address _addr) private view returns (bool)
    {
        uint32 size;
        assembly 
        {
            size := extcodesize(_addr)
        }
        return (size>0);
    }



     
}