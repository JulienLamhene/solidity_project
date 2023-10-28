// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2;

//import "@openzeppelin/contracts/access/Ownable.sol";
import "./Ownable.sol";
import "./WhiteList.sol";

contract Admin is Ownable(msg.sender) {
    mapping(address => bool) private whitelist;
    mapping(address => bool) private blacklist;

    event Whitelisted(address _address);
    event Blacklisted(address _address);

    function whitelistAddress(address _address) external onlyOwner {
        require(!whitelist[_address], "Adresse d\xC3\xA9j\xC3\xA0 whitelist\xC3\xA9e");

        whitelist[_address] = true;
        emit Whitelisted(_address);
    }

    function blacklistAddress(address _address) external onlyOwner {
        require(!blacklist[_address], "Adresse d\xC3\xA9j\xC3\xA0 whitelist\xC3\xA9e");

        blacklist[_address] = true;
        emit Blacklisted(_address);
    }

    function isWhitelist(address _address) external view returns (bool) {
        return whitelist[_address];
    }

    function isBlacklist(address _address) external view returns (bool) {
        return blacklist[_address];
    }
}
