pragma solidity ^0.4.20;

import "./Utils.sol";
// import "./Entities.sol";

contract OfferFabric is Ownable {
    enum State { Initial, Open, Failed, Paid, Refund }

    struct Offer {
        address owner;
        string name;
        State state;
        uint totalSum;
        uint maxSumPer;
        uint minSumPer;
        uint fundId;
    }
    
    Offer[] offers;
    
    // function kill() public {
    //     if(msg.sender == owner) selfdestruct(owner);
    // }
    
}