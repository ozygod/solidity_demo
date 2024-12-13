// SPDX-License-Identifier: MIT
pragma solidity 0.8.10;

contract AbiDecode {
    struct DecodeDemo {
        string name;
        uint[2] nums;
    }
    function encode(uint x, address addr, uint[] calldata arr, DecodeDemo calldata demo) external pure returns (bytes memory){
        return abi.encode(x, addr, arr, demo);
    }
    function decode(bytes calldata data) external pure returns (uint x, address addr, uint[] memory arr, DecodeDemo memory demo){
        (x, addr, arr, demo) = abi.decode(data, (uint, address, uint[], DecodeDemo));
    }

}