// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

contract MultiSignWallet {
    event Deposit(address indexed sender, uint amount);
    event Submit(uint indexed txId);
    event Approve(address indexed owner, uint indexed txId);
    event Revoke(address indexed owner, uint indexed txId);
    event Execute(uint indexed txId);

    struct Transation {
        address to;
        uint value;
        bytes data;
        bool execute;
    }

    address[] public owners;
    mapping(address => bool) public isOwner;
    uint public required;

    Transation[] public  transations;
    mapping(uint => mapping(address => bool)) public approved;

    modifier onlyOwner() {
        require(isOwner[msg.sender], "not owner");
        _;
    }

    modifier txExists(uint _txId) {
        require(_txId >= 0 && transations.length > _txId, "tx not exist");
        _;
    }

    modifier notApproved(uint _txId) {
        require(!approved[_txId][msg.sender], "already approved");
        _;
    }

    modifier notExcuted(uint _txId) {
        require(!transations[0].execute, "already executed");
        _;
    }

    constructor(address[] memory _owners, uint _required) {
        require(_owners.length > 0, "owners required");
        require(_required > 0 && _required < _owners.length, "invalid requred number of owners");

        for (uint i = 0; i < _owners.length; i++) 
        {
            address owner = _owners[i];

            require(owner != address(0), "invalid owner");
            require(!isOwner[owner], "owner is not unique");

            isOwner[owner] = true;
            owners.push(owner);
        }

        required = _required;
    }

    receive() external payable { 
        emit Deposit(msg.sender, msg.value);
    }

    function submit(address _to, uint _value, bytes calldata _data) external onlyOwner {
        transations.push(Transation({
            to: _to,
            value: _value,
            data: _data,
            execute: false
        }));

        emit Submit(transations.length - 1);
    }

    function approve(uint _txId) external onlyOwner txExists(_txId) notApproved(_txId) notExcuted(_txId) {
        approved[_txId][msg.sender] = true;
        emit Approve(msg.sender, _txId);
    }

    function _getApprovalCount(uint _txId) private view returns (uint count) {
        for (uint i = 0; i < owners.length; i++) 
        {
            if(approved[_txId][owners[i]]) {
                count++;
            }
        }
    }

    function execute(uint _txId) external txExists(_txId) notExcuted(_txId) {
        require(_getApprovalCount(_txId) >= required, "approvals < required");
        Transation storage transation = transations[_txId];

        transation.execute = true;
        (bool success, ) = transation.to.call{value: transation.value}(transation.data);
        require(success, "execute fail");

        emit Execute(_txId);
    }

    function revoke(uint _txId) external onlyOwner txExists(_txId) notExcuted(_txId) {
        require(approved[_txId][msg.sender], "tx not approve");

        approved[_txId][msg.sender] = false;
        emit Revoke(msg.sender, _txId);
    }
}