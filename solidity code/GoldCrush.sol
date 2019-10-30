pragma solidity >=0.4.22 <0.6.0;


import "./Cuts.sol";
import "./Cell.sol";
import "./Layers.sol";
import "./GoldClaim.sol";
import "./helperFunctions.sol";
import "./auction.sol";
import "./ClaimLocationManager.sol";




contract GoldCrush  {  //claim management
    uint indexOfClaims; //just to keep track of amount of claims, claim id is now claim address
    uint totalGoldDust;
    uint goldBarsMinted;
    address parent;
    address auctionHouse;
    ClaimLocationManager clm;
    
    Auction c;
    
    mapping(address => GoldClaim) allClaimsIdToAddress;
    mapping(uint => address) ownerOfClaim;
    mapping(address => address) _ownerOfClaim;
    mapping(address => uint) GoldClaimAddressToClaimId;
    mapping(address => bool) isGoldClaim;
 //mapping(address => uint) AllClaimsToClaimId;
// mapping(uint => address) FromClaimIdToClaimAddress;
    
    GoldClaim[] public goldClaimsArray;
 //   address[] public claimOwnersArray;
 
    constructor () public {
   //     parent = msg.sender;
        
    }
    
function setAuctionHouse (address auctionhouse) public {   //should not be public or have acces modifier
    
    auctionHouse = auctionhouse;
    c = Auction(auctionhouse);
    
}
   
function createNewClaimForAuction (string memory name) public returns (uint) {   // creates a new goldClaim contract on the blockchain and returns the address of it.
    indexOfClaims++;  //id should be address again
    GoldClaim newGoldClaim = new GoldClaim(msg.sender, name, auctionHouse, address(clm));
    address adresOfClaim = newGoldClaim.getAddress();
    // set location;
 //   uint idOfLocation = newGoldClaim.getLocationObjectAttached();
    goldClaimsArray.push(newGoldClaim);
    allClaimsIdToAddress[adresOfClaim] = GoldClaim(adresOfClaim);
  
    isGoldClaim[adresOfClaim] = true;

    uint auctionNr = c.createNewAuction(adresOfClaim);
    
    return auctionNr;
    
    
    
}    

function getAllClaims () public view returns (GoldClaim[] memory) {
    
    return (goldClaimsArray);
}

function checkIfClaim (address claimAddress)  public view returns (bool) {
    
    return isGoldClaim[claimAddress];
} 
function changeOwnerOfClaim (address claim, address futureOwner) public {         // access modifier needed
    // erease old values;
 uint claimId = GoldClaimAddressToClaimId[claim];
 address oldOwner = ownerOfClaim[claimId];
 ownerOfClaim[claimId] = futureOwner;
 _ownerOfClaim[claim] = futureOwner;

    
}
function registerAclaim (address _address) public {
    require(!isGoldClaim[_address]);
    GoldClaim claim = GoldClaim(_address);
    indexOfClaims++;
    
    goldClaimsArray.push(claim);
    isGoldClaim[_address] = true;
    GoldClaimAddressToClaimId[_address] = indexOfClaims;
    
    
    
    
    
}

function getClaimInfo (address addressOfClaim) public view returns (int, int, uint) {   //location x, location y, numberOfCuts, 
    int x = allClaimsIdToAddress[addressOfClaim].getLocationX();
    int y = allClaimsIdToAddress[addressOfClaim].getLocationY();
    uint totalCuts = allClaimsIdToAddress[addressOfClaim].getTotalCutsOnClaim();
    return (x, y, totalCuts);
    
}

function getAddress() public view returns (address) {
    
    return address(this);
}
function setClaimLocManager (address ClaimLocationManagerAddress) public {
    clm = ClaimLocationManager(ClaimLocationManagerAddress);
}
    
    
    
}