pragma solidity >=0.4.22 <0.6.0;

import "./helperFunctions.sol";
import "./Layers.sol";


contract Cuts is helperFunctions, Layers {
        uint indexOfCuts;
        address owner;

    
    struct cut {
    
    uint totalFoundInCut;    
    uint idOfTheCut;   //for unique number for every cut in the world
    string name;       // players can give a cut a name when they open it up.
    bool prospectedForTier;
    uint x; //dimensions of the cut
    uint y;
    uint z;
    uint tier;
    Layers[] layers;
    mapping(uint => Layers) mapLayers;
    bool drilled;
    address ownerOfcut;
    mapping(uint => bool) objectIsAtCut;
    
 
 
            }
            
    mapping(uint => cut) cuts; //*************************
    cut[] cutsArray; //useless?
    uint[] cutNumbersArray;
    
            
           modifier OnlyOwner () {
        require(tx.origin == owner);
        _;
    }
    modifier PaidOption () {
       require( msg.value >= 1  ether);
        _;
    
    }
    
 function setOwnerOfClaim (address _owner) internal {
     owner = _owner;
 }
    
function setOwerOfCut (uint idOfTheCut, address newOwner) internal  {
    cuts[idOfTheCut].ownerOfcut = newOwner;
}
    
function createNewCutNow() internal returns (uint) {
    cuts;
    
       indexOfCuts++;
        uint _index = indexOfCuts;
        
        
       
        
       // newcut.z = 1+random(_index+_index)%11;
       // newcut.layers[newcut.z-1];
         cuts[_index].name = "Undiscovered ground";
         cuts[_index].ownerOfcut = tx.origin;
        cutsArray.push(cuts[_index]);
        cutNumbersArray.push(_index);
  
        
        return _index;
        //prepare ampty cell array
        
    }
    
 
    
    
function prospectCut (uint _index) public PaidOption payable {  //needed to reveal tier and depth of the cut. simulate panning and digging before opening a cut.
 require(cutsArray.length >0);
 require(_index > 0);
 
    
    require(cuts[_index].prospectedForTier == false);
     cuts[_index].tier = 1 + random(_index + (uint160(address(this))) + block.number + now)%999;
     cuts[_index].x =  1+random(_index)%11;
    cuts[_index].y = 1+random(_index*_index)%10;
   
    
     cuts[_index].prospectedForTier = true;
     
     
    
}




function getCuts () public view returns (uint[] memory) {
    
    
    return cutNumbersArray;
    
    
}

 function drillTestHoles (uint cutId) public payable PaidOption returns (uint) {
     require(cuts[cutId].ownerOfcut == msg.sender);
     require(cuts[cutId].prospectedForTier);
     require(cuts[cutId].drilled == false);
     
     
     cuts[cutId].z = 1 + random(cutId + (uint160(address(this))) + cutNumbersArray.length + block.number + now)%100;
     cuts[cutId].drilled = true;
     
     return (cuts[cutId].z);
    
}



function getCut (uint id) public view returns (uint, uint, uint,uint,uint) {
    uint e = cuts[id].tier;
    uint c = cuts[id].z;
    uint b =  cuts[id].y;
    uint a = cuts[id].x;
    uint d = a*b*c ;
    
    return (a,b,c,d,e);
}

    
    
}