pragma solidity >0.4.24 <=0.6.0;

import "browser/ERC721Full.sol";
import "browser/plotsInterface.sol";
import "browser/ERC1820Client.sol";

 
    
contract streetsInterface is ERC1820ClientWithPoly, IERC721Receiver {  
  
 struct street {
        uint id;
        uint tier;
        uint board;
        uint LocationOnTheBoard;
        uint set;
        string color;
        uint[] soldPlots;
        string name;
        uint rent;

        plotsInterface.plot[] _plotObjects;
        uint[] plots; 

        address Mayor;
        address Governor;
    }
    
    
 
 


function canImplementInterfaceForAddress(bytes32 _interfaceHash, address _addr) external view returns(bytes32);
function streetIdToBoardNumber (uint streetId) public view returns (uint);
function getStreetDetails (uint streetId) public view returns (uint, uint, uint, uint, uint) ;
function getStreetDetailsSecond (uint streetId) public view returns(string memory, uint[]  memory, uint[] memory,  address,  address );
function setInter () public;
function _setMayor (uint streetId) public returns (address) ;
function createNewStreet (uint tier, uint boardId, uint LocationOnTheBoard) public  returns (uint) ;
function getSet (uint LocationOnTheBoard) public pure returns (uint) ;
function calculateCostToOpen (uint streetId,uint tier, uint i, uint rent) internal returns (uint);
function calculateRent (uint streetId, uint tier, uint i) internal returns (uint) ;
function getColor (uint LocationOnTheBoard) public pure returns (string memory);
function getMaxPlots (uint streetId) public view returns (uint) ;
function giveColor (uint LocationOnTheBoard) public pure returns(string memory);
function getStreet (uint streetId) public view returns (uint, uint, uint, uint, string memory, uint);
function setNameOfStreet (uint streetId, string memory name) public returns (string memory) ;
function random(uint nonce) public view returns(uint);
function getTier (uint streetId) public view returns (uint) ;
function getBoard (uint streetid) public view returns (uint) ;
function getLocationOnBoard (uint streetId) public view returns (uint); 
function getPlotsIds(uint streetid) public view returns (uint[] memory) ;
function getSoldPlots(uint streetid) public view returns(uint[] memory) ;
function getOwnerOfStreet(uint streetid) public view returns (address) ;
function getGovernorOfStreet (uint streetId) public view returns (address _Governor);
function getBaseRent(uint streetId) public view returns (uint) ;
function getAmountOfPlots(uint streetId) public view returns (uint) ;
function addPlotToStreet (uint streetId, uint tokenId, uint globalId, uint boardId) public ;
function getLocation (uint streetId) public view returns (uint) ;


  function onERC721Received(address operator, address from, uint256 tokenId, bytes memory data) public returns (bytes4);
}