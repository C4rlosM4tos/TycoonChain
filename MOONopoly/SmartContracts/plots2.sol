pragma solidity >0.4.24 <=0.6.0;

import "browser/ERC721Full.sol";
import "browser/streetsInterface.sol";
import "browser/PolyRegister.sol";
import "browser/objectManagerInterface.sol";
import "browser/ERC1820Client.sol";
import "browser/DataClient.sol";

contract Plots is ERC721Full, ERC1820ClientWithPoly {

    address admin;
    
    
     event StreetContractChanged (address newContractSet, string what, address who);
     event OnCallbackEvent (uint[], address[], bool[]);
     event newContractSet (string name, address contractSet);
     event HouseContractChangedOnPlots(address newContract, address sender);
     event PlotCreated (uint globalId, uint plotId, uint streetId, uint plotNumber);
    
    
    constructor (address _PolyRegister) ERC721Full("Plots", "PLOT")ERC1820ClientWithPoly(_PolyRegister)  public { //
        
        
         uint[] memory needs = new uint[](3);
      //   registerPoly = PolyRegister(_PolyRegister);
         needs[0] = uint(keccak256(abi.encodePacked("Houses")));
         needs[1] = uint(keccak256(abi.encodePacked("Streets")));
         needs[2] = uint(keccak256(abi.encodePacked("PolyObjectManager")));
              (bool[] memory boolSolutions, address[] memory solutions) = registerPoly.registerContract("Plots", needs);
          if(solutions.length > 0) {
              
              for(uint i = 0; i<solutions.length;i++) {
                  if(boolSolutions[i]){
                      if(i == 0) {
                      
                      }else if(i == 1) {
                   
                      }else if(i == 2) {
            
                  }
                  
                  
                  
              }
              
          }   
           (address[] memory contractsInNeed, uint[] memory hashesOfContractTypesinNeed) = registerPoly.fillOthersNeedsIfPossible(uint(keccak256(abi.encodePacked("Plots"))), address(this));
         onCreationCallback(hashesOfContractTypesinNeed, contractsInNeed);
         setInter();
        }

    }    
    
    struct plot {
        
        uint globalId; 
        uint plotId;
        uint tier;
        uint streetId;
    

        uint plotNumber; //number of plot on the street;
        address owner;
        uint houseNumber; //if build
        bool hasHouse;
        uint price;
        uint boardId;
        uint location;
        uint dateMinted;
        
    }

    mapping(uint => plot) public plots;
    mapping(uint => uint) public globalIdToPlotId;
    mapping(uint => uint) public plotIdToGlobalId;
    
   // mapping(bytes => uint) public dataIsStreet;
    mapping (bytes32 => bytes) public hashIsBytes;
    
    uint[] public allPlotIds;
    uint[] public streetIdsWithPlots; //used to generate an id
    plot[] public allPlotsArray;
    


    
function getPlotDetails (uint tokenId) public view returns (uint , uint , uint , uint , uint , address , uint ){
    
    return (plots[tokenId].globalId, tokenId, plots[tokenId].tier, plots[tokenId].streetId, plots[tokenId].plotNumber, plots[tokenId].owner, plots[tokenId].houseNumber);
} 
function getPlotDetailsSecond (uint tokenId) public view returns (bool, uint, uint, uint, uint) {
    
    return (plots[tokenId].hasHouse, plots[tokenId].price, plots[tokenId].boardId, plots[tokenId].location, plots[tokenId].dateMinted );
}
    
    
function setInter () public {
   
    setInterfaceImplementation("ERC721Flat", address(this));
    setInterfaceImplementation("ERC721", address(this));
    setInterfaceImplementation("Plots", address(this));
    setInterfaceImplementation("IERC721Receiver", address(this));
    
    
}

function getGlobalId(uint tokenId) public view returns (uint) {
    
    return plots[tokenId].globalId;
}

function createNewPlot(uint streetId) public returns (uint) {
     uint tier = streetsInterface(registerPoly.typeAtaddress("Streets")).getTier(streetId);
    
     uint location =  streetsInterface(registerPoly.typeAtaddress("Streets")).getLocation(streetId);
     bytes32 boardId = bytes32(streetsInterface(registerPoly.typeAtaddress("Streets")).streetIdToBoardNumber(streetId)); 
    uint owner = uint160(registerPoly.typeAtaddress("Streets"));
    uint id = streetIdsWithPlots.push(streetId);
   uint globalId = objectManagerInterface(registerPoly.typeAtaddress("ObjectManager")).getNewId();
    objectManagerInterface(registerPoly.typeAtaddress("ObjectManager")).registerNewObject (globalId, "Plot", id, registerPoly.typeAtaddress("Streets"), tier);
   
   bytes32 _streetId = bytes32(streetId);
    
   
    
    plot memory newplot = plots[id]; //create space otherwise values will not be stored ? need confirmation
    plots[id].globalId = globalId;
    plots[id].plotId = id;
    plots[id].tier = tier;
    plots[id].location = location;
    plots[id].streetId = streetId;
    plots[id].boardId = uint(boardId);
    plots[id].dateMinted = now;

    bytes32[] memory setOfData = new bytes32[](9);
    setOfData[0] = "Plots";
    setOfData[1] = boardId;
    setOfData[2] = bytes32(streetId);
    setOfData[3] = bytes32(id); 
    setOfData[4] = bytes32(owner);
    setOfData[5] = bytes32(tier);
    setOfData[6] = bytes32(location); 
    setOfData[7] = bytes32(now); 
    bytes memory transactionData =  abi.encodePacked(setOfData);
    DataClient(registerPoly.typeAtaddress("DataClient")).addData(transactionData, setOfData);
   hashIsBytes[keccak256(abi.encodePacked(transactionData))] = transactionData;
 
      mintPlot(address(owner), id, transactionData);
      
      
      return id;
    
}
function mintPlot (address owner, uint id, bytes memory dataId) internal {
    
    
    
     _safeMint(owner, id, dataId);
    
}




function createNewPlot(uint streetId, uint cost, uint num, uint tier) public returns (uint) { // only a board should be able to do this
    
   
    address owner = registerPoly.typeAtaddress("PolyAuction");
    uint id = streetIdsWithPlots.push(streetId);
    bytes memory txData = abi.encodePacked(id);

    _safeMint(owner, id, txData);
 plot memory newplot = plots[id]; //create space otherwise values will not be stored ? need confirmation
    plots[id].plotId = id;

    plots[id].streetId = streetId;
    plots[id].tier = tier;
    plots[id].owner = owner;
    plots[id].price = cost;
    plots[id].plotNumber = num;

    allPlotsArray.push(plots[id]);
    

    emit PlotCreated (id, streetId, num, cost);
    return id;
    
}
function checkIfPlotHasHouse (uint plotId) public view returns (bool) {
    
    return plots[plotId].hasHouse;
    
}   
function getHouseOnPlot (uint plotId) public view returns (uint) {
    
    return plots[plotId].houseNumber;
    
}
function setPolyObjectManager (address newObjectManager) public returns (bool) {

    
    return true;
    
}


function getPlotOwner (uint plotId) public view returns (address) {
    
    return plots[plotId].owner;
}

   
   function onCreationCallback(uint[] memory hashOfType, address[] memory contractsInNeedOfThis) public returns (bool[] memory) {
        bool[] memory answers = new bool[](contractsInNeedOfThis.length);
            for(uint i = 0; i < contractsInNeedOfThis.length;i++) {
                uint hash = hashOfType[i];
                address foundAt = contractsInNeedOfThis[i];
                
                answers[i] = (checkHash(hash, foundAt));
         
                
                
            }
        emit OnCallbackEvent (hashOfType, contractsInNeedOfThis, answers);
       
         return answers;
        }
function checkHash (uint hash, address foundAt ) public returns (bool) {
    
    uint hashStreets = uint(keccak256(abi.encodePacked("Streets")));
  uint hashMovement = uint(keccak256(abi.encodePacked("PolyMovement")));

    
}
function getTier (uint globalId) public view returns (uint) {
    uint plotId = globalIdToPlotId[globalId];
    uint tier = plots[plotId].tier;
}

}