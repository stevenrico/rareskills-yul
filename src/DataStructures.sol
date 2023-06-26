// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;

contract DataStructures {
  uint256[3] private _fixedArray;
  uint256[] private _dynamicArray;
  uint8[] private _packedArray;

  constructor() {
    _fixedArray = [5, 50, 500];
    _dynamicArray = [10, 20, 30, 40, 50, 60, 70, 80, 90, 100];
    _packedArray = [10, 20, 30, 40, 50, 60, 70, 80, 90, 100];
  }

  function readFixedArray(uint256 index) external view returns (uint256 data) {
    assembly {
      data := sload(add(_fixedArray.slot, index))
    }
  }

  function readDynamicArrayLength() external view returns (uint256 length) {
    assembly {
      length := sload(_dynamicArray.slot)
    }
  }

  function _readUint256ArrayLocation(uint256[] storage array)
    private
    pure
    returns (bytes32 location)
  {
    uint256 slot;

    assembly {
      slot := array.slot
    }

    location = keccak256(abi.encode(slot));
  }

  function readDynamicArray(uint256 index)
    external
    view
    returns (uint256 data, bytes32 location)
  {
    location = _readUint256ArrayLocation(_dynamicArray);

    assembly {
      data := sload(add(location, index))
    }
  }

  function _readUint8ArrayLocation(uint8[] storage array)
    private
    pure
    returns (bytes32 location)
  {
    uint256 slot;

    assembly {
      slot := array.slot
    }

    location = keccak256(abi.encode(slot));
  }

  /**
   * [INPUTS]           [VALUE]
   * index                   4
   *
   *
   * [STEP]              [TYPE]   [VALUE]
   * Get location          hex    0x8a35acfbc15ff81a39ae7d344fd709f28e8600b4aa8c65c6b64bfe7fe36bd19b
   * Load 'value'          hex    0x00000000000000000000000000000000000000000000645a50463c32281e140a
   *
   * Get 'index'         bytes         4
   * offset * 8           bits        32
   * shift right           hex    0x00000000000000000000000000000000000000000000645a50463c32281e140a
   * -                     hex    0x00000000000000000000000000000000000000000000645a50463c32
   * -                     hex    0x0000000000000000000000000000000000000000000000000000645a50463c32
   *
   * Create data
   * mask                  hex    0x00000000000000000000000000000000000000000000000000000000000000ff
   * withShift             hex    0x0000000000000000000000000000000000000000000000000000645a50463c32
   * bitwise 'and'         hex    0x0000000000000000000000000000000000000000000000000000000000000032
   */
  function readPackedArray(uint256 index)
    external
    view
    returns (uint256 data, bytes32 location)
  {
    location = _readUint8ArrayLocation(_packedArray);

    assembly {
      let value := sload(location)
      let withShift := shr(mul(index, 8), value)

      data := and(0xff, withShift)
    }
  }
}
