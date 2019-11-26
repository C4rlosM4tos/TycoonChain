pragma solidity >0.4.24 <0.6.0;

import "browser/ERC777Flat.sol";
import "browser/PolyExchange.sol";
  import "browser/PolyRegister.sol";
  import "browser/PolyLauncher.sol";
  import "browser/PolyMovement.sol";
  import "browser/ERC1820Register.sol";
  import "browser/PolyAuction.sol";

contract PolyToken is ERC777 {
    
  
    PolyLauncher launcher;
 
    event tokensMinted (uint amount, address receiver);
    event EchangeContractChangedOnPolyToken (address newcontract, string what, address byWho);
    PolyExchange exchange;

    mapping(address => bool) private minters;
    address public admin;
    address public token;
    PolyRegister registerPoly;
    
    event OnCallbackEvent (uint[], address[], bool[]);
    event newContractSet (string name, address contractSet);
    
    modifier onlyDefaultOperators {
        require(minters[msg.sender], "the caller does not have the rights to mint");
        _;
    }
    
 

    uint256 public constant initialSupply = 1*10**18;
    
    

    constructor (address _exchange, address[] memory ops, address _PolyRegister,address _registry) public ERC777("Moon", "MOON", ops, _registry) {
    admin = tx.origin;
           uint[] memory needs = new uint[](3);
        registerPoly = PolyRegister(_PolyRegister);
         needs[0] = uint(keccak256(abi.encodePacked("PolyExchange")));
        needs[1] = uint(keccak256(abi.encodePacked("PolyLauncher")));
           needs[2] = uint(keccak256(abi.encodePacked("PolyAuction")));
           for (uint i = 0; i < ops.length; i++) {
               minters[ops[i]] = true;
           }
           
      
              (bool[] memory boolSolutions, address[] memory solutions) = registerPoly.registerContract("PolyToken", needs);
          if(solutions.length > 0) {
              
              for(uint i = 0; i<solutions.length;i++) {
                  if(boolSolutions[i]){
                      if(i == 0) {
                         exchange = PolyExchange(solutions[i]);
                      }else if(i == 1) {
                         launcher = PolyLauncher(solutions[i]);
                      }
                     
                  }
                  
                  
                  
              }
              
          }   
           (address[] memory contractsInNeed, uint[] memory hashesOfContractTypesinNeed) = registerPoly.fillOthersNeedsIfPossible(uint(keccak256(abi.encodePacked("PolyToken"))), address(this));
         onCreationCallback(hashesOfContractTypesinNeed, contractsInNeed);
        _mint(_exchange, tx.origin, initialSupply, "", "");   // erc1820 not at correct address! 
    }
    
      
    
function mint (address receiver,uint amount) public onlyDefaultOperators {
    
    address adres = msg.sender;
    emit tokensMinted (amount, receiver);
 
    _mint((adres), receiver, amount, "", "");
    
}

function setExchange (address _exchange) public returns (bool) {

    exchange = PolyExchange(_exchange);
    
    return true;
    
}
function getBal (address who) public view returns (uint) {
    
    return balanceOf(who);
}

    
 function onCreationCallback(uint[] memory hashOfType, address[] memory contractsInNeedOfThis) public returns (bool[] memory) {
        bool[] memory answers = new bool[](contractsInNeedOfThis.length);
            for(uint i = 0; i < contractsInNeedOfThis.length;i++) {
                uint hash = hashOfType[i];
                address foundAt = contractsInNeedOfThis[i];
                
                answers[i] = (checkHash(hash, foundAt));
      
                
            }
         return answers;
        }
function checkHash (uint hash, address foundAt ) public returns (bool) {
    
    uint hashExchange = uint(keccak256(abi.encodePacked("PolyExchange")));
   uint hashLauncher = uint(keccak256(abi.encodePacked("PolyLauncher")));
   uint hashMovement = uint(keccak256(abi.encodePacked("PolyMovement")));
    uint hashAuction = uint(keccak256(abi.encodePacked("PolyAuction")));
    if (hash == hashExchange) {
        exchange = PolyExchange(foundAt);
     bool answer = exchange.setTokenContract(address(this));
  
    }
    if( hash == hashLauncher ){
        launcher = PolyLauncher(foundAt);
        bool answer = launcher.setPolyToken(address(this));
 
        
    }if(hash == hashMovement) {
     
    bool answer = PolyMovement(foundAt).setTokenContract(address(this));
          
         return answer;
    }if(hash == hashAuction) {
  
    bool answer = PolyAuction(foundAt).setTokenContract(address(this));
   
        
    }
    

}

  




}  
    

    
 

    
    
    
    


    
