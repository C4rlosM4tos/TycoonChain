pragma solidity >0.4.24 <0.6.0;

import "browser/PolyToken.sol";
import "browser/PolyRegister.sol";

contract PolyLauncher{
    PolyRegister registerPoly;
    PolyToken public _contract;
    address public exchange;
    address registry;
    address[] public operators;

constructor(address _PolyRegister) public {

         uint[] memory needs = new uint[](3); 
        registerPoly = PolyRegister(_PolyRegister);
         needs[0] = uint(keccak256(abi.encodePacked("PolyToken")));
         needs[1] = uint(keccak256(abi.encodePacked("PolyExchange")));
         needs[2] = uint(keccak256(abi.encodePacked("Registry")));
      
              (bool[] memory boolSolutions, address[] memory solutions) = registerPoly.registerContract("PolyLauncher", needs);
          if(solutions.length > 0) {
              
                  for(uint i = 0; i<solutions.length;i++) {
                      if(boolSolutions[i]){
                          if(i == 0) {
                              _contract = PolyToken(solutions[i]);
                          }else if(i == 1) {
                              exchange = (solutions[i]);
                              addOperator(exchange);
                          }else if(i == 2) {
                              registry = (solutions[i]);
                            }
                    
                         }
                 }
            }
    }

function launchPolyCoin() public  {

  new PolyToken(exchange, operators, address(registerPoly), registry);
}
function setExchange (address exchangeContract) public returns (bool) {
    exchange = exchangeContract;
    addOperator(exchangeContract);
    return true;
}

function setPolyToken (address _PolyToken) public returns (bool) {
    _contract = PolyToken(_PolyToken);

    return true;
}
function addOperator (address operatorToAdd) public {

if(operatorToAdd != address(0)){
      operators.push(operatorToAdd);
}
  
}
     
}
    


    
