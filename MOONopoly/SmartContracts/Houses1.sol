pragma solidity >0.4.24 <=0.6.0;

import "browser/PolyRegister.sol";
import "browser/plots.sol";
import "browser/Streets2.sol";
import "browser/PolyMovement.sol";
import "browser/PolyObjectManager.sol";
import "browser/PolyAuction.sol";

import "browser/ERC721Full.sol";

contract Houses is ERC721Full {
    ObjectManager public objectManager;
    Plots public plotsContract;
    Streets public streetsContract;
    
    PolyAuction public auctionHouse;
  
    
    
       PolyRegister registerPoly;
    
     event OnCallbackEvent (uint[], address[], bool[]);
    event newContractSet (string name, address contractSet);
    
    mapping(uint => uint) public houseIdToGlobalId;
    mapping(uint => uint) public globalIdToHouseId;
    
    
    constructor (address _PolyRegister) ERC721Full("Houses", "MHS") public { //MoonHouSe
           uint[] memory needs = new uint[](4);
           registerPoly = PolyRegister(_PolyRegister);
           needs[0] = uint(keccak256(abi.encodePacked("Plots")));
           needs[1] = uint(keccak256(abi.encodePacked("Streets")));
           needs[2] = uint(keccak256(abi.encodePacked("PolyObjectManager")));
           needs[3] = uint(keccak256(abi.encodePacked("PolyAuction")));
              (bool[] memory boolSolutions, address[] memory solutions) = registerPoly.registerContract("Houses", needs);
          if(solutions.length > 0) {
              
              for(uint i = 0; i<solutions.length;i++) {
                  if(boolSolutions[i]){
                      if(i == 0) {
                          plotsContract = Plots(solutions[i]);
                      }else if(i == 1) {
                          streetsContract = Streets(solutions[i]);
                      }else if(i == 2) {
                          objectManager = ObjectManager(solutions[i]);
                      }else if(i == 3) {
                          auctionHouse = PolyAuction(solutions[i]);
                      }
                  
                  
                  
                 }
              
          }   
           (address[] memory contractsInNeed, uint[] memory hashesOfContractTypesinNeed) = registerPoly.fillOthersNeedsIfPossible(uint(keccak256(abi.encodePacked("Houses"))), address(this));
         onCreationCallback(hashesOfContractTypesinNeed, contractsInNeed);
         }

    }   
    struct house {
        
        uint globalId; 
        uint houseId;
        uint tier;
        uint plotId;
        address owner;
        bool build;
        uint multiplier;
        
    }
    
    
mapping(uint => house) houses;
mapping(address => mapping(uint => bool)) isOwnerOfHouse;
mapping(uint => house) public globalIdToHouseObject;


uint[] allGlobalIds;

    
 function getGlobalId(uint tokenId) public view returns (uint) {
    
    return houses[tokenId].globalId;
}
    
function createNewHouse (uint tier) public {
    
    
    
    uint globalId = objectManager.getNewId();
    uint id = allGlobalIds.push(globalId);
    house memory newHouse = houses[id]; 
    houses[id].globalId = globalId;
    houses[id].houseId = id;
    houses[id].tier = tier;
    houses[id].multiplier = getNewMultiplier(id);
    
    objectManager.registerNewObject(globalId, "House", id, address(auctionHouse), tier);
    
    houseIdToGlobalId[id] = globalId;
    globalIdToHouseId[globalId] = id;
    _safeMint(address(auctionHouse), id);
    globalIdToHouseObject[globalId]= houses[id];
   
    
}

function setAuctionContract (address _auctionHouse) public returns (bool) {
    
    auctionHouse = PolyAuction(_auctionHouse);
    return true;
     
} 
function getNewMultiplier (uint houseId) public view returns (uint) { // /100
    uint base = 100;
    uint multiplier;
   if(houseId%1000000 == 0) {
    multiplier = base + uint(keccak256(abi.encodePacked(houseId, now, block.number)))%900; //10x   
        
    }
       else if(houseId%100000 == 0) {
    multiplier = base + uint(keccak256(abi.encodePacked(houseId, now, block.number)))%600;  //7x  
        
    }
       else if(houseId%10000 == 0) {
    multiplier = base + uint(keccak256(abi.encodePacked(houseId, now, block.number)))%400;  //5x 
        
    }
    
     else if(houseId%5000 == 0) {
    multiplier = base + uint(keccak256(abi.encodePacked(houseId, now, block.number)))%200;  //3x 
        
    }
    
     else if(houseId%1000 == 0) {
    multiplier = base + uint(keccak256(abi.encodePacked(houseId, now, block.number)))%100;   //2x
        
    }
    
    
    else if(houseId%100 == 0) {
         multiplier = base + uint(keccak256(abi.encodePacked(houseId, now, block.number)))%75; //1.75
    }
    
    else if(houseId%50 == 0) {
    multiplier = base + uint(keccak256(abi.encodePacked(houseId, now, block.number)))%50;   //1.5x 
        
    }
    else if(houseId%25 == 0) {
         multiplier = base + uint(keccak256(abi.encodePacked(houseId, now, block.number)))%25; //1.250
    }
    
    else if(houseId%10 == 0) {
         multiplier = base + uint(keccak256(abi.encodePacked(houseId, now, block.number)))%10; //1.1
        
    }
    else if(houseId%5 == 0) {
        multiplier = base + uint(keccak256(abi.encodePacked(houseId, now, block.number)))%5; //1.05
    }else{
        multiplier = base; //100
    }
    
    return multiplier;
}


function checkIfOwner (address owner, uint houseId) public view returns (bool) {
    
    
    return isOwnerOfHouse[owner][houseId];
    
    
}
function getTier (uint houseId) public view returns (uint) {
    
    return houses[houseId].tier;
}



function getOwner (uint houseId) public view returns (address) {
    
    return houses[houseId].owner;
    
}
function getMultiplier (uint houseId) public view returns (uint) {
    
    return houses[houseId].multiplier;
}
 
function setObjectManager (address newObjecctManager) public returns (bool){
     objectManager = ObjectManager(newObjecctManager);
     
     return true;
     
 } 

 
 //reg
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
    
    uint hashPlots = uint(keccak256(abi.encodePacked("Plots")));
    uint hashStreets = uint(keccak256(abi.encodePacked("Streets")));
     uint hashMovement = uint(keccak256(abi.encodePacked("PolyMovement")));
         uint hashHouse = uint(keccak256(abi.encodePacked("PolyAuction")));
    if (hash == hashPlots) {
        plotsContract = Plots(foundAt);
     bool answer = plotsContract.setHouseContract(address(this));
        //  emit newContractSet ("Boards", foundAt);
        return answer;
    }if (hash == hashStreets) {
        streetsContract = Streets(foundAt);
     bool answer = streetsContract.setHouseContract(address(this));
        //  emit newContractSet ("Boards", foundAt);
        return answer;
   // if( hash == )
    

}if(hash == hashMovement) {
     //   playerContract = PolyPlayer(foundAt);
    bool answer = PolyMovement(foundAt).setHouseContract(address(this));
          
         return answer;
    }if(hash == hashHouse) {
     //   playerContract = PolyPlayer(foundAt);
    bool answer = PolyAuction(foundAt).setHouseContract(address(this));
          
         return answer;
    }
        
} 
    
}