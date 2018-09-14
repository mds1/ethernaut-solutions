pragma solidity ^0.4.18;

/**
We can force Ether to be sent to an account by using the selfdestruct operation.
The selfdestruct operation takes one address as an input, and sends all
remaining Ether in the contract to this address. Therefore, we can force Ether
to an address as follows:

  1. Create a contract and send any amount of Ether to it upon deployment
  2. Call selfdestruct(address) to desroy the contract and immediately send its
     Ether to that address.

This can be done in one step as shown below
*/

contract ForceSend {

  constructor() public payable {
    // Call selfdestruct immediately after deployment
    selfdestruct(0xb933ff883ba79f8cc1b8102adaaa3709b54e13e7);
  }

}