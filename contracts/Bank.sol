// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2;

contract Bank {
    mapping (address => uint) _balances;

    function deposit(uint _amount) public {
        require(_amount > 0, "Montant doit \xC3\xAAtre sup\xC3\xA0rieur \xC3\xA9 0");
        _balances[msg.sender] = _amount;
    }

    function transfer(address _recipient, uint _amount) public {
        require(_amount < _balances[msg.sender], "Solde insuffisante");
        _balances[msg.sender] -= _amount;
        _balances[_recipient] += _amount;
    }

    function balanceOf(address _address) view public returns (uint) {
        return _balances[_address];
    }
}
