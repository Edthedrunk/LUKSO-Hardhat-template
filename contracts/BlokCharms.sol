// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

/** */

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
        uint256 percentage; // Add percentage chance for each color
    }

    ColorSupply[] public colorSupplies;

    mapping(uint256 => string) public tokenColors;

  constructor() ERC721("BlokCharms", "BLOK") {
        colorSupplies.push(ColorSupply("Pink", 1319, 314));
        colorSupplies.push(ColorSupply("Gold", 1764, 420));
        colorSupplies.push(ColorSupply("Blue", 2829, 690));
        colorSupplies.push(ColorSupply("Lime", 3045, 725));
        colorSupplies.push(ColorSupply("Orange", 5002, 1191));
        colorSupplies.push(ColorSupply("Black", 13986, 3330));
        colorSupplies.push(ColorSupply("White", 13986, 3330));
        // Add other colors similarly
    }

   function mint(uint256 amount) public payable nonReentrant {
    require(totalMinted + amount <= MAX_SUPPLY, "Exceeds maximum supply");
    require(amount <= MAX_PUBLIC_MINT, "Exceeds maximum mint amount");
    require(msg.value >= amount * MINT_PRICE, "Ether sent is not correct");

    for (uint256 i = 0; i < amount; i++) {
        uint256 tokenId = totalSupply() + 1;
        uint256 colorIndex = _randomColorIndex(msg.sender);
        require(colorSupplies[colorIndex].supply > 0, "Color out of stock");

        _mint(msg.sender, tokenId);
        tokenColors[tokenId] = colorSupplies[colorIndex].color;
        colorSupplies[colorIndex].supply -= 1;
        totalMinted += 1;
    }
}

  function _randomColorIndex(address _address) private view returns (uint256) {
        uint256 rand = uint256(keccak256(abi.encodePacked(block.prevrandao, block.timestamp, _address, totalMinted)));
        uint256 totalPercentage = 10000; // Sum of all percentages times 100 to allow for two decimal places
        uint256 accumulativePercentage = 0;
        uint256 selectedPercentage = rand % totalPercentage;

        for (uint256 i = 0; i < colorSupplies.length; i++) {
            if (colorSupplies[i].supply > 0) {
                accumulativePercentage += colorSupplies[i].percentage;
                if (selectedPercentage < accumulativePercentage) {
                    return i;
                }
            }
        }

        revert("No colors available"); // Fallback in case no colors are available, adjust as needed
    }


    function teamMint(address to, uint256 amount) public onlyOwner {
        require(totalMinted + amount <= MAX_SUPPLY, "Exceeds maximum supply");
        require(amount <= TEAM_MINT_AMOUNT, "Exceeds team mint amount");
        
        for (uint256 i = 0; i < amount; i++) {
            uint256 tokenId = totalSupply() + 1;
            _mint(to, tokenId);
            // Assuming team mints do not require color assignment or decrement color supply
            totalMinted += 1;
        }
    }

    // Additional functions like withdraw, setColorSupply, getTokenColor, etc.
}

