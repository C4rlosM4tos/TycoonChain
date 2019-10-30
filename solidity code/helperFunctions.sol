pragma solidity >=0.4.22 <0.6.0;




contract helperFunctions {
    
    uint internal previousRandom;
    uint internal nonceCounter;
    
  
        
 function random(uint nonce) internal returns(uint) {
     
     uint _nonce = nonceCounter + nonce + previousRandom + now;
     
     nonceCounter++;
    previousRandom = uint(keccak256(abi.encodePacked(_nonce)));
       
        
        return uint(keccak256(abi.encodePacked(_nonce)));
    }
    
    
function isLucky (uint number) public returns (bool) {
    
    uint newNumber = 11;
    newNumber = (random(number + previousRandom + nonceCounter + now + (uint160(address(msg.sender))) + block.number))%2; //1 kans op 3
    
    if(newNumber == 0 ){
        return true;
    }
    return false;
    
}

}