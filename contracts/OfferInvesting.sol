pragma solidity ^0.4.20;

import "./OfferFabric.sol";

contract OfferInvesting is OfferFabric {
    
    struct Investor {
        address _address;
    }

    struct Deposit {
        uint sum;   //wei
        // uint rate;
    }

    mapping (uint => uint[]) offerToInvestors;

    Investor[] public investors;

    function inviteInvestor(uint _offerId, address _investor) external ownerOfOffer(_offerId) {
        uint investorId = investors.push(Investor(_investor)) - 1;
        offerToInvestors[_offerId].push(investorId);
    }

    function invest(uint _offerId) external payable {
        Offer memory offer = offers[_offerId];
        require(msg.value >= offer.minSumPer);
        require(msg.value <= offer.maxSumPer);

        // offer.balance = offer.balance + msg.value;
    }
}