// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;

import { Script } from "forge-std/Script.sol";
import { DataTypes } from "../src/DataTypes.sol";
import { ControlFlow } from "../src/ControlFlow.sol";
import { Storage } from "../src/Storage.sol";
import { DataStructures } from "../src/DataStructures.sol";
import { Memory } from "../src/Memory.sol";

contract DeployScript is Script {
  uint256 private _deployer;

  constructor() {
    _deployer = vm.envUint("DEPLOYER_PRIVATE_KEY");
  }

  modifier broadcaster() {
    vm.startBroadcast(_deployer);
    _;
    vm.stopBroadcast();
  }

  function run() external broadcaster {
    new DataTypes();
    new ControlFlow();
    new Storage();
    new DataStructures();
    new Memory();
  }
}
