pragma solidity >0.4.24 <=0.6.0;

import "browser/ERC721Full.sol";
import "browser/plotsInterface.sol";
import "browser/boardsInterface.sol";
import "browser/ERC1820Client.sol";
import "browser/DataClient.sol";
 
    
contract Streets is ERC1820ClientWithPoly, IERC721Receiver {  
   bytes32 constant private ERC1820_ACCEPT_MAGIC = keccak256(abi.encodePacked("ERC1820_ACCEPT_MAGIC"));
  
    uint base = 10;
    

    

    
    
    constructor ( address _PolyRegister) public ERC1820ClientWithPoly (_PolyRegister) {
         uint[] memory needs = new uint[](4);
      setPoly(_PolyRegister);
       setRegistry(registerPoly.typeAtaddress("Registry"));
         needs[0] = uint(keccak256(abi.encodePacked("Plots")));
         needs[1] = uint(keccak256(abi.encodePacked("Houses")));
         needs[2] = uint(keccak256(abi.encodePacked("PolyObjectManager")));
          needs[3] = uint(keccak256(abi.encodePacked("PolyAuction")));
              (bool[] memory boolSolutions, address[] memory solutions) = registerPoly.registerContract("Streets", needs);
          if(solutions.length > 0) {
              
              for(uint i = 0; i<solutions.length;i++) {
                  if(boolSolutions[i]){
                      if(i == 0) {
               
                      }else if(i == 1) {
                   
                      }else if(i == 2) {
               
                  }else if(i == 3) {
                
                  }
                  
         
              }
              
          }   
           (address[] memory contractsInNeed, uint[] memory hashesOfContractTypesinNeed) = registerPoly.fillOthersNeedsIfPossible(uint(keccak256(abi.encodePacked("Streets"))), address(this));
 
        setInter();
      
        
      }
      
       
    }
    
    
    struct street {
        uint id;
        uint tier;
        uint board;
        uint LocationOnTheBoard;
        uint set;
        string color;
        uint[] soldPlots;
        string name;
        uint rent;

        plotsInterface.plot[] _plotObjects;
        uint[] plots; 

        address Mayor;
        address Governor;
    }
    
    mapping(uint => street) public streetIdToStreetObject;
    mapping(uint =>mapping(uint => street))public StreetAtLocation; 
    mapping(uint => uint)public streetIdToBoardNumber;

    
    street[] public allStreetsArray;
    string[] public allStreetsByName;
    uint[] public allStreetIdsArray;
    uint[] public rents;
    

    mapping(uint => mapping(uint => uint)) public locationOnBoardHoldsStreet; 
    mapping(uint => plotsInterface.plot) public plots;

event newPlotReceived (uint id, uint globalId, uint boardId, uint streetId, address _from);


function getStreetDetails (uint streetId) public view returns (uint, uint, uint, uint, uint) {
    
    
    return (streetIdToStreetObject[streetId].id,
    streetIdToStreetObject[streetId].tier,
    streetIdToStreetObject[streetId].board,
    streetIdToStreetObject[streetId].LocationOnTheBoard,
    streetIdToStreetObject[streetId].set);
    
    
}

function getStreetDetailsSecond (uint streetId) public view returns(string memory, uint[]  memory, uint[] memory,  address,  address ){
     return ( 
    streetIdToStreetObject[streetId].color,
    streetIdToStreetObject[streetId].soldPlots,


    streetIdToStreetObject[streetId].plots,
    streetIdToStreetObject[streetId].Mayor,
    streetIdToStreetObject[streetId].Governor);
}


function setInter () public {
bytes32  implementorNameRec = keccak256(abi.encodePacked(this.onERC721Received.selector)); 
setInterfaceImplementer(address(this),implementorNameRec, address(this));
 
    setInterfaceImplementation("Streets", address(this));
    setInterfaceImplementation("IERC721Receiver", address(this));
    setInterfaceImplementation("ERC1820ClientWithPoly", address(this));
    
    
} 
 function canImplementInterfaceForAddress(bytes32 _interfaceHash, address _addr) external view returns(bytes32) {
        return ERC1820_ACCEPT_MAGIC;
    }   


function _setMayor (uint streetId) public returns (address) {
   uint mostPlots;
   
   
   plotsInterface.plot[] memory plotsArray = streetIdToStreetObject[streetId]._plotObjects;
   if(plotsArray.length < 2) {
       return address(this);
   }else {
       // check mayor
       
   }
   
    
    
}
function createNewStreet (uint tier, uint boardId, uint LocationOnTheBoard) public  returns (uint) { 
 require(locationOnBoardHoldsStreet[boardId][LocationOnTheBoard] == 0, "location already has a street");
 string memory name = string(abi.encodePacked(boardId, LocationOnTheBoard));
    string memory color = getColor(LocationOnTheBoard);
    require(uint(keccak256(abi.encodePacked(color))) != uint(keccak256(abi.encodePacked(""))), "this location cannot have a street");
      bytes memory _color = bytes(color);
        if(_color.length <= 1){
          
        }else{
     
        uint streetId = allStreetsByName.push(name);
 
  
     streetIdToStreetObject[streetId].id = streetId;
  
     streetIdToStreetObject[streetId].tier = tier;
     streetIdToStreetObject[streetId].LocationOnTheBoard = LocationOnTheBoard;
     streetIdToStreetObject[streetId].color = color;
     streetIdToStreetObject[streetId].name = name;
     streetIdToStreetObject[streetId].set = getSet(LocationOnTheBoard);
     streetIdToStreetObject[streetId].board = boardId;
                 

     uint rent = calculateRent(streetId,tier, LocationOnTheBoard);
    
 locationOnBoardHoldsStreet[boardId][LocationOnTheBoard]=streetId;
         StreetAtLocation[boardId][LocationOnTheBoard]=streetIdToStreetObject[streetId];
       streetIdToBoardNumber[streetId] = boardId;
       allStreetsArray.push(streetIdToStreetObject[streetId]);
       allStreetIdsArray.push(streetId);
    

       return streetId;
        
       
        }
        
}  
function getSet (uint LocationOnTheBoard) public pure returns (uint) {
    
 
    uint i = LocationOnTheBoard;
    if((i == 1 || i == 3))                 {return 1;}
    else if(i == 6 || i == 8 || i == 9)    {return 2;}
    else if(i == 11 || i == 13 || i ==14 ) {return 3;}
    else if(i == 16 || i == 18 || i ==19 ) {return 4;}
    else if(i == 21 || i == 23 || i ==24 ) {return 5;}
    else if(i == 26 || i == 27 || i ==29 ) {return 6;}
    else if(i == 31 || i == 32 || i ==34 ) {return 7;}
    else if(i == 37 || i == 39)            {return 8;}
    else if(i == 12 || i == 28)            {return 9;}
    else{
        return 0;
        }    
    
 
}
function calculateCostToOpen (uint streetId,uint tier, uint i, uint rent) internal returns (uint) {
  uint maxPlots = 1 + streetIdToStreetObject[streetId].plots.length; 
    return ((((i+10)/10)*tier*base)+(i*tier))+((base*tier+i)+rent+(maxPlots*(tier*10)+(i*10)));
}
function calculateRent (uint streetId, uint tier, uint i) internal returns (uint) {
  uint maxPlots = 1 + streetIdToStreetObject[streetId].plots.length; 
  uint boostTier = tier * 10;
  uint rent = (((base*boostTier*tier) + ((((boostTier+(i*boostTier))+(base*tier))+((i+tier+base)) )) - ((maxPlots+i+(tier*base)))));
 
    return rent;
} 
function getColor (uint LocationOnTheBoard) public pure returns (string memory) {
    
    bool station; 
    if((LocationOnTheBoard%10 == 0) || (LocationOnTheBoard%5 == 0)){
        
        station = true; 
    }else{
        station = false;  
    }
    if(!station){
        return giveColor(LocationOnTheBoard);
        
        
        
        
    }
    
    
    
}
function getMaxPlots (uint streetId) public view returns (uint) {
    
   return streetIdToStreetObject[streetId].plots.length;
}
function giveColor (uint LocationOnTheBoard) public pure returns(string memory) {
  
    uint i = LocationOnTheBoard;
    if((i == 1 || i == 3)){
        
        return "Sienna";  // brown
    }else if(i == 6 || i == 8 || i == 9) {
        return "DeepSkyBlue ";
    }else if(i == 11 || i == 13 || i ==14 ) {
        return "MediumVioletRed";
    }else if(i == 16 || i == 18 || i ==19 ) {
        return "Orange"; 
        
    }else if(i == 21 || i == 23 || i ==24 ) {
        return "Red";
        
    }
        
    else if(i == 26 || i == 27 || i ==29 ) {
            return "Yellow";
    }else if(i == 31 || i == 32 || i ==34 ) {
            return "Green";
    }else if(i == 37 || i == 39) {
            return "MediumBlue";
    }else if(i == 12 || i == 28){
        return "LightGrey"; 
    }else{
        return "";
        }    
    
 
    
}
function getStreet (uint streetId) public view returns (uint, uint, uint, uint, string memory, uint) {
    
    uint tier = streetIdToStreetObject[streetId].tier;
    uint rent = streetIdToStreetObject[streetId].rent;
    uint board = streetIdToStreetObject[streetId].board;
    uint LocationOnTheBoard = streetIdToStreetObject[streetId].LocationOnTheBoard;
    string memory color = streetIdToStreetObject[streetId].color;
    uint plots = streetIdToStreetObject[streetId].plots.length;
   
   
   
    return (tier, rent, board, LocationOnTheBoard, color, plots);
    
}
function setNameOfStreet (uint streetId, string memory name) public returns (string memory) {
 
     
     streetIdToStreetObject[streetId].name = name;
   return streetIdToStreetObject[streetId].name;
}
function random(uint nonce) public view returns(uint) {
     uint num = uint(tx.origin);
     uint _nonce = nonce+block.number+num;
     

        
        return uint(keccak256(abi.encodePacked(_nonce)));
    }
function getTier (uint streetId) public view returns (uint) {
    
    return streetIdToStreetObject[streetId].tier;
}
function getBoard (uint streetid) public view returns (uint) {
    return streetIdToStreetObject[streetid].board;
}
function getLocationOnBoard (uint streetId) public view returns (uint) {
    return streetIdToStreetObject[streetId].LocationOnTheBoard;
} 
function getPlotsIds(uint streetid) public view returns (uint[] memory) {
    uint[] memory plotIdsToReturn = streetIdToStreetObject[streetid].plots;
    
    return plotIdsToReturn;
    
}
function getSoldPlots(uint streetid) public view returns(uint[] memory) {
    return streetIdToStreetObject[streetid].soldPlots;
}
function getOwnerOfStreet(uint streetid) public view returns (address) {
    return streetIdToStreetObject[streetid].Mayor;
}
function getGovernorOfStreet (uint streetId) public view returns (address _Governor) {
    
    return streetIdToStreetObject[streetId].Governor;
}
function getBaseRent(uint streetId) public view returns (uint) {
    return streetIdToStreetObject[streetId].rent;
}
function getAmountOfPlots(uint streetId) public view returns (uint) {
    return streetIdToStreetObject[streetId].plots.length;
}
function addPlotToStreet (uint streetId, uint tokenId, uint globalId, uint boardId) public {
boardsInterface(registerPoly.typeAtaddress("Boards")).registerNewPlotToStreet(tokenId, streetId);
plots[tokenId] = createPlotDetails (tokenId);
streetIdToStreetObject[streetId]._plotObjects.push(plots[tokenId]);
streetIdToStreetObject[streetId].plots.push(tokenId);



emit newPlotReceived (tokenId, globalId, boardId, streetId , plots[tokenId].owner);


}
function getLocation (uint streetId) public view returns (uint) {
    return streetIdToStreetObject[streetId].LocationOnTheBoard;
}

function createPlotDetails (uint tokenId) internal returns (plotsInterface.plot memory _plot ) {
  
  ( _plot.globalId,  _plot.plotId,  _plot.tier,  _plot.streetId, _plot.plotNumber, _plot.owner,  _plot.houseNumber ) = plotsInterface(registerPoly.typeAtaddress("Plots")).getPlotDetails(tokenId);
    (_plot.hasHouse, _plot.price, _plot.boardId, _plot.location, _plot.dateMinted) = plotsInterface(registerPoly.typeAtaddress("Plots")).getPlotDetailsSecond(tokenId);
     
    return _plot;
}

  function onERC721Received(address operator, address from, uint256 tokenId, bytes memory data) public returns (bytes4) {
          string memory nameOfToken = ERC721Full(msg.sender).name();
          uint hashesOfName = uint(keccak256(abi.encodePacked(nameOfToken)));
          uint HashOfTarget = uint(keccak256(abi.encodePacked("Plots")));
    uint globalId = ERC721Full(msg.sender).getGlobalId(tokenId);
    bytes32[] memory dataArray =  DataClient(registerPoly.typeAtaddress("DataClient")).getDataFromSet(data);
    
    
    
   
    if(hashesOfName == HashOfTarget) {


  addPlotToStreet(uint(dataArray[2]), tokenId, globalId, uint(dataArray[1]));
       emit newPlotReceived (tokenId, globalId, uint(dataArray[1]),  uint(dataArray[2]), from);
       

    }
    

      DataClient(registerPoly.typeAtaddress("DataClient")).addData(data, dataArray);
    ERC721Full(msg.sender).safeTransferFrom(address(this), registerPoly.typeAtaddress("PolyAuction"), tokenId, data);
      
      return bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"));
  }
 /* 
function forwardTokens (address tokens, uint tokenId, address recipient) public {
    ERC721Full(tokens).safeTransferFrom(address(this), registerPoly.typeAtaddress("PolyAuction"), tokenId, "");
}
 */

}