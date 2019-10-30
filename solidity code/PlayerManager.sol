pragma solidity >=0.4.24 <0.6.0;

import "./GoldCrushRegulator.sol";
import "./GoldCrushEntry.sol";
import "./Company.sol";

contract PlayerManager {
    

    Regulator regulator;
    
    
    uint playerIndex;
    
    struct player {
        
        uint playerId;
        string nickname;
    uint highestTier;  //probably keep track in tiers contract
     address LastAccountSeen;
    uint  companiesOwned;
    address owner;
    address[] goldclaims;
    Company[] companies;
    address[] companyAddresses;
    mapping(address => bool) ownsCompany;
    
    
        
    }
    
    mapping(address => bool) HasPlayerAccount;
    mapping(uint => player) players;
    mapping(address => uint) addressToPlayerId;
    mapping(address => player) playersByAddress;
    player[] allPlayersArray;
    
    
    address owner;
   modifier onlyOwner {
    require(msg.sender == owner);
    _;
    }
    
        
    constructor () public {
        owner = msg.sender;
    playerIndex = 0;    
        
        
    }
    
    
    
    
    
function addPlayer (address playerToAdd, string memory name) public returns (uint) {
    require(playerToAdd == tx.origin); //or todo, remove playertoadd argument
    playerIndex++;
    players[playerIndex].nickname = name; 
    players[playerIndex].playerId = playerIndex;
    players[playerIndex].owner = playerToAdd;
    HasPlayerAccount[playerToAdd] = true;
    addressToPlayerId[playerToAdd] = playerIndex;
    playersByAddress[playerToAdd] = players[playerIndex];
    
    
    
    return playerIndex;
    
    
}

function readPlayer (address target) public view returns(uint, string memory, address) {
    
    uint id =addressToPlayerId[target];
    
    string memory name = players[id].nickname;
    address _owner = players[id].owner; 
    
    return (id, name, _owner);
}

function setRegulator (address adres) public onlyOwner {
    
    regulator = Regulator(adres);
    
}

function checkIfPlayer(address _player) public view returns (bool){
        return (HasPlayerAccount[_player]);    
    
}

function getPlayerId(address ad) public view returns (uint) {
    return addressToPlayerId[ad];
}

function getPlayerName (address ad) public view returns (string memory name) {
    
    uint id = addressToPlayerId[ad];
    return players[id].nickname;
    
}

function addCompanyToPlayer(address companyAddress) public returns(address[] memory) { // 
Company activeCompany = Company(companyAddress);
//require(activeCompany.getOwner() == tx.origin);
//require(playersByAddress[tx.origin].owner == activeCompany.getOwner());
playersByAddress[tx.origin].companies.push(activeCompany);
playersByAddress[tx.origin].companyAddresses.push(companyAddress);
playersByAddress[tx.origin].ownsCompany[companyAddress]=true;
playersByAddress[tx.origin].companiesOwned = playersByAddress[tx.origin].companyAddresses.length;

return playersByAddress[tx.origin].companyAddresses;
}

function checkIfPlayerOwnsCompany (address _player, address company) public view returns (bool) {
        return playersByAddress[_player].ownsCompany[company];    
    


}

function getCompaniesOwnedByPlayer (address _player) public view returns (address[] memory) {
return playersByAddress[_player].companyAddresses;    
}

    

}