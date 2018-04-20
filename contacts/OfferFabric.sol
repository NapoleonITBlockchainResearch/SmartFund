pragma solidity ^0.4.20;

import "./Utils.sol";

contract OfferFabric is Ownable {

    event NewOffer(uint offerId, uint fundId, string name, string desc);

    enum State { Initial, Open, Failed, Paid, Refund }

    struct Offer {
        string name;
        string desc;
        State state;
        uint totalSum;  //wei
        uint maxSumPer; //wei
        uint minSumPer; //wei
        uint rate;      //wei
    }

    modifier ownerOfOffer(uint _offerId) {
        require(msg.sender == offerToOwner[_offerId]);
        _;
    }
    
    Offer[] public offers;

    mapping (uint => address) public offerToOwner;
    mapping (address => uint) ownerOfferCount;

    mapping (uint => uint) public offerToFund;
    mapping (uint => uint) fundOfferCount;
    
    function kill() public onlyOwner {
        selfdestruct(owner);
    }

    function createOffer(uint _fundId, string _name, string _desc) external {
        //TODO: add {require} for check fundId exists
        //TODO: add {require} for check fundId owner
        uint offerId = offers.push(Offer(_name, _desc, State.Initial, 0, 0, 0, 1)) - 1;
        offerToOwner[offerId] = msg.sender;
        ownerOfferCount[msg.sender]++;
        offerToFund[offerId] = _fundId;
        fundOfferCount[_fundId]++;
        NewOffer(offerId, _fundId, _name, _desc);
    }

    function changeName(uint _offerId, string _newName) external ownerOfOffer(_offerId) {
        offers[_offerId].name = _newName;
    }

    function changeDesc(uint _offerId, string _newDesc) external ownerOfOffer(_offerId) {
        offers[_offerId].desc = _newDesc;
    }

    function changeState(uint _offerId, State _newState) external ownerOfOffer(_offerId) {
        offers[_offerId].state = _newState;
    }

    function changeTotalSum(uint _offerId, uint _newTotalSum) external ownerOfOffer(_offerId) {
        offers[_offerId].totalSum = _newTotalSum;
    }

    function changeMaxSumPer(uint _offerId, uint _newMaxSumPer) external ownerOfOffer(_offerId) {
        offers[_offerId].maxSumPer = _newMaxSumPer;
    }

    function changeMinSumPer(uint _offerId, uint _newMinSumPer) external ownerOfOffer(_offerId) {
        offers[_offerId].minSumPer = _newMinSumPer;
    }

    function changeRate(uint _offerId, uint _newRate) external ownerOfOffer(_offerId) {
        offers[_offerId].rate = _newRate;
    }

    function getOffersByOwner(address _owner) external view returns (uint[]) {
        uint[] memory result = new uint[](ownerOfferCount[_owner]);
        uint counter = 0;
        for (uint i = 0; i < offers.length; i++) {
            if (offerToOwner[i] == _owner) {
                result[counter] = i;
                counter++;
            }
        }
        return result;
    }

    function getOffersByFundId(uint _fundId) external view returns (uint[]) {
        uint[] memory result = new uint[](fundOfferCount[_fundId]);
        uint counter = 0;
        for (uint i = 0; i < offers.length; i++) {
            if (offerToFund[i] == _fundId) {
                result[counter] = i;
                counter++;
            }
        }
        return result;
    }
    
}