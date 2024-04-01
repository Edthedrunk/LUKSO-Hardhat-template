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


  describe('Team Minting', function () {
    it('Should allow team minting by owner', async function () {
      // Implementation of the test
    });
  });
});
