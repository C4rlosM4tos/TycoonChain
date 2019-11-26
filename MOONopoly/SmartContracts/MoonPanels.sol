pragma solidity >0.4.24 <0.6.0;

import "browser/PolyRegister.sol";
import "browser/PolyObjectManager.sol";
import "browser/PolyAuction.sol";

import "browser/ERC721Full.sol";

contract MoonPanels is ERC721Full {
    
        address public owner;
        PolyRegister registerPoly;
    
    struct panel {
        
        uint globalId;
        uint id;
        uint house;
        bool hasHouse;
        address owner;
        uint tier;
         
        
        
    }
    
    
    modifier onlyOwner {
        require(msg.sender == owner, "you don't have the rights to change the owner");
        _;
    }
    
        constructor (address _PolyRegister) ERC721Full("MoonPanels", "MPN") public {
            
            owner = msg.sender;
            
           uint[] memory needs = new uint[](0);
           registerPoly = PolyRegister(_PolyRegister);
      //     needs[0] = uint(keccak256(abi.encodePacked("Plots")));
    //       needs[1] = uint(keccak256(abi.encodePacked("Streets")));
      //     needs[2] = uint(keccak256(abi.encodePacked("PolyObjectManager")));
     //      needs[3] = uint(keccak256(abi.encodePacked("PolyAuction")));
              (bool[] memory boolSolutions, address[] memory solutions) = registerPoly.registerContract("MoonPanels", needs);
          if(solutions.length > 0) {
              
              for(uint i = 0; i<solutions.length;i++) {
                  if(boolSolutions[i]){
                      if(i == 0) {
                      //    plotsContract = Plots(solutions[i]);
                      }else if(i == 1) {
                    //      streetsContract = Streets(solutions[i]);
                      }else if(i == 2) {
                      //    objectManager = ObjectManager(solutions[i]);
                      }else if(i == 3) {
                    //      auctionHouse = PolyAuction(solutions[i]);
                      }
                  
                  
                  
                 }
              
          }   
           (address[] memory contractsInNeed, uint[] memory hashesOfContractTypesinNeed) = registerPoly.fillOthersNeedsIfPossible(uint(keccak256(abi.encodePacked("MoonPanels"))), address(this));
         onCreationCallback(hashesOfContractTypesinNeed, contractsInNeed);
         }

    }  
    
    mapping(uint => panel) public globalIdToPanel;
    mapping(uint => panel) public panelIdToPanel;
    mapping(uint => uint) public panelIsGlobalid;
    mapping(uint => uint) public globalIdIsPanel;
    
    
    
    uint[] allGlobalIdsOfPanels;
    panel[] allPanelsArray;
    
function getGlobalId(uint tokenId) public view returns (uint) {
     
    return panelIdToPanel[tokenId].globalId;
}
    
    
function createNewPanel (uint tier) public {
    
    uint globalId = ObjectManager(registerPoly.typeAtaddress("PolyObjectManager")).getNewId();
    uint panelId = allGlobalIdsOfPanels.push(globalId);
    panel memory newPanel = globalIdToPanel[globalId];
   
    allPanelsArray.push(globalIdToPanel[globalId]);
    globalIdToPanel[globalId].id = panelId;
    globalIdToPanel[globalId].globalId = globalId;
      ObjectManager(registerPoly.typeAtaddress("PolyObjectManager")).registerNewObject(globalId, "MoonPanel", panelId, owner, tier);
    _safeMint(owner, panelId); 
    panelIsGlobalid[panelId] = globalId;
    globalIdIsPanel[globalId] = panelId;
     panelIdToPanel[panelId] = globalIdToPanel[globalId];
    
    
}
function onCreationCallback(uint[] memory hashOfType, address[] memory contractsInNeedOfThis) public returns (bool[] memory) {
        bool[] memory answers = new bool[](contractsInNeedOfThis.length);
            for(uint i = 0; i < contractsInNeedOfThis.length;i++) {
                uint hash = hashOfType[i];
                address foundAt = contractsInNeedOfThis[i];
                
                answers[i] = (checkHash(hash, foundAt));
         //       testCallOwn.push(answers[i]);
                
                
            }
   //      emit OnCallbackEvent (hashOfType, contractsInNeedOfThis, answers);
       
         return answers;
        }
function checkHash (uint hash, address foundAt ) public returns (bool) {
    
//    uint hashPlots = uint(keccak256(abi.encodePacked("Plots")));
  //  uint hashStreets = uint(keccak256(abi.encodePacked("Streets")));
//     uint hashMovement = uint(keccak256(abi.encodePacked("PolyMovement")));
   //      uint hashHouse = uint(keccak256(abi.encodePacked("PolyAuction")));
 //   if (hash == hashPlots) {
 //       plotsContract = Plots(foundAt);
 //    bool answer = plotsContract.setHouseContract(address(this));
        //  emit newContractSet ("Boards", foundAt);
   //     return answer;
    
  //  }
        
} 
function setOwner () public onlyOwner {
    owner = msg.sender;
}
    
    
}