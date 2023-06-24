// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;

contract DataTypes {
  function getNumber() external pure returns (uint256) {
    uint256 x;

    assembly {
      x := 10
    }

    return x;
  }

  function getHex() external pure returns (uint256) {
    uint256 x;

    assembly {
      x := 0xa
    }

    return x;
  }

  function getString() external pure returns (string memory) {
    bytes32 str = "";

    assembly {
      str := "Lorem ipsum dolor sit amet eget."
    }

    return string(abi.encode(str));
  }

  function getBoolean() external pure returns (bool) {
    bool isTrue;

    assembly {
      isTrue := 1
    }

    return isTrue;
  }

  function getAddress() external pure returns (address) {
    address owner;

    assembly {
      owner := 1
    }

    return owner;
  }
}
