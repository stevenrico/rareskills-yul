// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;

import { Test } from "forge-std/Test.sol";
import { DataStructures } from "../src/DataStructures.sol";

contract DataStructuresTest is Test {
  DataStructures private _dataStructures;

  function setUp() public {
    _dataStructures = new DataStructures();
  }

  function testReadFixedArray() external {
    assertEq(_dataStructures.readFixedArray(0), 5);
    assertEq(_dataStructures.readFixedArray(1), 50);
    assertEq(_dataStructures.readFixedArray(2), 500);
  }

  function testReadDynamicArrayLength() external {
    assertEq(_dataStructures.readDynamicArrayLength(), 10);
  }

  function _itReturnsDataAndLocation(
    function (uint256) view external returns (uint256,bytes32) funcPointer,
    uint256 index,
    uint256 expData,
    bytes32 expLocation
  ) private {
    (, bytes memory res) =
      address(_dataStructures).call(abi.encodeCall(funcPointer, (index)));

    (uint256 data, bytes32 location) = abi.decode(res, (uint256, bytes32));

    assertEq(data, expData);
    assertEq(location, expLocation);
  }

  function testReadDynamicArray() external {
    bytes32 location =
      0xc2575a0e9e593c00f959f8c92f12db2869c3395a3b0502d05e2516446f71f85b;

    _itReturnsDataAndLocation(_dataStructures.readDynamicArray, 0, 10, location);
    _itReturnsDataAndLocation(_dataStructures.readDynamicArray, 4, 50, location);
    _itReturnsDataAndLocation(
      _dataStructures.readDynamicArray, 9, 100, location
    );
  }

  function testReadPackedArray() external {
    bytes32 location =
      0x8a35acfbc15ff81a39ae7d344fd709f28e8600b4aa8c65c6b64bfe7fe36bd19b;

    _itReturnsDataAndLocation(_dataStructures.readPackedArray, 0, 10, location);
    _itReturnsDataAndLocation(_dataStructures.readPackedArray, 4, 50, location);
    _itReturnsDataAndLocation(_dataStructures.readPackedArray, 9, 100, location);
  }

  function testReadMapping() external {
    assertEq(_dataStructures.readMapping(5), 50);
    assertEq(_dataStructures.readMapping(10), 100);
  }

  function testReadNestedMapping() external {
    assertEq(_dataStructures.readNestedMapping(3, 5), 15);
    assertEq(_dataStructures.readNestedMapping(5, 10), 50);
  }

  function testReadAddressAndArrayMapping() external {
    assertEq(
      _dataStructures.readArrayInAddressMappingLocation(address(0xaa)),
      0x3e87fed9cda08916963d72e57b2df7d16ecabb7fb7fd2260730e0e3fdf688f9a
    );
    assertEq(_dataStructures.readArrayInAddressMapping(address(0xaa), 0), 5);
    assertEq(_dataStructures.readArrayInAddressMapping(address(0xaa), 1), 10);
    assertEq(_dataStructures.readArrayInAddressMapping(address(0xaa), 2), 50);
  }
}
