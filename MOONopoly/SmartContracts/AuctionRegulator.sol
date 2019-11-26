

pragma solidity >0.4.24 <0.6.0;

 import "browser/ERC777Flat.sol";
import "browser/PolyRegisterClient.sol";
   import "browser/ERC1820Client.sol";
import "browser/PolyToken.sol";
import "browser/auctionInterface.sol";
import "browser/ERC721Full.sol";

contract AuctionRegulator is IERC777Recipient, IERC777Sender, IERC721Receiver, ERC1820ClientWithPoly {
    
      bytes32 constant private ERC1820_ACCEPT_MAGIC = keccak256(abi.encodePacked("ERC1820_ACCEPT_MAGIC"));
 event TokensReceivedOnAuction (address operator, address _fromWho, string nameOfToken, uint amount, uint[] ids, bytes data, string _data, uint _globalId);

    
    mapping(address => uint) public balanceFrom; //amount send to this contract by
    
    struct paymentTicket {
        uint id;
        address tokenAddress;
        uint globalId;
        string tokenName; 
        uint tokenId;
        uint amount;
        uint[] tokenIds;
        address _from;
        address to;
        address operator;
        
        
        
    }
    
    mapping(uint => paymentTicket) public tickets;

    uint[] public allTickets;
    uint[] public tokensProcessed;

    
     
// ERC1820Registry register;
   //   PolyRegister public registerPoly;
      bool public allowTokensReceived;
    

   
    
     event OnCallbackEvent (uint[], address[], bool[]);
    event newContractSet (string name, address contractSet);
    
    
    constructor (address _PolyRegister) ERC1820ClientWithPoly(_PolyRegister) public {
         uint[] memory needs = new uint[](1);
     //   registerPoly = PolyRegister(_PolyRegister);
         needs[0] = uint(keccak256(abi.encodePacked("Registry")));
      //   needs[1] = uint(keccak256(abi.encodePacked("")));
      
              (bool[] memory boolSolutions, address[] memory solutions) = registerPoly.registerContract("AuctionRegulator", needs);
          if(solutions.length > 0) {
              
              for(uint i = 0; i<solutions.length;i++) {
                  if(boolSolutions[i]){
                      if(i == 0) {
              //            register = ERC1820Registry(solutions[i]);
                      }else if(i == 1) {
                     //     houseContract = Houses(solutions[i]);
                      }
                  }
     

                  
                  
              }
              
          }   
           (address[] memory contractsInNeed, uint[] memory hashesOfContractTypesinNeed) = registerPoly.fillOthersNeedsIfPossible(uint(keccak256(abi.encodePacked("AuctionRegulator"))), address(this));
         onCreationCallback(hashesOfContractTypesinNeed, contractsInNeed);
         setInter();
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
  
}
 function setInter () public {
     bytes32  implementorNameRec = keccak256(abi.encodePacked(this.onERC721Received.selector)); 
     bytes32 implementorNameTokens = keccak256(abi.encodePacked(this.tokensReceived.selector));
     bytes32 implementorNameSender = keccak256(abi.encodePacked(this.tokensToSend.selector));
  //  bytes32 test = bytes32(keccak256("onERC721Received(address,address,uint256,bytes)"));
//     bytes32 interfaceHash = keccak256(abi.encodePacked(implementorNameRec));
//     bytes32 interfaceHashToken = keccak256(abi.encodePacked(implementorNameTokens));
    setInterfaceImplementer(address(this),implementorNameRec, address(this));
   setInterfaceImplementer(address(this), implementorNameTokens, address(this));
   setInterfaceImplementer(address(this), implementorNameSender, address(this));
   setInterfaceImplementer(address(this),implementorNameRec, address(this));

    setInterfaceImplementation("IERC721Receiver", address(this));
    setInterfaceImplementation("ERC1820ClientWithPoly", address(this));
    setInterfaceImplementation("ERC777TokensRecipient", address(this));
    setInterfaceImplementation("AuctionRegulator", address(this));
    setInterfaceImplementation("ERC721Receiver", address(this));
    setInterfaceImplementation("ERC777TokensSender", address(this));
   
  
        allowTokensReceived = true;

}
   function canImplementInterfaceForAddress(bytes32 _interfaceHash, address _addr) external view returns(bytes32) {
        return ERC1820_ACCEPT_MAGIC;
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
  
    
        //do something after received
        
    }
    




    
function tokensToSend(
        address operator,
        address from,
        address to,
        uint256 amount,
        bytes calldata userData,
        bytes calldata operatorData
    ) external {

    
    
    
    
    
    
    PolyToken(registerPoly.typeAtaddress("PolyToken")).operatorSend(from, to, amount, userData, operatorData);
         
    }
    
  



         
    
    
function buyObject (uint globalId) public returns (address newOwner) {
    // require is object for sale
    require(PolyAuction(registerPoly.typeAtaddress("PolyAuction")).isAlreadyInAuction(globalId), "not for sale yet");
    
}

function tokensReceivedOnAuctionContract (address token, address operator, address from, uint256 tokenId, bytes memory data) public returns (bytes4) { //onlyAuction
    uint[] memory tokens = new uint[](1);
      tokens[0] = tokenId;
    string memory nameOfToken = ERC721Full(token).name();
    
    uint globalId = ERC721Full(token).getGlobalId(tokenId);
   uint ticketId = tokensProcessed.push(tokenId);
   paymentTicket memory newTicket = tickets[ticketId];
   tickets[ticketId].id = ticketId;
   tickets[ticketId].tokenName = nameOfToken;
   if(tokens.length == 1) {
          tickets[ticketId].tokenId = tokenId;
   }
   tickets[ticketId].amount = tokens.length;
   tickets[ticketId].tokenIds = tokens;
   tickets[ticketId]._from = from;
   tickets[ticketId].operator = operator;
   tickets[ticketId].tokenAddress = token;
   tickets[ticketId].globalId = globalId;
  
       
      
      emit TokensReceivedOnAuction (operator, from, nameOfToken, 1, tokens, data, string(data), globalId );
      
      return this.onERC721Received.selector;
}


function sendTokensERC721 (uint tokenId,  address tokenContract, address sender, address recipient) public {
    //note this contract must be approved
    ERC721Full(tokenContract).safeTransferFrom(sender, recipient, tokenId);
    
}


  function onERC721Received(address operator, address from, uint256 tokenId, bytes memory data) public returns (bytes4) {
      uint[] memory tokens = new uint[](1);
      tokens[0] = tokenId;
    string memory nameOfToken = ERC721Full(msg.sender).name();
    uint globalId = ERC721Full(msg.sender).getGlobalId(tokenId);
   uint ticketId = tokensProcessed.push(tokenId);
   paymentTicket memory newTicket = tickets[ticketId];
   tickets[ticketId].id = ticketId;
   tickets[ticketId].tokenName = nameOfToken;
   if(tokens.length == 1) {
          tickets[ticketId].tokenId = tokenId;
   }
   tickets[ticketId].amount = tokens.length;
   tickets[ticketId].tokenIds = tokens;
   tickets[ticketId]._from = from;
   tickets[ticketId].operator = operator;
   
  
       
      
      emit TokensReceivedOnAuction (operator, from, nameOfToken, 1, tokens, data, string(data), globalId );
      
      return this.onERC721Received.selector;
  }

/*
    function sellAnObject (uint globald, uint priceInTokens) public returns (uint auctionObjectNumber){
    
    require(objectManager.checkIfOwnerOfObject (globald, msg.sender),"you are not the owner of this object");
    
    
    
}
 function getDiscount (uint globalId) public returns (uint) {
    require(globalIdToAuctionObject[globalId].discountRequest != msg.sender, "you're already the last person to request a discount!");
    globalIdToAuctionObject[globalId].discountRequest = msg.sender;
    globalIdToAuctionObject[globalId].price = globalIdToAuctionObject[globalId].price - ((globalIdToAuctionObject[globalId].price)/100);
  if(globalIdToAuctionObject[globalId].price < 1000) { //min price
      globalIdToAuctionObject[globalId].price = 1000;
  }
}   
    
}function canBeSold (uint streetid) public view returns (bool) {
  uint totalPlots =  streetIdToStreetObject[streetid].plots.length;
  uint soldPlots = streetIdToStreetObject[streetid].soldPlots.length;
  
  if((soldPlots/totalPlots)*100 > 80){ 
      return true;
  }else{
      return false;
  }

   
    // the auction regulator should recceive all the coins of the auction contract in case some1 sends to the wrong contract.
    
  */
  
  
}
    
    