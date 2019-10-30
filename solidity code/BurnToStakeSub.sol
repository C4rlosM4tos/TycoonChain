pragma solidity >=0.4.22 <0.6.0;

import "./SafeMath.sol";
import "./FixidityLib.sol";
import "./BurnToStakeMaster.sol";







contract BurnToStakeSub {
    address payable parent;
    uint ToBePaid;
    uint public blockNumberAtLastPayout;
    uint public totalBurned;
    BurnToStakeMaster master;
  
    uint amountOfStakersInContract;
    uint paymentId;
    
    mapping(uint => uint) payments; //payment id to amount paid in wei;
    
    address[] subContracts;
    mapping(address  => uint) burnedBalance;
 
    
    using FixidityLib for int256;
    using SafeMath for uint256;
    
    
    address payable[] allSubcontracts;
    
    
    
constructor () public payable {
    blockNumberAtLastPayout = block.number;
    parent = msg.sender;
    master = BurnToStakeMaster(parent);
}

function () external payable {
    
    
    
}

    



function burn () external payable returns (uint) {
    require(msg.value >= 51 wei);
    if(burnedBalance[tx.origin] == 0) {
        allSubcontracts.push(tx.origin);
        amountOfStakersInContract++;
    }
    uint val = msg.value;
    totalBurned += val;
    burnedBalance[tx.origin] += val;
    
    
  //  BurnToStakeMaster master = BurnToStakeMaster(parent);
    
   master.burn.value(msg.value - 50 wei)();
    return msg.value;
    
}
function TriggerMasterPayout () public  {
    
master.payout();    
    
    
    
}

function getBalanceOfContracct () public view returns (uint) {
    
    address(this).balance;
}


function stakeRatioOfContract (address _address) private returns (int) {
    
    int balOfsubContract = int(burnedBalance[_address]);
    int allBurnedCoins = int(totalBurned);
    
    balOfsubContract = balOfsubContract.newFixed();
    allBurnedCoins = allBurnedCoins.newFixed();
    
    return balOfsubContract.divide(allBurnedCoins);
    
}

    function numDigits(uint number) private pure returns (uint) {
    uint digits = 0;
    //if (number < 0) digits = 1; // enable this line if '-' counts as a digit
    while (number != 0) {
        number /= 10;
        digits++;
    }
    return digits;
}

function getNumOfDigits (uint val) public view returns (uint){
    
    return numDigits(val);
    
    
}



function getActiveBlock () public view returns (uint) {
    
    return block.number;
}
function getBlockAtLastPayout () public view returns (uint) {
    return blockNumberAtLastPayout;
}

function payout () public payable  {
      uint rewardPool = address(this).balance;
    //  int rewardInInt = int(rewardPool);
    
    
 
        
        for(uint i=0; i <amountOfStakersInContract; i++){
        address payable tempAccount = allSubcontracts[i];
        ToBePaid = (((burnedBalance[tempAccount])*1000000000000000000).mul(rewardPool)).div(totalBurned);
        
        
       if(ToBePaid > 10*18){
            tempAccount.transfer(ToBePaid/1000000000000000000);
            
        }
        
      //  uint ratio = uint(stakeRatioOfContract (tempAccount));
      //  ToBePaid = (rewardPool * ((ratio/10**25)));
    //    tempAccount.transfer(ToBePaid);
      //  paymentId++;
    //    payments[paymentId] = ToBePaid;
        
    }
    
    blockNumberAtLastPayout = block.number;
    //trigger master payout?
    
    
    
}

function CreateNewSubContract ()public {
    
}

function getAddress () public view returns (address payable) {
    
    address _address = address(this);
   address payable addr3 = address(uint160(_address));
    return (addr3);
}
function getMaster () public view returns (address) {
    return parent;
}


}



