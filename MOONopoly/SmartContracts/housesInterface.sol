pragma solidity >0.4.24 <=0.6.0;



import "browser/ERC721Full.sol";

contract housesInterface {
  
     event OnCallbackEvent (uint[], address[], bool[]);
    event newContractSet (string name, address contractSet);
    
    mapping(uint => uint) public houseIdToGlobalId;
    mapping(uint => uint) public globalIdToHouseId;
 
    struct house {
        
        uint globalId; 
        uint houseId;
        uint tier;
        uint plotId;
        address owner;
        bool build;
        uint multiplier;
        
    }
    
    
mapping(uint => house) public houses;
mapping(address => mapping(uint => bool)) isOwnerOfHouse;
mapping(uint => house) public globalIdToHouseObject;


uint[] public allGlobalIds;

    
 function getGlobalId(uint tokenId) public view returns (uint);
    
function createNewHouse (uint tier) public ;

function setAuctionContract (address _auctionHouse) public returns (bool);
function getNewMultiplier (uint houseId) public view returns (uint);
function checkIfOwner (address owner, uint houseId) public view returns (bool);
function getTier (uint houseId) public view returns (uint) ;


function getOwner (uint houseId) public view returns (address);

function getMultiplier (uint houseId) public view returns (uint) ;
 
function setObjectManager (address newObjecctManager) public returns (bool);
function onCreationCallback(uint[] memory hashOfType, address[] memory contractsInNeedOfThis) public returns (bool[] memory);
function checkHash (uint hash, address foundAt ) public returns (bool) ;   
 

    
}