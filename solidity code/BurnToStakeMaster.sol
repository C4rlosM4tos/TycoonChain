pragma solidity >=0.4.22 <0.6.0;

import "browser/SafeMath.sol";
import "browser/FixidityLib.sol";
import "browser/BurnToStakeSub.sol";



contract BurnToStakeMaster {
    BurnToStakeSub sub;
    uint  ToBePaid;
    uint  blockNumberAtLastPayout;
    uint  totalBurned;
    uint  reward = 1 ether;
    uint  amountOfStakersInContract;
    uint  paymentId;
    
    mapping(uint => uint) payments; //payment id to amount paid in wei;
    
    address[] subContracts;
    mapping(address  => uint) burnedBalance;
    
    using FixidityLib for int256;
    using SafeMath for uint256;
    
    
    address payable[] allSubcontracts;
    
    mapping( address => bool) subContractsBool;
    
    
    
constructor () public payable {
    blockNumberAtLastPayout = block.number;
  
    
}

function() external payable {
 //   msg.sender.transfer(msg.value);
}
function burn () external payable {
//    require(msg.value == amount);
    
    
    if (subContractsBool[msg.sender]) {
    
    if(burnedBalance[msg.sender] == 0) {
        allSubcontracts.push(msg.sender);
        amountOfStakersInContract++;
    }
    uint val = msg.value;
    totalBurned += val;
    burnedBalance[msg.sender] += val;
    }
    
    else {
        msg.sender.transfer(msg.value); //refund, not a member of this contract
    }
    
    
    
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

function calculateReward () private returns (uint) {
    
    uint totalBlocksPassed = block.number.sub(blockNumberAtLastPayout);
    uint rewardPool = (reward).mul(totalBlocksPassed);
    
    return rewardPool;
    
}

function getActiveBlock () private view returns (uint) {
    
    return block.number;
}
function getBlockAtLastPayout () private view returns (uint) {
    return blockNumberAtLastPayout;
}

function payout () public payable  {
      uint rewardPool = calculateReward();
//  int rewardInInt = int(rewardPool);
    
    
    for(uint i=0; i <amountOfStakersInContract; i++){
        address payable tempAccount = allSubcontracts[i];
        ToBePaid = (burnedBalance[tempAccount].mul(rewardPool)).div(totalBurned);
        
        
      //  uint ratio = uint(stakeRatioOfContract (tempAccount));
      //  ToBePaid = (rewardPool * ((ratio/10**25)));
       tempAccount.transfer(ToBePaid);
    //    paymentId++;
    //    payments[paymentId] = ToBePaid;
        
    }
    
    blockNumberAtLastPayout = block.number;
 //   return (ToBePaid);
    
    
}

function CreateNewSubContract ()public payable returns (address) {
    
      BurnToStakeSub child = new BurnToStakeSub();
      address payable childAddress = child.getAddress();
   // LogChildCreated(child); // emit an event - another way to monitor this
    subContracts.push(childAddress); // you can use the getter to fetch child addresses
    subContractsBool[childAddress] = true;
    return childAddress;
    
}

function getSubcontracts () public view returns (address[] memory) {
    
    return subContracts;
    
    
}
function balanceOfContract (address _address) public view returns (uint) {
    return _address.balance;
}

function forwardFundsTo (address payable _address) public payable returns(address payable) {
   sub = BurnToStakeSub(_address);
   sub.burn.value(msg.value).gas(800000)();
    
 //   _address.transfer(msg.value);
    return sub.getAddress();
    
}
function getBalOfMaster() public view returns (uint) {
   return address(this).balance;
}

function getMasterContract () public view returns (address, address payable) {
    address payable addr3 = address(uint160(address(this)));
    return (address(this),addr3);
}

function getMaster (address payable _address) public view returns (address) {
    BurnToStakeSub activeSub = BurnToStakeSub(_address);
    return activeSub.getMaster();
}


function getBrunedBySub (address subcontract) public view returns (uint) {
    return burnedBalance[subcontract];
}
function payoutSub (address payable subcontract) public payable {
    BurnToStakeSub activeSub = BurnToStakeSub(subcontract);
    activeSub.payout();
}
}

