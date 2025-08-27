// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
contract NFTFaucetDAO is Ownable, ERC721, ERC721Enumerable{
    uint256 public maxsupply = 1000;
    uint256 public totalClaimed;
    uint256 public constant cooldown = 24;
    uint256 public id;
    
    mapping(address => uint256) public balances;
    mapping(address => uint256) public lastClaimed;
    event Dripped(address indexed to, uint256 indexed id);

    constructor() ERC721("DAONFT","DNFT") Ownable(msg.sender){}

    function claimFromFaucet(address to) external returns(bool){
        require(totalClaimed <= maxsupply, "maxSupply reached");
        require(block.timestamp > lastClaimed[msg.sender] + cooldown, "Must wait 24 hours");
        _safeMint(to, id);
        totalClaimed++;
        id++;
        lastClaimed[msg.sender] = block.timestamp;
        emit Dripped(msg.sender, id);
        return true;
    }
}