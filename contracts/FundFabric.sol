pragma solidity ^0.4.20;

import "./Utils.sol";

contract FundFabric is Ownable { 

    event NewFund(uint fundId, string name, string desc);

    struct Fund {
        string name;
        string desc;
    }

    modifier ownerOfFund(uint _fundId) {
        require(msg.sender == fundToOwner[_fundId]);
        _;
    }

    Fund[] public funds;

    mapping (uint => address) public fundToOwner;
    mapping (address => uint) ownerFundCount;

    function createFund(string _name, string _desc) external {
        uint fundId = funds.push(Fund(_name, _desc)) - 1;
        fundToOwner[fundId] = msg.sender;
        ownerFundCount[msg.sender]++;
        NewFund(fundId, _name, _desc);
    }

    function changeName(uint _fundId, string _newName) external ownerOfFund(_fundId) {
        funds[_fundId].name = _newName;
    }

    function changeDesc(uint _fundId, string _newDesc) external ownerOfFund(_fundId) {
        funds[_fundId].desc = _newDesc;
    }

    function deleteFund(uint _fundId) external ownerOfFund(_fundId) {
        //TODO: ...
    }

    function getFundsByOwner(address _owner) external view returns (uint[]) {
        uint[] memory result = new uint[](ownerFundCount[_owner]);
        uint counter = 0;
        for (uint i = 0; i < funds.length; i++) {
            if (fundToOwner[i] == _owner) {
                result[counter] = i;
                counter++;
            }
        }
        return result;
    }
    
    function kill() public onlyOwner {
        selfdestruct(owner);
    }
    
}