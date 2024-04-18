// SPDX-License-Identifier: MIT
pragma solidity >0.8.0;

contract Bank {
    // record every address deposit amount
    mapping(address => uint256) public balances;

    // record top3 deposit
    address[3] public top3Users;

    // admin user
    address public admin;

    constructor() {
        admin = msg.sender;
    }

    // withdraw balance by admin
    function withdraw(uint256 amount) public {
        require(msg.sender == admin, "only admin can withdraw");
        require(
            amount <= address(this).balance,
            "withdraw amount greater than balance"
        );
        payable(msg.sender).transfer(amount);
    }

    // doposit
    function deposit() public payable {
        balances[msg.sender] = balances[msg.sender] + msg.value;
        updateTop3User(msg.sender);
    }

    function updateTop3User(address newSender) internal {
        // compare amount,if newSender is bigger,then update top3Users element
        if (balances[newSender] > balances[top3Users[0]]) {
            // if great than first element,move other elements and set newSender as first element
            top3Users[2] = top3Users[1];
            top3Users[1] = top3Users[0];
            top3Users[0] = newSender;
        } else if (balances[newSender] > balances[top3Users[1]]) {
            top3Users[2] = top3Users[1];
            top3Users[1] = newSender;
        } else {
            top3Users[2] = newSender;
        }
    }

    function adminBalance() public view returns (uint256) {
        return admin.balance;
    }

    receive() external payable {}

    fallback() external payable {}
}
