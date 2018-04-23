pragma solidity ^0.4.20;

import "./OfferFabric.sol";

contract OfferInvesting is OfferFabric {

    }

    mapping (uint => address[]) public offerToInvestors;



    function invest(uint _offerId) external payable {
        Offer memory offer = offers[_offerId];
        require(msg.value >= offer.minSumPer);
        require(msg.value <= offer.maxSumPer);

        // offer.balance = offer.balance + msg.value;
    }
}