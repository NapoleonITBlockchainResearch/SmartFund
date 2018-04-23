pragma solidity ^0.4.20;

import "./OfferFabric.sol";

contract OfferInvesting is OfferFabric {

    modifier onlyInvestors(uint _offerId) {
        if (inInvestors(_offerId)) _;
    }

    mapping (uint => address[]) public offerToInvestors;

    function inInvestors(uint _offerId) public view returns(bool) {
        address[] memory investors = offerToInvestors[_offerId];
        for (uint i = 0; i < investors.length; i++) {
            if (investors[i] == msg.sender)
                return true;
        }

        return false;
    }

    function inviteInvestors(uint _offerId, address[] _investors) external ownerOfOffer(_offerId) {
        offerToInvestors[_offerId] = _investors;
    }

    function invest(uint _offerId) external payable onlyInvestors(_offerId) {
        Offer memory offer = offers[_offerId];
        require(msg.value >= offer.minSumPer);
        require(msg.value <= offer.maxSumPer);

        // offer.balance = offer.balance + msg.value;
    }
}