pragma solidity >=0.4.22 <0.6.0;

import "./SafeMath.sol";

contract FuelTank {
    uint indexOfTanks;
   using SafeMath for uint;
    
    
    struct _Tank {
        uint objectId; //mounted on object with id
        uint tankId;
        uint maxCapacity;
        uint currentLevel;
        
    }
    mapping(uint => _Tank) tanks;
    uint[] allTanksId;
    _Tank[] public allTanksArray;
    
 
 function fuelTank(uint tankId) public returns (uint) {
     
     
     uint amount = tanks[tankId].maxCapacity - tanks[tankId].currentLevel;
     tanks[tankId].currentLevel = tanks[tankId].maxCapacity;
    
     
     return amount;
     
 }   
 

        
        
function getFuelUsed(uint tankId) public view returns (uint) {
      _Tank memory  tank = tanks[tankId];
    return tank.maxCapacity.sub(tank.currentLevel);
}




function getFuelLeft(uint tankId) public view returns (uint) {
      _Tank memory  tank = tanks[tankId];
    return tank.currentLevel;
}
function getFuelLevel(uint tankId) public view returns (uint) {
      _Tank memory  tank = tanks[tankId];
    return ((tank.maxCapacity.sub(tank.currentLevel)).div(tank.maxCapacity))*100;


}
function createNewFuelTank (uint _maxCapacity, uint ParentObject) public returns (uint){
    indexOfTanks++;
    _Tank memory newTank = tanks[indexOfTanks];
    newTank.tankId = indexOfTanks;
    newTank.maxCapacity = _maxCapacity;
    newTank.objectId = ParentObject;
    newTank.currentLevel = _maxCapacity;
    tanks[indexOfTanks] = newTank;
    allTanksId.push(indexOfTanks);
    allTanksArray.push(newTank);
    
    
}

function getAllTanks () public view returns (uint[] memory) {
    
    return allTanksId;
}

function getTankDetails (uint tankid) public view returns (uint, uint, uint) {
    
    return ((tanks[tankid].objectId),(tanks[tankid].currentLevel),(tanks[tankid].maxCapacity));
}
        
        
function consumeFuel(uint tankid, uint amount) internal {
    tanks[tankid].currentLevel -= amount; 
}
        
}
    
    
    
    
 
    
    
    
    
    
    
    
    


    
    
