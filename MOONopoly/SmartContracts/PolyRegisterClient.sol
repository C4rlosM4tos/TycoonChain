pragma solidity >=0.4.22 <0.6.0;





contract PolyRegisterClient {
    
    
    
function typeAtaddress (string memory typeofcontract) public view returns(address);
function hashAtAddress (uint hash) public view returns (address);
function registerContract (string memory contractType, uint[] memory needs) public returns (bool[] memory, address[] memory);

function onCreationCallback(uint[] memory hashOfType, address[] memory contractsInNeedOfThis) public returns (bool[] memory);
function fillOthersNeedsIfPossible (uint hashOfNeed, address contractHoldingSolutionToNeed) public returns (address[] memory, uint[] memory);
       
function checkHash (uint hash, address foundAt ) public returns (bool);
 

    


         
    
    
}