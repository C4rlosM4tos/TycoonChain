pragma solidity >=0.4.22 <0.6.0;



import "./Cuts.sol";
import "./Cell.sol";
import "./Layers.sol";
import "./helperFunctions.sol";
import "./GoldCrush.sol";
import "./auction.sol";
import "./SafeMath.sol";
import "./heavyEquipment.sol";
import "./ClaimLocationManager.sol";




contract GoldClaim is helperFunctions, Cuts, mine {
    
    ClaimLocationManager clmanager;
    ClaimLocationManager.location locationObject;
    int x;
    int y;
    using SafeMath for uint;
    
    uint numberOfOwners;
    bool faucetIsHot;
    uint previousFaucet;
    
   address auctionHouseAddress;
    Auction auctionHouse;
    address creator;
    
    string public nameOfTheClaim;
    bool forSale;
   
    int locationOnTheMapX;
    int LocationOnTheMapY; // xy map
    bool prospected;
    
    
    uint internal previousRandom;
    uint internal nonceCounter;
    
    
    uint id;  //number of claim
    address owner;
    uint totalGoldFound;
    uint totalPaydirt;
    uint totalCutsOnTheClaim;
    
    mapping(address => bool) owners;
    address[] allOwners; //all old and new owners
    
    mapping(address => uint) ownerNumber;

   
        uint goldFound;
    
        address[] coOwners;
        mapping(address => bool) isCoOwner;
        Cuts[] cuts;
        uint maxCuts;
        uint[] objectsOnTheClaim;
       // uint[] objectsInStorage; //also on the claim
        uint maxObjectsPossible; // hangar size;
        
        
        

 
 
    
    
    
    constructor (address _creator, string memory name, address auctionhouse, address clm) public payable  { //creator should be auction house?
        creator = _creator;
      clmanager = ClaimLocationManager(clm);
        forSale = true;
        nameOfTheClaim = name;
        auctionHouseAddress = auctionhouse;
        auctionHouse = Auction(auctionHouseAddress);
        numberOfOwners = 0;
        //fire event?
        
    
      
        
    }
    
    
    modifier OnlyOwner () {
        require(msg.sender == owner);
        _;
    }
    modifier PaidOption () {
       require( msg.value >= 1  ether);
        _;
    
    }
    

    
function getAddress () public view returns (address) {
    
    return address(this);
    
}

function prospectGoldClaim () public payable PaidOption returns (uint) {  //needed to reveal amount of cuts possible. Advised to do this before you buy the claim.
         require(!prospected);

  totalCutsOnTheClaim = 1 + random(id + msg.value + block.number + (uint160(address(this))) + now)%10;
  prospected = true;
  //  for(uint i=0; i < totalCutsOnTheClaim; i++) {
   //     Cut activecut = Cut(address);
   return (totalCutsOnTheClaim);
        
    
    
}

function getLocationX() public view returns (int) {
    
    return locationObject.x;
}
function getLocationY() public view returns (int) {
    
    return locationObject.y;
}
function getLocationId () public view returns (uint) {
    return locationObject.locationId;
}


function createCut() public payable OnlyOwner {  //create the actual prospected cuts
    require(prospected);
    require(totalCutsOnTheClaim > 0); //should be the same as prospected
    require(cutsArray.length == 0);
    uint max = 10;  //should not be needed
    setOwnerOfClaim(owner);
   
   while((cutsArray.length < totalCutsOnTheClaim) && ( max > 0)){
           createNewCutNow();
           max--;
           
   }

    
    
       }



function getIdOfClaim() public view returns (uint) {

return id;    
    
}

function getName () public view returns (string memory) {
    return nameOfTheClaim;
}
function setName (string memory name) public payable returns (string memory) {
    
    nameOfTheClaim = name;
    return nameOfTheClaim;
}
function checkForSale() public view returns (bool) {
    return forSale;
}
function setForSale (bool status) public returns (bool) {
    
    forSale = status;
    return forSale;
}

function getOwner () public view returns (address) {
    
    return owner;
    

}

function setOwner (address newOwner) public  {   //not public ofc! public for testing  //need modifier so auction house can change owner
   
    // clear all old owners when claim gets new owners. // to do , co-owners
    for(uint i=0;i < allOwners.length;i++) {
    address temp = allOwners[i];
    owners[temp] = false;
    deleteOwner(temp);
    
    
    }
  
     allOwners.push(newOwner);
    
    owner = newOwner;
 //   GoldCrush gc = GoldCrush(creator);
    setOwnerOfClaim(newOwner);
    
    ownerNumber[owner] = numberOfOwners;
    
}



function getTotalCutsOnClaim () public view returns (uint) {
    
    return totalCutsOnTheClaim;
}


function getOwnerOfClaim () public view returns (address) {
    
    return owner;
}

function mine (uint layer, uint x, uint y) public  {
    
    
}

function deleteOwner (address owner) public OnlyOwner {
    
   uint index =ownerNumber[owner];
   allOwners[index] = allOwners[allOwners.length-1];
    

}
function setClaimLocationManager (address adres) public {
    clmanager = ClaimLocationManager(adres);
    
}
function getLocationObjectAttached() public returns(uint) {
    uint idOftheObject = clmanager.bindClaimToLocation(address(this));
    int x = clmanager.getX(idOftheObject);
    int y = clmanager.getY(idOftheObject);
    locationObject.locationId = idOftheObject;
    locationObject.x = x;
    locationObject.y = y;
    locationObject.claim = address(this);
    return idOftheObject;
}




}
    

