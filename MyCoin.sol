pragma solidity 0.4.8;

contract Coin {

    address public minter;
    uint public totalCoins;

    event LogCoinsMinted(address deliveredTo, uint amount);
    event LogCoinsSent(address sentTo, uint amount);

    
    mapping (address => uint) balances;
    function Coin(uint initialCoins) {
        minter = msg.sender;
        totalCoins = initialCoins;
        balances[minter] = initialCoins;
    }

    //Adds the amount of coins to the address mentioned. Can only be called by contract owner.
    function mint(address owner, uint amount) {
        if (msg.sender != minter) return;
        balances[owner] += amount;
        totalCoins += amount;
        LogCoinsMinted(owner, amount);
    }

    //function to send the coins to another address. Can be called from any address
    function send(address receiver, uint amount) {
        if (balances[msg.sender] < amount) return;
        balances[msg.sender] -= amount;
        balances[receiver] += amount;
        LogCoinsSent(receiver, amount);
    }

    //returns the balance coins in the passed address
    function queryBalance(address addr) constant returns (uint balance) {
        return balances[addr];
    }

    //destroy the contract. Can only be called by the owner of the contract.
    function killCoin() returns (bool status) {
        if (msg.sender != minter) throw;
        selfdestruct(minter);
    }
}