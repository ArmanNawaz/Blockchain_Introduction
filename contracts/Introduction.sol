// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

contract Introduction {
    string[] private allData;

    event dataAdded(string data);

    function add(string memory data) public {
        allData.push(data);
        emit dataAdded(data);
    }
}