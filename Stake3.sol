
pragma solidity >=0.4.22 <0.6.0;

import "browser/SafeMath.sol";
import "browser/playground.sol";


contract BurnToStake {
    
   
    uint private NrOfBigNumber;
    address public owner;
    
    
    using SafeMath for uint256;
    
    struct bigNumber {
        string TypeOfticket;
        address payable adres; // owner of the ticket
        uint ticketNr;
        uint beforeComma;  // 123xyz,0000
        uint afterComma;  //0,xyze123456
        uint base;   //10
        uint expo;  //**        eg: 2.3 x 10 ** 3 = 2300
        uint amount;
    }
    
    
    struct staker {
        address payable rewardAddress;
        uint balNrTicket;
        bigNumber burned;                   //todo, move them into the array of numbers?
        bigNumber blockNrAtLastPayout;
        bigNumber[] NumberFormsOfStaker;
        
        
    }
    
    struct paymentReceipt{
        uint paymentId;
        bigNumber blockNrAtTx;
        uint amount;
        address addressOfRecipient;
        
    }
    
    mapping(uint =>bigNumber) bigNumbers;
    mapping(address => staker) stakers;
    mapping(address => bigNumber) Burned;
    mapping(uint => address) BigNumberTicketAddresses;
    address[] stakerAccounts;
    address[] burns;
    
    
    
    constructor() public payable {
        owner = tx.origin; 
  
     NrOfBigNumber = 0;
    }
    
    
      modifier ownerOnly(){
        
        require(msg.sender == owner);
        _;
        
    }
    
    
    
        //just send money
    
    //fallback function if you send money
    function () external payable {
    require(msg.value >= 1 wei);
    uint nrOfPopTicket = popuplateBigNumber(msg.value, tx.origin);
    addStaker(nrOfPopTicket);
    //send ticket door naar ticket addition, maak nieuw bigNumberTicket aan, en stuur het door naar addStaker.
    
    
    }
    
    
    
    
    
     function addStaker(uint ticketNr) private {
         bigNumber storage activeBigNumberOnNewTicket = bigNumbers[ticketNr];
  
         
        staker storage activeStaker = stakers[activeBigNumberOnNewTicket.adres];
        
        address payable _adres = activeBigNumberOnNewTicket.adres;                                   //address here (seem to look over it a lot)
      
        // look for the old balance and fill a new big number form
        
        uint NewReceivedTicked = createNewBigNumbersFormForOldAccount(_adres);
        
        uint oldticket = ticketNr; //first
        
        uint newBalanceBurned = additionOfSnrTraditional (oldticket, NewReceivedTicked); //in amount
        
        activeStaker.burned.amount = newBalanceBurned;
        
        //create a new ticketNr
        
        uint newBalanceInSnTicketNr = createNewTicketFromNumber(newBalanceBurned, _adres);
        
       setNewBalance(newBalanceInSnTicketNr);
        
        
        
        
        
     //keep track of everyone

    
        bool isUnique = true;
        
        //indien niet op de lijst, voeg toe.
        for(uint i=0; i<stakerAccounts.length; i++){
         address tempAccount = stakerAccounts[i];
          if(tempAccount == _adres) {
              isUnique = false;
          }
        }
        if(isUnique)
        stakerAccounts.push(_adres);
        
    }
    
       function createNewTicketFromNumber(uint _val, address payable _adres ) private returns (uint) {
      uint NrOfBigNumber = getTicketNumber();
      
      
         
      bigNumber storage activeNumberes =bigNumbers[NrOfBigNumber];
     
      

        activeNumberes.TypeOfticket = "conversion";
        activeNumberes.adres = _adres;
        activeNumberes.beforeComma =getBeforeComma(_val);            //bezig hier
        activeNumberes.afterComma = getAfterComma(_val);
        activeNumberes.expo = getExponential(_val);
        activeNumberes.base = 10;
        activeNumberes.amount = _val;
        activeNumberes.ticketNr = NrOfBigNumber;
        
        return NrOfBigNumber;
     }
    
    
       function setNewBalance (uint ticketNr) private { //copy numberAtoB)
       address payable _adres = tx.origin;
           
           staker storage staker = stakers[_adres];
           bigNumber storage balance = bigNumbers[ticketNr];
           
          staker.balNrTicket = ticketNr; 
          staker.burned.ticketNr = ticketNr;                       //note may just use ticked number alone to track the balance instead of a bigNumber burned 
          staker.burned.TypeOfticket = "CurrentBalance";
          staker.burned.beforeComma = balance.beforeComma;
          staker.burned.afterComma = balance.afterComma;
          staker.burned.expo = balance.expo;
          staker.burned.amount = balance.amount;
          
           
       }
    
    
    
    
    function readStakerAgain (address adres) public view returns (uint, uint, uint, uint) {
     uint number = stakers[adres].burned.beforeComma;
     uint decimals = stakers[adres].burned.afterComma;
     uint expo =  stakers[adres].burned.expo;
     
     return ((FromScienticNotation(number, decimals, expo)), number, decimals, expo);
     
    
        
        
    }
    
    function FromScienticNotation (uint _beforeComma, uint _afterComma, uint _expo) public view returns (uint) {
         uint originalDigits= _expo;
         uint numberOfDigitsa = _expo;
       
        uint beforeComma = _beforeComma;
        uint afterComma =  _afterComma;
    
        uint result = (beforeComma*10**(numberOfDigitsa-1));  //waarschijnlijk niet -1 door gebruik expo
        
      
        numberOfDigitsa= numDigits(afterComma);
        uint resultb = (afterComma);
        result = result + resultb;
      
       

        
        return (result);
    }
      
    //setters and initialising
    
    function fundContract () public ownerOnly() payable {
      
     address(this).send(msg.value);
        }
  
  
  
  
     function popuplateBigNumber(uint _val, address payable _adres ) private returns (uint) {
      uint NrOfBigNumber = getTicketNumber();
      
      
         
      bigNumber storage activeNumberes =bigNumbers[NrOfBigNumber];
     
      

        activeNumberes.TypeOfticket = "NewPayment";
        activeNumberes.adres = _adres;
        activeNumberes.beforeComma =getBeforeComma(_val);            //bezig hier
        activeNumberes.afterComma = getAfterComma(_val);
        activeNumberes.expo = getExponential(_val);
        activeNumberes.base = 10;
        activeNumberes.amount = _val;
        activeNumberes.ticketNr = NrOfBigNumber;
        
        return NrOfBigNumber;
     }
     
     //request balance of the old account in the db
     function createNewBigNumbersFormForOldAccount (address payable _adres) private returns (uint) {        
       uint NrOfBigNumber = getTicketNumber();
         bigNumber memory dummyCopyBigNumber = bigNumbers[NrOfBigNumber];
         staker memory dummyCopyStaker = stakers[_adres];
         
         
        dummyCopyBigNumber.TypeOfticket = "copy";
        dummyCopyBigNumber.adres =_adres;
        dummyCopyBigNumber.ticketNr = NrOfBigNumber;
        dummyCopyBigNumber.beforeComma = dummyCopyStaker.burned.beforeComma;
        dummyCopyBigNumber.afterComma = dummyCopyStaker.burned.afterComma;
        dummyCopyBigNumber.expo =   dummyCopyStaker.burned.expo;
        dummyCopyBigNumber.amount = dummyCopyStaker.burned.amount;
        
        return NrOfBigNumber;


        
         
     }
    
   
    
    
    
    
    function toScienticNotation (uint256 _a) public view returns (uint, uint, uint) {
         uint originalDigits= numDigits(_a);
         uint numberOfDigitsa = numDigits(_a);
       
        uint beforeComma = getBeforeComma(_a);
        uint afterComma =  getAfterComma(_a);
    
        uint result = (beforeComma*10**(numberOfDigitsa-1));
        
      
        numberOfDigitsa= numDigits(afterComma);
        uint resultb = (afterComma);
        result = result + resultb;
         

        
        return (result, beforeComma, afterComma);
    }
       
       
       
       
       
        function getBeforeComma (uint number) public view returns (uint) {
            uint numberOfDigitsa = numDigits(number);
        uint beforeComma = number /10**((numberOfDigitsa)-1);  //result in 20 digits for 1 eth
        
        return beforeComma;
            
        }
        
        
        
        
        
        function getAfterComma (uint number) public view returns (uint) {
            uint numberOfDigitsa = numDigits(number);
            uint afterComma = number % 10**((numberOfDigitsa-1));
            
            return afterComma;
              
              
            
        }
        
         function getExponential (uint256 _a) public view returns (uint)  {
             
            uint answer = (numDigits(_a));
            
            return (answer-1);
             
        // uint originalDigits= numDigits(_a);
       //  uint numberOfDigitsa = numDigits(_a);
       //  uint beforeComma = getBeforeComma(_a);
        // uint afterComma =  getAfterComma(_a);
        
        
    
         }
         
 
 function getStaker(address adres) view public returns (uint) {
     
     uint formNum = stakers[adres].balNrTicket;
     uint amount = bigNumbers[formNum].amount;
     
    return amount/10**18;
 }
 function getStakers() view public returns (address[] memory) {
     return stakerAccounts;
 }
 
    // helpers
        function additionOfSnrTraditional (uint ticketnra, uint ticketnrb) public view returns (uint) {
        bigNumber memory newbignumbera = bigNumbers[ticketnra];
        bigNumber memory newbignumberb = bigNumbers[ticketnrb];
        
        
        uint abeforeComma = newbignumbera.beforeComma;
        uint aAfterComma = newbignumbera.afterComma;
        uint aExpo = newbignumbera.expo;
        uint aAmount = newbignumbera.amount;
        //ticketnrb
        uint bBeforeComma = newbignumberb.beforeComma;
        uint bAfterComma = newbignumberb.afterComma;
        uint bExpo = newbignumberb.expo;
        uint bamount = newbignumberb.amount;
        
        uint result1 = aAmount.add(bamount);
        
        return result1;
        
        
        
    }
        function additionOfSnrAlternative (uint ticketnra, uint ticketnrb) public view returns (uint) {   //af te werken
        bigNumber memory newbignumbera = bigNumbers[ticketnra];
        bigNumber memory newbignumberb = bigNumbers[ticketnrb];
        
        
        uint abeforeComma = newbignumbera.beforeComma;
        uint aAfterComma = newbignumbera.afterComma;
        uint aExpo = newbignumbera.expo;
        uint aAmount = newbignumbera.amount;
        //ticketnrb
        uint bBeforeComma = newbignumberb.beforeComma;
        uint bAfterComma = newbignumberb.afterComma;
        uint bExpo = newbignumberb.expo;
        uint bamount = newbignumberb.amount; //as check
        
        uint result1 = aAmount.add(bamount);
        
        uint newNumberaA = makeBigNumberOneButKeepBig(abeforeComma, aAfterComma);
        aExpo++; 
        uint newNumberaB = makeBigNumberOneButKeepBig(bBeforeComma, bAfterComma);
        bExpo++;
        
        
        if(aExpo == bExpo){
            
      //  return (newNumberaA.add(newNumberaB)*expo+1);
            
            // tel op
            
            //overflow! 
            
        }
        
        //vermenigvuldig (x10à zodanig beide getallen na de komma valt, vervolgens werken we met units, maar *10**16
    }                //todo *
        function makeBigNumberOneButKeepBig (uint beforeComma, uint afterComma) public view returns (uint) {
        uint numberOfdigitsInComma = numDigits (afterComma);
        uint valuetoreturn = (beforeComma*10**(numberOfdigitsInComma-1)) + afterComma;
        
        return(valuetoreturn);
        
    }
        function bringToSameExponent (uint ticketnra, uint ticketnrb) private {  //to be continued
           bigNumber memory newbignumbera = bigNumbers[ticketnra];
        bigNumber memory newbignumberb = bigNumbers[ticketnrb];
        
        
        
    }
        function getTicketNumber() private returns (uint) {
        uint number = NrOfBigNumber+1;
        NrOfBigNumber++;
        return number;
    }
        function numDigits(uint number) internal pure returns (uint) {
    uint digits = 0;
    //if (number < 0) digits = 1; // enable this line if '-' counts as a digit
    while (number != 0) {
        number /= 10;
        digits++;
    }
    return digits;
}

    

    
    
}


