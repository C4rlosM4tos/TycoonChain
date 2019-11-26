pragma solidity >0.4.24 <=0.6.0;

import "browser/PolyRegister.sol";
import "browser/Streets2.sol";
import "browser/PolyPlayer.sol";
import "browser/Boards2.sol";
import "browser/plots.sol";
import "browser/Houses1.sol";
import "browser/PolyLauncher.sol";
import "browser/MoonCards.sol";
import "browser/PolyMovement.sol";
import "browser/PolyToken.sol";
import "browser/MovementInterface.sol";


contract PolyMovementExtension is MovementInterface { //TODO access control using roles and modifier
    
    uint startReward = 1000;
     
  PolyPlayer public playerContract;
  Streets public streetsContract;
  Boards public boardContract;
  Plots public plotsContract;
  Houses public houseContract;
  address admin;

mapping(uint => uint) public hashIsboard; //returns the boardId



        PolyRegister registerPoly;
       
        constructor(address _PolyRegister) public payable {
        admin = msg.sender;
                   uint[] memory needs = new uint[](5);
                     registerPoly = PolyRegister(_PolyRegister);
                      needs[0] = uint(keccak256(abi.encodePacked("PolyPlayer")));
                      needs[1] = uint(keccak256(abi.encodePacked("Streets")));
                      needs[2] = uint(keccak256(abi.encodePacked("Boards")));
                      needs[3] = uint(keccak256(abi.encodePacked("Plots")));
                      needs[4] = uint(keccak256(abi.encodePacked("Houses")));
                    
           
              
                      (bool[] memory boolSolutions, address[] memory solutions) = registerPoly.registerContract("PolyMovementExtension", needs);
                  if(solutions.length > 0) {
                      
                      for(uint i = 0; i<solutions.length;i++) {
                          if(boolSolutions[i]){
                              if(i == 0) {
                                  playerContract = PolyPlayer(solutions[i]);
                            }else if(i == 1) {
                                  streetsContract = Streets(solutions[i]);
        
                            }else if(i == 2) {
                                  boardContract = Boards(solutions[i]);
                          }else if(i == 3) {
                                  plotsContract = Plots(solutions[i]);
                          }else if(i == 4) {
                                  houseContract = Houses(solutions[i]);
                          
                          }
 
                      }
                      
                  }   
                   (address[] memory contractsInNeed, uint[] memory hashesOfContractTypesinNeed) = registerPoly.fillOthersNeedsIfPossible(uint(keccak256(abi.encodePacked("PolyMovementExtension"))), address(this));
                 onCreationCallback(hashesOfContractTypesinNeed, contractsInNeed);
       
            
               
                  }     
}

    
    

   modifier onlyAdmin {
       require(msg.sender == admin, "not an admin");
       _;
   } 
   
 function getBoardFromHash (uint hash) public view returns (uint _boardId) {
     
     _boardId = hashIsboard[hash];
     return _boardId;
 }

function resolveMoonCard (uint cardId, uint avatarId) public returns (uint) {
  
    // string[11] memory types = ["receive tokens", "pay tokens", "move forward", "take card", "receive object", "pay object", "create auction", "create new board", "create new avatar", "move back", "move back amount"];
    uint boardId = playerContract.getAvatarBoard(avatarId);
   
       address _owner = playerContract.getAvatarOwner(avatarId);
   // uint location = playerContract.getAvatarLocation(avatarId);
    uint tier = boardContract.getTier(boardId);
   uint actionId = MoonCards(registerPoly.typeAtaddress("MoonCards")).getActionId(cardId);
   uint oldBalance = PolyToken(registerPoly.typeAtaddress("PolyToken")).getBal(_owner);
  
   bool passedStart;

   
   if(actionId == 0) {
        uint amount =1 + MoonCards(registerPoly.typeAtaddress("MoonCards")).getAmountToReceive(cardId);
        amount *= (tier+1);
        testMint(_owner, amount); 
      require(oldBalance + (amount) == PolyToken(registerPoly.typeAtaddress("PolyToken")).getBal(_owner), "someting went wrong with the payment" );
  } 
  if(actionId == 1) {
      uint amount = (1 + MoonCards(registerPoly.typeAtaddress("MoonCards")).getAmountToPay(cardId))*(tier+1);
       PolyToken tokenContract = PolyToken(registerPoly.typeAtaddress("PolyToken"));
       bytes memory userData = abi.encodePacked(hashBoards(boardId));
       bytes memory operatorData = abi.encodePacked("MoonCard"); 
      address MoonAdmin = registerPoly.typeAtaddress("MoonAdmin");
      IERC777Sender (MoonAdmin).tokensToSend(_owner,_owner, MoonAdmin, amount, userData, operatorData );
       
  }if(actionId == 2) {
      
     if(seeIfPassesStartMoonCard(cardId, avatarId)){
         payoutStart(avatarId);
     }
      
  }
  
}
function hashBoards (uint boardId) internal returns (uint)  {
    uint hash = uint(keccak256(abi.encodePacked("boardId")));
    hashIsboard[hash] = boardId;
    return hash;
}

function payoutStart (uint avatarId) public returns (uint) {
    address _owner = playerContract.getAvatarOwner(avatarId);
    uint amount = startReward * (playerContract.getTier(avatarId)); 
    
    testMint(_owner, amount);
    return amount;
    
}

function seeIfPassesStartMoonCard (uint cardId, uint avatarId) public returns (bool){ 
   uint location = playerContract.getAvatarLocation(avatarId); 
   uint NewLocation =  MoonCards(registerPoly.typeAtaddress("MoonCards")).getNewLocation(cardId);
  playerContract.setAvatarLocation(avatarId, NewLocation);
     if(NewLocation < location) {
         return true;
     }else{
         return false;
     }
    
}

function testMint (address receiver, uint amount) internal {
    PolyToken tokenContract = PolyToken(registerPoly.typeAtaddress("PolyToken"));
        tokenContract.mint(receiver, amount);
}


function setLauncherOperator () public returns (bool) {
   PolyLauncher(registerPoly.typeAtaddress("PolyLauncher")).addOperator(registerPoly.typeAtaddress("MoonCards"));
   PolyLauncher(registerPoly.typeAtaddress("PolyLauncher")).addOperator(registerPoly.typeAtaddress("PolyPlayer"));
 PolyLauncher(registerPoly.typeAtaddress("PolyLauncher")).addOperator(registerPoly.typeAtaddress("Boards"));
    PolyLauncher(registerPoly.typeAtaddress("PolyLauncher")).addOperator(registerPoly.typeAtaddress("PolyMovement"));
   PolyLauncher(registerPoly.typeAtaddress("PolyLauncher")).addOperator(registerPoly.typeAtaddress("PolyAuction"));
      PolyLauncher(registerPoly.typeAtaddress("PolyLauncher")).addOperator(registerPoly.typeAtaddress("MoonAdmin"));
         PolyLauncher(registerPoly.typeAtaddress("PolyLauncher")).addOperator(registerPoly.typeAtaddress("MoonNpc"));
    PolyLauncher(registerPoly.typeAtaddress("PolyLauncher")).addOperator(registerPoly.typeAtaddress("PolyExchange"));
      
   PolyLauncher(registerPoly.typeAtaddress("PolyLauncher")).addOperator(address(this));
   
   return true;
}

function setPlayerContract (address _playerContract) public onlyAdmin returns (bool) {
    
    playerContract = PolyPlayer(_playerContract);
 
    
       return true;
}
function setStreetsContract (address _streetsContract) public onlyAdmin returns (bool) {
    
    streetsContract = Streets(_streetsContract);
   
    
       return  true;
} 
function setBoardsContrat (address _boardsContract) public onlyAdmin returns (bool) {
    
    boardContract = Boards(_boardsContract);
    
  
       return true;
}
function setPlotsContract (address _plotsContract) public onlyAdmin returns (bool) {
    
    plotsContract = Plots(_plotsContract);
    
   
       return true;
}
function setHouseContract (address _houseContract) public onlyAdmin returns (bool) {
    
    houseContract = Houses(_houseContract);
  
       return true;
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


}
         

}   