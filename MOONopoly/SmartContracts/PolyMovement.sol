pragma solidity >0.4.24 <=0.6.0;

import "browser/PolyRegister.sol";
import "browser/Streets2.sol";
import "browser/PolyPlayer.sol";
import "browser/Boards2.sol";
import "browser/plots.sol";
import "browser/Houses1.sol";
import "browser/PolyToken.sol";
import "browser/ERC1820Register.sol";
import "browser/MoonCards.sol";
import "browser/ERC777Flat.sol";
import "browser/PolyMovementExtension.sol";

contract PolyMovement is IERC777Recipient  {
    
  PolyPlayer public playerContract;
  Streets public streetsContract;
  Boards public boardContract;
  Plots public plotsContract;
  Houses public houseContract;
  PolyToken public tokenContract;
   ERC1820Registry register;  


   uint startReward = 1000;
   
event BillPaid (uint billId, address ownerOfTheBill, uint amount, address PaidBy, uint when);
event chanceCardReceived (uint avatarId, uint cardId);
event communityCardReceived (uint whatAvatar, uint whatCard);
event OnCallbackEvent (uint[], address[], bool[]);
event newContractSet (string name, address contractSet);
event userdataevent (bytes output);   
            

    address public admin;
   
      bool private allowTokensReceived;


    mapping(address => address) public token;
    mapping(address => address) public operator;
    mapping(address => address) public from;
    mapping(address => address) public to;
    mapping(address => uint256) public amount;
    mapping(address => bytes) public data;
    mapping(address => bytes) public operatorData;
    mapping(address => uint256) public balanceOf;
    mapping(bytes => uint) public hashOfBillToBillId;      
    
        PolyRegister registerPoly;
    
           
    
        constructor(address _PolyRegister) public payable {
            admin = msg.sender;
                   uint[] memory needs = new uint[](7);
                     registerPoly = PolyRegister(_PolyRegister);
                      needs[0] = uint(keccak256(abi.encodePacked("PolyPlayer")));
                      needs[1] = uint(keccak256(abi.encodePacked("Streets")));
                      needs[2] = uint(keccak256(abi.encodePacked("Boards")));
                      needs[3] = uint(keccak256(abi.encodePacked("Plots")));
                      needs[4] = uint(keccak256(abi.encodePacked("Houses")));
                      needs[5] = uint(keccak256(abi.encodePacked("PolyToken")));
                      needs[6] = uint(keccak256(abi.encodePacked("Registry")));
              
                      (bool[] memory boolSolutions, address[] memory solutions) = registerPoly.registerContract("PolyMovement", needs);
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
                          }else if(i == 5) {
                                  tokenContract = PolyToken(solutions[i]);
                          }else if(i == 6) {
                                  register = ERC1820Registry(solutions[i]);
                          }
 
                      }
                      
                  }   
                   (address[] memory contractsInNeed, uint[] memory hashesOfContractTypesinNeed) = registerPoly.fillOthersNeedsIfPossible(uint(keccak256(abi.encodePacked("PolyMovement"))), address(this));
                 onCreationCallback(hashesOfContractTypesinNeed, contractsInNeed);
                 setInter();
            
               
                  }     
}
    uint public billIndex;
    

  
  
  struct bill {
      
      uint id;
      bool paid;
      address owner; //person with the debt
      address[] recipients;
      mapping(address => uint) addressToAmount;
      uint total;
      
      
  }
    
    
mapping(uint => bill) public bills;
mapping(address => uint) public lastBillIdForAccount;
mapping(address => bool) public hasUnpaidBill;
    
    
function setInter () internal {
    string memory implementorNameRec = "ERC777TokensRecipient";
     string memory implementorNameSend ="ERC777Sender";
     bytes32 interfaceHash = keccak256(abi.encodePacked(implementorNameRec));
    register.setInterfaceImplementer(address(this),interfaceHash, address(this));
        allowTokensReceived = true;
          
                 }
function mintNewStreet (uint boardId, uint location)  public { //restrict acces
    uint tier = boardContract.getTier(boardId);
    
streetsContract.createNewStreet(tier, boardId, "new Street", location);

    
}

function checkIfStreetHasPlotsForSale (uint streetId) public returns (bool) {
    uint maxPlots = streetsContract.getMaxPlots(streetId);
    uint currentPlots = streetsContract.getAmountOfPlots(streetId);
    
    if(streetsContract.checkIfStreetHasPlotsForSale(streetId)){
  
        return true;
        }else {
             if(currentPlots < maxPlots){
              
            uint globalIdOfPlot =  plotsContract.createNewPlot(streetId);
         }

        }
        
    }
    
    
    


    
