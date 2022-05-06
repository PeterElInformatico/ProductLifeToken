// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

//contract import
import "@openzeppelin/contracts@4.5.0/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts@4.5.0/access/Ownable.sol";
import "@openzeppelin/contracts@4.5.0/utils/Counters.sol";

contract ProductLife is ERC721, Ownable { //defining inheritage
    using Counters for Counters.Counter;

    Counters.Counter private _tokenIdCounter; //setting of the counter

    address public projectOwner; //declaring one Owner

    constructor() ERC721("ProductLife", "PL") { //declaring constructor that will be called once when minting
        projectOwner = msg.sender;
    }

    struct Product {            // defining a struct for the product
    uint productId;             // the unique product ID of the physical product, cannot be changed after declaration
    string productName;         // the designation of the physical product, cannot be changed after declaration
    string colour;              // the colour of the physical product, cannot be changed after declaration
    address owner;              // holds the wallet address of the owner, is always overwritten when the product is transfered
    uint8 ownerCount;           // increments up to 255 everytime a transfer takes place
    uint32 [] priceHistory;     // saves an array of prices, a new price is appended after as part of each transfer
    uint [] timestampHistory;   // saves an array of timestamps, a new price is appended after as part of each transfer
    }

    mapping (uint256 => Product) idToProduct; //maps the ProductLife tokenId to the Product

//minting of the NFT

    function safeMint(address to) public onlyOwner returns(uint256) { // can only be called by the owner
        uint256 _tokenId = _tokenIdCounter.current();                 // assignes the current counter as the token Id
        _tokenIdCounter.increment();                                  // incrementation of the counter
        _safeMint(to, _tokenId);                                      // function inherited from ERC721.sol
        return _tokenId;
    }

//adding of properties

    function createProduct(uint _productId, string memory _productName, string memory _colour, address _ownerId, uint32 _price) public {
        require(projectOwner == msg.sender, "No permission to mint");   // function can only be called by the owner, placed at the beginning of the function to spare unnecessary use of ressources
        uint32 [] memory price = new uint32[](_price);                  // creation of an empty array + writing to it's index 0 since the declaration within the struct is no sufficient
        uint [] memory timestamp = new uint [](block.timestamp);
        uint256 _tokenId = safeMint(_ownerId);
        idToProduct[_tokenId] = Product(_productId, _productName, _colour, _ownerId, 1, price, timestamp);
    }

//transfer of the token

    function transferFrom(address _from, address _to, uint256 _tokenId) public virtual override {   // override modifier since the old owner is being overriden, general structure following the ERC721 standard
        require(_from == idToProduct[_tokenId].owner, "The transfer caller is not the owner");      // function can only be called by the owner, placed at the beginning of the function to spare unnecessary use of ressources
        idToProduct[_tokenId].owner == _to;
    }

    function _transfer(address _from, address _to, uint256 _tokenId, uint32 _price) private {       // updating all necessary components of the product for the transfer
        idToProduct[_tokenId].ownerCount++;
        idToProduct[_tokenId].priceHistory.push(_price);
        idToProduct[_tokenId].timestampHistory.push(block.timestamp);
        transferFrom(_from, _to, _tokenId);
    }

// burning of the token
    function burn(address _from, uint256 _tokenId) public {
        _transfer(_from, address(0), _tokenId, 0);          // transfering to the zero address with a fixed price of 0 to be able to reuse the existing _transfer function
    }      
}