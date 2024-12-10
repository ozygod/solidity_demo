// SPDX-License-Identifier: MIT
pragma solidity 0.8.10;

contract DeployWithCreate2 {
    address public owner;

    constructor(address _owner) {
        owner = _owner;
    }
}

contract Create2Factory {
    event Deploy(address addr);

    function deploy(uint _salt) external {
        DeployWithCreate2 _newContract = new DeployWithCreate2{
            salt: bytes32(_salt)
        }(msg.sender);
        emit Deploy(address(_newContract));
    }

    function getAddress(bytes memory bytecode, uint _salt) public view returns (address) {
        bytes32 hash = keccak256(abi.encodePacked(bytes1(0xff), address(this), _salt, keccak256(bytecode)));

        return address(uint160(uint(hash)));
    }

    function getByteCode(address _owner) public pure returns (bytes memory bytecode) {
        bytes memory tmp = type(DeployWithCreate2).creationCode;
        bytecode = abi.encodePacked(tmp, abi.encode(_owner));
    }
}