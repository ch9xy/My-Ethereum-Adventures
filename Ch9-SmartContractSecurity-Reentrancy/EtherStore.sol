contract EtherStore {

    uint public withdrawalLimit = 1 ether;
    mapping(address => uint256) public lastWithdrawalTime;
    mapping(address => uint256) public balances;

    function depositFunds() public payable {
        balances[msg.sender] += msg.value;
    }

    function withdrawFunds(uint256 _weiToWithdraw) public {
        require(balances[msg.sender] >= _weiToWithdraw);
        // Limit the withdrawal
        require(_weiToWithdraw <= withdrawalLimit); 
        require(now >= lastWithdrawalTime[msg.sender] + 1 weeks);
        require(msg.sender.call.value(_weiToWithdraw)());
        balances[msg.sender] -= _weiToWithdraw;
        lastWithdrawalTime[msg.sender] = now;
    }
}