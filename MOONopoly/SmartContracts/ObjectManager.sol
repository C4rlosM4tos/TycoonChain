pragma solidity >0.4.24 <0.6.0;


//import "browser/streetsInteface.sol";
import "browser/plotsInterface.sol";
import "browser/auctionInterface.sol";
import "browser/housesInterface.sol";
import "browser/ERC1820Client.sol";

contract ObjectManager is ERC1820ClientWithPoly{
    
    uint public maxTier;
    
    uint public globalObjectCounter;
   
    
    
    struct object {
        uint id;
        uint tier; 
        string typeOfObject;
        uint hashOfType;
        uint idWithinType; //eg => streetnumber, housenumber
        address owner;
        
        
        
    }
    
    mapping(uint => bool) public isTier;
    mapping(uint => object) public objectsById;
    mapping(uint => bool) public isRegisteredObject;
    mapping(address => uint) public ownerToObject; // this is wrong 
    mapping(uint => address) public objectToOwner;
    mapping(uint => mapping(uint => uint)) public objectsOfTier;  // of same type
    mapping(address => mapping(uint => bool)) public isOwnerOfObject;
    
    string[] public alltypes;
  //      PolyRegister registerPoly;
    
     event OnCallbackEvent (uint[], address[], bool[]);
    event newContractSet (string name, address contractSet);
    event newObjectLogged (uint globalId, string whatObject, uint idOfObjectInType);
      
      
    uint[] allTiers; 
     
      
      
      
        
    constructor (address _PolyRegister) public ERC1820ClientWithPoly(_PolyRegister) {
         uint[] memory needs = new uint[](1);
    //    registerPoly = PolyRegister(_PolyRegister);
         needs[0] = uint(keccak256(abi.encodePacked("Registry")));
    //     needs[1] = uint(keccak256(abi.encodePacked("")));
      
              (bool[] memory boolSolutions, address[] memory solutions) = registerPoly.registerContract("ObjectManager", needs);
          if(solutions.length > 0) {
              
              for(uint i = 0; i<solutions.length;i++) {
                  if(boolSolutions[i]){
                      if(i == 0) {
             //             register = ERC1820Registry(solutions[i]);
                      }else if(i == 1) {
                     //     houseContract = Houses(solutions[i]);
                      }
                  }
                  
                  
                  
              }
              
          }   
           (address[] memory contractsInNeed, uint[] memory hashesOfContractTypesinNeed) = registerPoly.fillOthersNeedsIfPossible(uint(keccak256(abi.encodePacked("ObjectManager"))), address(this));
         onCreationCallback(hashesOfContractTypesinNeed, contractsInNeed);
         setInter();
    } 
   
    
  
function setInter () internal {

    setInterfaceImplementation("ObjectManager", address(this));
 }  
    
function getNewId () public returns (uint) {
    
    globalObjectCounter++;
    return globalObjectCounter;
    
}
function registerNewObject (uint id, string memory objectType, uint idInType, address _owner, uint tier) public returns (uint) {  //id = globalId
    
    
    require(!isRegisteredObject[id], "the given id is already registered");
    
    object memory newObject = objectsById[id];
        objectsById[id].id =id;
        objectsById[id].tier = tier;
        objectsById[id].typeOfObject = objectType;
        objectsById[id].hashOfType = uint(keccak256(abi.encodePacked(objectType)));
        objectsById[id].idWithinType = idInType;
        objectsById[id].owner = _owner;
        objectToOwner[id] = _owner;
        ownerToObject[_owner] = id;
        isOwnerOfObject[_owner][id] = true;
        
        isRegisteredObject[id] = true;
        
        if(isTier[tier]){
            
             
        }else{
           
           allTiers.push(tier);
           isTier[tier] = true;
           maxTier = tier;
           
           
        }
        
         objectsOfTier[objectsById[id].hashOfType][tier] += 1;
        emit newObjectLogged (id, objectType, idInType);
    // return checkIfActionIsNeeded(id); 
      createAuctionOnRegistration(id);  
        
        
}    


function checkIfActionIsNeeded (uint globalId) public returns (uint) {
     uint[3] memory cases =[(uint(keccak256(abi.encodePacked("Street")))),(uint(keccak256(abi.encodePacked("Plot")))),(uint(keccak256(abi.encodePacked("House"))))];
     uint[3] memory types =[(uint(keccak256(abi.encodePacked("PolyAuction")))),(uint(keccak256(abi.encodePacked("Plots")))),(uint(keccak256(abi.encodePacked("Houses"))))]; //contracts
     uint hashQuestion =uint(keccak256(abi.encodePacked(objectsById[globalId].typeOfObject)));
       if(hashQuestion == cases[0]){
              auctionInterface(address(registerPoly.hashAtAddress(types[0]))).createNewAuction(globalId); 
    
     } if(hashQuestion == cases[1]){
      auctionInterface(address(registerPoly.hashAtAddress(types[0]))).createNewAuction(globalId);
     } if(hashQuestion == cases[2]){
    
        
        auctionInterface(address(registerPoly.hashAtAddress(types[0]))).createNewAuction(globalId);
        checkIfSupplyOfHousesIsBigEnough(globalId); //loop
              
           
              
          } 
          
         
     }

function checkIfSupplyOfHousesIsBigEnough (uint globalId) internal returns (bool) {
    uint[3] memory cases =[(uint(keccak256(abi.encodePacked("Street")))),(uint(keccak256(abi.encodePacked("Plot")))),(uint(keccak256(abi.encodePacked("House"))))];
    uint[3] memory types =[(uint(keccak256(abi.encodePacked("PolyAuction")))),(uint(keccak256(abi.encodePacked("Plots")))),(uint(keccak256(abi.encodePacked("Houses"))))]; //contracts
     uint tier = getTierOfObject(globalId);
          uint supplyOfPlots = objectsOfTier[cases[1]][tier];
          uint supplyOfHouses = objectsOfTier[cases[2]][tier];
          
          if (supplyOfPlots/2 <= supplyOfHouses) {
              return true;
          }else{
             housesInterface (registerPoly.hashAtAddress(types[2])).createNewHouse(tier); 
          }
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
            
            uint hashStreets = uint(keccak256(abi.encodePacked("Streets")));
            uint hashPlots = uint(keccak256(abi.encodePacked("Plots")));
             uint hashHouse = uint(keccak256(abi.encodePacked("Houses")));
               uint hashAuction = uint(keccak256(abi.encodePacked("PolyAuction")));
            if (hash == hashStreets) {
        
            } if (hash == hashPlots) {
             bool answer = plotsInterface(foundAt).setPolyObjectManager(address(this));
          //        emit newContractSet ("Boards", foundAt);
                return answer;
    
            }if (hash == hashHouse) {
             bool answer = housesInterface(foundAt).setObjectManager(address(this));
          //        emit newContractSet ("Boards", foundAt);
                return answer;
    
    }if (hash == hashAuction) {
             bool answer = auctionInterface(foundAt).setObjectManager(address(this));
          //        emit newContractSet ("Boards", foundAt);
                return answer;
    
    }
        }  
        
 //getters     
function getTypeOfObject (uint globalId) public view returns (string memory) {
     uint[3] memory cases =[(uint(keccak256(abi.encodePacked("Street")))),(uint(keccak256(abi.encodePacked("Plot")))),(uint(keccak256(abi.encodePacked("House"))))];
     
  
            uint hashQuestion =uint(keccak256(abi.encodePacked(objectsById[globalId].typeOfObject)));
     if(hashQuestion == cases[0]){
         return "Street";
     } if(hashQuestion == cases[1]){
         return "Plot";
     } if(hashQuestion == cases[2]){
         return "House";
         
     }}
function getHashOfObjectType (uint globalId) public view returns (uint) {
      uint[3] memory cases =[(uint(keccak256(abi.encodePacked("Street")))),(uint(keccak256(abi.encodePacked("Plot")))),(uint(keccak256(abi.encodePacked("House"))))];
     uint hashQuestion =uint(keccak256(abi.encodePacked(objectsById[globalId].typeOfObject)));
       if(hashQuestion == cases[0]){
         return cases[0];
     } if(hashQuestion == cases[1]){
         return cases[1];
     } if(hashQuestion == cases[2]){
         return cases[2];
         
     }
     
     
     
 }
function getIdWithinTheType (uint globalId) public view returns (uint) {
    
    return objectsById[globalId].idWithinType;
    
}
function checkIfObject (uint globalId) public view returns (bool) {
    
    
   
    return isRegisteredObject[globalId];
    
}
function getSupplyOfTier(string memory objectType, uint tier) public view returns (uint) {
    uint objectTypeHash = uint(keccak256(abi.encodePacked(objectType)));
    return objectsOfTier[objectTypeHash][tier];
}
function getTierOfObject (uint globalId) public view returns (uint)  {
    return objectsById[globalId].tier;
}
function checkIfOwnerOfObject (uint globalId, address owner) public view returns (bool) {
    return isOwnerOfObject[owner][globalId];
}
function createAuctionOnRegistration (uint globalId) internal {
    auctionInterface(registerPoly.typeAtaddress("PolyAuction")).createNewAuction(globalId);
}

}

    
    
    
