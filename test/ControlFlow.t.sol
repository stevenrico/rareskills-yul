// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;

import { Test } from "forge-std/Test.sol";
import { ControlFlow } from "../src/ControlFlow.sol";

contract ControlFlowTest is Test {
  ControlFlow private _controlFlow;

  function setUp() public {
    _controlFlow = new ControlFlow();
  }

  function testSumTo() external {
    assertEq(_controlFlow.sumTo(10), 55);
    assertEq(_controlFlow.sumTo(100), 5050);
    assertEq(_controlFlow.sumTo(1000), 500_500);
  }

  function testIsPrime() external {
    assertEq(_controlFlow.isPrime(4), false);
    assertEq(_controlFlow.isPrime(7), true);
    assertEq(_controlFlow.isPrime(50), false);
    assertEq(_controlFlow.isPrime(97), true);
  }

  function testIsTruthy() external {
    assertEq(_controlFlow.isTruthy(0), false);
    assertEq(_controlFlow.isTruthy(1), true);
  }

  function testIsFalsy() external {
    assertEq(_controlFlow.isFalsy(0), true);
    assertEq(_controlFlow.isFalsy(1), false);
  }

  function testIsFalsyWithNegation() external {
    assertEq(_controlFlow.isFalsyWithNegation(0), true);
    assertEq(_controlFlow.isFalsyWithNegation(1), false);
  }

  function testIsFalsyWithUnsafeNegation() external {
    assertEq(_controlFlow.isFalsyWithUnsafeNegation(0), true);
    assertEq(_controlFlow.isFalsyWithUnsafeNegation(1), true);
  }

  function testBitFlip() external {
    bytes32 flipTwo =
      0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffd;
    bytes32 flipTen =
      0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff5;

    assertEq(_controlFlow.bitFlip(2), flipTwo);
    assertEq(_controlFlow.bitFlip(10), flipTen);
  }

  function testMin() external {
    assertEq(_controlFlow.min(0, 5), 0);
    assertEq(_controlFlow.min(50, 5000), 50);
  }

  function testMax() external {
    assertEq(_controlFlow.max(0, 5), 5);
    assertEq(_controlFlow.max(50, 5000), 5000);
  }
}
