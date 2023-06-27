// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;

contract Memory {
  /**
   * [SLOT]              [BYTES]   [DESCRIPTION]
   * 0x000 => 0x020      32 (32)    - scratch space
   * 0x020 => 0x040      64 (32)    - scratch space
   * 0x040 => 0x060      96 (32)    - free memory pointer
   * 0x060 => 0x080     128 (32)    - empty
   * 0x080 => ...           (..)    - arrays, mappings & structs
   */

  struct Point {
    uint256 x;
    uint256 y;
  }

  event MemoryPointer(bytes32 indexed memPointer);

  /**
   * [SLOT]                [BYTES]    [DESCRIPTION]
   * 0x000 - 0x080       128 (128)    - see above
   *
   * 0x080 - 0x0c0        192 (64)    - Point({ x: 5, y: 10 });
   * + 0x080 => 0x005
   * + 0x0a0 => 0x00a
   * 0x0c0 - 0x100        256 (64)    - [15, 20];
   * + 0x0c0 => 0x00f
   * + 0x0e0 => 0x014
   */
  function memStructsAndFixedArrays() external {
    bytes32 x40;

    assembly {
      x40 := mload(0x40)
    }

    emit MemoryPointer(x40);

    Point memory point = Point({ x: 5, y: 10 });

    assembly {
      x40 := mload(0x40)
    }

    emit MemoryPointer(x40);

    uint256[2] memory array = [uint256(15), 20];

    assembly {
      x40 := mload(0x40)
    }

    emit MemoryPointer(x40);
  }

  /**
   * [SLOT]                [BYTES]    [DESCRIPTION]
   * 0x000 - 0x080       128 (128)    - see above
   *
   * 0x080 - 0x0e0        224 (96)    - abi.encode(5, 10);
   * + 0x080 => 0x040
   * + 0x0a0 => 0x005
   * + 0x0c0 => 0x00a
   * 0x0e0 - 0x130        304 (80)    - abi.encodePacked(15, 20);
   * + 0x0e0 => 0x030
   * + 0x110 => 0x00f
   * + 0x130 => 0x014
   */
  function memAbiEncode() external {
    bytes32 x40;

    assembly {
      x40 := mload(0x40)
    }

    emit MemoryPointer(x40);

    bytes memory data = abi.encode(uint256(5), uint256(10));

    assembly {
      x40 := mload(0x40)
    }

    emit MemoryPointer(x40);

    bytes memory dataPacked = abi.encodePacked(uint256(15), uint128(20));

    assembly {
      x40 := mload(0x40)
    }

    emit MemoryPointer(x40);
  }

  event ReadArray(bytes32 indexed location, bytes32, bytes32, bytes32);

  /**
   * [SLOT]                [BYTES]    [DESCRIPTION]
   * 0x000 - 0x080       128 (128)    - see above
   *
   * 0x080 - 0x0e0        224 (96)    - [5, 10];
   * + 0x080 => 0x002
   * + 0x0a0 => 0x005
   * + 0x0c0 => 0x00a
   */
  function memDynamicArray(uint256[] memory array) external {
    bytes32 location;
    bytes32 length;
    bytes32 valueAtIndex0;
    bytes32 valueAtIndex1;

    assembly {
      location := array
      length := mload(location)
      valueAtIndex0 := mload(add(location, 0x20))
      valueAtIndex1 := mload(add(location, 0x40))
    }

    emit ReadArray(location, length, valueAtIndex0, valueAtIndex1);
  }

  event MemoryPointerWithData(bytes32 indexed memPointer, uint256 data);

  /**
   * [SLOT]                [BYTES]    [DESCRIPTION]
   * 0x000 - 0x080       128 (128)    - see above
   *
   * 0x080 - 0x0c0        192 (64)    - originalArray
   * + 0x080 => 0x005
   * + 0x0a0 => 0x00a
   *
   * [MEMORY POINTER SET TO 0x080]
   *
   * 0x080 - 0x0c0        192 (64)    - overwriteArray
   * + 0x080 => 0x00f
   * + 0x0a0 => 0x014
   */
  function memOverwrite(uint256[2] memory originalArray) external {
    bytes32 x40;

    assembly {
      x40 := mload(0x40)
    }

    emit MemoryPointerWithData(x40, originalArray[0]);

    assembly {
      mstore(0x40, 0x80)
      x40 := mload(0x40)
    }

    uint256[2] memory overwriteArray = [uint256(15), 20];

    emit MemoryPointerWithData(x40, originalArray[0]);
  }

  /**
   * [SLOT]                [BYTES]    [DESCRIPTION]
   * 0x000 - 0x080       128 (128)    - see above
   *
   * 0x080 - 0x120       256 (128)    - unpackedArray
   * + 0x080 => 0x004
   * + 0x0a0 => 0x005
   * + 0x0c0 => 0x00a
   * + 0x0e0 => 0x00f
   * + 0x100 => 0x014
   */
  function memUnpacked(uint64[] memory unpackedArray) external {
    bytes32 x40;
    bytes32 x80;
    bytes32 xa0;
    bytes32 xc0;
    bytes32 xe0;
    bytes32 x100;

    assembly {
      x40 := mload(0x40)
      x80 := mload(0x80)
      xa0 := mload(0xa0)
      xc0 := mload(0xc0)
      xe0 := mload(0xe0)
      x100 := mload(0x100)
    }

    emit MemoryPointer(x40);
    emit MemoryPointerWithData(bytes32(uint256(0x80)), uint256(x80));
    emit MemoryPointerWithData(bytes32(uint256(0x80)), uint256(x80));
    emit MemoryPointerWithData(bytes32(uint256(0xa0)), uint256(xa0));
    emit MemoryPointerWithData(bytes32(uint256(0xc0)), uint256(xc0));
    emit MemoryPointerWithData(bytes32(uint256(0xe0)), uint256(xe0));
    emit MemoryPointerWithData(bytes32(uint256(0x100)), uint256(x100));
  }

  /**
   * [SLOT]                [BYTES]    [DESCRIPTION]
   * 0x000 - 0x080       128 (128)    - see above
   *
   * 0x080 - 0x100       256 (128)    - unpackedArray
   * + 0x080 => 0x005
   * + 0x0a0 => 0x00a
   * + 0x0c0 => 0x00f
   * + 0x0e0 => 0x014
   *
   * 0x000 - 0x020       256 (128)    - keccak256(0x80, 0x80)
   * + 0x000 => 0x8e3e...294c
   */
  function memHash() external pure returns (bytes32) {
    assembly {
      let memPointer := mload(0x40)

      mstore(memPointer, 5)
      mstore(add(memPointer, 0x20), 10)
      mstore(add(memPointer, 0x40), 15)
      mstore(add(memPointer, 0x60), 20)

      mstore(0x40, add(memPointer, 0x80))

      mstore(0x00, keccak256(memPointer, 0x80))

      return(0x00, 0x20)
    }
  }
}
