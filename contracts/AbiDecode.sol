// SPDX-License-Identifier: MIT
pragma solidity 0.8.10;

contract AbiDecode {
    struct DecodeDemo {
        string name;
        uint[2] nums;
    }
    // x: 1
    // addr: 0x4B20993Bc481177ec7E8f571ceCaE8A9e22C02db
    // arr: [2,3,3,3]
    // demo: ["demo", [2,3]]
    function encode(uint x, address addr, uint[] calldata arr, DecodeDemo calldata demo) external pure returns (bytes memory){
        return abi.encode(x, addr, arr, demo);
    }
    function decode(bytes calldata data) external pure returns (uint x, address addr, uint[] memory arr, DecodeDemo memory demo){
        (x, addr, arr, demo) = abi.decode(data, (uint, address, uint[], DecodeDemo));
    }

}