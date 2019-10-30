pragma solidity >=0.4.22 <0.6.0;


import "./SafeMath.sol";
import "./Tier.sol";

contract layerCounter  {
    
   
    
        uint256 layerId;
    uint256 Layer;
    uint256 Tier;
     address parent; //tier
       uint internal previousRandom;
    uint internal nonceCounter;
    
    uint public oreToBeFoundAtThisLayer;
    uint public totalFoundInLayer;
    uint public currentReward;
    
    
    using SafeMath for uint;
   
    
    uint currentTier;
    uint endOfTheList;
    
 
    mapping(uint => uint) goldOre;
    uint[] valuesAtLayer;
    
    
    

    
    
    
    constructor (uint _layer, uint _tier) payable public {
        require(( _tier) > 0);
        require(_layer > 0);
        Layer = _layer;
        parent = msg.sender; //the contract
        Tier = _tier;
        currentReward = 0;
     
        
    }
  //  uint[] allValuesToBeFound;
    
    uint[] allValuesFoundOnThisLayer;
    
    
function addGoldOreToTheList(uint amount) public returns (uint){
   uint tier = Tier;
   uint layer = Layer;
    uint tempVal;
    
    for(uint i=0; i < amount; i++) {
    
    endOfTheList++;
 //  uint modulo = (tier*layer)%100;
   uint256 variable = (uint160(address(msg.sender)))+ uint160(address(this));
      
     uint random = random(variable+layer+tier);
     random =1+ random %(tier*layer);
     uint smallRandom = random % (tier+layer);
     uint value = (tier*layer) ;
        value += smallRandom.mul(layer);
        value -= (tier**2);
     uint modulo = tier+layer+((random)%(tier*layer));
      value = (value)%modulo;
     
      
     if( value > 10000) {
         value = value%5000;
     }
      
      if((value%3) == 0){
          goldOre[endOfTheList] = value;
          valuesAtLayer.push(value);
          
      }else{
          goldOre[endOfTheList] = 0;
          value = 0;
      }
      oreToBeFoundAtThisLayer += value;
    
 //   allValuesToBeFound.push(value);   
    tempVal += value;
        
}
return tempVal;
    }
    
function getAddress () public view returns (address) {
    
    return address(this);
}
function getOreAtlocation(uint value) public view returns (uint) {
    
    return goldOre[value];
    
}
function minePaydirt () public returns (uint) {  //internal or some modifiers needed
    currentReward++;
    uint answer = goldOre[currentReward];
    totalFoundInLayer += answer;
    allValuesFoundOnThisLayer.push(answer);
    
    return answer;
}
function getAllValuesFoundArray () public view returns (uint[] memory) {
    return allValuesFoundOnThisLayer;
}
function getAllValuesToBeFoundArray () public view returns (uint[] memory) {
    
    return valuesAtLayer;
  //  return allValuesToBeFound;
}

 function random(uint nonce) internal returns(uint) {
     
     uint _nonce = nonceCounter + nonce + previousRandom + now;
     
     nonceCounter++;
    previousRandom = uint(keccak256(abi.encodePacked(_nonce)));
       
        
        return uint(keccak256(abi.encodePacked(_nonce)));
    }
    
function getTier () public view returns (uint) {
    
    return Tier;
}
function getLayer() public view returns (uint) {
    return Layer;
}



 
 
}
    