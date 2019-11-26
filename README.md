# TycoonChain

WORK IN PROGRESS... DO NOT USE ANY OF THE CODE YET! very unSafu!
----------------------------------------------------------------

Working on Moonoply before GoldCrush.

Moonopoly will be some monopoly-like game on the blockchain. The game will never end.
The bank will mint Moonopoly tokens and give them to the players as they pass "start".

a street will not be ownable, but instead it will have a Mayor.
each street will contain many buildingplots for houses. The Mayor can change depending on the plots owned in a street.
a new plot will be minted when a player visits a street. That piece of ground will then go into auction.

players can only bid on plots they are standing on.
Houses can be build when you have the Mayors role. 
All revenue must be shared with the Mayor, Governor and President. 

Stations cannot be owned, because they are used to transfer to other boards and progress to higher tiers;

...



All Moonopoly tokens will be backed by the stake reward received by the game.

gameObjects will be auctioned and the funds will be burned in the BurnToStake ecosystem. 

The token and coin might be worthless, but as long as people are mining the chain players will be able to earn 
back the gass from the transactions and more.

This blockchain project does not claim to be the next bitcoin! instead we claim to be Peer-To-Peer virtual monopoly money, used for all sorts of different tycoongames. we hope to have a low-value to keep the entry low for new players.

IMPORTANT:
i am not a programmer or anything, i promising nothing and all the code might be very insecure!



RoadMap:

i hope to finish a first version that will be running on a website with metamask and local node.
This will be some sort of proof of concept, very basic and limited to no-art. (always welcome to help me...)

If that goes well, i will focus on creating a front-end for the game in unity. I have no idea how yet, but it should be possible 

I will probably not have the skills for that, so chances are that i will focus again on finishing a v0.01 of GoldCrush.

To be fair, don't wait for the game... I do this in my own time and will likely run out of money or time before i get anywhere...


------------------------------------------------------------------------------------------------------------------------------

What you can find in the smart contracts so far:

ERC1820Registry:
limited implementation of ERC1820Registry for remix website. (see all "browser/...")

The address is a pain, so i created a registry for my game contracts and the ERC1820 registry. i simply deploy it and let my own register forward the address of the ERC1820Registry to all the contracts that use it.


ERC777Token:
not fully implemented yet, just to a point where it is usable for testing and playing around...
The token contract is launched by the PolyLauncher contract. lots of EIP170 problems there...
i use the launcher to set the default operators (eg: exchange)
you can probably still send tokens to unsupported contracts

ERC721Tokens:
The plots and houses are ERC721 tokens. They cannot be send to a contract that does not support them when using SafeTransferFrom
Only the plots contract has ERC721 fully working. (or at least working)


i'm mainly posting this as backup for myself, and i silently hope to find other people to help a bit...






note that many files start with Poly. the project had a name change from PonziPoly to Moonopoly but the old code is not updated yet. I also have lots of files that are undergoing conversion to the new 1820 registry, i did not had that in the beginning...



There is limited to no access controll yet (i don't want to pain myself while testing and changing)

-------------------------------------------------------------------------------------------------------------------------
Installation:

You can copy paste the code in remix ide and play with it a little...
first you need the PolyRegister,
then you launch the modified ERC1820 registry with the polyregister address
From there it should not matter wich one you deploy first as the registers will fill in the needs of the contracts (the address of all the other contracts). Since the ERC1820 registry is not running on the address it should we need to pass the polyRegister to all other contracts. they will find the ERC1820's address in the PolyRegister.


Warning: you need to add gas! the tychain blockchain will have high limit of max gas, more than the remix VM. the VM will also crash a lot or just freeze.
i run ganache-cli blockchain most of the times if i want to test the whole system. the VM is fine for just a few contracts. Best results with own node, but no use burning hashes...

I don't like creating websites... The idea is to have fully decentralized games so anyone could use their own front-end... 


Todo:
Change the stake contract to 1 contract again and make stakers request their own payment only. looping is a problem very fast... 
even the sub-contract system will yiel problems if any game would actually make it...
