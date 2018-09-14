Delegate calls execute in the context of the calling contract. This means that `msg.sender` and `msg.value` do _not_ change, and storage and balance stil refer to the calling contract. Only code is taken from the called contract.

Notice that the fallback function of the `Delegation` contract uses a delegate call to the `Delegate` contract. This call also passes along any data provided. Also notice that the `Delegate` contract contains a function called `pwn()` that changes the owner. If we can call this function, but in the context of the `Delegation` contract, we can become the owner.

So, to become owner of the `Delegation` contract, we must sent the method ID of `pwn()` to its fallback function. The method ID is defined as the first four bytes of the Keccak-256 hash of the signature of the function. We can make a quick Solidity contract with the expression below to obtain the method ID:

```javascript
bytes4 public id = bytes4(keccak256("pwn()"));
```

Alternatively, we can use Web3/JavaScript to find the ID using:
```javascript
id = web3.sha3("pwn()").slice(0,10)
```

We see these give us a method ID of `0xdd365b8b`. From the console, we can now take ownership of the contract using:
```javascript
await contract.sendTransaction({data:"0xdd365b8b"})
```
