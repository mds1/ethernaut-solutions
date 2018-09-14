The first thing we notice is that the `password` variable is private. According to the Solidity documentation, "making something private only prevents other contracts from accessing and modifying the information, but it will still be visible to the whole world outside of the blockchain." This means we should somehow be able to view the password to unlock the account, but because the variable is private there will not be an automatically generated getter function.

Instead, we can look directly at the storage location using `web3.eth.getStorageAt()`. This function takes an address as the first argument, the storage location index as the second argument, and an optional callback.

From the [Solidity documentation](https://solidity.readthedocs.io/en/develop/miscellaneous.html#layout-of-state-variables-in-storage), we see that statically-sized variables are simply laid contiguously beginning from index 0. This means the first variable defined, `locked`, is in storage slot 0. The second variable, `password`, is 32 bytes. This means it cannot be packed into the same storage slot as `locked` (since storage slots are 32 bytes), and instead it will be in the next slot, which is slot 1.

Therefore, we can determine the password using the following code snippet in the console:

```javascript
web3.eth.getStorageAt("0x07159e277e4c5e307c0b3c99cc1236470147aa95", 1, function(err, result) {
  password = result
});
```

This will create a variable for us called `password` that stores the password! Entering `password` in the console reveals the value of our password:

```javascript
"0x412076657279207374726f6e67207365637265742070617373776f7264203a29"
```

Notice that this is a hex string, so we can convert it to ASCII using `web3.toAscii()` method. This will reveal the actual password, which we can then pass in to the `unlock` function to unlock the contract.
