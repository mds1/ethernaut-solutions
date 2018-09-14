We can see that the contract's [fallback function](https://solidity.readthedocs.io/en/v0.4.25/contracts.html#fallback-function) will make us the owner if we send Ether to it and have previously contributed to this contract. Once we become owner, we can call the `withdraw()` function to reduce the balance of the contract to 0.

So, first we need to contribute to the campaign. This is pretty straightforward, and can be done by simply calling the `contribute()` function and sending along some Ether, like so:

```javascript
contract.contribute({value: '1'}) // send 1 Wei
```

Now we need to call the fallback function. We have already contributed, so if we now send Ether to this function we will pass the `require()` statement and become the owner. From the Solidity documentation linked above, we know that when a fallback function is payable (which this one is) we can activate it by sending Ether directly to the contract. We can do this with:

```javascript
contract.sendTransaction({value: 1}) // send another Wei
```

We are now the owner! At this point, we simply need to call the `withdraw` function to drain all Ether from this contract.