pragma solidity ^0.4.20;

library Utils {
    function min(uint a, uint b) pure internal returns (uint _min) {
        return (a < b) ? a : b;
    }

    function max(uint a, uint b) pure internal returns (uint _max) {
        return (a < b) ? b : a;
    }
}