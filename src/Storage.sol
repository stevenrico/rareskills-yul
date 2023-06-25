// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;

contract Storage {
  uint256 private _numOne = 5;
  uint256 private _numTwo = 50;

  function writeToNumOne(uint256 value) external {
    assembly {
      sstore(_numOne.slot, value)
    }
  }

  function writeToNumTwo(uint256 value) external {
    assembly {
      sstore(_numTwo.slot, value)
    }
  }

  function readNumBySlot(uint256 slot) external view returns (uint256 data) {
    assembly {
      data := sload(slot)
    }
  }

  uint128 private _packOne = 10;
  uint64 private _packTwo = 5;
  uint64 private _packThree = 5;

  function readPackOneOffset() external pure returns (uint128 offset) {
    assembly {
      offset := _packOne.offset
    }
  }

  function readPackTwoOffset() external pure returns (uint64 offset) {
    assembly {
      offset := _packTwo.offset
    }
  }

  function readPackThreeOffset() external pure returns (uint64 offset) {
    assembly {
      offset := _packThree.offset
    }
  }

  /**
   * V and 00 = 00
   * V and FF = V
   * V or  00 = V
   */

  /**
   * [STEP]             [TYPE]    [VALUE]
   * Get slot          uint256         2
   * Load 'value'          hex    0x000000000000000500000000000000050000000000000000000000000000000a
   *
   * Create 'cleanValue'
   * mask                  hex    0xffffffffffffffffffffffffffffffff00000000000000000000000000000000
   * Load 'value'          hex    0x000000000000000500000000000000050000000000000000000000000000000a
   * bitwise 'and'         hex    0x0000000000000005000000000000000500000000000000000000000000000000
   *
   * Get offset          bytes         0
   * offset * 8           bits         0
   * Load 'newValue'   uint256         5
   * shift left            hex    0x0000000000000000000000000000000000000000000000000000000000000005
   *
   * Load 'cleanValue'     hex    0x0000000000000005000000000000000500000000000000000000000000000000
   * withShift             hex    0x0000000000000000000000000000000000000000000000000000000000000005
   * bitwise 'or'          hex    0x0000000000000005000000000000000500000000000000000000000000000005
   */
  function writeToPackOne(uint128 newValue) external {
    assembly {
      let value := sload(_packOne.slot)
      let cleanValue :=
        and(
          0xffffffffffffffffffffffffffffffff00000000000000000000000000000000,
          value
        )

      let withShift := shl(mul(_packOne.offset, 8), newValue)

      value := or(cleanValue, withShift)

      sstore(_packOne.slot, value)
    }
  }

  /**
   * [STEP]             [TYPE]    [VALUE]
   * Get slot          uint256         2
   * Load 'value'          hex    0x000000000000000500000000000000050000000000000000000000000000000a
   *
   * Create 'cleanValue'
   * mask                  hex    0xffffffffffffffff0000000000000000ffffffffffffffffffffffffffffffff
   * Load 'value'          hex    0x000000000000000500000000000000050000000000000000000000000000000a
   * bitwise 'and'         hex    0x000000000000000500000000000000000000000000000000000000000000000a
   *
   * Get offset          bytes        16
   * offset * 8           bits       128
   * Load 'newValue'   uint256        10
   * shift left            hex    0x000000000000000000000000000000000000000000000000000000000000000a
   * -                     hex    0x0000000000000000000000000000000a
   * -                     hex    0x0000000000000000000000000000000a00000000000000000000000000000000
   *
   * Load 'cleanValue'     hex    0x000000000000000500000000000000000000000000000000000000000000000a
   * withShift             hex    0x0000000000000000000000000000000a00000000000000000000000000000000
   * bitwise 'or'          hex    0x0000000000000005000000000000000a0000000000000000000000000000000a
   */
  function writeToPackTwo(uint64 newValue) external {
    assembly {
      let value := sload(_packTwo.slot)
      let cleanValue :=
        and(
          0xffffffffffffffff0000000000000000ffffffffffffffffffffffffffffffff,
          value
        )

      let withShift := shl(mul(_packTwo.offset, 8), newValue)

      value := or(cleanValue, withShift)

      sstore(_packTwo.slot, value)
    }
  }

  /**
   * [STEP]             [TYPE]    [VALUE]
   * Get slot          uint256         2
   * Load 'value'          hex    0x000000000000000500000000000000050000000000000000000000000000000a
   *
   * Create 'cleanValue'
   * mask                  hex    0x0000000000000000ffffffffffffffffffffffffffffffffffffffffffffffff
   * Load 'value'          hex    0x000000000000000500000000000000050000000000000000000000000000000a
   * bitwise 'and'         hex    0x000000000000000000000000000000050000000000000000000000000000000a
   *
   * Get offset          bytes        24
   * offset * 8           bits       192
   * Load 'newValue'   uint256        10
   * shift left            hex    0x000000000000000000000000000000000000000000000000000000000000000a
   * -                     hex    0x000000000000000a
   * -                     hex    0x000000000000000a000000000000000000000000000000000000000000000000
   *
   * Load 'cleanValue'     hex    0x000000000000000000000000000000050000000000000000000000000000000a
   * withShift             hex    0x000000000000000a000000000000000000000000000000000000000000000000
   * bitwise 'or'          hex    0x000000000000000a00000000000000050000000000000000000000000000000a
   */
  function writeToPackThree(uint64 newValue) external {
    assembly {
      let value := sload(_packThree.slot)
      let cleanValue :=
        and(
          0x0000000000000000ffffffffffffffffffffffffffffffffffffffffffffffff,
          value
        )

      let withShift := shl(mul(_packThree.offset, 8), newValue)

      value := or(cleanValue, withShift)

      sstore(_packThree.slot, value)
    }
  }

  /**
   * [STEP]             [TYPE]    [VALUE]
   * Get slot          uint256         2
   * Load 'value'          hex    0x000000000000000500000000000000050000000000000000000000000000000a
   *
   * Get offset          bytes         0
   * offset * 8           bits         0
   * shift right           hex    0x000000000000000500000000000000050000000000000000000000000000000a
   *
   * Create data
   * mask                  hex    0x00000000000000000000000000000000ffffffffffffffffffffffffffffffff
   * withShift             hex    0x000000000000000500000000000000050000000000000000000000000000000a
   * bitwise 'and'         hex    0x000000000000000000000000000000000000000000000000000000000000000a
   */
  function readPackOne()
    external
    view
    returns (bytes32 dataAsBytes, uint256 dataAsUint)
  {
    assembly {
      let value := sload(_packOne.slot)
      let withShift := shr(mul(_packOne.offset, 8), value)

      let data := and(0xffffffffffffffffffffffffffffffff, withShift)

      dataAsBytes := data
      dataAsUint := data
    }
  }

  /**
   * [STEP]             [TYPE]    [VALUE]
   * Get slot          uint256         2
   * Load 'value'          hex    0x000000000000000500000000000000050000000000000000000000000000000a
   *
   * Get offset          bytes        16
   * offset * 8           bits       128
   * shift right           hex    0x000000000000000500000000000000050000000000000000000000000000000a
   * -                     hex    0x00000000000000050000000000000005
   * -                     hex    0x0000000000000000000000000000000000000000000000050000000000000005
   *
   * Create data
   * mask                  hex    0x000000000000000000000000000000000000000000000000ffffffffffffffff
   * withShift             hex    0x0000000000000000000000000000000000000000000000050000000000000005
   * bitwise 'and'         hex    0x0000000000000000000000000000000000000000000000000000000000000005
   */
  function readPackTwo()
    external
    view
    returns (bytes32 dataAsBytes, uint256 dataAsUint)
  {
    assembly {
      let value := sload(_packTwo.slot)
      let withShift := shr(mul(_packTwo.offset, 8), value)

      let data := and(0xffffffffffffffff, withShift)

      dataAsBytes := data
      dataAsUint := data
    }
  }

  /**
   * [STEP]             [TYPE]    [VALUE]
   * Get slot          uint256         2
   * Load 'value'          hex    0x000000000000000500000000000000050000000000000000000000000000000a
   *
   * Get offset          bytes        24
   * offset * 8           bits       192
   * shift right           hex    0x000000000000000500000000000000050000000000000000000000000000000a
   * -                     hex    0x0000000000000005
   * -                     hex    0x0000000000000000000000000000000000000000000000000000000000000005
   *
   * Create data
   * mask                  hex    0x000000000000000000000000000000000000000000000000ffffffffffffffff
   * withShift             hex    0x0000000000000000000000000000000000000000000000000000000000000005
   * bitwise 'and'         hex    0x0000000000000000000000000000000000000000000000000000000000000005
   */
  function readPackThree()
    external
    view
    returns (bytes32 dataAsBytes, uint256 dataAsUint)
  {
    assembly {
      let value := sload(_packThree.slot)
      let withShift := shr(mul(_packThree.offset, 8), value)

      let data := and(0xffffffffffffffff, withShift)

      dataAsBytes := data
      dataAsUint := data
    }
  }
}
