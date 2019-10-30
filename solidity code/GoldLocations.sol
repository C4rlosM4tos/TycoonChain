pragma solidity >=0.4.22 <0.6.0;

import "./helperFunctions.sol";
import "./SafeMath.sol";
import "./Tier.sol";
import "./layerCounter.sol";


contract GoldLocations is helperFunctions {
    
  //  Tier t;
    
    using SafeMath for uint;
    
    uint public TotalGoldLocated; //until t+0
    uint public TotalGoldFound;
    
    
    
     

    
   
 
    mapping(uint => bool) trackingTiers;

    mapping(address => uint) tiers;
    mapping(uint => address) _tiers;
    uint[] allValues;
    uint[] tiersToDate;
    address[] allTiersAddress;
    
    
    
    function GenerateNewFields (uint amount, uint tier, uint layer) public returns (uint) {
        
     //   for(uint i=0; i < amount; i++) {
        if(trackingTiers[tier] == false) { //new tier detected
        
          Tier child = new Tier(tier);
            address tierAddress =  child.getAddress();
            tiersToDate.push(tier);
            tiers[tierAddress] = tier;
            _tiers[tier]= tierAddress;
               Tier activeTier = Tier(tierAddress);
           uint answer = activeTier.addNewValue(layer, amount);
            allValues.push(answer);
            allTiersAddress.push(tierAddress);
            TotalGoldLocated += answer;
          
    
        
        
       //    tier activeTier = new Tier();
           
      
    }else{  // tier is known
    
    Tier activeTier = Tier(_tiers[tier]);
      uint answer = activeTier.addNewValue(layer, amount);
            allValues.push(answer);
            TotalGoldLocated += answer;
         
        
        
        
    //}
    
        }
    
  //  uint value = addNewValue(layer);
    //allValues.push(value);
    
    
    }

    function getAllValues () public view returns (uint[] memory) {
        return allValues;
    }
    function getAllTiers () public view returns (uint[] memory)  {
        return tiersToDate; 
    }
      function getAllAddresses () public view returns (address[] memory)  {
        return allTiersAddress; 
    }
    
}




    
    
    
    
    
    
    
    
    
    
    
    
    
    


