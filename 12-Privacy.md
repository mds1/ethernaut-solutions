The goal here is to unlock the contract, by figuring out the key stored in the `data` state variable. This variable consists of three elements, with each element being 32 bytes. From the `unlock` function, we can see that the key is equal to the first 16 bytes of the third element.

Because the `data` variable is private, the only way to view it is to figure out where it lives in storage, then use `web3.eth.getStorageAt()` to find its value. Based on what we know about how [Solidity stores state variables](https://solidity.readthedocs.io/en/v0.4.25/miscellaneous.html), we can figure out what slot the `data` variable lives in:
* The first variable declared is a `bool`, which takes up 1 byte and lives in slot 0
* The next variable is a `uint256`, which takes up 32 bytes. However, this variable is also declared `constant`, and [constants are not kept in storage](https://solidity.readthedocs.io/en/latest/contracts.html#constant-state-variables). Instead, they are re-evaluated each time they are used. Therefore, this variable will not take up a storage slot
* The next three variables are a `uint8`, another `uint8`, and a `uint16`. This totals to 32 bits, or 1 byte, and therefore can fit in slot 0. Variables in slot 0 are currently using 2 of the 32 available bytes
* The final state variable is the three element `bytes32` data array we're interested in. Arrays always start in new slots, and here each element in the array takes up a full 32 byte slot. Therefore, the three elements live in slots 1, 2, and 3 respectively.

First, let's confirm this analysis by looking at the variables in slot 0. In the console we use the following expression to view what's in slot 0:

```javascript
web3.eth.getStorageAt("0x4ba058c951b5b653b514dcf6d7cd9b50bf99bc0c", 0, function(err, result) {
  slot0 = result
});
```

This returns the following value for slot 0:
`0x0000000000000000000000000000000000000000000000000000007fb6ff0a01`

And this value is simply `7fb6ff0a01` padded to 32 bytes. So, let's inspect this value.

The last 2 digits are `01`, which corresponds to the boolean variable `locked`. The preceding two digits should correspond to the 8 bit `flattening` variable. Entering `web3.toDecimal("0x0a")` returns `10`, which confirms this. Next on the list is `denomination`, and sure enough converting `0xff` to decimal returns `255`. The remaining 4 digits correspond to `now` casted to 16 bits.

Now that we've made sense of that, let's take a look at `data[2]` and find the key. This corresponds to the final element in the data array, which we know is slot 3. Querying the slot using `getStorageAt()` returns our 32 byte value. The `unlock()` function only wants a 16 byte variable, so we simply pass it the first 16 bytes of this value. If we have a value of

`0x258c07ea68321278c3e34b807d26af74fc7622025a15723803f3e5a5c5a5956d`

then the first 16 bytes can be found using `value.slice(0, 16*2+2)`, returning

`0x258c07ea68321278c3e34b807d26af74`

Sure enough, passing this into the `unlock()` function unlocks the contract!