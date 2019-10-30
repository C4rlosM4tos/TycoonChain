pragma solidity >=0.4.22 <0.6.0;



import "./PlayerManager.sol";
import "./auction.sol";
import "./GoldCrush.sol";
import "./GoldCrushObjects.sol";
import "./SafeMath.sol";
import "./Bulldozers.sol";

contract Regulator is GameObjects {
    

    
    
    address owner;
    
    PlayerManager manager;
    
    
    modifier onlyOwner {
    require(msg.sender == owner);
    _;
    }
    
    
    
    
    constructor () public {
        owner = msg.sender;
    }
 
function setPlayerManager (address _manager) public onlyOwner returns (address) {
    
    manager = PlayerManager(_manager);
    
    return address(manager);
}
function addPlayer (address ad) public returns (uint) {
if(!manager.checkIfPlayer(ad)){
      uint playerId =  manager.addPlayer(ad, (""));
    return playerId;
}else{
    manager.getPlayerId(ad);
    
    
}
}
function getPlayerManager() public view returns (address) {
  
  return address(manager);  
  
}
}


    
    
    

    
    
    
    
    
    
    
    
