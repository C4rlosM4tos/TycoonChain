pragma solidity >0.4.24 <0.6.0;


import "browser/ERC1820Register.sol";
import "browser/PolyRegisterClient.sol";



contract ERC1820ClientWithPoly {
        
        ERC1820Registry public ERC1820REGISTRY;
        PolyRegisterClient public registerPoly; 
    
    constructor (address _registerPoly) public {
        registerPoly = PolyRegisterClient(_registerPoly);
        ERC1820REGISTRY = ERC1820Registry(registerPoly.typeAtaddress("Registry"));
    }
   
 
    
       
    
    
    function setPoly(address poly) internal {
        registerPoly = PolyRegisterClient(poly);
        
    }
   function setRegistry (address reg) internal {
       ERC1820REGISTRY = ERC1820Registry(reg);
   }
 function setInterfaceImplementer(address _addr, bytes32 _interfaceHash, address _implementer) internal {
 
     ERC1820REGISTRY.setInterfaceImplementer(_addr, _interfaceHash, _implementer);
 }

    function setInterfaceImplementation(string memory _interfaceSelector, address _implementation) internal {
        bytes32 interfaceHash = keccak256(abi.encodePacked(_interfaceSelector));
        ERC1820REGISTRY.setInterfaceImplementer(address(this), interfaceHash, _implementation);
    }

    function interfaceAddr(address addr, string memory _interfaceLabel) internal view returns(address) {
        bytes32 interfaceHash = keccak256(abi.encodePacked(_interfaceLabel));
        return ERC1820REGISTRY.getInterfaceImplementer(addr, interfaceHash);
    }

    function delegateManagement(address _newManager) internal {
        ERC1820REGISTRY.setManager(address(this), _newManager);
    }
}