pragma solidity ^0.4.22;

contract owned {
    address owner;

    constructor() {
        owner = msg.sender;
    }

    // Access control modifier
    modifier onlyOwner {
        require(msg.sender == owner, "Only the contract owner can call this function");
        _;
    }
}

contract mortal is owned {
    function destroy() public onlyOwner {
        selfdestruct(owner);
    } 
}

contract Faucet is mortal {

    event Withdrawal(address indexed to, uint amount);
    event Deposit(address indexed from, uint amount);

    function withdraw(uint withdraw_amount) public {
        // Limit withdrawal amount
        require(this.balance >= withdraw_amount, "Insufficient balance in faucet for withdrawal request");
        require(withdraw_amount <= 0.1 ether, "Withdrawal amount can't be larger than 0.1 ether");
        msg.sender.transfer(withdraw_amount);
        emit Withdrawal(msg.sender, withdraw_amount);
    
    }
    // Accept any incoming payment
    function() public payable{
        emit Deposit(msg.sender, msg.value);
    }
}