pragma solidity >0.4.24 <=0.6.0;

import "browser/streetsInterface.sol";
import "browser/plotsInterface.sol";
import "browser/PolyRegisterClient.sol";

import "browser/ERC1820Client.sol";

contract Boards is ERC1820ClientWithPoly{ 
    

    streetsInterface streetsContract;
    uint lastBoard; 
    uint highestTier;
  
    address public admin;
    
    
    struct board {
        
        uint id;
        uint tier;
        uint[] streets;
        address President;
        string name;
        streetsInterface.street[] streetObjects;
        uint[] avatarIds;
        address[] players;
        
    }

    mapping (uint => board) public boards;
    mapping (uint => streetsInterface.street) public streetIdToStreetObject;
    mapping (uint => plotsInterface.plot) public PlotIdToPlotObject;

    mapping (uint => mapping(uint => bool)) public avatarIsOnBoard;
    mapping (uint => mapping(address => bool)) public playerHasAvatarOnBoard; 
    mapping (uint => mapping(uint => uint)) public avatarIdOnBoardAtLocation;
    mapping (uint => mapping(address => uint)) public playerHasElectionPointsOnBoard;
    
    mapping(uint => mapping(uint => uint)) public locationOnBoardHoldsStreet; 
  
    mapping (uint => mapping(uint => bool)) public locationOnBoardHasStreet;
    

   mapping (uint => mapping(uint => address)) public streetOnBoardHasMayor;
    mapping (uint => mapping(uint => address)) public streetOnBoardHasgovernor;
    mapping (uint => address) public boardsPresident;
    
    

    uint[] public allBoardIdsArray;
    board[] public allBoards;
    string[] public boardNames; 
    

    
    constructor(address _PolyRegister) public ERC1820ClientWithPoly(_PolyRegister)  {
        uint[] memory needs = new uint[](2);
   
         needs[0] = uint(keccak256(abi.encodePacked("Registry")));
        
         (bool[] memory boolSolutions, address[] memory solutions) = registerPoly.registerContract("Boards", needs);
          if(solutions.length > 0) {
              
              for(uint i = 0; i<solutions.length;i++) {
                  if(boolSolutions[i]){
                      if(i == 0) {
                     
                      }else if(i == 1) {
             
                      }
                  }
                  
                  
                  
              }
              
          }   
     
            (address[] memory contractsInNeed, uint[] memory hashesOfContractTypesinNeed) = registerPoly.fillOthersNeedsIfPossible(uint(keccak256(abi.encodePacked("Boards"))), address(this));
       setInter();

}

event NewBoardCreated (uint id, uint tier, string name);
event newStreetAdded (uint board, uint location, uint tier, uint streetId);
 event NewMayorSet (uint streetId, uint boardId, uint location, address mayor);
 function setInter () public {

    setInterfaceImplementation("Boards", address(this));
    setInterfaceImplementation("ERC1820ClientWithPoly", address(this));
   // setInterfaceImplementation("Boards", address(this));
 }
 
 
function createNewBoard (uint tier, string memory name) public returns (uint boardId) {

    uint id = boardNames.push(name);
    if(tier > highestTier){
        highestTier = tier;
    }
    
    board memory newBoard = boards[id];
    boards[id].id = id;
    boards[id].name = name;
    
    emit NewBoardCreated (id, tier, name);
    
    return id;
    
    
}

function addStreetToBoard (uint boardId, uint location) public returns (uint streetId) {
    streetsContract = streetsInterface(registerPoly.typeAtaddress("Streets"));
    if(!locationOnBoardHasStreet[boardId][location]){
    uint tier = boards[boardId].tier;
streetId = streetsInterface(registerPoly.typeAtaddress("Streets")).createNewStreet(tier, boardId, location );


getStreetDetails(streetId);
getStreetDetailsSecond(streetId);
for(uint i = 0; i<streetIdToStreetObject[streetId].plots.length; i++){
    uint plotId = streetIdToStreetObject[streetId].plots[i];
    plotsInterface.plot memory test = createPlotDetails(plotId);
    streetIdToStreetObject[streetId]._plotObjects.push(test);
}


 locationOnBoardHoldsStreet[boardId][location] = streetId; 
boards[boardId].streetObjects.push(streetIdToStreetObject[streetId]);
     locationOnBoardHasStreet[boardId][location] = true;
     emit newStreetAdded (boardId, location, tier, streetId);
            return streetId;
}else{
   return locationOnBoardHoldsStreet[boardId][location];
    
}
}
function getStreetDetails (uint streetId) internal  {

  ( streetIdToStreetObject[streetId].id,
    streetIdToStreetObject[streetId].tier,
    streetIdToStreetObject[streetId].board,
    streetIdToStreetObject[streetId].LocationOnTheBoard,
    streetIdToStreetObject[streetId].set) = streetsContract.getStreetDetails(streetId);

    
    
    
    
    
    
    
    
    
} 
function getStreetDetailsSecond (uint streetId) internal {
        (  streetIdToStreetObject[streetId].color,
            streetIdToStreetObject[streetId].soldPlots,


    streetIdToStreetObject[streetId].plots,
    streetIdToStreetObject[streetId].Mayor,
    streetIdToStreetObject[streetId].Governor) = streetsContract.getStreetDetailsSecond(streetId);
    
}





function setMayor (uint boardId, uint location) public returns (address _Mayor) {
    
    
    uint streetId = locationOnBoardHoldsStreet[boardId][location];
     address player = streetsInterface(registerPoly.typeAtaddress("Streets"))._setMayor(streetId); 
    streetIdToStreetObject[streetId].Mayor = player;
    streetOnBoardHasMayor[boardId][location] = player;
    locationOnBoardHasStreet[boardId][location] = true;
    uint points = (streetIdToStreetObject[streetId].plots.length * streetIdToStreetObject[streetId].set);
    
     emit NewMayorSet ( streetId,  boardId,  location,  player);
   
    
    return streetOnBoardHasMayor[boardId][location];
    
    
}

function setGovornor (uint boardId, uint[] memory setOflocation) public returns (address governorOfBoard) {
    bool mayorIsGovernor = true;
    uint streetIdOfFirstStreet = locationOnBoardHoldsStreet[boardId][setOflocation[0]];
    address mayor = streetIdToStreetObject[streetIdOfFirstStreet].Mayor;
    
    
  
    for(uint i=1; i < setOflocation.length; i++) {
        uint location = setOflocation[i];
        uint streetId = locationOnBoardHoldsStreet[boardId][location];
        if(streetIdToStreetObject[streetId].Mayor == mayor){
 
        }else {
            mayorIsGovernor = false;
            
        }
        
        
        
    }
 
        for(uint i = 0; i < setOflocation.length ; i++) {
               if(mayorIsGovernor){
           uint streetId = locationOnBoardHoldsStreet[boardId][setOflocation[i]];
            streetIdToStreetObject[streetId].Governor = mayor;
            streetOnBoardHasgovernor[boardId][setOflocation[i]] = mayor;
                } else {
            uint streetId = locationOnBoardHoldsStreet[boardId][setOflocation[i]];
            streetIdToStreetObject[streetId].Governor = address(this);
            streetOnBoardHasgovernor[boardId][setOflocation[i]] = address(this); 
            
                }
         }
    return streetOnBoardHasgovernor[boardId][setOflocation[0]];
}

function registerNewPlotToStreet (uint plotId, uint streetId) public {
       plotsInterface.plot memory test = createPlotDetails(plotId);
    streetIdToStreetObject[streetId]._plotObjects.push(test);
}

function createPlotDetails (uint tokenId) internal returns (plotsInterface.plot memory _plot ) {
  
  ( _plot.globalId,  _plot.plotId,  _plot.tier,  _plot.streetId, _plot.plotNumber, _plot.owner,  _plot.houseNumber ) = plotsInterface(registerPoly.typeAtaddress("Plots")).getPlotDetails(tokenId);
    (_plot.hasHouse, _plot.price, _plot.boardId, _plot.location, _plot.dateMinted) = plotsInterface(registerPoly.typeAtaddress("Plots")).getPlotDetailsSecond(tokenId);
     
     
     PlotIdToPlotObject[tokenId] = _plot;
    return _plot;
}


    
}