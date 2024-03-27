const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("BlokCharms Contract", function () {
  let blokCharms;
  let addr1;

  beforeEach(async function () {
    const [_, addr1] = await ethers.getSigners();
    const BlokCharms = await ethers.getContractFactory("BlokCharms");
    blokCharms = await BlokCharms.deploy();
  });

  it("Should mint a new Blok and assign a color", async function () {
    await expect(blokCharms.connect(addr1).mint(1, { value: ethers.utils.parseEther("0.1") }))
      .to.emit(blokCharms, "Transfer");
  });
});
