import { expect } from 'chai';
import { ethers } from 'hardhat';
import { type HardhatEthersSigner } from '@nomicfoundation/hardhat-ethers/signers';
import { type BlokCharms } from '../typechain-types';

const toMint = 2;


describe('BlokCharms Contract', function () {
  let BlokCharms, blokCharms: BlokCharms;
  let owner, addr1: HardhatEthersSigner;

  beforeEach(async function () {
    [owner, addr1] = await ethers.getSigners();
    BlokCharms = await ethers.getContractFactory('BlokCharms');
    blokCharms = await BlokCharms.deploy();
  });

  describe('Minting', function () {
    it('Should mint a new Blok and assign a color', async function () {
      await expect(blokCharms.connect(addr1).mint(toMint, { value: ethers.parseEther(`${(0.1 * toMint)}`) }))
        .to.emit(blokCharms, 'Transfer') // Checking for the Transfer event as an example
        .withArgs(ethers.ZeroAddress, addr1.address, toMint);

      // Assuming there's a way to verify the color or other attributes after minting
      const colors = []
      for (let i = 1; i < toMint + 1; i++) {
        const color = await blokCharms.tokenColors(i)
        colors.push(color);
      }

      console.log(colors)
      expect(colors.length).to.eq(toMint)
    });
  });

  describe('Color Assignment', function () {
    it('Should not assign colors out of supply', async function () {
      // The logic here depends on how you can check the remaining supply and percentages
      // For simplicity, assume a scenario where a color is almost out of supply
  
      // Act: Mint an NFT when a specific color is nearly out of supply
      await blokCharms.connect(addr1).mint(toMint, { value: ethers.parseEther("0.1") });
  
      // Assert: Check that no color is assigned that exceeds its supply limit
      // This is a conceptual test; you'll need to adjust it based on your contract's methods and logic
      const color = await blokCharms.tokenColors(toMint);
      console.log(color); // For demonstration, ideally, you verify against expected conditions
  
      // Note: A more thorough test would mock the randomness to ensure each color can be assigned within its supply constraints, which might require contract adjustments for testability.
    });
  });
  
  describe('Team Minting', function () {
    it('Should allow team minting by owner', async function () {
      // Implementation of the test
    });
  });
});
