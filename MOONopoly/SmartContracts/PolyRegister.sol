pragma solidity >0.4.24 <=0.6.0;


contract PolyRegister {
 
    
  
    struct registerEntry {
        
        uint id;
        address _Contract;
        string contractType;
        uint hashOfType;
        
        string[] needsType;
        uint[] hashOfNeeds;
    
        
    }
    
mapping (string => address[]) public isInNeedOfType; //give type, get addresses in need; //note, can lookup the typeHash again when given the contract address back
mapping (uint => address[]) public addressesInNeedOfHashType;
mapping (uint => address) public hashAtAddress;
    
mapping (uint => registerEntry) public registerToId;
mapping (string => address) public typeAtaddress;
mapping (address => string) public contractIsType;
mapping (address => uint) public contractIsHash;

mapping(uint => address) public hashOfContractToItsAddress;
mapping(string => uint) public stringToHash;
mapping(uint => string) public hashIsString;
mapping(string => bool) public contractIsLive;
mapping(uint => bool) public HashIsLive;

address[] public defaultOperators;


mapping(uint => uint[]) public registereryEntriesThatNeedHash;
mapping(uint => address[]) public contractsInNeedOfHash;

event NewContractRegistered (string name, uint hash, address foundAt, uint[] hashOfNeeds);
event newFills (uint hash, uint[] hashesOfContracts, address[] contractsInNeed);

    
string[] types;
uint[] hashes;
 
 
 
 function getOperators () public view returns (address[] memory) {
     return defaultOperators;
 }
 
function registerContract (string memory contractType, uint[] memory needs) public returns (bool[] memory, address[] memory) {
    uint inputHash = uint(keccak256(abi.encodePacked(contractType)));
    address[] memory solutions = new address[](needs.length);
    bool[] memory boolSolutions = new bool[](needs.length);
    registerEntry memory newEntry = registerToId[types.push(contractType)];
    uint id = hashes.push(inputHash);
    
//    if(tx.origin == admin) {
    //    defaultOperators.push(msg.sender);
  //  }
    
    
    registerToId[id].id = id;
      registerToId[id]._Contract = msg.sender;
        registerToId[id].contractType = contractType;
          registerToId[id].hashOfType = inputHash;
      registerToId[id].hashOfNeeds = needs;
    typeAtaddress[contractType] = msg.sender;
    hashAtAddress[inputHash] = msg.sender;
    contractIsType[msg.sender] = contractType;
    contractIsHash[msg.sender] = inputHash;
    hashOfContractToItsAddress[inputHash] = msg.sender;
    stringToHash[contractType] = inputHash;
    hashIsString[inputHash] = contractType;
    
    contractIsLive[contractType] = true;
    HashIsLive[inputHash] = true;
    
  
    
    for(uint i=0;i<needs.length;i++){
        uint hashOfNeed = needs[i];
        registereryEntriesThatNeedHash[hashOfNeed].push(id);
        contractsInNeedOfHash[hashOfNeed].push(msg.sender);
        boolSolutions[i] = HashIsLive[hashOfNeed]; 
        solutions[i] = checkIfNeedIsPresent(hashOfNeed);
        addressesInNeedOfHashType[hashOfNeed].push(msg.sender);
        isInNeedOfType[contractType].push(msg.sender);
    }
    
  
    emit NewContractRegistered (contractType, inputHash, msg.sender, needs);
    return (boolSolutions, solutions);
    
}
function checkIfNeedIsPresent (uint hashOfNeed) public returns (address) {
    
    if(HashIsLive[hashOfNeed]){
           return hashOfContractToItsAddress[hashOfNeed];
    }
 
   
}



function fillOthersNeedsIfPossible (uint hashOfNeed, address contractHoldingSolutionToNeed) public returns (address[] memory, uint[] memory) {  //returns the addresses that need this new contract and the hash of their type
    address[] memory contractsInNeedOfThisSolution = addressesInNeedOfHashType[hashOfNeed];
    uint[] memory hashOfTheContractTypeThatFitsSolution = new uint[](contractsInNeedOfThisSolution.length);
    for(uint i = 0; i<contractsInNeedOfThisSolution.length;i++) {
        hashOfTheContractTypeThatFitsSolution[i] = contractIsHash[contractsInNeedOfThisSolution[i]];
        
        
    }
    emit newFills (hashOfNeed, hashOfTheContractTypeThatFitsSolution, contractsInNeedOfThisSolution);
    return (contractsInNeedOfThisSolution, hashOfTheContractTypeThatFitsSolution);
    
}
 
 
    
    
}