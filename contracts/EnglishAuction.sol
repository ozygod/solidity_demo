// SPDX-License-Identifier: MIT
pragma solidity 0.8.10;

interface IERC721 {
    function transferFrom(address from, address to, uint nftId) external;
}

contract EnglishAuction {
    event Start();
    event Bid(address indexed sender, uint amount);
    event Withdraw(address indexed caller, uint amount);
    event End(address highestBidder, uint highestBid);

    IERC721 public immutable nft;
    uint public immutable nftId;

    address payable public immutable seller;
    uint32 public endTime;
    bool public started;
    bool public ended;

    address public highestBidder;
    uint public highestBid;
    mapping(address => uint) public bids;

    constructor(address _nft, uint _nftId, uint _startingBid) {
        nft = IERC721(_nft);
        nftId = _nftId;
        seller = payable(msg.sender);
        highestBid = _startingBid;
    }    

    modifier isSeller {
        require(msg.sender == seller, "not seller");
        _;
    }

    modifier notStarted {
        require(!started, "started");
        _;
    }

    modifier isStarted {
        require(started, "not started");
        _;
    }

    modifier notEnded {
        require(!ended, "ended");
        _;
    }

    function start(uint endTimes) external isSeller notStarted notEnded {
        started = true;
        endTime = uint32(block.timestamp + endTimes);
        nft.transferFrom(seller, address(this), nftId);

        emit Start();
    }

    function bid() external payable isStarted {
        require(block.timestamp < endTime, "ended");
        require(msg.value > highestBid, "value < highest bid");

        if (highestBidder != address(0)) {
            bids[highestBidder] += highestBid;
        }

        highestBid = msg.value;
        highestBidder = msg.sender;

        emit Bid(msg.sender, msg.value);
    }

    function withdraw() external {
        uint bal = bids[msg.sender];
        bids[msg.sender] = 0;
        payable(msg.sender).transfer(bal);

        emit Withdraw(msg.sender, bal);
    }

    function end() external isStarted notEnded {
        require(block.timestamp >= endTime, "not ended");

        ended = true;
        if (highestBidder != address(0)) {
            nft.transferFrom(address(this), highestBidder, nftId);
            seller.transfer(highestBid);
        } else {
            nft.transferFrom(address(this), seller, nftId);
        }
        
        emit End(highestBidder, highestBid);
    }
}