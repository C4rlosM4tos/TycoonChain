pragma solidity >0.4.24 <=0.6.0;

import "browser/ERC721Full.sol";

import "browser/ERC1820Client.sol";

 
    
contract DataProcessor is ERC1820ClientWithPoly, IERC721Receiver {  
  
  
  
    
    event newData (bytes data, bytes32[] dataArray, uint dataId); 
    event processedData (string blabla, uint amount);



struct setOfData {
    uint id;
    bytes data;
    bytes32[] dataInBytes;
    
    
    
    
    
}


mapping (uint => setOfData) public dataSets;
mapping (bytes => setOfData) public dataIsDataSet;
mapping (bytes => uint) public dataIsDataSetId;

setOfData[] public datasetsArray;
uint[] public allDataSetsArray;
bytes[] dataArray;


    
    
    constructor ( address _PolyRegister)ERC1820ClientWithPoly(_PolyRegister) public {
         uint[] memory needs = new uint[](4);
      setPoly(_PolyRegister);
       setRegistry(registerPoly.typeAtaddress("Registry"));
         needs[0] = uint(keccak256(abi.encodePacked("Plots")));
         needs[1] = uint(keccak256(abi.encodePacked("Houses")));
         needs[2] = uint(keccak256(abi.encodePacked("PolyObjectManager")));
          needs[3] = uint(keccak256(abi.encodePacked("PolyAuction")));
              (bool[] memory boolSolutions, address[] memory solutions) = registerPoly.registerContract("DataClient", needs);
          if(solutions.length > 0) {
              
              for(uint i = 0; i<solutions.length;i++) {
                  if(boolSolutions[i]){
                      if(i == 0) {
               
                      }else if(i == 1) {
                   
                      }else if(i == 2) {
               
                  }else if(i == 3) {
                
                  }
                  
         
              }
              
          }   
           (address[] memory contractsInNeed, uint[] memory hashesOfContractTypesinNeed) = registerPoly.fillOthersNeedsIfPossible(uint(keccak256(abi.encodePacked("DataClient"))), address(this));
 
        setInter();
      
        
      }
      
       
    }
    
    
function getDataFromSet (uint setId) public view returns (bytes32[] memory){
    
    return dataSets[setId].dataInBytes;
}
function getDataFromSet (bytes memory _data) public view returns (bytes32[] memory){
    
    return dataIsDataSet[_data].dataInBytes;
}


function addData (bytes memory _data, bytes32[] memory _setOfData) public returns (uint dataId){

    
    dataId = dataArray.push(_data);
    setOfData memory newSet = dataSets[dataId];
     dataSets[dataId].id = dataId;
      dataSets[dataId].data = _data;
       dataSets[dataId].dataInBytes = _setOfData;
       
       datasetsArray.push(dataSets[dataId]);
       allDataSetsArray.push(dataId);
       dataIsDataSet[_data] = dataSets[dataId];
       dataIsDataSetId[_data] = dataId;
       
       
           emit newData (_data, _setOfData, dataId);
       return dataId;
    
    
    
    
}


function setInter () public {
   

    setInterfaceImplementation("DataProcessor", address(this));
    setInterfaceImplementation("DataClient", address(this));
    
}







function onERC721Received(address operator, address from, uint256 tokenId, bytes memory data) public returns (bytes4) {
          string memory nameOfToken = ERC721Full(msg.sender).name();
          uint hashesOfName = uint(keccak256(abi.encodePacked(nameOfToken)));
          uint HashOfTarget = uint(keccak256(abi.encodePacked("Plots")));
    uint globalId = ERC721Full(msg.sender).getGlobalId(tokenId);
  
    if(hashesOfName == HashOfTarget) {
              
              
        
       
       
    }

      
   

      
      return bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"));
  }


  


}