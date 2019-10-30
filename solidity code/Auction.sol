pragma solidity >=0.4.22 <0.6.0;


import "./GoldCrush.sol";
import "./GoldClaim.sol";
import "./SafeMath.sol";

contract Auction { // for claims

using SafeMath for uint;
    
    uint public auctionNumber;
    
    address auctionHouseOwner; //parentContract game logic

    uint timeStamp;  //in blocks
    
    GoldCrush public ClaimContract;
    
    
    struct _auction {
        
        uint id;                    //sale nr:
        uint price;
        address object; 
        address owner;// the address of the object
        string name;                              //name of the object
        uint timeStamp;                                 //time of createNewAuction
        address previousOwner;
        bool closed;
        
        
    }
    mapping(uint => _auction) allAuctions;
    mapping(address => uint) claimAtAuction;
    mapping(uint => address) auctionToClaimAddress;
    
    address[] allClaims;
    address[] allAuctionsArray;
    uint[] allAuctionIds;
    
    mapping(address => bool) objectIsAtAuctionHouse;
    
     
    
    
    
    
    
     constructor () public {
        
        auctionHouseOwner = msg.sender;
        auctionNumber = 0;
        
        
        
        
    }
    mapping(address => bool) isSellAble;
    mapping(address => uint) claimsToAuctionNumber;
    
    address[] allClaimsForSale;
    
    address[] allSoldClaims;
    uint[] allClosedAuctions;
    
    
    
    
    
function createNewAuction (address objectId) public returns (uint) {
   
   require(checkifClaim(objectId));
  require(!objectIsAtAuctionHouse[objectId]);
 
   GoldClaim newClaim = GoldClaim(objectId);
   require(newClaim.checkForSale());
 uint idOfLocation = newClaim.getLocationObjectAttached();
    newClaim.setOwner((address(this)));
    
        auctionNumber++;
    uint timeNow = block.number;
    uint startPrice = 1*10**20;

    _auction memory newClaimToBeSold = allAuctions[auctionNumber];
    newClaimToBeSold.id = auctionNumber;
    newClaimToBeSold.price = startPrice;
    newClaimToBeSold.timeStamp = timeNow;
    newClaimToBeSold.object = objectId;

    newClaimToBeSold.name = newClaim.getName();
    newClaimToBeSold.previousOwner = msg.sender;
    claimAtAuction[objectId] = auctionNumber;
    auctionToClaimAddress[auctionNumber] = objectId;
    objectIsAtAuctionHouse[objectId] = true;             
    allAuctions[auctionNumber] = newClaimToBeSold;
    allAuctionIds.push(auctionNumber);
    allClaims.push(objectId);
    
    
    
  
    
    return auctionNumber;

}
    
    
    
    
function buyClaim (uint auctionId) public payable returns (uint) {
 require(allAuctions[auctionId].price <= msg.value);
 require(!allAuctions[auctionId].closed);
    GoldClaim claimToBuy = GoldClaim(allAuctions[auctionId].object); 
            claimToBuy.setOwner(msg.sender); //not working?
            claimToBuy.setForSale(false);
            allAuctions[auctionId].name = "sold";
    allAuctions[auctionId].closed = true;
    allAuctions[auctionId].owner = msg.sender;
    allAuctions[auctionId].price = msg.value;
    objectIsAtAuctionHouse[allAuctions[auctionId].object] = false;
    allSoldClaims.push(allAuctions[auctionId].object);
    
    
    
            
}




    
function getTimeNow () public view returns (uint) {
    
    return block.number;

}
function checkifClaim (address claimAddress) public view returns (bool) {
   
    
    return   ClaimContract.checkIfClaim(claimAddress);
    
}

function getBetterPrice (uint auctionId) public returns (uint) {
    _auction memory activeAuction = allAuctions[auctionId];
    uint currentblock = block.number;
    
    uint blockGap = currentblock.sub(activeAuction.timeStamp);
    uint currentPrize = activeAuction.price;
    if(currentPrize.div(1000) >= 10000) {
    uint reduction = (currentPrize.mul(blockGap)).div(1000) ;
     currentPrize = currentPrize.sub(reduction);
     if(currentPrize > 100) {
         activeAuction.price = currentPrize; 
     }
    allAuctions[auctionId] = activeAuction;
     
    }
     return activeAuction.price;
     
    
    
    
    
}

function getAuction (uint auctionid) public view returns (uint, uint, address, uint, string memory, bool) {
    _auction memory activeAuction = allAuctions[auctionid];
    uint price = activeAuction.price;
    uint time = activeAuction.timeStamp;
    uint Timenow = block.number;
    address a = activeAuction.object;
    string memory name = activeAuction.name;
   
    bool sold = activeAuction.closed;
    
    
    return (price, time, a, Timenow, name, sold);
    
    
    
    
    
}

function getAllactiveAuctions () public view returns (uint[] memory) {
    
    return allAuctionIds;
}

function GetAuctionIdByAddress (address _address) public view returns (uint) {
    
    return claimAtAuction[_address];
    
}
function getAddressForAuctionId (uint auctionid) public view returns (address) {
    
    return auctionToClaimAddress[auctionid];
}

function getAllactiveClaimsInAuction () public view returns (address[] memory) {
    
    return allClaims;
}
function setGoldCrush (address claims) public {

        ClaimContract = GoldCrush(claims);
    
}
function prospectClaim (address claimAddress) public payable returns (uint) {  // returns the number of cuts possible after prospecting

   
   return GoldClaim(claimAddress).prospectGoldClaim.value(msg.value)();
}
function viewClaim (address claimToView) public view returns (uint, int, int, address ) {
    uint cuts = GoldClaim(claimToView).getTotalCutsOnClaim();
    int x= GoldClaim(claimToView).getLocationX();
    int y= GoldClaim(claimToView).getLocationY();
    address owner = GoldClaim(claimToView).getOwner();
    
    return (cuts, x, y, owner);
    
}
    
    
    
    
}