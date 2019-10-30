pragma solidity >=0.4.22 <0.6.0;

import "./Company.sol";
import "./GoldCrushEntry.sol";


contract Player  {
    // keep track of stats in stack // all tx should also be managed in the gold contract or objects parent contract
    uint playerId; 
    string nickname;
    uint highestTier; 
    uint goldOreFound;
    uint GoldBarsSold;
    uint GoldBarsInStock;
    address LastAccountSeen;
    uint public companiesOwned;
    
    
    //internal operations
    
    address parent;
    GoldCrushEntry c;
    
    
    address[] playerAddresses; // 1 player can have multiple eth wallets/accounts
    address[] companies;  //all companies owned by this player
    address[] coOwnerOf;
    
    // a player can add other players(friends), claims or companies  to a list to watch;
    address[] watchListPlayers;
    address[] watchListClaims;
    address[] watchListCompanies;
    
    
    
    mapping(address => bool) isCoOwnerOf;
    mapping(address => bool) isOwner; 
    mapping(address => uint) addressesForPlayerId;  // should be in general game logic contract
    
    
constructor (address _parent, string memory name) public payable {  //parent should be known, added for testing purpose 
    nickname = name;
    parent = _parent;
 //   playerId = id;
    highestTier = 1;
      c = GoldCrushEntry(parent);
   
   
    LastAccountSeen = tx.origin;
    playerAddresses.push(LastAccountSeen);
    isOwner[tx.origin] = true;
    addressesForPlayerId[LastAccountSeen] = playerId;
//    c.registerPlayer(address(this), id);
  
    
}

function setPlayerId (uint val) internal returns (uint) { //not used anymore
    // should be internal?
    
    playerId = val;
}
function registerPlayerToTheGame () public returns (uint) {
    
 // playerId =  c.registerPlayer(address(this));
  return playerId;
}

function getName() public view returns (string memory) {
    
    
    return nickname;
}

function createCompany (string memory name) public returns (address) {
 //   GoldCrushEntry mainContract = GoldCrushEntry(parent);
   // uint companyId = mainContract.getCompanyId();//ask for a new id, need to ask to main game contract
 //   Company newCompany = new Company (companyId, name);
   // companies.push(address(newCompany));
  //  mainContract.registerCompany(address(newCompany), companyId, address(this));
    companiesOwned++;
    
//    return address(newCompany);
    
    
}

function getCompaniesOwnedByThisPlayer () public view returns (address[] memory ) {
    
    return companies;
    
}

function getPlayerAddresses () public view returns (address[] memory ) {
    
    return playerAddresses;
    
}

function GetPlayerId () public view returns (uint) {
    
    return playerId;
}
    
    
    
    
}