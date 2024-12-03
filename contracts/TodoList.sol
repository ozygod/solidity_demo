// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

contract TodoList {
    struct Todo {
        string text;
        bool completed;
    }

    Todo[] public todos;

    function create(string calldata text) external {
        todos.push(Todo({
            text: text,
            completed: false
        }));
    }

    function updateText(uint index, string calldata text) external {
        todos[index].text = text;
    }

    function get(uint index) external view  returns (string memory, bool) {
        Todo memory todo = todos[index];
        return (todo.text, todo.completed);
    }

    function toggle(uint index) external {
        todos[index].completed = !todos[index].completed;
    }
}