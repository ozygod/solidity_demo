// SPDX-License-Identifier: MIT
pragma solidity 0.8.10;

contract MultiDelegateCall {
    error DelegatecallFailed();

    function call(bytes[] calldata data) external payable returns (bytes[] memory results) {
        results = new bytes[](data.length);
        for (uint i; i < data.length; i++) 
        {
            (bool success, bytes memory result) = address(this).delegatecall(data[i]);
            if (!success) {
                revert DelegatecallFailed();
            }
            results[i] = result;
        }
    }
}

contract TestMultiDelegateCall is MultiDelegateCall {
    event Log(address caller, string func, uint i);

    function func1(uint x, uint y) external {
        emit Log(msg.sender, "func1", x + y);
    }

    function func2() external returns (uint) {
        emit Log(msg.sender, "func1", 2);
        return 111;
    }

    mapping (address => uint) public balanceOf;

    // !!! unsafe code
    function mint() external payable {
        balanceOf[msg.sender] += msg.value;
    }
}

contract Helper {
    function getFunc1Data(uint x, uint y) external pure returns (bytes memory result) {
        result = abi.encodeWithSelector(TestMultiDelegateCall.func1.selector, x, y);
    } 
    function getFunc2Data() external pure returns (bytes memory result) {
        result = abi.encodeWithSelector(TestMultiDelegateCall.func2.selector);
    } 
    function getMintData() external pure returns (bytes memory result) {
        result = abi.encodeWithSelector(TestMultiDelegateCall.mint.selector);
    } 
}