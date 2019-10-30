pragma solidity >=0.4.22 <0.6.0;

import "./helperFunctions.sol";
import "./SafeMath.sol";
import "./layerCounter.sol";



contract Tier is helperFunctions{
    
    using SafeMath for uint;
    address parent;
    
    uint currentTier = 1;
    uint endOfTheList;
    uint lastFoundReward; //index
    
    
     mapping(uint =>mapping(uint=>uint)) values; // value at location in a layer
     mapping(address => uint) layerAddres;
     mapping(uint => bool) trackingLayers;
     mapping(uint => address) layerIsAtAddress;
     mapping(address => uint) adToLayer;
     
     uint[] allLayers;
    address[] allAddresses;
    uint[] allValuesAtTier;
     
     
     constructor (uint _tier) public payable {
         
         parent = msg.sender;
         currentTier = _tier;
         lastFoundReward = 0;
         if(_tier < 1){
             currentTier = 5 ;//test
         }
         
         
     }
     
     
    
    
    
  function addNewValue (uint layer, uint amount) public payable returns (uint) {
      
       if(trackingLayers[layer] == false) { //new layer detected
        
          layerCounter child = new layerCounter(layer, currentTier);
            address layerAddress =  child.getAddress();
            adToLayer[layerAddress]=layer;
            layerIsAtAddress[layer] = layerAddress;
            allLayers.push(layer);
            allAddresses.push(layerAddress);
      
       }
       
       //else look for the layer in the mapping
       layerCounter selectedLayer = layerCounter(layerIsAtAddress[layer]);
       uint answer = selectedLayer.addGoldOreToTheList(amount);
       allValuesAtTier.push(answer);
       
       return answer;
       
       
      
  } 
  
  function getTier () public view returns (uint) {
      
      return currentTier;
  }
    
function getCreatorContract () public view returns (address) {
    
    return parent;
}
function getAddress () public view returns (address) {
    return address(this);
}


function getAllValues () public view returns (uint[] memory) {
    
    return allValuesAtTier;
}
function getAlllayers () public view returns (uint[] memory) {
    
    return allLayers;
}
function getAllAddresses () public view returns (address[] memory) {
    
    return allAddresses;
}



        
        
    }