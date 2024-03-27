const { expect } = require("chai");
const { ethers } = require("hardhat");



describe("BlokCharms Contract", function () {
  let BlokCharms, blokCharms;
  let owner, addr1;

  beforeEach(async function () {
    [owner, addr1] = await ethers.getSigners();
    BlokCharms = await ethers.getContractFactory("BlokCharms");
    blokCharms = await BlokCharms.deploy();
  });

  describe("Minting", function () {
    it("Should mint a new Blok and assign a color", async function () {
      await expect(blokCharms.connect(addr1).mint(1, { value: ethers.utils.parseEther("0.1") }))
        .to.emit(blokCharms, 'Transfer') // Checking for the Transfer event as an example
        .withArgs(ethers.constants.AddressZero, addr1.address, 1);

      // Assuming there's a way to verify the color or other attributes after minting
      const color = await blokCharms.tokenColors(1);
      expect(color).to.exist; // Replace with appropriate checks for your contract
    });
  });

  describe("Team Minting", function () {
    it("Should allow team minting by owner", async function () {
      // Implementation of the test
    });
  });
});
