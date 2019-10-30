pragma solidity >=0.4.22 <0.6.0;

import "./Context.sol";
import "./Roles.sol";
import "./GoldCrushEntry.sol";
import "./PlayerManager.sol";


contract Company is Context  {
    PlayerManager pm;
    GoldCrushEntry GCEC;
    using Roles for Roles.Role;
    
    Roles.Role CEO;
    Roles.Role Operator;
    Roles.Role Leaser;
    
    Roles.Role private _CEOs;
      
    event CEOAdded(address indexed account);
    event CEORemoved(address indexed account);

    
    address owner; 
    uint playerIdOwner;
    uint companyId;
    string companyName;
    address creator;
    address creatorAccount; //the account that was playing with the player profile
    
    uint maxTier;
    
    
    address[] owners;  //array of player contracts or owners of the player contracts?
    address[] coOwners; //allowed to do certain actions
   
   
    address[] claims;   // array of adddresses that this company owners
    address[] inventoryStorage; // unused objects
    address[] inventory; // all objects owned by this company
   
    address[] accountsOfowners; // the addresses of the accounts holding the parent player contract
    
    
    mapping(address => address) locationOfObject; // from object address to claim address // lookup in inentory, copy address and look for claim locattion
    
    mapping(address => bool) isObjectInStorage; // add true to an object when placed in storage so it can be looked for
    
    mapping(address => bool) isOwner;
    mapping(address => bool) isCoOwner;
    
    
    modifier onlyCEO() {
        require(isCEO(_msgSender()), "CapperRole: caller does not have the Capper role");
        _;
    }
    
    
    
    
    constructor (uint id, string memory name, uint playerid) public payable {  //should only be created by the player contract! public for easy testing 
        
        owner=tx.origin;
        playerIdOwner = playerid;
        companyId = id;
        companyName = name;
        creator = msg.sender; 
        creatorAccount = tx.origin;
        owners.push(tx.origin);
        accountsOfowners.push(tx.origin);
        isOwner[tx.origin]=true;
        _addCEO(_msgSender());
     
        
    }
    
function setTier (uint newTier) public returns (uint) {  //should only be accessed by the GameLogic, public for testing
    maxTier = newTier;
    return maxTier;
}
function getTier () public view returns (uint) {
    return maxTier;
}
function getOwners() public view returns (address[] memory) {
    
    return owners;
}
function addCoOwner (address _address) public onlyCEO returns (bool)  { //only owner can do this! modifier to be added!

    coOwners.push(_address);
    isCoOwner[_address]=true;
    return isCoOwner[_address];
    
}
function getCoOwners () public view returns (address[] memory) {
    return coOwners;
}
function checkCoOwner (address _address) public view returns (bool) {
    
    return isCoOwner[_address];
}
    function isCEO(address account) public view returns (bool) {
        return _CEOs.has(account);
    }
    function addCEO(address account) public onlyCEO {
        _addCEO(account);
    }
    function renounceCEO() public {
        _removeCEO(_msgSender());
    }

    function _addCEO(address account) internal {
        _CEOs.add(account);
        emit CEOAdded(account);
    }

    function _removeCEO(address account) internal {
        _CEOs.remove(account);
        emit CEORemoved(account);
    }

function getOwner() public view returns (address) {
    return owner;
    
    
} 
function setId () public returns (uint) {
    GCEC.getCompanyId();
}
function setGoldCrushEntry(address ad) public { //should be set by the game only
    GCEC = GoldCrushEntry(ad);
}   

function setOwner(address adres) public returns (address) {
    owner = adres;
    return owner;
}
    
    
    
}