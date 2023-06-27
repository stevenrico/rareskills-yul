// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;

contract Logs {
  event LogWithData(bytes32 indexed sig, uint256 data);

  function emitLog() external {
    assembly {
      let sig := 0xc2309f1893e25c3dd11bd95ce0ead384cc3f8f55057b61e00cdd6e729d8999a7

      mstore(0, 0x05)

      log2(0, 0x20, sig, sig)
    }
  }
}