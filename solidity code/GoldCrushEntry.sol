pragma solidity >=0.4.22 <0.6.0;


import "./PlayerManager.sol";
import "./Company.sol";

contract GoldCrushEntry  {
   

    uint companyIdCounter;
    PlayerManager pmanager;
    
 address owner; //admin of the gam
 
    
modifier onlyOwner{
    require(msg.sender == owner);
    _;
}
    
    address[] allCompanies;
    mapping(address => address) companyOwners;  //link a company address to a player (give compnaoy, get player)
    mapping(uint => address) companyIdToAddress; // company id is at address x

    mapping(address => bool) isValidCompany;
    mapping(address => Company) companies;
    mapping(uint => Company) companiesById;
    Company[] allCompaniesArray;
    //
    
    mapping(address => uint) ownedByPlayerId;
  
    
 constructor () public payable {
     
     owner = tx.origin;

 }
 

function createNewCompany (string memory name) public returns (address){
    require(pmanager.checkIfPlayer(msg.sender));
    uint compid = getCompanyId();
  
   uint playerid = pmanager.getPlayerId(msg.sender);
   
    Company newCompany = new Company(compid, name, playerid);
            newCompany.setOwner(msg.sender);
            pmanager.addCompanyToPlayer(address(newCompany));
    allCompanies.push(address(newCompany));
    allCompaniesArray.push(newCompany);
    companyOwners[address(newCompany)]= msg.sender;
    companyIdToAddress[compid]=address(newCompany);
    isValidCompany[address(newCompany)] = true;
    companies[address(newCompany)] = Company(address(newCompany));
    companiesById[compid] = newCompany;
    ownedByPlayerId[address(newCompany)] = playerid;
  //  pmanager.addCompanyToPlayer(address(newCompany));
    return address(newCompany);   
}




function getCompanyId() public returns (uint) {
    
    companyIdCounter++;
    return companyIdCounter;
    
}
function registerCompany (address companyAddress, address playerAddress) public returns(uint) {
    companyIdCounter++;
    allCompanies.push(companyAddress);
    companyOwners[companyAddress] = playerAddress;
    companyIdToAddress[companyIdCounter]=companyAddress;
    return companyIdCounter;
}

function getAllCompanies () public view returns (address[] memory ) {
    
    return allCompanies;
}

function checkCompany (address companyAddress) public view returns (bool) {
    
    return isValidCompany[companyAddress];
}

function setPlayerManager (address ad) public onlyOwner returns (address) {
    pmanager = PlayerManager(ad);
    return address(pmanager);
}

    
}