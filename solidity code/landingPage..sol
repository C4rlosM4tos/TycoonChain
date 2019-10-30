pragma solidity >=0.4.24 <0.6.0;

import "./GoldCrushRegulator.sol";
import "./PlayerManager.sol";
import "./Company.sol";
import "./GoldClaim.sol";
import "./GoldCrushEntry.sol"; //manage companies

contract Landing {
    
    Regulator reg;
    address owner;
    
    PlayerManager manager;
    
    constructor () public {
        
        owner = msg.sender;
    }
    

modifier onlyOwner {
    require(msg.sender == owner);
    _;
}

function setRegulator (address regulatorAddress) public onlyOwner {
    
    reg = Regulator(regulatorAddress);
    
    }
    
function getPlayerManager() public onlyOwner returns (address) {
         address adres =reg.getPlayerManager();
        manager = PlayerManager(adres);
        return adres;
        
}       

function checkPlayerForIdOrGiveOne(address adres) public returns (uint) {
    
    return reg.addPlayer(msg.sender);
}

function getRegulator() public view returns (address) {
    
    return address(reg);
}

function viewPlayerManager() public view returns (address){
    return address(manager);
}
 
function loadCompaniesOwnedByThePlayer(address accountAddress) public returns(address[] memory) {
  return  manager.getCompaniesOwnedByPlayer(accountAddress);
    
} 
function getPlayertId () public view returns (uint) {
   require(manager.checkIfPlayer(msg.sender));
   return manager.getPlayerId(msg.sender);
    
}

 
    
}

