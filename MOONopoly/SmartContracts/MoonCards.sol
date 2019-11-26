pragma solidity >0.4.24 <=0.6.0;
import "browser/PolyRegister.sol";




contract MoonCards {
    
   PolyRegister registerPoly;  
    
    struct MoonCard {
        
        uint id;
        string typeOfCard;
        uint hashOfType;
        string action;
        uint actionId;
        string actionInWords;
        string description;
        uint toReceive;
        uint toPay;
        uint locationToMove;
        uint now;
        string typeOfTarget;
        uint amount;
        bool forward;
   
    }
    
    event newCardTaken (uint typeofcard, uint card);
    
    mapping (uint => MoonCard) allCards;
    
    mapping (uint => MoonCard) allChanceCards;
    mapping (uint => MoonCard) allCommunityChestCards;
    mapping (uint => bool) public isCommunityChestCard;
    mapping (uint => bool) public isChanceCard;
    
    
    MoonCard[] chanceArray;
    MoonCard[] communityArray;
    
    string[] public cardsArrayByString;
     uint[] public cards;
     uint[] draws;
     
     
     
       constructor (address _PolyRegister) public {
          uint[] memory needs = new uint[](0);
        registerPoly = PolyRegister(_PolyRegister);

      
              (bool[] memory boolSolutions, address[] memory solutions) = registerPoly.registerContract("MoonCards", needs);
    
     

      
       }
   
function createCard (uint _kindOfCards, uint actionId, string memory description, uint amount) public returns (uint) { //amount can be tokens, location, number of cards, ...
  
    string[2] memory kindOfCards = ["community chest", "chance"];
     string[11] memory types = ["receive tokens", "pay tokens", "move forward", "take card", "receive object", "pay object", "create auction", "create new board", "create new avatar", "move back", "move back amount"];
    uint id = cardsArrayByString.push(kindOfCards[_kindOfCards]);
    MoonCard memory newcard = allCards[id];
    allCards[id].id = id;
    allCards[id].typeOfCard = kindOfCards[_kindOfCards];
    allCards[id].hashOfType = uint(keccak256(abi.encodePacked(kindOfCards[_kindOfCards])));
    allCards[id].action = types[actionId];
    allCards[id].actionId = actionId;
    allCards[id].description = description;
//    allCards[id].now = now; 

    if(_kindOfCards == 0) { //community
    uint communityId = communityArray.push(allCards[id]);
        isCommunityChestCard[id] = true;
        communityArray.push(allCards[id]);
        allCommunityChestCards[communityId] = allCards[id];
    }else{
        uint chanceId = chanceArray.push(allCards[id]);
        isChanceCard[id] = true;
        allChanceCards[chanceId] = allCards[id];
    }

   if(actionId == 0) {
       allCards[id].actionInWords = "receive an amount of tokens";
       allCards[id].toReceive = amount;
   }else if(actionId == 1) {
        allCards[id].actionInWords = "pay an amount of tokens";
        allCards[id].toPay = amount;
   }else if(actionId == 2) {
       allCards[id].actionInWords = "Move to a new location";
       allCards[id].locationToMove = amount; 
   }else if(actionId == 3) {
          allCards[id].actionInWords = "Take a new MoonCard of the other type";
   }else if(actionId == 4) {
          allCards[id].actionInWords = "You have won a free object"; //moonpanel, well;
   }else if(actionId == 5) {
          allCards[id].actionInWords = "You lost 1 object in a disaster, burn one object of type";

   }else if(actionId == 6) {
          allCards[id].actionInWords = "create a general auction for type";

   }else if(actionId == 7) {
          allCards[id].actionInWords = "Create a new Board of the next tier";
    }else if(actionId == 8) {
          allCards[id].actionInWords = "Create a new avatar if wanted";
    }else if(actionId == 9) {
          allCards[id].actionInWords = "Move back to street at location, receive no payment for passing start";
          allCards[id].locationToMove = amount;
    }
    
  
  return id;
    
    
    
}

function whereisMyCard () public returns (uint) {
    
    
 return takeCard(0);
}

    
function takeCard (uint typeOfCard) public returns (uint) {
    uint nonce = draws.push(typeOfCard);
    uint idToReturn;
    
    if(typeOfCard == 0) {
       uint cardId = 1 + uint(keccak256(abi.encodePacked(nonce)))%(communityArray.length-1);
         idToReturn = allCommunityChestCards[cardId].id;
      
    }else{
        uint cardId = 1 + uint(keccak256(abi.encodePacked(nonce)))%(chanceArray.length-1);
        idToReturn = allChanceCards[cardId].id;
     
    }
    
    emit newCardTaken (typeOfCard, idToReturn);
   return idToReturn; 

}

function preLoadSetOfCards () public {
    string[2] memory kindOfCards = ["community chest", "chance"];
                                    //0                 1             2             3               4               5               6                 7                 8                   9               10          //   11
    string[11] memory actions = ["receive tokens", "pay tokens", "move forward", "take card", "receive object", "pay object", "create auction", "create new board", "create new avatar", "move back", "move back amount"];
}

function communityCardMoveForward() public returns (uint[] memory) {
// move
    cards.push(createCard(0, 2, "Advance To 'START', receive double payment for landing on 'START'", 0));
    cards.push(createCard(0, 2, "Advance To 'street 1', receive normal payment if you pass 'START'", 1));
    cards.push(createCard(0, 2, "Advance To 'street 2', receive normal payment if you pass 'START'", 3));
     cards.push(createCard(0, 2, "Advance To 'station1', receive normal payment if you pass 'START'", 5));
    cards.push(createCard(0, 2, "Advance To 'street 3', receive normal payment if you pass 'START'", 6));
    cards.push(createCard(0, 2, "Advance To 'street 4', receive normal payment if you pass 'START'", 8));
    cards.push(createCard(0, 2, "Advance To 'street 5', receive normal payment if you pass 'START'", 9));
    cards.push(createCard(0, 2, "Visit the prison, receive normal payment if you pass 'START'", 10));
    cards.push(createCard(0, 2, "Advance To 'street 6', receive normal payment if you pass 'START'", 11));
    cards.push(createCard(0, 2, "Advance To 'street 7', receive normal payment if you pass 'START'", 13));
    cards.push(createCard(0, 2, "Advance To 'street 8', receive normal payment if you pass 'START'", 14));
    cards.push(createCard(0, 2, "Advance To 'station2', receive normal payment if you pass 'START'", 15));
    cards.push(createCard(0, 2, "Advance To 'street 9', receive normal payment if you pass 'START'", 16));
    cards.push(createCard(0, 2, "Advance To 'street 10', receive normal payment if you pass 'START'", 18));
    cards.push(createCard(0, 2, "Advance To 'street 11', receive normal payment if you pass 'START'", 19));
    cards.push(createCard(0, 2, "Advance To 'street 12', receive normal payment if you pass 'START'", 21));
    cards.push(createCard(0, 2, "Advance To 'street 13', receive normal payment if you pass 'START'", 23));
    cards.push(createCard(0, 2, "Advance To 'street 14', receive normal payment if you pass 'START'", 24));
    cards.push(createCard(0, 2, "Advance To 'station3', receive normal payment if you pass 'START'", 25));
    cards.push(createCard(0, 2, "Advance To 'street 15', receive normal payment if you pass 'START'", 26));
    cards.push(createCard(0, 2, "Advance To 'street 16', receive normal payment if you pass 'START'", 27));
    cards.push(createCard(0, 2, "Advance To 'street 17', receive normal payment if you pass 'START'", 29));
    cards.push(createCard(0, 2, "Advance To 'street 18', receive normal payment if you pass 'START'", 31));
    cards.push(createCard(0, 2, "Advance To 'street 19', receive normal payment if you pass 'START'", 32));
    cards.push(createCard(0, 2, "Advance To 'street 20', receive normal payment if you pass 'START'", 34));
    cards.push(createCard(0, 2, "Advance To 'station4', receive normal payment if you pass 'START'", 35));
    cards.push(createCard(0, 2, "Advance To 'street 21', receive normal payment if you pass 'START'", 37));
    cards.push(createCard(0, 2, "Advance To 'street 22', receive normal payment if you pass 'START'", 39));
    
    
    return cards;


}
function communityCardMoveBack() public returns (uint[] memory) {
    cards.push(createCard(0, 9, "Go back To 'street 1', you receive no payment because you're not passing 'start'", 1));
    cards.push(createCard(0, 9, "Go back To 'street 2', you receive no payment because you're not passing 'start'", 3));
    cards.push(createCard(0, 9, "Go back To 'street 3', you receive no payment because you're not passing 'start'", 6));
    cards.push(createCard(0, 9, "Go back To 'street 4', you receive no payment because you're not passing 'start'", 8));
    cards.push(createCard(0, 9, "Go back To 'street 5', you receive no payment because you're not passing 'start'", 9));
    cards.push(createCard(0, 9, "Go back to Visit the prison, you do not pass start to receive money", 10));
    cards.push(createCard(0, 9, "Go back To 'street 6', you receive no payment because you're not passing 'start'", 11));
    cards.push(createCard(0, 9, "Go back To 'street 7', you receive no payment because you're not passing 'start'", 13));
    cards.push(createCard(0, 9, "Go back To 'street 8', you receive no payment because you're not passing 'start'", 14));
    cards.push(createCard(0, 9, "Go back To 'street 9', you receive no payment because you're not passing 'start'", 16));
    cards.push(createCard(0, 9, "Go back To 'street 10', you receive no payment because you're not passing 'start'", 18));
    cards.push(createCard(0, 9, "Go back To 'street 11', you receive no payment because you're not passing 'start'", 19));
    cards.push(createCard(0, 9, "Go back To 'street 12', you receive no payment because you're not passing 'start'", 21));
    cards.push(createCard(0, 9, "Go back To 'street 13', you receive no payment because you're not passing 'start'", 23));
    cards.push(createCard(0, 9, "Go back To 'street 14', you receive no payment because you're not passing 'start'", 24));
    cards.push(createCard(0, 9, "Go back To 'street 15', you receive no payment because you're not passing 'start'", 26));
    cards.push(createCard(0, 9, "Go back To 'street 16', you receive no payment because you're not passing 'start'", 27));
    cards.push(createCard(0, 9, "Go back To 'street 17', you receive no payment because you're not passing 'start'", 29));
    cards.push(createCard(0, 9, "Go back To 'street 18', you receive no payment because you're not passing 'start'", 31));
    cards.push(createCard(0, 9, "Go back To 'street 19', you receive no payment because you're not passing 'start'", 32));
    cards.push(createCard(0, 9, "Go back To 'street 20', you receive no payment because you're not passing 'start'", 34));
    cards.push(createCard(0, 9, "Go back To 'street 21', you receive no payment because you're not passing 'start'", 37));
    cards.push(createCard(0, 9, "Go back To 'street 22', you receive no payment because you're not passing 'start'", 39));

  
}    
function communityCardPay() public returns (uint[] memory) {
      cards.push(createCard(0, 1, "Bill for your bank account and credit card, pay 750*tier", 750));
    cards.push(createCard(0, 1, "Hospital bill arrived, pay 500*tier", 500));
    cards.push(createCard(0, 1, "You lost your private key, pay 300*tier", 300));
    cards.push(createCard(0, 1, "Scammed by some prince on the internet, pay 250*tier", 250));
    cards.push(createCard(0, 1, "Dumped on by the whales, you lost 100*tier", 200));
    cards.push(createCard(0, 1, "Income Tax bill arrived, pay 1000*tier", 1000));
    cards.push(createCard(0, 1, "Pay tax for being poor, 100*tier please", 100));
    cards.push(createCard(0, 1, "The food wasted away, get new food for 25*tier", 25));
    cards.push(createCard(0, 1, "Buy a presents for x-mass, spend 75*tier", 75));
    cards.push(createCard(0, 1, "New books for school needed, pay 125*tier", 125));
    cards.push(createCard(0, 1, "Join a crypto signal group, lose 50*tier", 50));
    cards.push(createCard(0, 1, "Crypto exchange hacked, lose 750*tier", 750));
    cards.push(createCard(0, 1, "Invest 100 tokens in Bitconnect, you lose 100*tier tokens", 100));
    cards.push(createCard(0, 1, "Support a charity, donate 10*tier", 10));
    return cards;
}
function communityCardReceive() public returns (uint[] memory) {
     cards.push(createCard(0, 0, "A bank error in your favor, collect 1000*tier", 1000));
     cards.push(createCard(0, 0, "tax-refund, receive 500*tier", 500));
     cards.push(createCard(0, 0, "Receive a stake in the crypto profits, collect 250*tier", 250));
     cards.push(createCard(0, 0, "X-mass came early, collect 200*tier", 200));
     cards.push(createCard(0, 0, "Some prince from the internet died, inherit 100*tier", 100));
     cards.push(createCard(0, 0, "You got lucky in a Pump and dump, receive 300*tier", 300));
     cards.push(createCard(0, 0, "you found a private key, collect 150*tier", 150));
     cards.push(createCard(0, 0, "Second price in a beauty contest, win 50*tier ", 50));
     cards.push(createCard(0, 0, "Late birtday present, you receive 75*tier", 75));
     cards.push(createCard(0, 0, "Ponzi scheme payout, receive 400*tier", 400));
     cards.push(createCard(0, 0, "Voucher for free meal, collect 20*tier", 20));
     cards.push(createCard(0, 0, "You found some coins on the ground, receive 10*tier", 10));
     cards.push(createCard(0, 0, "you found some old Bitcoins from back in the days, receive 750*tier ", 750));
     cards.push(createCard(0, 1, "Some new tether got printed, collect crypto earnings 100*tier", 100));
    
    return cards;
}
function firstCardsChance () public returns (uint[] memory) {

    
    cards.push(createCard(1, 9, "Go back To 'street 1', you receive no payment because you're not passing 'start'", 1));
    cards.push(createCard(1, 9, "Go back To 'street 2', you receive no payment because you're not passing 'start'", 3));
    cards.push(createCard(1, 9, "Go back To 'street 3', you receive no payment because you're not passing 'start'", 6));
    cards.push(createCard(1, 9, "Go back To 'street 4', you receive no payment because you're not passing 'start'", 8));
    cards.push(createCard(1, 9, "Go back To 'street 5', you receive no payment because you're not passing 'start'", 9));
    cards.push(createCard(1, 9, "Go back to Visit the prison, you do not pass start to receive money", 10));
    cards.push(createCard(1, 9, "Go back To 'street 6', you receive no payment because you're not passing 'start'", 11));
    cards.push(createCard(1, 9, "Go back To 'street 7', you receive no payment because you're not passing 'start'", 13));
    cards.push(createCard(1, 9, "Go back To 'street 8', you receive no payment because you're not passing 'start'", 14));
    cards.push(createCard(1, 9, "Go back To 'street 9', you receive no payment because you're not passing 'start'", 16));
    cards.push(createCard(1, 9, "Go back To 'street 10', you receive no payment because you're not passing 'start'", 18));
    cards.push(createCard(1, 9, "Go back To 'street 11', you receive no payment because you're not passing 'start'", 19));
    cards.push(createCard(1, 9, "Go back To 'street 12', you receive no payment because you're not passing 'start'", 21));
    cards.push(createCard(1, 9, "Go back To 'street 13', you receive no payment because you're not passing 'start'", 23));
    cards.push(createCard(1, 9, "Go back To 'street 14', you receive no payment because you're not passing 'start'", 24));
    cards.push(createCard(1, 9, "Go back To 'street 15', you receive no payment because you're not passing 'start'", 26));
    cards.push(createCard(1, 9, "Go back To 'street 16', you receive no payment because you're not passing 'start'", 27));
    cards.push(createCard(1, 9, "Go back To 'street 17', you receive no payment because you're not passing 'start'", 29));
    cards.push(createCard(1, 9, "Go back To 'street 18', you receive no payment because you're not passing 'start'", 31));
    cards.push(createCard(1, 9, "Go back To 'street 19', you receive no payment because you're not passing 'start'", 32));
    cards.push(createCard(1, 9, "Go back To 'street 20', you receive no payment because you're not passing 'start'", 34));
    cards.push(createCard(1, 9, "Go back To 'street 21', you receive no payment because you're not passing 'start'", 37));
    cards.push(createCard(1, 9, "Go back To 'street 22', you receive no payment because you're not passing 'start'", 39));
    
    
    
    
}

function readCard (uint cardId) public view returns (uint id, string memory card, string memory action, string memory description, uint toReceive, uint topay, uint locationToMove) {
    
    return (allCards[cardId].id, allCards[cardId].typeOfCard, allCards[cardId].actionInWords, allCards[cardId].description, allCards[cardId].toReceive, allCards[cardId].toPay, allCards[cardId].locationToMove);
    
    
}
function getAmountToReceive (uint cardId) public view returns (uint) {
    
    return (allCards[cardId].toReceive);
}
function getAmountToPay (uint cardId) public view returns (uint) {
    
    return (allCards[cardId].toPay);
}

function getActionId (uint cardId) public view returns (uint)  {
    
    return allCards[cardId].actionId;
}
function getNewLocation (uint cardId) public view returns (uint) {
    return allCards[cardId].locationToMove;
}

}
    
    
    
    
    
