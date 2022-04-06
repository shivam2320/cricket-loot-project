pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "./Base64.sol";

contract CricVerse is ERC721Enumerable, ReentrancyGuard, Ownable {

    uint minPrice = 0.1 ether;
    uint public maxTotalSupply = 2022;

    string[] private BattingPosition = [
        "Top Order",
        "Opener",
        "Upper middle order",
        "Lower middle order",
        "Tail ender"
    ];
    
    string[] private BattingShot = [
        "Straight Drive",
        "Square Drive",
        "Cover Drive",
        "Off Drive",
        "Hook",
        "Pull",
        "Cut",
        "Late Cut",
        "Square Cut",
        "Leg Glance",
        "On Drive"
    ];
    
    string[] private BowlingArm = [
        "Left Arm",
        "Right Arm"
    ];
    
    string[] private BowlingPace = [
        "Fast",
        "Fast Medium",
        "Medium Fast",
        "Medium",
        "Medium Slow",
        "Slow Medium",
        "Slow"
    ];
    
    string[] private BowlingTechnique = [
        "Bouncer",
        "Off-cutter",
        "Leg-cutter",
        "Inswinger",
        "outswinger",
        "Finger Spin",
        "Wrist Spin",
        "Yorker",
        "Seamer",
        "Flipper",
        "Doosra",
        "Googly",
        "Arm ball",
        "Mixed-bag"
    ];
    
    string[] private Celebration = [
        "Sword celebration",
        "Pulling the stumps",
        "Joy Run",
        "Cupping Ears",
        "Run the world dance",
        "Sergeant",
        "Selfie "
    ];
    
    string[] private PhysicalAttributes = [
        "Strength",
        "Stamina",
        "Height",
        "Speed",
        "Balance",
        "Agility",
        "Jumping",
        "Acceleration",
        "Endurance"
    ];

    string[] private MentalAttributes = [
        "Aggressive",
        "Composed",
        "Intelligent",
        "Aware",
        "Reactive",
        "Defensive",
        "Team Player",
        "Leader",
        "Visionary"
    ];
    
    string[] private Visuals = [
        "Bald",
        "Long Hair",
        "Piercings",
        "Sleeve Tatto",
        "Pony Tail"
    ];
    
    function random(string memory input) internal pure returns (uint256) {
        return uint256(keccak256(abi.encodePacked(input)));
    }
    
    function getBatPos(uint256 tokenId) public view returns (string memory) {
        return pluck(tokenId, "BATTINGPOSITION", BattingPosition);
    }
    
    function getBatShot(uint256 tokenId) public view returns (string memory) {
        return pluck(tokenId, "BATTINGSHOT", BattingShot);
    }
    
    function getBowlArm(uint256 tokenId) public view returns (string memory) {
        return pluck(tokenId, "BOWLINGARM", BowlingArm);
    }
    
    function getBowlSpc(uint256 tokenId) public view returns (string memory) {
        return pluck(tokenId, "BOWLINGPACE", BowlingPace);
    }

    function getBowlTech(uint256 tokenId) public view returns (string memory) {
        return pluck(tokenId, "BOWLINGTECHNIQUE", BowlingTechnique);
    }
    
    function getCeleb(uint256 tokenId) public view returns (string memory) {
        return pluck(tokenId, "CELEBRATION", Celebration);
    }
    
    function getPhycAttr(uint256 tokenId) public view returns (string memory) {
        return pluck(tokenId, "PHYSICALATTRIBUTES", PhysicalAttributes);
    }

    function getMentalAttr(uint256 tokenId) public view returns (string memory) {
        return pluck(tokenId, "MENTALATTRIBUTES", MentalAttributes);
    }
    
    function getVisuals(uint256 tokenId) public view returns (string memory) {
        return pluck(tokenId, "VISUALS", Visuals);
    }

    function pluck(uint256 tokenId, string memory keyPrefix, string[] memory sourceArray) internal pure returns (string memory) {
        uint256 rand = random(
            string(abi.encodePacked(keyPrefix, toString(tokenId)))
        );
        uint256 required_index = rand % sourceArray.length;
        string memory output = sourceArray[required_index];

        return output;
    }


    function tokenURI(uint256 tokenId) override public view returns (string memory) {
        string[19] memory parts;
        parts[0] = '<svg xmlns="http://www.w3.org/2000/svg" preserveAspectRatio="xMinYMin meet" viewBox="0 0 350 350"><style>.base { fill: white; font-family: serif; font-size: 14px; }</style><rect width="100%" height="100%" fill="black" /><text x="10" y="20" class="base">';

        parts[1] = getBatPos(tokenId);

        parts[2] = '</text><text x="10" y="40" class="base">';

        parts[3] = getBatShot(tokenId);

        parts[4] = '</text><text x="10" y="60" class="base">';

        parts[5] = getBowlArm(tokenId);

        parts[6] = '</text><text x="10" y="80" class="base">';

        parts[7] = getBowlSpc(tokenId);

        parts[8] = '</text><text x="10" y="100" class="base">';

        parts[9] = getBowlTech(tokenId);

        parts[10] = '</text><text x="10" y="120" class="base">';

        parts[11] = getCeleb(tokenId);

        parts[12] = '</text><text x="10" y="140" class="base">';

        parts[13] = getPhycAttr(tokenId);

        parts[14] = '</text><text x="10" y="160" class="base">';

        parts[15] = getMentalAttr(tokenId);

        parts[16] = '</text><text x="10" y="180" class="base">';

        parts[17] = getVisuals(tokenId);

        parts[18] = '</text></svg>';

        string memory output = string(abi.encodePacked(parts[0], parts[1], parts[2], parts[3], parts[4], parts[5], parts[6]));
        output = string(abi.encodePacked(output, parts[7], parts[8], parts[9], parts[10], parts[11], parts[12]));
        output = string(abi.encodePacked(output, parts[13], parts[14], parts[15], parts[16], parts[17], parts[18]));

        string memory json = Base64.encode(bytes(string(abi.encodePacked('{"name": "Player #', toString(tokenId), '", "description": "CricketLoot", "image": "data:image/svg+xml;base64,', Base64.encode(bytes(output)), '"}'))));
        output = string(abi.encodePacked('data:application/json;base64,', json));

        return output;
    }

    function claim(uint256 tokenId) public nonReentrant payable {
        require(msg.value >= minPrice, "Mint price should be greater than 20 matic");
        require(tokenId > 0 && tokenId <= maxTotalSupply, "Token ID invalid");
        _safeMint(_msgSender(), tokenId);
    }

    function withdraw() public onlyOwner {
        uint redeemableBalance = address(this).balance;
        require(redeemableBalance > 0, "Insufficient Balance");
        payable(msg.sender).transfer(redeemableBalance);
    }
    
    function toString(uint256 value) internal pure returns (string memory) {
    // Inspired by OraclizeAPI's implementation - MIT license
    // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol

        if (value == 0) {
            return "0";
        }
        uint256 temp = value;
        uint256 digits;
        while (temp != 0) {
            digits++;
            temp /= 10;
        }
        bytes memory buffer = new bytes(digits);
        while (value != 0) {
            digits -= 1;
            buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
            value /= 10;
        }
        return string(buffer);
    }

    constructor() ERC721("CricVerse", "CricV") Ownable() {}
}

