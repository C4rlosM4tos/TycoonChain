pragma solidity >0.4.24 <0.6.0;



contract ClaimLocationManager {
    uint locationId;
        uint loops;
    address tempAddress;
    uint maxSearch;
    int biggestX;
    int biggestY;
    int smallestX;
    int smallestY;
    int prevX;
    int prevY;
    
    struct location {
        uint locationId;
        int x;
        int y;
        address claim;
        
    }
    
    
    constructor () public {
        biggestX = 1;
        biggestY = 1;
        smallestX =-1;
        smallestY =-1;
        prevX =1;
        prevY = 1;
        maxSearch = 10;
    }
    
    event LocationAdded (int x, int y);
    event startNewLoop(uint loops, int x, int y);
    
    mapping(int =>mapping(int => bool)) activeLocations;
    mapping(int =>mapping(int => location)) claimAtLocation;
    mapping(uint => location) idToLocationObject;
    mapping(address => location) claimAddressToLocationObject;
    mapping(address => bool) hasLocation;
    location[] locations;
    int[] allx;
    int[] ally;
    
function startSearch() public {
    loops = 0;
    lookForLocation(prevX, prevY);
    
}
    
    
 function lookForLocation (int x, int y) public returns (bool) {
     require(loops < maxSearch);
    int newX = x;   
    int newY = y;
     //check if empty place
     bool empty = false;
   
    empty = checkIfNewEmptyFound(newX, newY); //returns true if found
    if(empty){
        return true;
    }
    
    
    bool goRightFirst = checkGoright(newX, newY);
    
    while(!empty && (newX >= biggestX) && goRightFirst){
        newX++;
        if (newX == 0){
            newX = 1;
        }
        empty = checkIfNewEmptyFound(newX, newY);
        if(empty){
            return empty;
        }
    }
   
    
    
    
    
     bool GoDown = checkgoDown(newX, newY);
     
         while (!empty && (newY >= smallestY) &&(GoDown)) {
             newY = newY-1;
             if(newY == 0) {  //skip 0 because it has no locationId
                 newY = -1; }
            empty = checkIfNewEmptyFound(newX, newY);
            if(empty){
                return empty;
                }
        }
    
    
            
            bool goLeft = checkgoLeft(newX, newY);
            
            while(!empty && (newX >= smallestX) && (goLeft)){ //-1 -1
                newX = newX-1;
                    if(newX == 0) {  //skip 0 because it has no locationId
                         newX = -1; 
                    }
            empty = checkIfNewEmptyFound(newX, newY);    
            }
 
            
            
            
             
            bool goUp = checkGoUp(newX, newY);
           
            while(!empty && (newY <= biggestY) && (goUp)){ //x is now negative, we need to scan the y axle again for free supports
            newY++;
            if(newY == 0){
                newY = 1;}
             empty = checkIfNewEmptyFound(newX, newY);        //-1 2
             if(empty) {
                 return empty;
             }
            }
    
            
            
            
      
            bool goRight = checkGoright(newX, newY);
            while (!empty && (newX <= biggestX) && (goRight)){            //1 2
                newX = newX + 1;
                if(newX == 0){
                    newX = 1;
                }
             empty = checkIfNewEmptyFound(newX, newY);  
             if (empty) {
                 return empty;
             }
                         }
     
                         
            
        
            bool _goDown = checkgoDown(newX, newY);
            while(!empty && (newY >= smallestY) && _goDown){
                y--;
                if(y == 0){
                    y = -1;
                }
            empty = checkIfNewEmptyFound(newX,newY);
            if(empty){
                return empty;
            }
                
            }
    
    
    
    
            bool _goLeft = checkgoLeft(newX, newY);
            while(!empty && (newX >= smallestX)&&(_goLeft)){
                x--;
                if(x == 0){
                    x = -1;
                }
            empty = checkIfNewEmptyFound(newX, newY);
            if(empty) {
                return empty;
            }
            }
              
                 bool _GOUP = checkGoUp(newX, newY);
            while(!empty && (newX >= smallestX)&&(_GOUP)){
                y++;
                if(y == 0){
                    y = 1;
                }
            empty = checkIfNewEmptyFound(newX, newY);
            if(empty) {
                return empty;
            }
            
            }           
         
            if(!empty){
                biggestX++;
                biggestY++;
                smallestY--;
                smallestX--;
            }
            loops++;
           emit startNewLoop(loops, newX, newY); 
           
            if(loops > 75) {
            return false;
        }
          if (!empty) {
           
             
              lookForLocation(newX, newY);
          }
          
       
          return true;   
 }
 
            
function checkgoDown(int x, int y) public view returns (bool) {
    y--;
    if (y == 0) {
        y = -1;
    }
     
    if(y < smallestY) {
        return false; // too far too the left
    }
    
    bool filled = seeIfFilled(x, y);
    if(filled){
        filled = seeIfFilled(x, smallestY);
        if(filled){
                 return false; // the next one is filled already
        }
   
    }else{
        
        return true; // could be to the left
    }
    
    return true;
    
    
} 
                 
function checkgoLeft(int x, int y) public view returns (bool) {
    
    x--;
    if(x == 0) {
        x = -1;
    }
    if(x < smallestX) {
        return false; // too far too the left
    }
    
    bool filled = seeIfFilled(x, y);
    if(filled){
        filled = seeIfFilled(smallestX, y);
        if(filled){
                 return false; // the next one is filled already
        }
        return true;
   
    }else{
        
        return true; // could be to the left
    }
    
    
}         
             
function checkGoUp(int x, int y) public view returns (bool) {
    
    y = y+1;
    if(y == 0) { //skip 0, no claim there
        y = 1;
    }
    //check if we are allowed to go checkGoUp
    
    if(y > biggestY) {
        return false;
    }
    
     bool filled = seeIfFilled(x, y);
     if(filled) {
       filled =  seeIfFilled(x, biggestY);
       if (filled){
            return false; // up is already filled;
       }
       return true;
        
     }else{
         return true;
     }
     
     
}         
             
function checkGoright(int x, int y) public view returns (bool) {
    x = x+1;
    if(x == 0) {
        x = 1;
    }
    if(x > biggestX) {
        return false; //out of range if we go to the right more
    }
    bool filled = seeIfFilled(x, y);
        if(filled){
         filled = seeIfFilled(biggestX, y);
         if(filled){
                 return false; 
         }
       
        }else{
            return true;
        }
    
}            
             
         // round here, add one to largest x and call self to repeat

function addLocation (int x, int y) public returns (bool) {
      locationId++;
         activeLocations[x][y] = true; //register location as taken
         location memory newLocation = claimAtLocation[x][y];
         newLocation.x = x;
         newLocation.y = y;
         idToLocationObject[locationId] = newLocation;
         claimAtLocation[x][y] = newLocation;
        emit LocationAdded(x,y);
        prevX = x;
        prevY = y;
        allx.push(x);
        ally.push(y);
        locations.push(newLocation);
        setLocationObject(locationId, x, y);
    return !checkIfNewEmptyFound(x, y); // if false expect true  // extra check if its added;
}
    
function checkIfNewEmptyFound(int x, int y) public returns (bool) { //first time finds an object, add the locations, and as answer it looks again if the location is empty, it should now be true in the look, resulting in answer false (its just added) and will inverse the answer  to true, because it was empty
    
     if(!activeLocations[x][y]){
       return  addLocation(x,y);
        
     }else{
         return false;
     }
}
function seeIfFilled (int x, int y) public view returns (bool) {
   return activeLocations[x][y];
}
function haveFun (uint amount) public {
    for(uint i = 0;i <= amount; i++){
        startSearch();
    }
}
function getAllx () public view returns (int[] memory) {
    
    return allx;
} 
function getAlly () public view returns (int[] memory) {
    
    return ally;
} 
function bindClaimToLocation (address claim) public returns (uint) {
require(!hasLocation[claim]);
    tempAddress = claim;
        startSearch();
        return claimAddressToLocationObject[claim].locationId;
}
function setLocationObject(uint id, int x, int y) public {
    
    idToLocationObject[id].x = x;
    idToLocationObject[id].y = y;
    idToLocationObject[id].locationId = id;
    idToLocationObject[id].claim = tempAddress;
    claimAtLocation[x][y]=idToLocationObject[id];
    locations.push(idToLocationObject[id]);
    claimAddressToLocationObject[tempAddress] =idToLocationObject[id];
    hasLocation[tempAddress] = true;
    tempAddress = address(999);
 
}
function getX (uint id) public view returns (int) {
    return idToLocationObject[id].x;
}
function getY (uint id) public view returns (int) {
    return idToLocationObject[id].y;
}

}

    
