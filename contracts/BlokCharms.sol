// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

/*
*

BBBBBB      LLL         OOOOOO           KKK
BBBBBBB     LLL        OOOOOOOO         KKK
BB   BB     LLL        OOO  OOO        KKK
BB   BB     LLL        OOO  OOO       KKK
BBBBBB      LLL        OOO  OOO      KKK
BBBBBBB     LLL        OOO  OOO     KKK
BB   BBB    LLL        OOO  OOO      KKK
BB    BB    LLL        OOO  OOO       KKK
BB   BBB    LLL        OOO  OOO        KKK
BBBBBBB      LLLLLLLL  OOOOOOOO         KKK
BBBBBB        LLLLLLL   OOOOOO           KKK

*
* Its a Blok Chain......get it XD
*/
/// @author EdtheDrunk
/// Material mainly stolen from @CupCo and @Burnt Punx
/// This contract is used to mint BLOK NFTs


import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract BlokCharms is ERC721Enumerable, ReentrancyGuard, Ownable {
    uint256 public constant MINT_PRICE = 0.1 ether;
    uint256 public constant MAX_SUPPLY = 42000;
    uint256 public constant TEAM_MINT_AMOUNT = 420;
    uint256 public constant MAX_PUBLIC_MINT = 4200;
    uint256 private totalMinted;

    struct ColorSupply {
        string color;
        uint256 supply;
    }

    ColorSupply[] public colorSupplies;

    mapping(uint256 => string) public tokenColors;

    constructor() ERC721("BlokCharms", "BLOK") {
        colorSupplies.push(ColorSupply("Pink", 1319));
        colorSupplies.push(ColorSupply("Blue", 1764));
        colorSupplies.push(ColorSupply("Lime", 2829));
        colorSupplies.push(ColorSupply("Orange", 3045));
        colorSupplies.push(ColorSupply("Red", 5002));
        colorSupplies.push(ColorSupply("Black", 13986));
        colorSupplies.push(ColorSupply("White", 13986));
        // Add other colors similarly
    }

    function mint(uint256 amount) public payable nonReentrant {
        require(totalMinted + amount <= MAX_SUPPLY, "Exceeds maximum supply");
        require(amount <= MAX_PUBLIC_MINT, "Exceeds maximum mint amount");
        require(msg.value >= amount * MINT_PRICE, "Ether sent is not correct");
        
        for(uint256 i = 0; i < amount; i++) {
            uint256 tokenId = totalSupply() + 1;
            uint256 colorIndex = _randomColorIndex();
            require(colorSupplies[colorIndex].supply > 0, "Color out of stock");
            
            _mint(msg.sender, tokenId);
            tokenColors[tokenId] = colorSupplies[colorIndex].color;
            colorSupplies[colorIndex].supply -= 1;
            totalMinted += 1;
        }
    }

    function _randomColorIndex() private view returns (uint256) {
        // Random selection logic based on remaining supply
        // Simplified for example purposes
        return uint256(keccak256(abi.encodePacked(block.timestamp, msg.sender))) % colorSupplies.length;
    }

    function teamMint() external onlyOwner {
        // Team minting logic here
    }

    // Additional functions like withdraw, setColorSupply, getTokenColor, etc.
}

