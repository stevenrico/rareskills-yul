// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;

import { Test } from "forge-std/Test.sol";
import { Logs } from "../src/Logs.sol";

contract LogsTest is Test, Logs {
  Logs private _logs;

  function setUp() public {
    _logs = new Logs();
  }

  function testEmitLog() external {
    bytes32 expectedSig = keccak256("LogWithData(bytes32,uint256)");

    vm.expectEmit(true, false, false, true);
    emit LogWithData(expectedSig, 5);

    _logs.emitLog();
  }
}
