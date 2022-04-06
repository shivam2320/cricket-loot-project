const { ethers } = require('hardhat');
const { expect } = require('chai');
const { inputToConfig } = require('@ethereum-waffle/compiler');

describe("CricVerse Testing", () => {

    let owner;
    let addr1;
    let CricVerse;
    let cricVerse;

    beforeEach(async () => {
        [owner, addr1] = await ethers.getSigners();
        CricVerse = await ethers.getContractFactory("CricVerse");
        cricVerse = await CricVerse.deploy();

        await cricVerse.deployed();
    });

    describe("Minting", () => {
        it("Should mint NFTs", async () => {
           await cricVerse.claim(23, {value: ethers.utils.parseEther("23")});
           await cricVerse.claim(232, {value: ethers.utils.parseEther("0.1")});
           expect(await cricVerse.totalSupply()).to.equal(2);
           expect(await cricVerse.ownerOf(23)).to.equal(owner.address);

           console.log("TokenURI: ",await cricVerse.tokenURI(23));
        });
    });

    describe("Transfers", () => {
        it("Transfer properly", async () => {
            await cricVerse.claim(23, {value: ethers.utils.parseEther("1")});
            await cricVerse.transferFrom(owner.address, addr1.address, 23);
            expect(await cricVerse.balanceOf(addr1.address)).to.equal(1);
        });
    });

    describe("Withdraw", () => {
        it("Should withdraw balance", async () => {
            await cricVerse.connect(addr1).claim(23, {value: ethers.utils.parseEther("90")});
            console.log(this.address.balance);
        });
    });

});