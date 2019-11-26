pragma solidity >0.4.24 <=0.6.0;


contract DataClient {  

function getDataFromSet (uint setId) public view returns (bytes32[] memory);
function getDataFromSet (bytes memory _data) public view returns (bytes32[] memory);


function addData (bytes memory _data, bytes32[] memory _setOfData) public returns (uint dataId){
    
   
    
    
}


function setInter () public;
 

function setData () public;
  


function getData (bytes memory data) public returns (string memory name, uint amount);


function onERC721Received(address operator, address from, uint256 tokenId, bytes memory data) public returns (bytes4);
 
      

  }
  