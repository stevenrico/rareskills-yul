// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;

import { Test } from "forge-std/Test.sol";
import { DataTypes } from "../src/DataTypes.sol";

contract DataTypesTest is Test {
  DataTypes private _dataTypes;

  function setUp() public {
    _dataTypes = new DataTypes();
  }
}
