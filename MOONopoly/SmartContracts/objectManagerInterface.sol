pragma solidity >0.4.24 <0.6.0;



import "browser/ERC1820Client.sol";

contract objectManagerInterface is ERC1820ClientWithPoly{
    
    uint public maxTier;
    
    uint public globalObjectCounter;
   
    
    
    struct object {
        uint id;
        uint tier; 
        string typeOfObject;
        uint hashOfType;
        uint idWithinType; //eg => streetnumber, housenumber
        address owner;
        
        
        
    }
    
    
 
    
function getNewId () public returns (uint) ;
function registerNewObject (uint id, string memory objectType, uint idInType, address _owner, uint tier) public returns (uint);

function checkIfActionIsNeeded (uint globalId) public returns (uint) ;
function checkIfSupplyOfHousesIsBigEnough (uint globalId) internal returns (bool);
 function onCreationCallback(uint[] memory hashOfType, address[] memory contractsInNeedOfThis) public returns (bool[] memory);
 function checkHash (uint hash, address foundAt ) public returns (bool) ;
 //getters     
function getTypeOfObject (uint globalId) public view returns (string memory);
function getHashOfObjectType (uint globalId) public view returns (uint) ;
function getIdWithinTheType (uint globalId) public view returns (uint);
function checkIfObject (uint globalId) public view returns (bool) ;
function getSupplyOfTier(string memory objectType, uint tier) public view returns (uint);
function getTierOfObject (uint globalId) public view returns (uint);
function checkIfOwnerOfObject (uint globalId, address owner) public view returns (bool);


}

    
    