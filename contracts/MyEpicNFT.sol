// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

// We first import some OpenZeppelin Contracts.
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "hardhat/console.sol";
import {Base64} from "./libraries/Base64.sol";

// We inherit the contract we imported. This means we'll have access
// to the inherited contract's methods.
contract MyEpicNFT is ERC721URIStorage {
    // Magic given to us by OpenZeppelin to help us keep track of tokenIds.
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    // This is our SVG code. All we need to change is the word that's displayed. Everything else stays the same.
    // So, we make a baseSvg variable here that all our NFTs can use.
    string baseSvg =
        "<svg xmlns='http://www.w3.org/2000/svg' preserveAspectRatio='xMinYMin meet' width='100%' height='100%' viewBox='0 0 350 350'><style>.base { fill: white; font-family: serif; font-size:5px; }</style><rect width='100%' height='100%' fill='blue' float='left' /> <text x='50' y='50' class='base' dominant-baseline='left'  text-anchor='left'>";

    // A "DEVELOPER" IN "AN ECOMMERCE" STARTUP IGNORING "STAND-UP MEETINGS" WHILE LISTENING TO THE "TIM FERRIS" PODCAST
    string[] firstWords = [
        "Developer",
        "Programmer",
        "Founder",
        "VP",
        "Product Manager",
        "Solidity Dev",
        "VC",
        "Developer Advocate"
    ];
    string[] secondWords = [
        "an E-commerce",
        "a Robotics",
        "an Aerospace",
        "a SAAS",
        "a B2B",
        "a Crypto",
        "a Defi"
    ];
    string[] thirdWords = [
        "stand-up meetings",
        "project sprints",
        "users calls",
        "the PM",
        "the press outside",
        "the crypto FOMO",
        "the bug in production"
    ];
    string[] fourthWords = [
        "Chainlinked",
        "Acquired",
        "Masters of scale",
        "Land of the Giants",
        "A16Z",
        "the Wall street journal",
        "the Lex Fridman"
    ];
    event NewEpicNFTMinted(address sender, uint256 tokenId);

    // We need to pass the name of our NFTs token and it's symbol.
    constructor() ERC721("DINKY TALES", "DINKTALE") {}

    // I create a function to randomly pick a word from each array.
    function pickRandomFirstWord(uint256 tokenId)
        public
        view
        returns (string memory)
    {
        // I seed the random generator. More on this in the lesson.
        uint256 rand = random(
            string(abi.encodePacked("FIRST_WORD", Strings.toString(tokenId)))
        );
        // Squash the # between 0 and the length of the array to avoid going out of bounds.
        rand = rand % firstWords.length;
        return firstWords[rand];
    }

    function pickRandomSecondWord(uint256 tokenId)
        public
        view
        returns (string memory)
    {
        uint256 rand = random(
            string(abi.encodePacked("SECOND_WORD", Strings.toString(tokenId)))
        );
        rand = rand % secondWords.length;
        return secondWords[rand];
    }

    function pickRandomThirdWord(uint256 tokenId)
        public
        view
        returns (string memory)
    {
        uint256 rand = random(
            string(abi.encodePacked("THIRD_WORD", Strings.toString(tokenId)))
        );
        rand = rand % thirdWords.length;
        return thirdWords[rand];
    }
    function pickRandomFourthWord(uint256 tokenId)
        public
        view
        returns (string memory)
    {
        uint256 rand = random(
            string(abi.encodePacked("FOURTH_WORD", Strings.toString(tokenId)))
        );
        rand = rand % fourthWords.length;
        return fourthWords[rand];
    }

    function random(string memory input) internal pure returns (uint256) {
        return uint256(keccak256(abi.encodePacked(input)));
    }

    function getTotalNFTsMintedSoFar () external view returns (uint256) {
        return _tokenIds.current() - 1;
    }

    function makeAnEpicNFT() public {
        uint256 newItemId = _tokenIds.current();
        require(newItemId < 51, "Only 50 NFTs to be minted max!");

        string memory first = pickRandomFirstWord(newItemId);
        string memory second = pickRandomSecondWord(newItemId);
        string memory third = pickRandomThirdWord(newItemId);
        string memory fourth = pickRandomFourthWord(newItemId);
        string memory combinedWord = string(
            abi.encodePacked(
                "A ",first," in ",second, " startup ignoring ", third, " while listening to the ", fourth, " podcast" )
        );

        string memory finalSvg = string(
            abi.encodePacked(baseSvg, combinedWord, "</text></svg>")
        );

        // Get all the JSON metadata in place and base64 encode it.
        string memory json = Base64.encode(
            bytes(
                string(
                    abi.encodePacked(
                        '{"name": "',
                        // We set the title of our NFT as the generated word.
                        combinedWord,
                        '", "description": "A collection of very rare moments in peoples careers.", "image": "data:image/svg+xml;base64,',
                        // We add data:image/svg+xml;base64 and then append our base64 encode our svg.
                        Base64.encode(bytes(finalSvg)),
                        '"}'
                    )
                )
            )
        );

        // Just like before, we prepend data:application/json;base64, to our data.
        string memory finalTokenUri = string(
            abi.encodePacked("data:application/json;base64,", json)
        );

        console.log("\n--------------------");
        console.log(finalTokenUri);
        console.log("--------------------\n");

        _safeMint(msg.sender, newItemId);

        // Update your URI!!!
        _setTokenURI(newItemId, finalTokenUri);

        _tokenIds.increment();
        console.log(
            "An NFT w/ ID %s has been minted to %s",
            newItemId,
            msg.sender
        );

        emit NewEpicNFTMinted(msg.sender, newItemId);
    }
}
