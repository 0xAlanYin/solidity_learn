// SPDX-License-Identifier: MIT
pragma solidity >0.8.0;

import {Bank} from "./bank.sol";

contract Ownable {
    address public owner;
    BigBank public bigBank;

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "only owner can do this call");
        _;
    }

    function setBigBank(BigBank _bigBank) external {
        bigBank = _bigBank;
    }

    function transferOwner(address newOwner) external onlyOwner {
        bigBank.transferOwner(newOwner);
    }
}

// 用 Solidity 编写 BigBank 智能合约
contract BigBank is Bank {
    // min deopsit amount is 0.001 ether
    uint256 public minDepositAmount = 0.001 ether;

    constructor(address _newOwner) Bank(_newOwner) {
        admin = _newOwner;
    }

    // 存款金额 >0.001 ether
    modifier validMinDeposit() {
        require(
            msg.value > minDepositAmount,
            "min deposit must great than 0.001 ether"
        );
        _;
    }

    function deposit() public payable override validMinDeposit {
        balances[msg.sender] = balances[msg.sender] + msg.value;
        updateTop3User(msg.sender);
    }

    function transferOwner(address _newOwner) external onlyOwner {
        admin = _newOwner;
    }
}
