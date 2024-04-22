// SPDX-License-Identifier: MIT
pragma solidity >0.8.0;

import {Bank} from "./Bank.sol";

interface IBigBank {
    function withdraw(uint256 amount) external;
}

contract Ownable {
    address public owner;
    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "only owner can do this call");
        _;
    }

    function withdraw(address payable bank, uint256 amount) external onlyOwner {
        IBigBank(bank).withdraw(amount);
    }

    event Received(address from, address to, uint amount);

    receive() external payable {
        emit Received(msg.sender, address(this), msg.value);
    }

    function getBalance() public view returns (uint) {
        return address(this).balance;
    }
}

// 用 Solidity 编写 BigBank 智能合约
contract BigBank is Bank {
    // min deposit amount is 0.001 ether
    uint256 public minDepositAmount = 0.001 ether;

    constructor(address _newOwner) Bank(_newOwner) {
        owner = _newOwner;
    }

    // 存款金额 >0.001 ether
    modifier validMinDeposit() {
        require(
            msg.value > minDepositAmount,
            "min deposit must great than 0.001 ether"
        );
        _;
    }

    receive() external override payable validMinDeposit {
        balances[msg.sender] = balances[msg.sender] + msg.value;
        updateTop3User(msg.sender);
    }

    function transferOwner(address _newOwner) external onlyOwner {
        owner = _newOwner;
    }
}