function checkBeforeMoveRequest (uint avatarId) public returns (uint) { //amount to pay before you can move again



    uint boardId = playerContract.getAvatarBoard(avatarId);
    uint location = playerContract.getAvatarLocation(avatarId);
    uint lastBill;
    address owner = playerContract.getAvatarOwner(avatarId);
    if(hasUnpaidBill[owner]) {
        lastBill = lastBillIdForAccount[owner];
        payBill(lastBill);
    }
    require(!hasUnpaidBill[owner], "please pay your open bills first"); // check on the above step
   
    bool street = checkIfStreet(location);
    bool special;
    bool chance;
    bool communityCard;
    bool tax1;
    bool tax2;

    if(!street){
     special = checkIfSpecial(location);       
            if(!special) {
              
                chance = checkIfChance(location);
                    if(!chance){
                     communityCard = checkIfCommunity(location);
                     
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
     if(!boardContract.seeIfLocationHasStreet(boardId, location)){
         mintNewStreet(boardId, location);
         uint streetId = streetsContract.locationOnBoardHoldsStreet(boardId, location);  //put in its own function
   
     checkIfStreetHasPlotsForSale(streetId);

     } 
     
    
      if(playerContract.getOldLocation(avatarId) > location){
       payoutStart(avatarId);
             } 
  
    uint streetId = boardContract.getStreetId(boardId, location);  //put in its own function
 
    
    bool sold = streetsContract.getIfStreetIsSold(streetId);

    address ownerOfStreet =streetsContract.getOwnerOfStreet(streetId);
    if(ownerOfStreet != owner){
 
    
       lastBill = toDoIfStreet(streetId, owner, sold, ownerOfStreet); //owner of the avatar
    
    }
        
    } 
if(special){
        if(playerContract.getOldLocation(avatarId) > location){
       payoutStart(avatarId);
           
       
     
        if(location == 0) {
               payoutStart(avatarId);
           }
        
    }
}
if(communityCard){
        
                      MoonCards mooncards = MoonCards(registerPoly.typeAtaddress("MoonCards"));
             
             
                      emit communityCardReceived ( avatarId, mooncards.takeCard(0));
                      PolyMovementExtension(registerPoly.typeAtaddress("PolyMovementExtension")).resolveMoonCard(mooncards.takeCard(0), avatarId);
                      
                     
    }
if(chance) {
                      MoonCards mooncards = MoonCards(registerPoly.typeAtaddress("MoonCards"));
                      
                      
                      emit chanceCardReceived ( avatarId, mooncards.takeCard(1));
                      PolyMovementExtension(registerPoly.typeAtaddress("PolyMovementExtension")).resolveMoonCard(mooncards.takeCard(1), avatarId);
    }
    
if(tax1){
          if(playerContract.getOldLocation(avatarId) > location){
       payoutStart(avatarId);

         }
        
    }
if(tax2){
        
    }
    
    
    require(hasUnpaidBill[owner] == false, "you need to pay your bills first!");
    
}


function toDoIfStreet (uint streetId, address owner, bool sold, address ownerOfStreet) public returns (uint) { //owner of the bills/avatar that wants to move
     uint[] memory soldPlots = streetsContract.getSoldPlots(streetId);
        billIndex++;
     bill memory newBill = bills[billIndex]; 
     bills[billIndex].id = billIndex;
     bills[billIndex].owner = owner;
  

    if(soldPlots.length >= 1) {                         
        
        for(uint i = 0; i < soldPlots.length;i++){
        
            uint plotId = soldPlots[i];
            address plotOwner = plotsContract.getPlotOwner(plotId);
            
            if(plotOwner != owner){
                
                uint houseId = plotsContract.getHouseOnPlot(plotId);
                 uint baseAmount = streetsContract.getBaseRent(streetId);
                 uint amount = baseAmount;
                        if(houseId > 0){
                    
                         uint multiplier = houseContract.getMultiplier(houseId);
                         amount = baseAmount*multiplier;                              
                         }
                
                bills[billIndex].total += amount;
                bills[billIndex].recipients.push(plotOwner);
                bills[billIndex].addressToAmount[plotOwner] += amount/2;
                     if(sold) {
                           bills[billIndex].recipients.push(ownerOfStreet);
                           bills[billIndex].addressToAmount[ownerOfStreet] += amount/2;          
                        }
                
                hasUnpaidBill[owner] = true;
                lastBillIdForAccount[owner] = billIndex;  
            
                }
            
            }
            
        }
     if (bills[billIndex].total == 0) {
             hasUnpaidBill[owner] = false;
              bills[billIndex].paid = true;
              
     }else
    
    
     return lastBillIdForAccount[owner]; 
     
}

function checkIfCommunity (uint location) public view returns (bool) {
     if(location == 2 || location == 18 || location == 33) {
    
        return true;
    }else{
        return false;
        }
    
}

function checkIfChance (uint location) public view returns (bool) {
    
    if(location == 7 || location == 22 || location == 36) {
    
        return true;
    }else{
        return false;
        }
    
}

function checkIfSpecial(uint location) public view returns (bool) {
    
    if(location%5 == 0) {
        return true;
    }
    
}

function checkIflastBillIsPaid (address playerToCheck) public returns (bool) {
    uint billId = lastBillIdForAccount[playerToCheck];
    if (!bills[billId].paid && billId != 0) {
    } 
    return bills[billId].paid;
    
}

function checkIfStreet (uint i) public view returns (bool) {
    
    if((i == 1 || i == 3)){
        return true;
    }else if(i == 6 || i == 8 || i == 9) {
        return true;
    }else if(i == 11 || i == 13 || i ==14 ) {
        return true;
    }else if(i == 16 || i == 18 || i ==19 ) {
        
        return true;
        
    }else if(i == 21 || i == 23 || i ==24 ) {
            return true;
    
    
    }else if(i == 26 || i == 27 || i ==29 ) {
            return true;
    }else if(i == 31 || i == 32 || i ==34 ) {
            return true;
    }else if(i == 37 || i == 39) {
            return true ;
    }else if(i == 12 || i == 28){
        return true; 
    }else{
        return false;
        }    
    
 
    
}

function createBill (uint amount) public returns (uint) { //testing purpose only, not used to create a bill !!! probably should use it instead of todoifstreet or rename that to createBill
    require(!hasUnpaidBill[msg.sender], "pay your bills first");
    billIndex++;
    bill memory newBill = bills[billIndex];
    bills[billIndex].id = billIndex;
    bills[billIndex].owner = msg.sender;
    bills[billIndex].recipients.push(address(this));
    bills[billIndex].addressToAmount[address(this)] += amount;
    bills[billIndex].total += amount;
    lastBillIdForAccount[msg.sender] = billIndex;
    hasUnpaidBill[msg.sender] = true;
    
    return lastBillIdForAccount[msg.sender];
    
    
    
    
} 



function payBill (uint billId) public returns (uint) {

 uint totalpaid;
 address ownerOfBill = bills[billId].owner;
 uint balanceOfSender = tokenContract.getBal(ownerOfBill);
 uint _amount = bills[billId].total;
 bytes memory _data = new bytes(32);
 bytes memory _operatorData;
 bytes32 temp;
 
 require(balanceOfSender >= _amount, "you do not have enough money!");
 
 for(uint i = 0; i < bills[billId].recipients.length; i++){
        address recipient = bills[billId].recipients[i];
        uint amountToPay = bills[billId].addressToAmount[recipient];
  
        
       temp = bytes32(billId);  
         for (uint i = 0; i < 32 ; i++) {
     _data[i] = temp[i];
     hashOfBillToBillId[_data] = billId;
             }
 
    
        bytes memory _operatorData = abi.encodePacked("Serviced by PolyMovement to Pay a bill");
        IERC777Sender(registerPoly.typeAtaddress("MoonAdmin")).tokensToSend(address(this), ownerOfBill, recipient, amountToPay, _data, _operatorData);
        totalpaid += amountToPay;
        bills[billId].addressToAmount[recipient] = 0;
     
     
 }
 

 
 bills[billId].paid = true;
 lastBillIdForAccount[msg.sender] = 0;
 hasUnpaidBill[ownerOfBill] = false;
 emit BillPaid (billId, ownerOfBill, totalpaid, msg.sender, now);
 
return totalpaid;
    
}



function setPlayerContract (address _playerContract) public  returns (bool) {
    
    playerContract = PolyPlayer(_playerContract);
    
    
       return true;
}
function setStreetsContract (address _streetsContract) public  returns (bool) {
    
    streetsContract = Streets(_streetsContract);
    
    
       return  true;
} 
function setBoardsContrat (address _boardsContract) public  returns (bool) {
    
    boardContract = Boards(_boardsContract);
    
  
       return true;
}
function setPlotsContract (address _plotsContract) public  returns (bool) {
    
    plotsContract = Plots(_plotsContract);
    
   
       return true;
}
function setHouseContract (address _houseContract) public  returns (bool) {
    
    houseContract = Houses(_houseContract);
   
    
       return true;
}
function setTokenContract (address _tokenContract) public  returns (bool) {

    tokenContract = PolyToken(_tokenContract);
    
       
    return true;
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
    
    uint hashPlayer = uint(keccak256(abi.encodePacked("PolyPlayer")));
       if (hash == hashPlayer) {
        playerContract = PolyPlayer(foundAt);

    }

    

}
function payoutStart (uint avatarId) public returns (uint) {
    address _owner = playerContract.getAvatarOwner(avatarId);
    uint _amount = startReward * (playerContract.getTier(avatarId)); 
    
    PolyToken tokenContract = PolyToken(registerPoly.typeAtaddress("PolyToken"));
        tokenContract.mint(_owner, _amount);
    return _amount;
    
}
function getBillAmount (uint billId) public view returns (uint) {
    bills[billId].total;
}
         

}   
    
    
