pragma solidity ^0.4.20;

import "./FundFabric.sol";

contract Registry is FundFabric {
    
    

    function kill() public onlyOwner {
        selfdestruct(owner);
    }

}