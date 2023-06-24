// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;

contract ControlFlow {
  function sumTo(uint256 num) external pure returns (uint256 total) {
    assembly {
      for { let i := 0 } lt(i, add(num, 1)) { i := add(i, 1) } {
        total := add(total, i)
      }
    }
  }

  function isPrime(uint256 num) external pure returns (bool result) {
    result = true;

    assembly {
      let halfNum := add(div(num, 2), 1)

      for { let i := 2 } lt(i, halfNum) { i := add(i, 1) } {
        if iszero(mod(num, i)) {
          result := 0
          break
        }
      }
    }
  }

  function isTruthy(uint256 num) external pure returns (bool result) {
    assembly {
      if num { result := 1 }
    }
  }

  function isFalsy(uint256 num) external pure returns (bool result) {
    result = true;

    assembly {
      if num { result := 0 }
    }
  }

  function isFalsyWithNegation(uint256 num) external pure returns (bool result) {
    assembly {
      if iszero(num) { result := 1 }
    }
  }

  /**
   * [WARNING]
   * It does not work with truthy values and is not recommended,
   * use 'iszero()' instead
   */
  function isFalsyWithUnsafeNegation(uint256 num)
    external
    pure
    returns (bool result)
  {
    assembly {
      if not(num) { result := 1 }
    }
  }

  function bitFlip(uint256 num) external pure returns (bytes32 result) {
    assembly {
      result := not(num)
    }
  }

  function min(uint256 numOne, uint256 numTwo)
    external
    pure
    returns (uint256 result)
  {
    assembly {
      if lt(numOne, numTwo) { result := numOne }

      if lt(numTwo, numOne) { result := numTwo }
    }
  }

  function max(uint256 numOne, uint256 numTwo)
    external
    pure
    returns (uint256 result)
  {
    assembly {
      if gt(numOne, numTwo) { result := numOne }

      if gt(numTwo, numOne) { result := numTwo }
    }
  }
}
