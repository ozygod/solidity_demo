// SPDX-License-Identifier: MIT
pragma solidity 0.8.10;

contract GasGolf {
    // start - 55601
    // use calldata - 52953
    // load state variables to memory - 52077
    // short circuit - 51601
    // loop increments - 51551
    // cache array length - 51484
    // load array elements to memory - 51086
    uint public total;

    // [1,2,3,4,10,50,90,99,100,103]
    function sumIfEvenAndLessThan99(uint[] calldata nums) external {
        uint tmp = 0;
        uint length = nums.length;
        for (uint i = 0; i < length; ++i) 
        {
            uint num = nums[i];
            // bool isEven = nums[i] % 2 == 0;
            // bool isLessThan99 = nums[i] < 99;
            if (num % 2 == 0 && num < 99) {
                tmp += num;
            }
        }
        total = tmp;
    }
}