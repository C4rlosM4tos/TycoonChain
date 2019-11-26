pragma solidity >0.4.24 <0.6.0;


 
contract auctionInterface { 


function canImplementInterfaceForAddress(bytes32 _interfaceHash, address _addr) external view returns(bytes32);
function createNewAuction (uint globalId, string memory name, uint hashOfName, address from, uint tokenId) public returns (uint);
function createNewAuction (uint globalId) public returns (uint);


function onCreationCallback(uint[] memory hashOfType, address[] memory contractsInNeedOfThis) public returns (bool[] memory) ;
function checkIfStreet (string memory typeOfObject, string memory typeToCheck) public view returns (bool) ;
function checkHash (uint hash, address foundAt ) public returns (bool) ;

function setInter () public ;
function setTokenContract (address _tokenContract) public returns (bool);
function setHouseContract (address newcontract) public returns (bool);
function setObjectManager (address objectManagerContract) public returns (bool);


function buyObject (uint globalId, address buyer) public  ;


function getPrice (uint globalId) public view returns (uint);

function setPrice (uint globalId, uint price) public ;


 function onERC721Received(address operator, address from, uint256 tokenId, bytes memory data) public returns (bytes4);
}


 
   
 