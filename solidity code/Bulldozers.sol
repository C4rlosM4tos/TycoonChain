pragma solidity >=0.4.22 <0.6.0;


import "./ObjectTypes.sol";
import "./fuelTank.sol";
import "./heavyEquipment.sol";
import "./SafeMath.sol";
import "./GoldCrushObjects.sol";


contract Bulldozers is objectType, FuelTank, heavyEquipment, GameObjects {
    uint indexOfBulldozers;
 
    
    
    
    struct _Bulldozer  {
        
        GameObjects.object base;
        uint fuelTankId;
        FuelTank._Tank tank;              //fueltank
        uint motorId;
        heavyEquipment.motor motor;
        uint toolsetId;
        heavyEquipment.tools toolset;


        
    }
    
    mapping(uint => _Bulldozer) BulldozerObjects;
    mapping(uint => _Bulldozer) bulldozers;
    
    
    
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