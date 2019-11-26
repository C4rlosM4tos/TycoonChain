pragma solidity >0.4.24 <0.6.0;

//needed by polytoken;

import "browser/ERC777Flat.sol";
import "browser/PolyToken.sol";
import "browser/ERC1820Register.sol";
//import "browser/GameRegister.sol";
import "browser/PolyRegister.sol";
import "browser/PolyLauncher.sol";


contract PolyExchange is IERC777Recipient {
  
  bytes32 constant private ERC1820_ACCEPT_MAGIC = keccak256(abi.encodePacked("ERC1820_ACCEPT_MAGIC"));
  
  
    event TokensBought (uint amount, uint price, uint totalSupply, uint stake);
      event TokensSold (uint amount, uint price, uint totalSupply, uint stake);
      event TokenContractChangedOnExchange (address newContract, string what, address byWho);
    event tokensReceivedOnExchange (uint amountOfTokens, address sender, address receiver, string message);
    
    uint public bal = address(this).balance;
    using SafeMath for uint;
         PolyRegister registerPoly;
    PolyToken public tokenContract;
    PolyLauncher public launcher;
    
    
    ERC1820Registry register;
    uint public totalSup;
    uint public rate;
    uint public rateXPolyFor1Eth;
    
    
     event OnCallbackEvent (uint[], address[], bool[]);
     event newContractSet (string name, address contractSet);
    
    
    bool private allowTokensReceived;

    mapping(address => address) public token;
    mapping(address => address) public operator;
    mapping(address => address) public from;
    mapping(address => address) public to;
    mapping(address => uint256) public amount;
    mapping(address => bytes) public data;
    mapping(address => bytes) public operatorData;
    mapping(address => uint256) public balanceOf;

    constructor(address _PolyRegister) public payable {
       
     
         uint[] memory needs = new uint[](3);
        registerPoly = PolyRegister(_PolyRegister);
         needs[0] = uint(keccak256(abi.encodePacked("PolyToken")));
         needs[1] = uint(keccak256(abi.encodePacked("PolyLauncher")));
          needs[2] = uint(keccak256(abi.encodePacked("Registry")));
              (bool[] memory boolSolutions, address[] memory solutions) = registerPoly.registerContract("PolyExchange", needs);
          if(solutions.length > 0) {
              
              for(uint i = 0; i<solutions.length;i++) {
                  if(boolSolutions[i]){
                      if(i == 0) {
                          tokenContract = PolyToken(solutions[i]);
                      }else if(i == 1) {
                          launcher = PolyLauncher(solutions[i]);
                      }else if (i == 2){
                          
                          register = ERC1820Registry(solutions[i]);
                      }
                  }
                  
                  
                  
              }
              
          }   
           (address[] memory contractsInNeed, uint[] memory hashesOfContractTypesinNeed) = registerPoly.fillOthersNeedsIfPossible(uint(keccak256(abi.encodePacked("PolyExchange"))), address(this));
         onCreationCallback(hashesOfContractTypesinNeed, contractsInNeed);
          setInter();
    }
        
        
        


    function tokensReceived(
        address _operator,
        address _from,
        address _to,
        uint256 _amount,
        bytes calldata _data,
        bytes calldata _operatorData
    )
        external
    {
        require(allowTokensReceived, "Receive not allowed");
        token[_to] = msg.sender;
        operator[_to] = _operator;
        from[_to] = _from;
        to[_to] = _to;
        amount[_to] = _amount;
        data[_to] = _data;
        operatorData[_to] = _operatorData;
      balanceOf[_from] = tokenContract.balanceOf(_from);
      balanceOf[_to] = tokenContract.balanceOf(_to);
      
      emit tokensReceivedOnExchange (_amount, msg.sender, address(this), string(_data));
      
    }

    function acceptTokens() public  { allowTokensReceived = true; }

    function rejectTokens() public  { allowTokensReceived = false; }

   
    function canImplementInterfaceForAddress(bytes32 _interfaceHash, address _addr) external view returns(bytes32) {
        return ERC1820_ACCEPT_MAGIC;
    }
    
function setTokenContract (address _tokenContract) public returns (bool) {
    
        tokenContract = PolyToken(_tokenContract);
       emit TokenContractChangedOnExchange (_tokenContract, "TokenContractChangedOnExchange", msg.sender); 
        
        return true;
} function setInter () public {
   string memory implementorName = "ERC777TokensRecipient";
     bytes32 interfaceHash = keccak256(abi.encodePacked(implementorName));
      register.setInterfaceImplementer(address(this),interfaceHash, address(this)); 
        allowTokensReceived = true;
}



 function getTotalSup () public returns (uint) {
     
     
      
    totalSup = tokenContract.totalSupply();
    
    return totalSup;
     
 }  
 
 function getPriceToBuyTokens(uint amount) public returns (uint) {
     
      uint sup = tokenContract.totalSupply();
  uint priceToBuyX =1 + (address(this).balance * amount)/sup;  //pay for potential future growth of the stake (as it growth with each block given no burns and no mints)
  
 

require(priceToBuyX > 1 wei, "you need to buy more tokens! price too low to handle");     
   
      return priceToBuyX;
  }
     
     
 
 
 
 
  function getPriceToSellTokens(uint amount) public  returns (uint) { //
  uint sup = tokenContract.totalSupply();
 require(sup > 1 && address(this).balance >1);
  uint TokensValue = ((address(this).balance-10) / (sup))*amount; // value in wei 

require(TokensValue > 1 wei, "you need to sell more tokens!");     
     if(TokensValue <= 0) {
       
     }else{
     return TokensValue;
  }
 }
  function fund() public payable returns (uint) {
      
      
      
      
      return address(this).balance + msg.value;
  }
    
    
 function buyTokens (uint amount) public payable returns (uint) { //get price back

    uint price = getPriceToBuyTokens(amount); 
    require(msg.value >= price, "you need to pay more!"); 
    tokenContract.mint(msg.sender, amount);
    
    
    uint restMoney = msg.value - price;
    if(restMoney > 0){
        
        msg.sender.transfer(restMoney);
    }
    
    uint newSupply = tokenContract.totalSupply();
    uint stake = address(this).balance;
     emit TokensBought (amount, price, newSupply, stake);
     
     return price;
     
 }
 
 function sellTokens (uint amount) public payable {
    uint bal = tokenContract.balanceOf(msg.sender);
     uint priceToReceive =getPriceToSellTokens(amount);
     
   //  require(bal >= amount, "you don't have enough tokens");
  
    
    tokenContract.operatorBurn(msg.sender, amount, "", "");
  // todo, call for payout of burn to stake first, selling causes missing out on the payout
  msg.sender.send(priceToReceive);
     
 }

  
  function approve () public {
      
      tokenContract.authorizeOperator(address(this));
  }
      
  
    function viewBal() public view returns (uint) {
      
      return address(this).balance;
  }
     
   function onCreationCallback(uint[] memory hashOfType, address[] memory contractsInNeedOfThis) public returns (bool[] memory) {
        bool[] memory answers = new bool[](contractsInNeedOfThis.length);
            for(uint i = 0; i < contractsInNeedOfThis.length;i++) {
                uint hash = hashOfType[i];
                address foundAt = contractsInNeedOfThis[i];
                
                answers[i] = (checkHash(hash, foundAt));
         //       testCallOwn.push(answers[i]);
                
                
            }
         emit OnCallbackEvent (hashOfType, contractsInNeedOfThis, answers);
       
         return answers;
        }
function checkHash (uint hash, address foundAt ) public returns (bool) {
    
    uint hashToken = uint(keccak256(abi.encodePacked("PolyToken")));
    uint hashLauncher = uint(keccak256(abi.encodePacked("PolyLauncher")));
    if (hash == hashToken) {
        tokenContract = PolyToken(foundAt);
     bool answer = tokenContract.setExchange(address(this));
          emit newContractSet ("PolyToken", foundAt);
         return answer;
    }
    if( hash == hashLauncher) {
        launcher = PolyLauncher(foundAt);
        launcher.setExchange(address(this));
    }
    

}
    
}
    
    
    
