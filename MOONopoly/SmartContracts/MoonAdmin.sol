

pragma solidity >0.4.24 <0.6.0;

import "browser/ERC777Flat.sol";
import "browser/PolyRegister.sol";
import "browser/ERC1820Register.sol";
import "browser/PolyToken.sol";
import "browser/MovementInterface.sol";
import "browser/ERC721Full.sol"; 

contract MoonAdmin is IERC777Recipient, IERC777Sender, IERC721Receiver {
    
    uint public totalProccessed;
   

      bytes32 constant private ERC1820_ACCEPT_MAGIC = keccak256(abi.encodePacked("ERC1820_ACCEPT_MAGIC"));
  
    
    mapping(address => uint) public balanceFrom; //amount send to this contract by
    mapping(address => bool) public donator;
    
    struct paymentTicket {
        uint id;
        address operator;
        address _from;
        address _to;
        uint amount;
        string userData;
        bytes dataUser;
        string operatorData;
        bytes dataOperator;
        uint timestamp;
        bool receive;
        

    }
    
    mapping (uint => paymentTicket) public tickets;
    
    uint[] public allTicketsAmountsArray;
    uint[] public allTicketIdsArray;
    
    
     
      ERC1820Registry register;
      PolyRegister public registerPoly;
      bool public allowTokensReceived;
    
    mapping(bytes4 => bool) public supportedInterfaces;
 
   

    
    mapping(uint => uint) public jackpotOnBoard;
    
   

 
    event newContractSet (string name, address contractSet);
   
    constructor (address _PolyRegister) public {
         uint[] memory needs = new uint[](1);
        registerPoly = PolyRegister(_PolyRegister);
         needs[0] = uint(keccak256(abi.encodePacked("Registry")));

      
              (bool[] memory boolSolutions, address[] memory solutions) = registerPoly.registerContract("MoonAdmin", needs);
          if(solutions.length > 0) {
              
              for(uint i = 0; i<solutions.length;i++) {
                  if(boolSolutions[i]){
                      if(i == 0) {
                          register = ERC1820Registry(solutions[i]);
                      }
                  }
     

                  
                  
              }
              
          }   
                   setInter();
    }
   
   function canImplementInterfaceForAddress(bytes32 _interfaceHash, address _addr) external view returns(bytes32) {
        return ERC1820_ACCEPT_MAGIC;
    }



function supportsInterface(bytes4 InterfaceId) public view returns (bool) {
    
    return supportedInterfaces[InterfaceId];
    
}

 function setInter () public {
    MoonAdmin moon;

   
  

     
     string memory implementorNameRec = "ERC777TokensRecipient";
     string memory implementorNameSend ="ERC777Sender";
     bytes32 interfaceHash = keccak256(abi.encodePacked(implementorNameRec));
     bytes32 interfaceHash2 =keccak256(abi.encodePacked(implementorNameSend));
    register.setInterfaceImplementer(address(this),interfaceHash, address(this));
    register.setInterfaceImplementer(address(this),interfaceHash2, address(this)); 
     string memory implementorNameTokens = "IERC721Receiver";
          bytes32 interfaceHashToken = keccak256(abi.encodePacked(implementorNameTokens));
 register.setInterfaceImplementer(address(this),interfaceHashToken, address(this)); 

        allowTokensReceived = true;
//register.setInterfaceImplementer(address(this),interfaceTest, address(this)); 
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
 

 
 
    uint ticketId = allTicketsAmountsArray.push(_amount);
    paymentTicket memory newPaymentTicket = tickets[ticketId];
    tickets[ticketId].id = ticketId;
    tickets[ticketId]._from = _from;
    tickets[ticketId]._to = _to;
    tickets[ticketId].operator = _operator;
    tickets[ticketId].amount = _amount;
    tickets[ticketId].userData = string(_data);
    tickets[ticketId].dataUser = _data;
    tickets[ticketId].operatorData = string(_operatorData);
    tickets[ticketId].dataOperator = _operatorData;
    tickets[ticketId].receive = true;
    tickets[ticketId].timestamp = now;
    
      if (uint(keccak256(abi.encodePacked(_operatorData))) == uint(keccak256(abi.encodePacked("MoonNpcForward")))){
            if(_to == address(this) && tickets[ticketId].receive ){ 
          balanceFrom[_from] += _amount; 
          donator[_from] = true;
          PolyToken(registerPoly.typeAtaddress("PolyToken")).approve(_from, balanceFrom[_from]);
             }
      }
  
     
    allTicketIdsArray.push(ticketId);
    
    if (uint(keccak256(abi.encodePacked(_operatorData))) == uint(keccak256(abi.encodePacked("MoonCard")))){
        uint hash = uint(keccak256(abi.encodePacked(_data)));
        uint boardId = MovementInterface(registerPoly.typeAtaddress("PolyMovementExtension")).getBoardFromHash(hash);
       jackpotOnBoard[boardId] += _amount; 
        
    }
    
    
        //do something after received
        //call 
    }
    
function addToJackpot (uint boardId, uint amount) public returns (uint) {
    //restrict access
    
    jackpotOnBoard[boardId] += amount;
    
    return jackpotOnBoard[boardId];
}
    
function getTickets () public view returns (uint[] memory) {
    
    return allTicketIdsArray;
    
}
   
  
 
    
function tokensToSend(
        address operator,
        address from,
        address to,
        uint256 amount,
        bytes calldata userData,
        bytes calldata operatorData
    ) external {

   
   
    uint ticketId = allTicketsAmountsArray.push(amount);
    paymentTicket memory newPaymentTicket = tickets[ticketId];
    tickets[ticketId].id = ticketId;
    tickets[ticketId]._from = from;
    tickets[ticketId]._to = to;
    tickets[ticketId].operator = operator;
    tickets[ticketId].amount = amount;
    tickets[ticketId].userData = string(userData);
    tickets[ticketId].operatorData = string(operatorData);
    tickets[ticketId].receive = false;
    tickets[ticketId].timestamp = now;
    tickets[ticketId].dataUser = userData;
    tickets[ticketId].dataOperator = operatorData;
    allTicketIdsArray.push(ticketId); 
    
     
    totalProccessed += amount;

    
     
    
    PolyToken(registerPoly.typeAtaddress("PolyToken")).operatorSend(from, to, amount, userData, operatorData);
         
    }
    
   function onERC721Received(address operator, address from, uint256 tokenId, bytes memory data)  public returns (bytes4) {
     return  this.onERC721Received.selector;
   }

 

   
function sendTokens (uint amount, string memory message) public { //only owner
    bytes memory data = abi.encodePacked(message);
    bytes memory _operatorData = abi.encodePacked("Admin stake payout");
    
    require(balanceFrom[msg.sender] - amount > 0, "withdrawal not allowed, not enough balance");
    balanceFrom[msg.sender] -=amount;
    uint ticketId = allTicketsAmountsArray.push(amount);
    paymentTicket memory newPaymentTicket = tickets[ticketId];
    tickets[ticketId].id = ticketId;
    tickets[ticketId]._from = address(this);
    tickets[ticketId]._to = msg.sender;
    tickets[ticketId].operator = msg.sender;
    tickets[ticketId].amount = amount;
    tickets[ticketId].userData = message; 
    tickets[ticketId].operatorData = string(_operatorData);
    tickets[ticketId].receive = false;
    tickets[ticketId].timestamp = now;
    
    allTicketIdsArray.push(ticketId);
    
    
    PolyToken(registerPoly.typeAtaddress("PolyToken")).approve(msg.sender, balanceFrom[msg.sender]);
    PolyToken(registerPoly.typeAtaddress("PolyToken")).operatorSend(address(this), msg.sender, amount, data, _operatorData); 
    
}






         
 
    
}

   
    
    
    
    
    