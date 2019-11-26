pragma solidity >0.4.24 <=0.6.0;

import "browser/ERC721Full.sol";

import "browser/ERC1820Client.sol";


contract plotsInterface is ERC721Full, ERC1820ClientWithPoly {


      
    
    struct plot {
        
        uint globalId; 
        uint plotId;
        uint tier;
        uint streetId;
    

        uint plotNumber; //number of plot on the street;
        address owner;
        uint houseNumber; //if build
        bool hasHouse;
        uint price;
        uint boardId;
        uint location;
        uint dateMinted;
        
    }


    


    
function getPlotDetails (uint tokenId) public view returns (uint , uint , uint , uint , uint , address , uint );
function getPlotDetailsSecond (uint tokenId) public view returns (bool, uint, uint, uint, uint) ;  
    
function setInter () public ;

function getGlobalId(uint tokenId) public view returns (uint);
function createNewPlot(uint streetId) public returns (uint);
function mintPlot (address owner, uint id, bytes memory dataId) internal ;

function createNewPlot(uint streetId, uint cost, uint num, uint tier) public returns (uint);
function checkIfPlotHasHouse (uint plotId) public view returns (bool);
function getHouseOnPlot (uint plotId) public view returns (uint);
function setPolyObjectManager (address newObjectManager) public returns (bool);
function getPlotOwner (uint plotId) public view returns (address) ;
function onCreationCallback(uint[] memory hashOfType, address[] memory contractsInNeedOfThis) public returns (bool[] memory) ;
function checkHash (uint hash, address foundAt ) public returns (bool);
function getTier (uint globalId) public view returns (uint) ;

}