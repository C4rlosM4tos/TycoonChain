pragma solidity >0.4.24 <0.6.0;


import "browser/ERC777Flat.sol";
import "browser/streetsInterface.sol";
import "browser/plotsInterface.sol";
import "browser/auctionInterface.sol";
import "browser/housesInterface.sol";
import "browser/ERC1820Client.sol";
import "browser/PolyToken.sol";
import "browser/objectManagerInterface.sol";
import "browser/PolyPlayer.sol";
import "browser/ERC721Full.sol";
import "browser/PolyRegisterClient.sol";

import "browser/AuctionRegulator.sol";
 
contract MoonAuction is IERC721Receiver, ERC1820ClientWithPoly { 
    
    
    
    
    mapping(address => uint) receivedFrom;
    
    Streets public streetContract;
    Houses public houseContract;
    objectManagerInterface public objectManager;

    
    event OnCallbackEvent (uint[], address[], bool[]);
    event newContractSet (string name, address contractSet);
    event NewAuctionCreated (uint globalId, string name, uint auctionNumber);
    // event ObjectSold (uint globalId, string name, uint price, address newOwner);
    
   
    bool private allowTokensReceived;  
    uint public auctionNumber;
    PolyToken public tokenContract;
    
    modifier onlyAuctionRegulator {
        require(msg.sender == registerPoly.typeAtaddress("AuctionRegulator"), "caller is not the regulator");
        _;
    }
     
    struct object {
        
        uint globalId;
        uint auctionNumber; 
        uint tokenId;
        address tokenContract; //tokencontract
        string TokenName;
        uint HashOfName;
        mapping(uint =>mapping(uint => uint)) locationOfItem;
        uint price;
        address currentOwner;
        bool sold;
        address discountRequest;
        bool NoDiscounts;
  
    }
    
    
  
    mapping(uint => uint) auctionNumberToGlobalId;
    mapping(uint => object) public globalIdToAuctionObject;

   
       mapping(uint => bool) public isAlreadyInAuction; // globalId
  
   bytes32 constant private ERC1820_ACCEPT_MAGIC = keccak256(abi.encodePacked("ERC1820_ACCEPT_MAGIC"));

 


    uint[] public allAuctionNumbers;
    uint[] public allObjectIdsArray;
    
    mapping(uint => uint) public boardStreetsAreInRoom;
    
    constructor (address _PolyRegister) ERC1820ClientWithPoly(_PolyRegister) public {
            uint[] memory needs = new uint[](4); 
        registerPoly = PolyRegisterClient(_PolyRegister);
         needs[0] = uint(keccak256(abi.encodePacked("Streets")));
         needs[1] = uint(keccak256(abi.encodePacked("Registry")));
         needs[2] = uint(keccak256(abi.encodePacked("Houses")));
        needs[3] = uint(keccak256(abi.encodePacked("ObjectManager")));
              (bool[] memory boolSolutions, address[] memory solutions) = registerPoly.registerContract("PolyAuction", needs);
          if(solutions.length > 0) {
              
              for(uint i = 0; i<solutions.length;i++) {
                  if(boolSolutions[i]){
                      if(i == 0) {
                       //   streetContract = streetsInterface(solutions[i]);
                      }else if(i == 1) {
                 //         register = ERC1820Registry(solutions[i]);
                      }else if(i == 2) {
                          houseContract = Houses(solutions[i]);
                  }else if(i == 3) {
                          objectManager = objectManagerInterface(solutions[i]);
                  }

              }
              
          }   
           (address[] memory contractsInNeed, uint[] memory hashesOfContractTypesinNeed) = registerPoly.fillOthersNeedsIfPossible(uint(keccak256(abi.encodePacked("PolyAuction"))), address(this));
         onCreationCallback(hashesOfContractTypesinNeed, contractsInNeed);
         setInter();
    }
    
    }  
  
 function canImplementInterfaceForAddress(bytes32 _interfaceHash, address _addr) external view returns(bytes32) {
        return ERC1820_ACCEPT_MAGIC;
    }  
    
    
    
    

function createNewAuction (uint globalId) public returns (uint) {
    
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
        
function checkIfStreet (string memory typeOfObject, string memory typeToCheck) public view returns (bool) {
    uint hashInput = uint(keccak256(abi.encodePacked(typeOfObject)));
    uint hashToCheck = uint(keccak256(abi.encodePacked(typeToCheck)));
    
    if(hashInput == hashToCheck) {
        return true;
    }else{
        return false;
    }
    
    
}

function checkHash (uint hash, address foundAt ) public returns (bool) {
    
    uint hashHouse = uint(keccak256(abi.encodePacked("Houses")));
   uint hashStreets = uint(keccak256(abi.encodePacked("Streets")));
    if (hash == hashHouse) {
     bool answer = Houses(foundAt).setAuctionContract(address(this));
          
         return answer;
    }if (hash == hashStreets) {
  //   bool answer = streetsInterface(foundAt).setAuctionContract(address(this));
          
  //       return answer;
    }

    

    
}

//function setInter () public {
    /*
     string memory implementorName = "ERC777TokensRecipient";
     bytes32 interfaceHash = keccak256(abi.encodePacked(implementorName));
      setInterfaceImplementer(address(this),interfaceHash, address(this)); 
        allowTokensReceived = true;
        _registerInterface(this.onERC721Received.selector);
        string memory implementorName2 = "onERC721Received";
     bytes32 interfaceHash2 = keccak256(abi.encodePacked(implementorName));
      register.setInterfaceImplementer(address(this),interfaceHash2, address(this)); 
        allowTokensReceived = true;
        */
        
function setInter () public {

     bytes32  implementorNameRec = keccak256(abi.encodePacked(this.onERC721Received.selector)); 
setInterfaceImplementer(address(this),implementorNameRec, address(this));
    setInterfaceImplementation("PolyAuction", address(this));
    setInterfaceImplementation("IERC721Receiver", address(this));
    setInterfaceImplementation("ERC1820ClientWithPoly", address(this));
    setInterfaceImplementation("ERC777TokensRecipient", address(this));
    
    
//}
}

function setTokenContract (address _tokenContract) public returns (bool) {
    tokenContract = PolyToken(_tokenContract);
    

    return true;
}
function setHouseContract (address newcontract) public returns (bool) {
    
    houseContract = Houses(newcontract);
    
    return true;
}
function setObjectManager (address objectManagerContract) public returns (bool) {
    
    objectManager = objectManagerInterface(objectManagerContract);
    return true;
    
} 

function setStartPrice (uint globalId) internal returns (uint) {
  uint hashQuestion =  objectManager.getHashOfObjectType(globalId);
  string memory readableType = objectManager.getTypeOfObject(globalId);
        uint[3] memory cases =[(uint(keccak256(abi.encodePacked("Street")))),(uint(keccak256(abi.encodePacked("Plot")))),(uint(keccak256(abi.encodePacked("House"))))];
     
       if(hashQuestion == cases[0]){
  //    return setPriceForStreet(globalId);
       }
     if(hashQuestion == cases[1]){
         return setPriceForPlot(globalId);
     } if(hashQuestion == cases[2]){
         return 100000;
     }
}
function setPriceForHouse (uint globalId) internal returns (uint) {
    uint houseId = objectManager.getIdWithinTheType(globalId);
    uint tier = houseContract.getTier(houseId);
      return (globalIdToAuctionObject[globalId].price = 100000*(tier*10));
} 

function setPriceForPlot (uint globalId) internal returns (uint) {
  
     uint plotId = objectManager.getIdWithinTheType(globalId);
     uint streetId = Plots(registerPoly.typeAtaddress("Plots")).getStreet(plotId);
     uint location = streetContract.getLocationOnBoard(streetId);
     uint tier =Plots(registerPoly.typeAtaddress("Plots")).getTier(globalId);
    
      return (globalIdToAuctionObject[globalId].price = 1000*(tier+1)+ tier*location);
}


function buyObject (uint globalId, address buyer) public onlyAuctionRegulator  { // only auctionREgulator should be able to call this
    globalIdToAuctionObject[globalId].sold = true;
    globalIdToAuctionObject[globalId].currentOwner = buyer;
    isAlreadyInAuction[globalId]= false;

}
function getPrice (uint globalId) public view returns (uint) {
 return globalIdToAuctionObject[globalId].price;
}

function setPrice (uint globalId, uint price) public onlyAuctionRegulator {
    globalIdToAuctionObject[globalId].price = price;
}


 function onERC721Received(address operator, address from, uint256 tokenId, bytes memory data) public returns (bytes4) {
      
      ERC721Full(msg.sender).approve(registerPoly.typeAtaddress("AuctionRegulator"), tokenId);   //setApprovalForAll(registerPoly.typeAtaddress("AuctionRegulator"), true);
      
    uint globalId = ERC721Full(msg.sender).getGlobalId(tokenId);
       string memory name = ERC721Full(msg.sender).name();
     uint hashName = uint(keccak256(abi.encodePacked(name)));
     if(msg.sender == registerPoly.typeAtaddress(name)){
         //supported coin
         if(msg.sender == registerPoly.typeAtaddress("Streets")) {
             uint boardId = Streets(registerPoly.typeAtaddress("Streets")).getBoard(tokenId);
             
             
         }else{
          uint _auctionId = createNewAuction(globalId);//, name, hashName, from, tokenId);
         }
          
     }else{
         //token unknown
     }
     
      //unknow token
      
      //forward to
     data = abi.encodePacked(data, "received by Auction and forwarded to the regulator");
      
      AuctionRegulator(registerPoly.typeAtaddress("AuctionRegulator")).tokensReceivedOnAuctionContract(msg.sender ,operator, from, tokenId, data);
 
      return bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"));
  }
}


 
   
 