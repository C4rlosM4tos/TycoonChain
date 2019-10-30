pragma solidity >=0.4.22 <0.6.0;



contract Cell  {
    
    uint indexOfCells;
    
    struct aCell {
        
        uint id;
        uint x;    //location in the cut x-as -y-as. the layer containiong the cells is the z as.
        uint y;
        uint value; //gold at cell, after low eff mining ther might be gold left for a second run.
        bool mined;
        uint timesMined;
        bool hasWater;
        
     
        
    }
    
    mapping(uint => aCell) allCells;
    aCell[] cellsArray;
    

    
 
 

function getCell () public view returns (uint) {
    
    uint idOfTheCell;
 return idOfTheCell;
}

function createCell(uint x, uint y, uint tier) public returns (uint) {  //empty cell to keep track of findings at the location in the cut on layer x. 
    indexOfCells++; //make it start with 1
    aCell memory cellToAdd = allCells[indexOfCells];
    cellToAdd.id = indexOfCells;
    cellToAdd.x = x;
    cellToAdd.y = y;
    
    
    
    
}
    
    
    
function mineCell (uint _cellNumber) internal returns (uint){
    


//game logic


    

}

}