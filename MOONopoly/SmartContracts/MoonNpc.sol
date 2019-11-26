pragma solidity >0.4.24 <=0.6.0;

import "browser/ERC777Flat.sol";
import "browser/PolyRegister.sol";
import "browser/ERC1820Register.sol";
import "browser/PolyToken.sol";
import "browser/PolyPlayer.sol";
import "browser/Streets2.sol";
import "browser/plots.sol";
import "browser/PolyMovement.sol";
import "browser/MovementInterface.sol";
import "browser/Boards2.sol";
import "browser/MoonCards.sol";

contract MoonNpc is IERC777Recipient {
    PolyRegister registerPoly;
    ERC1820Registry register;
    
      bytes32 constant private ERC1820_ACCEPT_MAGIC = keccak256(abi.encodePacked("ERC1820_ACCEPT_MAGIC"));
  
  bool allowTokensReceived;
  
   constructor (address _PolyRegister) public {
         uint[] memory needs = new uint[](1);
        registerPoly = PolyRegister(_PolyRegister);
         needs[0] = uint(keccak256(abi.encodePacked("Registry")));

      
              (bool[] memory boolSolutions, address[] memory solutions) = registerPoly.registerContract("MoonNpc", needs);
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


   struct npc {
        
        uint id;
        uint avatarId;
        mapping(uint => bool) visitedLocation;
        int bal;
        
        
    }
    
    
    event NewNPCcreated (uint board, uint avatarId, uint npcID);
    mapping(uint => npc) public npcs;
    mapping(uint => npc) public boardHasNpc;  
    mapping(uint => bool) public hasBoardNpc;
    
    
     uint[] public allNPCavatarIds;
    
function setInter () public {
     string memory implementorNameRec = "ERC777TokensRecipient";

     bytes32 interfaceHash = keccak256(abi.encodePacked(implementorNameRec));

    register.setInterfaceImplementer(address(this),interfaceHash, address(this));
 
        allowTokensReceived = true;

}  
    
    
    
    
function getAvatarIdForBoard (uint board) public view returns (uint avatarId) {
    
    return npcs[board].avatarId;
}

 function canImplementInterfaceForAddress(bytes32 _interfaceHash, address _addr) external view returns(bytes32) {
        return ERC1820_ACCEPT_MAGIC;
    }







function createNewNpc (uint boardId) public {
   uint playerId = PolyPlayer(registerPoly.typeAtaddress("PolyPlayer")).registerNewPlayer("NPC"); 
   uint avatarId = PolyPlayer(registerPoly.typeAtaddress("PolyPlayer")).createAvatar(boardId, "NPC");
   uint npcId = allNPCavatarIds.push(avatarId);
   npc memory newnpc = npcs[npcId];
   boardHasNpc[boardId] = npcs[npcId];
   npcs[npcId].id = npcId;
   npcs[npcId].avatarId = avatarId;
   hasBoardNpc[boardId] = true;
   
   
   emit NewNPCcreated (boardId, avatarId, npcId);
   
    
}




function moveNpc (uint boardId, uint amountOfSteps) public { //access rights to be set!
   uint avatarId = npcs[boardId].avatarId;
   uint location = PolyPlayer(registerPoly.typeAtaddress("PolyPlayer")).getAvatarLocation(avatarId);
   uint newlocation = (location + amountOfSteps)%40;
    uint what =  checkBeforeMoveRequest(avatarId, boardId, newlocation);
    
    
    
    
    
   // check the current location
   
   
   
   
   
   
   PolyPlayer(registerPoly.typeAtaddress("PolyPlayer")).setAvatarLocation(avatarId, newlocation);
    
}
function checkIfStreetHasPlotsForSale (uint streetId) public returns (bool) {
    uint maxPlots = Streets(registerPoly.typeAtaddress("Streets")).getMaxPlots(streetId);
    uint currentPlots = Streets(registerPoly.typeAtaddress("Streets")).getAmountOfPlots(streetId);
    
    if(Streets(registerPoly.typeAtaddress("Streets")).checkIfStreetHasPlotsForSale(streetId)){
 
        return true;
        }else {
             if(currentPlots < maxPlots){
           
            uint globalIdOfPlot =  Plots(registerPoly.typeAtaddress("Plots")).createNewPlot(streetId);
         }

        }
        
    }
    
    


function checkBeforeMoveRequest (uint avatarId, uint boardId, uint location) public returns (uint) { //amount to pay before you can move again

     
    address owner = address(this); 
    
    bool street = PolyMovement(registerPoly.typeAtaddress("PolyMovement")).checkIfStreet(location);
    bool special;
    bool chance;
    bool communityCard;
    bool tax1;
    bool tax2;

    if(!street){
     special =  PolyMovement(registerPoly.typeAtaddress("PolyMovement")).checkIfSpecial(location);       
            if(!special) {
              
                chance =  PolyMovement(registerPoly.typeAtaddress("PolyMovement")).checkIfChance(location);
                    if(!chance){
                     communityCard =  PolyMovement(registerPoly.typeAtaddress("PolyMovement")).checkIfCommunity(location);
                     
                        if(!communityCard){
                            if(location == 4) {
                                tax1 = true;
                                }else if(location == 38){
                                tax2 = true;
                                }
                            
                        }
                    }
                }
    
    
    
    }
    
    if(street){
     if(! Boards(registerPoly.typeAtaddress("Boards")).seeIfLocationHasStreet(boardId, location)){
         PolyMovement(registerPoly.typeAtaddress("PolyMovement")). mintNewStreet(boardId, location);
         uint streetId =  Streets(registerPoly.typeAtaddress("Streets")).locationOnBoardHoldsStreet(boardId, location);  //put in its own function

     checkIfStreetHasPlotsForSale(streetId);
 
  
     } 
     
    
        //start
      if( PolyPlayer(registerPoly.typeAtaddress("PolyPlayer")).getOldLocation(avatarId) > location){
       PolyMovement(registerPoly.typeAtaddress("PolyMovement")).payoutStart(avatarId);
             } 
  
    uint streetId =  Boards(registerPoly.typeAtaddress("Boards")).getStreetId(boardId, location);  //put in its own function
    bool sold =  Streets(registerPoly.typeAtaddress("Streets")).getIfStreetIsSold(streetId);
    address ownerOfStreet = Streets(registerPoly.typeAtaddress("Streets")).getOwnerOfStreet(streetId);
    if(ownerOfStreet != owner){
      uint lastBill =  PolyMovement(registerPoly.typeAtaddress("PolyMovement")).toDoIfStreet(streetId, owner, sold, ownerOfStreet); //owner of the avatar
    if(lastBill > 0) {
        
    //    payBill(lastBill);
        
       
    }
        
    }
        
        
    } 
if(special){
        if( PolyPlayer(registerPoly.typeAtaddress("PolyPlayer")).getOldLocation(avatarId) > location){
       PolyMovement(registerPoly.typeAtaddress("PolyMovement")).payoutStart(avatarId);
           
        if(location == 0) {
            PolyMovement(registerPoly.typeAtaddress("PolyMovement")).payoutStart(avatarId);
           }
        
    }
}
if(communityCard){
        
                      MoonCards mooncards = MoonCards(registerPoly.typeAtaddress("MoonCards"));
                      uint cardId = mooncards.takeCard(0);
                      
                 
                      MovementInterface(registerPoly.typeAtaddress("PolyMovementExtension")).resolveMoonCard(cardId, avatarId);
                      
                     
    }
if(chance) {
                      MoonCards mooncards = MoonCards(registerPoly.typeAtaddress("MoonCards"));
                      uint cardId = mooncards.takeCard(0);
                    
                      MovementInterface(registerPoly.typeAtaddress("PolyMovementExtension")).resolveMoonCard(cardId, avatarId);
    }
    
if(tax1){
          if( PolyPlayer(registerPoly.typeAtaddress("PolyPlayer")).getOldLocation(avatarId) > location){
                     PolyMovement(registerPoly.typeAtaddress("PolyMovement")).payoutStart(avatarId);
                         }
        
    }
if(tax2){
        
    }
    
    
   
}




function payBill (uint bill) internal {
uint amountToPay = PolyMovement(registerPoly.typeAtaddress("PolyMovement")).getBillAmount(bill);
uint balanceOfNPC =PolyToken(registerPoly.typeAtaddress("PolyToken")).getBal(address(this));

if (amountToPay > balanceOfNPC) {
    PolyToken(registerPoly.typeAtaddress("PolyToken")).mint(address(this), amountToPay);
} 
    
PolyMovement(registerPoly.typeAtaddress("PolyMovement")).payBill(bill);
    
}
function tokensReceived (
        address _operator,
        address _from,
        address _to,
        uint256 _amount,
        bytes calldata _data,
        bytes calldata _operatorData
    )
        external
    {
 bytes memory operatorData = abi.encodePacked("MoonNpcForward");
    
   IERC777Sender(registerPoly.typeAtaddress("MoonAdmin")).tokensToSend(address(this), address(this), registerPoly.typeAtaddress("MoonAdmin"), _amount, _data, operatorData );
    
    }
}