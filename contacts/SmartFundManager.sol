pragma solidity ^0.4.20;

import "./Utils.sol";

contract SmartFundManager is Ownable {
    
    address public registry;

    function setRegistry(address _registry) external onlyOwner {
        registry = _registry;
    }

    function kill() public onlyOwner {
        selfdestruct(owner);
    }

}