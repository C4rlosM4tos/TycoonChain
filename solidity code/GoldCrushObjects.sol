pragma solidity >=0.4.22 <0.6.0;

import "./ObjectTypes.sol";
import "./heavyEquipment.sol";



contract GameObjects is objectType {
    
uint indexGameObjects;
    
    
    
    
        struct object {
            
            uint idOfTheObject;
            objectType._Type typeOfObject;
            uint objectInterfaceIdNumber;
            heavyEquipment.adminPanel paperWork;
            uint panelid; //for easy access
            uint objectid;
            string typeId;   //eg 1 is bulldozers
            
            
            
        }
  
        
        
        
function requestNewObjectId () public returns (uint) { //function to get an id of the specific type, not a global id
    
    return indexGameObjects++;
}
// each type can have its own auctionhouse?




    
}