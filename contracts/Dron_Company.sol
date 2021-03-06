//SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

 import "./ERC20.sol";
 import "./Dron.sol";
 import "./Plot.sol";
 import "./SafeMath.sol";

contract Dron_Company is SafeMath
{
    uint256 public id_dron;
    uint256 public id_plot;

    uint256 public n_trabajos;
    address owner;
    mapping (uint256 => Dron) internal drones; 
    mapping (uint256 => Plot) internal plots;


    //la clave será el id_plot y el valor será el id_dron
    mapping (uint256 => uint256) internal trabajosPendientes;

    ERC20 token;

    event ContrataDronFumigador (uint256 id_dron, uint256 id_plot);
    event Sold (address buyer, uint256 amount);

    constructor () 
    {
        owner = msg.sender;
        token = new ERC20();
        id_dron = 0;
        id_plot = 0;
    }

    function registraDron (uint256 maxheight, uint256 minheight, uint256 cost) public returns (bool success)
    {
        require(maxheight>minheight);
        require(cost > 0);
        require(maxheight > 0);
        require(minheight > 0);
        //creamos un nuevo dron
        id_dron+=1;
        Dron dron  = new Dron (maxheight, minheight, cost, id_dron); 
        drones[id_dron] = dron;
        //minteamos
        dron._mintDron(msg.sender, id_dron);
        return true;
    }

    function registraPlot (uint256 maxheight, uint256 minheight, string memory _pesticide) public returns (bool success)
    {
        require(maxheight>minheight);
        require(maxheight > 0);
        require(minheight > 0);
        require (compareStrings(_pesticide, "Pesticida A") || compareStrings(_pesticide, "Pesticida B") ||compareStrings(_pesticide, "Pesticida C") 
        || compareStrings(_pesticide, "Pesticida D") ||compareStrings(_pesticide, "Pesticida E"));

        id_plot+=1;
        Plot plot  = new Plot (maxheight, minheight, id_plot, _pesticide); 
        plots[id_plot] = plot;

        //minteamos
        plot._mintPlot(msg.sender, id_plot);
        return true;
    }


    /************************************************/
    function getDronesDisponibles() public view returns(uint256[] memory)
    {
        uint256 [] memory drones_disp = new uint256 [](id_dron);
        uint n = 0;
        for (uint i=1; i<=id_dron; i++)
        {
           if(drones[i].getDisponible())
           {
               drones_disp[n]=i;
               n++;
           }
        }
        return drones_disp;
    }

    function ContrataDron (uint256 iddron, uint256 idplot) public payable returns (bool success)
    { 
        require (iddron != 0 && idplot != 0);
        address dron_owner = drones[iddron].ownerOf(iddron);
        address plot_owner = plots[idplot].ownerOf(idplot);

        require (msg.sender == plot_owner); 

        require(!plots[idplot].getAtendido());
        require(drones[iddron].getDisponible());

        require (plots[idplot].getMaxHeight() >= drones[iddron].getMaxHeight());
        require (plots[idplot].getMinHeight() <= drones[iddron].getMinHeight());

        uint256 tokens = drones[iddron].getCost(); 
        uint256 amountToBuy = safeMul(tokens, uint256(10)**18);
        require (token.balanceOf(msg.sender)>= amountToBuy);
        require (token.approve(plot_owner,  amountToBuy));
        require (token.transferFrom (plot_owner, dron_owner, amountToBuy), "ERROR AL TRANSFERIR");
        n_trabajos++;
        trabajosPendientes[idplot] = iddron; 
        drones[iddron].setDisponible(false);

        emit ContrataDronFumigador (iddron, idplot);
        return true;
    }

    function aceptaTrabajos (uint256 iddron, uint256 idplot) public
    {
        require (iddron != 0 && idplot != 0);
        require (msg.sender == drones[iddron].ownerOf(iddron));
        require (trabajosPendientes[idplot] == iddron); 
        drones[iddron].fumigacion(idplot); 
        plots[idplot].setAtendido(true);
        drones[iddron].setDisponible(true);
        trabajosPendientes[idplot]=0;
        n_trabajos= n_trabajos-1;
    }

    function getTrabajosDisponibles() public view returns(uint256[] memory)
    {
        uint256 [] memory trabajosOwner = new uint256 [] (n_trabajos);
        uint n = 0;
        
        for (uint i=1; i<=n_trabajos; i++)
        {
            uint256 iddron = trabajosPendientes[i];
            
            if (iddron != 0)
            {
                address dron_owner = drones[iddron].ownerOf(iddron);
                if (dron_owner == msg.sender)
                {
                    trabajosOwner[n]=i;
                    n++;
                }
            }
        }
        return trabajosOwner;
    }

    function buyTokens(uint256 _amount) public payable returns (bool success) 
    {
        require(msg.value > safeMul(_amount, 1000));

        uint256 amountToBuy = safeMul(_amount, uint256(10)**18);

        require(token.balanceOf(address(this)) >= amountToBuy);
        
        require(token.transfer(msg.sender, amountToBuy));

        emit Sold(msg.sender, amountToBuy); 

        return true;
    }

    function getBalanceOf (address dir) public view returns (uint)
    {
        return token.balanceOf(dir);
    }


    /*****************************************************************/
    function get_idDron() public view returns(uint256)
    {
        return id_dron;
    }

    function get_idPlot() public view returns(uint256)
    {
        return id_plot;
    }
    function getCost(uint256 iddron) public view returns (uint256)
    {
        return drones[iddron].getCost();
    }

    function getMaxHeight(uint256 iddron) public view returns (uint256)
    {
        return drones[iddron].getMaxHeight();
    }

    function getMinHeight(uint256 iddron) public view returns (uint256)
    {
        return drones[iddron].getMinHeight();
    }

    function compareStrings(string memory a, string memory b) internal pure returns (bool) 
    {
        return (keccak256(abi.encodePacked((a))) == keccak256(abi.encodePacked((b))));
    }

 
}