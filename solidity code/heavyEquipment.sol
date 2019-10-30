pragma solidity >= 0.4.22 <0.6.0;

import "./ObjectTypes.sol";
import "./GoldClaim.sol";


contract heavyEquipment is objectType {
    
    uint indexOfObject;
    uint indexOfmotor;
    uint indexOfPanel;
    uint indexOfTickets;
    
    
    mapping(uint => objectType._Type) objectIsType;
    
    
    
    struct motor { //and wheels
        uint id;
        uint lastService;
        bool broken;
        uint created; //block number
        uint workingTime; //active blocks worked
        uint speed;
        bool hasTrack;
        uint partOfObjectid; //eg bulldozer
        uint maxTier;  //power of the motor
        uint minTier;
        uint efficient;
        
        
    }
    
    struct tools {
        uint toolsetId;
        uint attachedToObjectId;  //is part of ?
        bool canDig;
        bool canTransfer;
        bool canBulldoze;
        bool hasRipper;
        bool hasTracks;
        uint capacity; //paydirt per hour
        uint efficient; 
        
    }
    
    
    mapping (uint => tools) toolsets;
    
    struct adminPanel {
        uint panelId;    
        uint id;   //id of the object within the type
        uint objectId; //number of object in the game, must be given by parent in the constructor
        address owner;        
        uint companyId;
        address location;  //claim number or cut number
        mapping(address => bool) operators;
        address[] allOperators;
        uint soldAtBlock;
        uint tier; //of the object
        uint runningCost;
        bool forSale;
        uint price; //if not for sale, show price purchased 
        uint size;  //use tier instead?
        string name;             //name the bulldozer
        string color;

    }
    mapping (uint => adminPanel) panels;
    mapping (uint => motor) motors;
    
    struct transferTicket {
        uint ticketNumber;
        uint reward;
        address destinationClaim;
        int x;
        int y;
        bool done;
        uint creation;
        
        
    }
    
mapping(uint => transferTicket) transferRequests;
transferTicket[] allTickets;
mapping(uint => bool) isAlreadyTicket;
uint[] allTicketNumbersArray;




    
function moveToClaim (uint truckid, uint objectToMove, uint targetClaimId) public payable {
    // require to be owner of the truck
    
}
function requestTransfer (uint panelId, address targetClaimId) public payable returns (uint) {
    GoldClaim activeClaim = GoldClaim(targetClaimId);
    
    adminPanel memory activeObject = panels[panelId];
    require(activeObject.location != targetClaimId);
    require(activeObject.owner == msg.sender ); //only owner can create a ticket;
    require(!isAlreadyTicket[panelId]);
    indexOfTickets++;
    transferTicket memory newticket = transferRequests[indexOfTickets];
    isAlreadyTicket[indexOfTickets] = true;
    newticket.ticketNumber = indexOfTickets;
    newticket.reward = msg.value;
    newticket.creation = block.number;
    newticket.destinationClaim = targetClaimId;
    newticket.x = activeClaim.getLocationX();
    newticket.y = activeClaim.getLocationY();
    allTickets.push(newticket);
    allTicketNumbersArray.push(indexOfTickets);
    
    transferRequests[indexOfTickets] = newticket;
    
    
}
function getAllticketNumbers () public view returns (uint[] memory){
    
    return allTicketNumbersArray;
}


    
}