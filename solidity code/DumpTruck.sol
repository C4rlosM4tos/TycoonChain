pragma solidity >=0.4.22 <0.6.0;


import "./ObjectTypes.sol";
import "./fuelTank.sol";
import "./heavyEquipment.sol";
import "./SafeMath.sol";
import "./GoldCrushObjects.sol";


contract DumpTruck is objectType, FuelTank, heavyEquipment, GameObjects {
    uint indexOfBulldozers;
 
    
    
    
    struct _DumpTruck  {
        
        GameObjects.object base;
        uint fuelTankId;
        FuelTank._Tank tank;              //fueltank
        uint motorId;
        heavyEquipment.motor motor;
        uint toolsetId;
        heavyEquipment.tools toolset;


        
    }
    
    mapping(uint => _DumpTruck) DumpTrucks;
    mapping(uint => _DumpTruck) bulldozers;
    
    
    
function clearGround (uint cutId, uint bulldozerId) public returns(uint) {
    
    // remove all trees and obsticals on top layer of a cut
    
    return cutId;
}
function removeOverburden (uint layerid, uint bulldozerId) public returns (uint) {
    
    
    return layerid;
}
function ripGroundOpen (uint layerid, uint bulldozerId) public {
    
    
}
function addBullDozer () public {
  uint indexOfBulldozer =  indexOfBulldozers++;
 uint objectId = requestNewObjectId() ;   
    
    
}


    
    
}