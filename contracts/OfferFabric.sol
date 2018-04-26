pragma solidity ^0.4.20;

import "./Ownable.sol";
import "./Utils.sol";

contract OfferFabric is Ownable {

    event NewOffer(uint offerId, string name, string desc, uint maxTotalSum);
    event AddInvestors(uint offerId, string name, string desc, uint maxTotalSum);

    enum State { Initial, Open, Failed, Paid, Refund }

    struct ParticipantData {
        uint deposit;
        bool existing;
    }

    struct Offer {
        string name;
        string desc;

        State state;

        uint maxTotalSum;   //wei
        uint minSumPer;     //wei
        uint maxSumPer;     //wei
        uint rate;          //wei
        uint currentTotalSum;    //wei

        bool restricted;

        address[] participants;
        
        mapping (address => ParticipantData) participantToData;
    }

    modifier ownerOfOffer(uint _offerId) {
        if (msg.sender == offerToOwner[_offerId]) _;
    }
    modifier stateOf(uint _offerId, State needState) {
        if (offers[_offerId].state == needState) _;
    }
    
    Offer[] public offers;

    mapping (uint => address) public offerToOwner;
    mapping (address => uint) ownerOfferCount;
    
    function kill() public onlyOwner {
        selfdestruct(owner);
    }

    function createOffer(string _name, string _desc, uint _maxTotalSum, uint _minSumPer, uint _maxSumPer, uint _rate) external {
        require(_minSumPer <= _maxSumPer);
        require(_maxSumPer <= _maxTotalSum);

        uint offerId = offers.push(Offer({
            name: _name,
            desc: _desc,
            state: State.Initial,
            maxTotalSum: _maxTotalSum,
            minSumPer: _minSumPer,
            maxSumPer: _maxSumPer,
            rate: _rate,
            currentTotalSum: 0,
            restricted: false,
            participants: new address[](0)
            })) - 1;
        offerToOwner[offerId] = msg.sender;
        ownerOfferCount[msg.sender]++;
        NewOffer(offerId, _name, _desc, _maxTotalSum);
    }

    function changeName(uint _offerId, string _newName) external ownerOfOffer(_offerId) stateOf(_offerId, State.Initial) {
        offers[_offerId].name = _newName;
    }

    function changeDesc(uint _offerId, string _newDesc) external ownerOfOffer(_offerId) stateOf(_offerId, State.Initial) {
        offers[_offerId].desc = _newDesc;
    }

    // function changeState(uint _offerId, State _newState) internal ownerOfOffer(_offerId) {
    //     offers[_offerId].state = _newState;
    // }

    function changemaxTotalSum(uint _offerId, uint _newmaxTotalSum) external ownerOfOffer(_offerId) stateOf(_offerId, State.Initial) {
        offers[_offerId].maxTotalSum = _newmaxTotalSum;
    }

    function changeMaxSumPer(uint _offerId, uint _newMaxSumPer) external ownerOfOffer(_offerId) stateOf(_offerId, State.Initial) {
        offers[_offerId].maxSumPer = _newMaxSumPer;
    }

    function changeMinSumPer(uint _offerId, uint _newMinSumPer) external ownerOfOffer(_offerId) stateOf(_offerId, State.Initial) {
        offers[_offerId].minSumPer = _newMinSumPer;
    }

    function changeRate(uint _offerId, uint _newRate) external ownerOfOffer(_offerId) stateOf(_offerId, State.Initial) {
        offers[_offerId].rate = _newRate;
    }

    function _addParticipant(uint _offerId, address _address) internal {
        offers[_offerId].participants.push(_address);
        offers[_offerId].participantToData[_address] = ParticipantData(0, true);
    }

    function addInvestor(uint _offerId, address _investor) external ownerOfOffer(_offerId) {
        offers[_offerId].restricted = true;

        if (!inInvestors(_offerId, _investor)) _addParticipant(_offerId, _investor);
    }

    function addInvestors(uint _offerId, address[] _investors) external ownerOfOffer(_offerId) {
        offers[_offerId].restricted = true;

        for(uint i = 0; i < _investors.length; i++) {
            if (!inInvestors(_offerId, _investors[i])) _addParticipant(_offerId, _investors[i]);
        }
    }

    function getOffersByOwner(address _owner) external view returns(uint[]) {
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

    function inInvestors(uint _offerId, address _address) public view returns(bool) {
        return (offers[_offerId].participantToData[_address].existing);
    }
    
    function invest(uint _offerId) external payable {
        Offer storage offer = offers[_offerId];

        if (offer.currentTotalSum >= offer.maxTotalSum || offer.participantToData[msg.sender].deposit >= offer.maxSumPer || msg.value < offer.minSumPer) {
            msg.sender.transfer(msg.value);
            return;
        }

        ParticipantData storage participantData = offers[_offerId].participantToData[msg.sender];
        uint needSum = Utils.min(Utils.min(msg.value, offer.maxSumPer - participantData.deposit), offer.maxTotalSum - offer.currentTotalSum);

        participantData.deposit += needSum;
        offer.currentTotalSum += needSum;

        if (msg.value > needSum) msg.sender.transfer(msg.value - needSum);
    }

}