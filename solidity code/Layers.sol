pragma solidity >=0.4.22 <0.6.0;

import "./helperFunctions.sol";
import "./Cell.sol";




contract Layers is helperFunctions, Cell {
    
       
    struct _layer {
        
        
        
     
        uint id;  //mapping in game logic contract
        uint totalx;
        uint totaly;
        uint totalCells;
        Cell[] cells;
        bool layerIsSoldid; //ripper needed
        
        
        
        
        
        
    }
    
    
    function mineLayer () public {
        
        
        
        
    }
    
   
//  activeCut.z = 1 + random(cutId + (uint160(address(this))) + cutNumbersArray.length + block.number + now)%10;
    
    
}