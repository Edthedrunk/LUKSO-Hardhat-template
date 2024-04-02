// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

/** */

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import {Address} from "@openzeppelin/contracts/utils/Address.sol";
import { OnChainMetadata } from "./OnChainMetadata.sol";

contract BlokCharms is ERC721Enumerable, ReentrancyGuard, Ownable {
    uint256 public constant MINT_PRICE = 0.1 ether;
    uint256 public constant MAX_SUPPLY = 42000;
    uint256 public constant TEAM_MINT_AMOUNT = 420;
    uint256 public constant MAX_PUBLIC_MINT = 420;
    uint256 private totalMinted;

    struct ColorSupply {
        string color;
        uint256 supply;
        uint256 percentage; // Add percentage chance for each color
    }

    ColorSupply[] public colorSupplies;

    mapping(uint256 => string) public tokenColors;
    mapping (address => uint) public publicMintedAddress;
    mapping (bytes32 => string) public blokTypes;

    /// errors
    error BLOKMintingLimitExceeded(uint256 _amount);
    error BLOKMintingPriceNotMet(uint256 _amount);
    error Unauthorized();

     /// @dev Modifier to ensure caller is authorized operator
    modifier onlyAuthorizedAgent() {
        if (msg.sender != authorizedAgent && msg.sender != owner()) {
            revert Unauthorized();
        }
        _;
    }

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

/// @notice team mint
    /// @param _amount The amount of tokens to mint
    function teamMint(address receiver, uint256 _amount) external onlyAuthorizedAgent {
        uint256 _totalSupply = totalSupply();
        if(_totalSupply + _amount > MAX_SUPPLY) revert BloksMintingLimitExceeded(_amount);
        for (uint256 i = 0; i < _amount; i++) {
            uint256 tokenId = ++_totalSupply;
            mintAndGenerate(receiver, tokenId);
        }
    }

    /// @param _amount The amount of tokens to mint
    function publicMint(uint256 _amount) external payable nonReentrant {
        require(publicMintSet, "Public minting is closed");
        uint256 _totalSupply = totalSupply();
        if(_totalSupply + _amount > MAX_SUPPLY) revert BloksMintingLimitExceeded(_amount);
        if(publicMintedAddress[msg.sender] + _amount > MAX_MINTABLE) revert BlokMintingLimitExceeded(_amount);
        if(msg.value != _amount*PRICE) revert BloksMintingPriceNotMet(_amount);
        for (uint256 i = 0; i < _amount; i++) {
            uint256 tokenId = ++_totalSupply;
            mintAndGenerate(msg.sender, tokenId);
        }
        publicMintedAddress[msg.sender] += _amount;
    }

  /// @notice Mint a token and generate the metadata
    /// @param _to The address of the token receiver
    /// @param _tokenId The token id
    function mintAndGenerate(address _to, uint256 _tokenId) internal {
        bytes32 _bytes32TokenId = bytes32(_tokenId);
        _mint(_to, _bytes32TokenId, false, "");
        string memory _blokType = getRandomBlok();
        blokTypes[_bytes32TokenId] = _blokType;        
    }

    /// @notice Set Minting Status
    /// @param _publicMintSet bool
    function setMintStatus(bool _publicMintSet) external onlyAuthorizedAgent {
        publicMintSet = _publicMintSet;
    }
    /// withdraw funds from the contract
    /// @param _to address
    function withdraw(address payable _to) external onlyAuthorizedAgent {
        _to.transfer(address(this).balance);
    }

    /// @notice setup the metadata
    /// @param _index The index of the metadata
    /// @param data The metadata
    function setUp(string memory _index, string[] memory data) external onlyAuthorizedAgent {
        _setUp(_index, data);
    }
    /// @notice retrieves the supply cap
    /// @return uint256
    function tokenSupplyCap() public view virtual returns (uint256) {
        return MAX_SUPPLY;
    }

   //function mint(uint256 amount) public payable nonReentrant {
   // require(totalMinted + amount <= MAX_SUPPLY, "Exceeds maximum supply");
   // require(amount <= MAX_PUBLIC_MINT, "Exceeds maximum mint amount");
   // require(msg.value >= amount * MINT_PRICE, "Ether sent is not correct");

   // for (uint256 i = 0; i < amount; i++) {
   //     uint256 tokenId = totalSupply() + 1;
   //     uint256 colorIndex = _randomColorIndex(msg.sender);
   //     require(colorSupplies[colorIndex].supply > 0, "Color out of stock");

  //      _mint(msg.sender, tokenId);
  //      tokenColors[tokenId] = colorSupplies[colorIndex].color;
  //      colorSupplies[colorIndex].supply -= 1;
   //     totalMinted += 1;
   // }
//}

 // function _randomColorIndex(address _address) private view returns (uint256) {
 //       uint256 rand = uint256(keccak256(abi.encodePacked(block.prevrandao, block.timestamp, _address, totalMinted)));
 //       uint256 totalPercentage = 10000; // Sum of all percentages times 100 to allow for two decimal places
 //       uint256 accumulativePercentage = 0;
 //       uint256 selectedPercentage = rand % totalPercentage;

//        for (uint256 i = 0; i < colorSupplies.length; i++) {
 //           if (colorSupplies[i].supply > 0) {
 //               accumulativePercentage += colorSupplies[i].percentage;
 //               if (selectedPercentage < accumulativePercentage) {
  //                  return i;
 ////               }
  //          }
 //       }

 //       revert("No colors available"); // Fallback in case no colors are available, adjust as needed
//    }


 //   function teamMint(address to, uint256 amount) public onlyOwner {
   //     require(totalMinted + amount <= MAX_SUPPLY, "Exceeds maximum supply");
    //    require(amount <= TEAM_MINT_AMOUNT, "Exceeds team mint amount");
      //  
        //for (uint256 i = 0; i < amount; i++) {
          //  uint256 tokenId = totalSupply() + 1;
            //_mint(to, tokenId);
            ///- Assuming team mints do not require color assignment or decrement color supply
    //        totalMinted += 1;
     //   }
   // }

function withdraw() external onlyOwner {
        Address.sendValue(payable(msg.sender), address(this).balance);
    }
    // Additional functions like withdraw, setColorSupply, getTokenColor, etc.
}

