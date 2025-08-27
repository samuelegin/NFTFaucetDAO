// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
contract NFTFaucetDAO is Ownable,ERC721Enumerable, ReentrancyGuard {
    uint256 public maxSupply = 1000;
    uint256 public totalClaimed;
    uint256 public constant coolDown = 24 hours;
    uint256 public id;
    
    mapping(address => uint256) public lastClaimed;
    event Dripped(address indexed to, uint256 indexed id);

    constructor() ERC721("DAONFT","DNFT") Ownable(msg.sender){}

    function claimFromFaucet() external nonReentrant returns (bool) {
        require(totalClaimed < maxSupply, "Max supply reached");
        require(block.timestamp >= lastClaimed[msg.sender] + coolDown, "Must wait 24 hours");
        id++;
        _safeMint(msg.sender, id);
        totalClaimed++;
        lastClaimed[msg.sender] = block.timestamp;
        emit Dripped(msg.sender, id);
        return true;
    }

    function setMaxSupply(uint256 _maxSupply) external onlyOwner {
        require(_maxSupply >= totalClaimed, "Cannot set max supply below total claimed");
        maxSupply = _maxSupply;
    }

    function totalSupply() public override view returns (uint256) {
        return totalClaimed;
    }
}