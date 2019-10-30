pragma solidity >= 0.4.22 <0.6.0;





contract objectType {
    
    uint indexCounterOfTypes;
    

    
    
    struct _Type {
        
        uint typeId;
        string name; // eg: bulldozers
        string subCategory;
        uint subCategoryId;
        
        
        
        
        
    }
    mapping(string => bool) isCategoryName;
    mapping(string => uint) categories;
    mapping(uint => bool) isCategoryId;
    mapping(uint => string) whatType;
    
mapping(uint => _Type) types;    
_Type[] allTypesOfobjects;
    



    
    


    function addType(string memory catName) public returns (uint) {
    require(!isCategoryName[catName]);
    indexCounterOfTypes++;
    isCategoryName[catName] = true;
    categories[catName] = indexCounterOfTypes;
    isCategoryId[indexCounterOfTypes]=true;
    types[indexCounterOfTypes] = _Type(indexCounterOfTypes, catName, "", 0);
    allTypesOfobjects.push(types[indexCounterOfTypes]);
    whatType[indexCounterOfTypes] = catName;
    
    return indexCounterOfTypes;
      }
      
      
      
function getType (uint typeId) public view returns (string memory) {
    
    return whatType[typeId];
    
}
      
function getTypeTest (uint typeId) internal view returns (_Type memory) {
    
    return types[typeId];
    
}

   
      
}