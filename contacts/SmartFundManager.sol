pragma solidity ^0.4.20;

import "./Utils.sol";

contract SmartFundManager is Ownable {
    
    address public register;

    function setRegister(address _register) external onlyOwner {
        register = _register;
    }

    function kill() public onlyOwner {
        selfdestruct(owner);
    }

}