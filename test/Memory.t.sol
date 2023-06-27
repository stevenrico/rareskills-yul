// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;

import { Test } from "forge-std/Test.sol";
import { Memory } from "../src/Memory.sol";

contract MemoryTest is Test, Memory {
  Memory private _memory;

  uint256[] private _dynamicArray;
  uint64[] private _packedArray;

  function setUp() public {
    _memory = new Memory();
  }

  function testMemStructsAndFixedArrays() external {
    vm.expectEmit(true, false, false, false);
    emit MemoryPointer(bytes32(uint256(0x80)));

    vm.expectEmit(true, false, false, false);
    emit MemoryPointer(bytes32(uint256(0xc0)));

    vm.expectEmit(true, false, false, false);
    emit MemoryPointer(bytes32(uint256(0x100)));

    _memory.memStructsAndFixedArrays();
  }

  function testMemAbiEncode() external {
    vm.expectEmit(true, false, false, false);
    emit MemoryPointer(bytes32(uint256(0x80)));

    vm.expectEmit(true, false, false, false);
    emit MemoryPointer(bytes32(uint256(0xe0)));

    vm.expectEmit(true, false, false, false);
    emit MemoryPointer(bytes32(uint256(0x130)));

    _memory.memAbiEncode();
  }

  function testMemDynamicArray() external {
    bytes32 location = bytes32(uint256(0x80));
    bytes32 length = bytes32(uint256(0x02));

    _dynamicArray = [5, 10];

    vm.expectEmit(true, false, false, true);
    emit ReadArray(
      location, length, bytes32(_dynamicArray[0]), bytes32(_dynamicArray[1])
    );

    _memory.memDynamicArray(_dynamicArray);
  }

  function testMemOverwrite() external {
    uint256[2] memory array = [uint256(5), 10];

    vm.expectEmit(true, false, false, true);
    emit MemoryPointerWithData(bytes32(uint256(0xc0)), array[0]);

    vm.expectEmit(true, false, false, true);
    emit MemoryPointerWithData(bytes32(uint256(0x80)), 15);

    _memory.memOverwrite(array);
  }

  function testMemUnpacked() external {
    _packedArray = [5, 10, 15, 25];

    vm.expectEmit(true, false, false, false);
    emit MemoryPointer(bytes32(uint256(0x120)));

    vm.expectEmit(true, false, false, true);
    emit MemoryPointerWithData(bytes32(uint256(0x80)), _packedArray.length);

    vm.expectEmit(true, false, false, true);
    emit MemoryPointerWithData(bytes32(uint256(0xa0)), _packedArray[0]);

    vm.expectEmit(true, false, false, true);
    emit MemoryPointerWithData(bytes32(uint256(0xc0)), _packedArray[1]);

    vm.expectEmit(true, false, false, true);
    emit MemoryPointerWithData(bytes32(uint256(0xe0)), _packedArray[2]);

    vm.expectEmit(true, false, false, true);
    emit MemoryPointerWithData(bytes32(uint256(0x100)), _packedArray[3]);

    _memory.memUnpacked(_packedArray);
  }

  function testMemHash() external {
    bytes32 expectedHash = keccak256(abi.encode(5, 10, 15, 20));

    assertEq(_memory.memHash(), expectedHash);
  }
}
