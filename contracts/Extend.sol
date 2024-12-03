// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

contract A {
    function foo() public pure virtual  returns (string memory) {
        return "A";
    }

    function bar() public pure virtual  returns (string memory) {
        return "B";
    }

    function fuk() public  pure returns (string memory) {
        return "C";
    }
}

contract B is A {
    function foo() public pure override returns (string memory) {
        return "A1";
    }

    function bar() public pure override returns (string memory) {
        return "B1";
    }
}