import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

contract WaifuToken is ERC721, Ownable {
    uint8 public constant HAIRSTYLE_LONG = 1;
    uint8 public constant HAIRSTYLE_SHORT = 2;
    uint8 public constant HAIRSTYLE_PONYTAIL = 3;
    uint8 public constant HAIRSTYLE_BOB = 4;
    uint8 public constant HAIRSTYLE_SHORT_TWINTAIL = 5;
    uint8 public constant HAIRSTYLE_TWINTAIL_DRILL = 6;

    uint8 public constant EMOTION_JOY = 1;
    uint8 public constant EMOTION_SADNESS = 2;
    uint8 public constant EMOTION_LOVE = 3;
    uint8 public constant EMOTION_SURPRISE = 4;
    uint8 public constant EMOTION_FEAR = 5;
    uint8 public constant EMOTION_ANGER = 6;

    string public baseURI;

    struct Waifu {
        string name;
        uint8 hairstyle;
        uint8 emotion;
    }

    mapping(uint256 => Waifu) public waifus;

    event Haircut(uint256 indexed tokenId, uint8 newHairstyle);
    event EmotionUpdate(uint256 indexed tokenId, uint8 newEmotion);
    event BaseURIUpdated(string indexed baseURI);

    constructor() ERC721("WaifuToken", "WFT") {
        setBaseURI("https://BASE_URL.XYZ/");
        mintWaifu("Alice", HAIRSTYLE_LONG, EMOTION_JOY);
    }

    function mintWaifu(string memory _name, uint8 _hairstyle, uint8 _emotion) internal {
        uint256 tokenId = 1;
        waifus[tokenId] = Waifu(_name, _hairstyle, _emotion);
        _safeMint(msg.sender, tokenId);

        emit Haircut(tokenId, _hairstyle);
        emit EmotionUpdate(tokenId, _emotion);
    }

    function getHaircut(uint256 _tokenId, uint8 _newHairstyle) external {
        require(ownerOf(_tokenId) == msg.sender, "You do not own this Waifu");
        require(_newHairstyle >= 1 && _newHairstyle <= 6, "Hair style non-exist");

        Waifu storage waifu = waifus[_tokenId];
        waifu.hairstyle = _newHairstyle;

        emit Haircut(_tokenId, _newHairstyle);
    }

    function updateEmotion(uint256 _tokenId, uint8 _newEmotion) external {
        require(ownerOf(_tokenId) == msg.sender, "You do not own this Waifu");
        require(_newEmotion >= 1 && _newEmotion <= 6, "Emotion non-exist");

        Waifu storage waifu = waifus[_tokenId];
        waifu.emotion = _newEmotion;

        emit EmotionUpdate(_tokenId, _newEmotion);
    }

    function tokenURI(uint256 _tokenId) public view override returns (string memory) {
        require(_exists(_tokenId), "Token does not exist");

        Waifu memory waifu = waifus[_tokenId];

        string memory json = string(
            abi.encodePacked(
                '{"name": "', waifu.name, '", "hairstyle": "', 
                Strings.toString(waifu.hairstyle), '", "emotion": "', 
                Strings.toString(waifu.emotion), '"}'
            )
        );

        return string(abi.encodePacked(baseURI, Strings.toString(_tokenId), "/", json));
    }

    function setBaseURI(string memory _newBaseURI) public onlyOwner {
        string memory nb = _newBaseURI;
        if (bytes(_newBaseURI)[bytes(_newBaseURI).length - 1] != '/') {
            nb = string(abi.encodePacked(_newBaseURI, '/'));
        }

        baseURI = nb;

        emit BaseURIUpdated(baseURI);
    }
}
