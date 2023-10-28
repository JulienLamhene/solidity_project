// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2;

contract WhiteList {
    mapping(address => bool) internal whitelist;

    event Authorized(address _address);

    modifier check(){
        require(whitelist[msg.sender], "Adresse non whitelist\xC3\xA9e");
        _;
    }

    function authorize(address _address) public {
        require(_address != address(0), "Adresse non valide");
        // \xC3\xA9 : é
        // \xC3\xA0 : à
        require(!whitelist[_address], "Adresse d\xC3\xA9j\xC3\xA0 whitelist\xC3\xA9e");

        whitelist[_address] = true;
        emit Authorized(_address);
    }
} 
