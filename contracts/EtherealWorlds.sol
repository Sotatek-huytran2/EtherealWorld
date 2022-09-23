// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "./ERC721P/ERC721Enumerable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

contract EtherealWorlds is Ownable, ERC721Enumerable {
    using Strings for uint256;
    using ECDSA for bytes32;

    address constant public TREASURY = 0x9e4693e5F5304cFf85c0D563632E64d2FaF26Ca3; // it was private 
    address constant public TAKOA = 0x40119D8CFFFf7B79B3034460786dE09f57786B0A; // it was private 
    address constant public PIONEER = 0x1b0619EF3D87B4bf9f53F16f0a58AAE71f9f2188; // it was private 
    address constant public EXCEED = 0x4B273F780ebFAd7c1EEe7A9DF3B73dF1a9b78be2; // it was private 
    address constant public SUIKON = 0xa5FBF2FE1167bb2Eacaf28147aDDb42e3be15C8A; // it was private 
    address constant public DEV_1 = 0x3E36Bdbae15833bD3A1cB61dBa0CB7d8f345CC8b; // it was private 
    address constant public DEV_2 = 0x73964F6F211D5a8428322EDFbDfEc72FF76D9fCd; // it was private 
    address constant public DEV_3 = 0x6F3e043Ea066b96842FAd75e85526483819efbFa; // it was private 
    address constant public STAFF_1 = 0x5b4d5DaF00c2b4A888871C46Ae3AF2769b6dB3c9; // it was private 
    address constant public STAFF_2 = 0x0fc587E4cA63E25A1dF0D34C3DE7Dc8A5254D87e; // it was private 

    uint256 constant public MAX_WORLDS = 345;
    uint256 constant public WORLD_PRICE = 0.125 ether;

    mapping(uint256 => bool) public usedNonces; // it was private 
    
    bool public isSaleActive;

    string public _baseTokenURI = "https://data.forgottenethereal.world/metadata/";
    address public _signer; // it was private

    constructor(address signer) ERC721("Forgotten Ethereal Worlds", "FEW") {
        _safeMint(TAKOA, 0);
        _safeMint(EXCEED, 1);
        _safeMint(PIONEER, 2);
        _safeMint(SUIKON, 3);
        _safeMint(DEV_1, 4);
        _safeMint(DEV_2, 5);
        _safeMint(DEV_3, 6);
        _safeMint(STAFF_1, 7);
        _safeMint(STAFF_2, 8);
        _signer = signer;
    }

    /**
     * @dev Only mints if sale is active, and that the signature is valid.
     *      Each signature is valid for 1 mint
     */
    function mint(bytes calldata _signature, uint256 _nonce) external payable {
        require(isSaleActive, "Worlds: Sale Inactive");

        // require(WORLD_PRICE <= msg.value, "Worlds: Insufficient Funds");
        // require(hashMessage(_nonce).recover(_signature) == _signer, "Worlds: Weird Hash");
        // require(!usedNonces[_nonce], "Worlds: Reused Hash");

        uint256 currentSupply = totalSupply();
        require(currentSupply < MAX_WORLDS, "Worlds: Sold Out");
        usedNonces[_nonce] = true;

        _safeMint(msg.sender, currentSupply);
    }

    /**
     * @dev Mints all remaining NFT's into treasury in the event someone decides not to mint
     *      Should keep in mind gas limit in case there are a lot of no shows
     */
    function mintRemaining() external onlyOwner {
        uint256 currentSupply = totalSupply();

        while(currentSupply < MAX_WORLDS) {
            _safeMint(TREASURY, currentSupply++);
        }
    }

    /**
     * @dev Just a utility function so the mint code looks slightly cleaner
     */
    function hashMessage(uint256 _nonce) internal view returns(bytes32 _hash) {
        _hash = keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", keccak256(abi.encodePacked(msg.sender, _nonce))));
    }

    /**
     * @dev Turn's sale on if its off and vice versa
     */
    function toggleSale() external onlyOwner {
        isSaleActive = !isSaleActive;
    }

    /**
    * @notice Set baseURI
    *
    * @param baseURI URI of the pet image server
    */
    function setBaseURI(string calldata baseURI) external onlyOwner {
        _baseTokenURI = baseURI;
    }

    /**
    * @notice Base URI for computing {tokenURI}. If set, the resulting URI for each
    * token will be the concatenation of the `baseURI` and the `tokenId`.
    *
    * @return string Uri
    */
    function _baseURI() internal view virtual returns (string memory) {
        return _baseTokenURI;
    }

    /**
     * @dev See {IERC721Metadata-tokenURI}.
     */
    function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
	    require(_exists(tokenId), "ERC721Metadata: Unknown token");
        
	    string memory baseURI = _baseURI();
	    return bytes(baseURI).length > 0	? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
	}

    /**
     * @dev Not safe to have all the funds on the deployer's address
     */
    function withdrawAll() external {
        uint256 balance = address(this).balance;
        
        payable(TREASURY).transfer(balance * 5000 / 10000);
        payable(TAKOA).transfer(balance * 1150 / 10000);
        payable(EXCEED).transfer(balance * 800 / 10000);
        payable(PIONEER).transfer(balance * 1000 / 10000);
        payable(SUIKON).transfer(balance * 550 / 10000);
        payable(DEV_1).transfer(balance * 500 / 10000);
        payable(DEV_2).transfer(balance * 650 / 10000);
        payable(DEV_3).transfer(balance * 350 / 10000);
    }
}