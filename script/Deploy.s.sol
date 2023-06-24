// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;

import { Script } from "forge-std/Script.sol";
import { Counter } from "../src/Counter.sol";

contract DeployScript is Script {
  address private _deployer;

  constructor() {
    _deployer = vm.envAddress("DEPLOYER_PRIVATE_KEY");
  }

  modifier broadcaster() {
    vm.startBroadcast(_deployer);
    _;
    vm.stopBroadcast();
  }

  function run() external broadcaster {
    new Counter();
  }
}
