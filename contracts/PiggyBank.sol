// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

contract PiggyBank {
    address public owner = msg.sender;

    event Deposit(uint amount);
    event Withdraw(uint amount);

    receive() external payable { 
        emit Deposit(msg.value);
    }

    modifier isOwner() {
        require(owner == msg.sender, "not owner");
        _;
    }

    function _withdraw() internal {
        uint balance = address(this).balance;
        emit Withdraw(balance);
        payable(msg.sender).transfer(balance);
    }

    function withdraw() external isOwner {
        _withdraw();
    }
}