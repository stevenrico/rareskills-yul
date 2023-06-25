// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;

import { Test } from "forge-std/Test.sol";
import { Storage } from "../src/Storage.sol";

contract StorageTest is Test {
  Storage private _storage;

  function setUp() public {
    _storage = new Storage();
  }

  function testWriteToNumOne() external {
    vm.expectCall(
      address(_storage), abi.encodeCall(_storage.writeToNumOne, (10))
    );
    _storage.writeToNumOne(10);

    assertEq(_storage.readNumBySlot(0), 10);
  }

  function testWriteToNumTwo() external {
    vm.expectCall(
      address(_storage), abi.encodeCall(_storage.writeToNumTwo, (100))
    );
    _storage.writeToNumTwo(100);

    assertEq(_storage.readNumBySlot(1), 100);
  }

  function testReadNumBySlot() external {
    assertEq(_storage.readNumBySlot(0), 5);
    assertEq(_storage.readNumBySlot(1), 50);
  }

  function testReadPackOneOffset() external {
    assertEq(_storage.readPackOneOffset(), 0);
  }

  function testReadPackTwoOffset() external {
    assertEq(_storage.readPackTwoOffset(), 16);
  }

  function testReadPackThreeOffset() external {
    assertEq(_storage.readPackThreeOffset(), 24);
  }

  function testWriteToPackOne() external {
    vm.expectCall(
      address(_storage), abi.encodeCall(_storage.writeToPackOne, (5))
    );
    _storage.writeToPackOne(5);

    (bytes32 asBytes, uint256 asUint) = _storage.readPackOne();

    assertEq(
      asBytes,
      0x0000000000000000000000000000000000000000000000000000000000000005
    );
    assertEq(asUint, 5);
  }

  function testWriteToPackTwo() external {
    vm.expectCall(
      address(_storage), abi.encodeCall(_storage.writeToPackTwo, (10))
    );
    _storage.writeToPackTwo(10);

    (bytes32 asBytes, uint256 asUint) = _storage.readPackTwo();

    assertEq(
      asBytes,
      0x000000000000000000000000000000000000000000000000000000000000000a
    );
    assertEq(asUint, 10);
  }

  function testWriteToPackThree() external {
    vm.expectCall(
      address(_storage), abi.encodeCall(_storage.writeToPackThree, (10))
    );
    _storage.writeToPackThree(10);

    (bytes32 asBytes, uint256 asUint) = _storage.readPackThree();

    assertEq(
      asBytes,
      0x000000000000000000000000000000000000000000000000000000000000000a
    );
    assertEq(asUint, 10);
  }

  function testReadPackOne() external {
    (bytes32 asBytes, uint256 asUint) = _storage.readPackOne();

    assertEq(
      asBytes,
      0x000000000000000000000000000000000000000000000000000000000000000a
    );
    assertEq(asUint, 10);
  }

  function testReadPackTwo() external {
    (bytes32 asBytes, uint256 asUint) = _storage.readPackTwo();

    assertEq(
      asBytes,
      0x0000000000000000000000000000000000000000000000000000000000000005
    );
    assertEq(asUint, 5);
  }

  function testReadPackThree() external {
    (bytes32 asBytes, uint256 asUint) = _storage.readPackThree();

    assertEq(
      asBytes,
      0x0000000000000000000000000000000000000000000000000000000000000005
    );
    assertEq(asUint, 5);
  }
}
