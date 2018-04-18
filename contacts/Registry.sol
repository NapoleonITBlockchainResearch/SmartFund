pragma solidity ^0.4.20;

import "./Utils.sol";

contract Registry is Ownable {
    // mapping (address => Fund) addressToFond;
    
    function kill() public onlyOwner {
        selfdestruct(owner);
    }
    
}