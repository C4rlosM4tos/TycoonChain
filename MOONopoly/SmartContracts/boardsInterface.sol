pragma solidity >0.4.24 <=0.6.0;

import "browser/streetsInterface.sol";
import "browser/plotsInterface.sol";


import "browser/ERC1820Client.sol";

contract boardsInterface is ERC1820ClientWithPoly{ 
    

    
    struct board {
        
        uint id;
        uint tier;
        uint[] streets;
        address President;
        string name;
        streetsInterface.street[] streetObjects;
        uint[] avatarIds;
        address[] players;
        
    }


 function setInter () public ;
 

function createNewBoard (uint tier, string memory name) public returns (uint boardId);

function addStreetToBoard (uint boardId, uint location) public returns (uint streetId);
function getStreetDetails (uint streetId) internal  ;
function getStreetDetailsSecond (uint streetId) internal ;

function setMayor (uint boardId, uint location) public returns (address _Mayor) ;
function setGovornor (uint boardId, uint[] memory setOflocation) public returns (address governorOfBoard) ;

function registerNewPlotToStreet (uint plotId, uint streetId) public ;
function createPlotDetails (uint tokenId) internal returns (plotsInterface.plot memory _plot ) ;



    
}