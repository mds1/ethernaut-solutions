Our goal here is to become King and prevent the instance from reclaiming ownership afterwards. This is a simple contract, and all we really have to work with is the fallback function. By sending Ether to this fallback function we can become King. If we can then ensure the fallback function fails every time afterwards, then `king = msg.sender` will never be executed, and we can remain King.

These means we must do two things:
1. Call the King contract's fallback function to become King
2. Prevent subsequent calls of the King's fallback function from succeeding.

Let's write a contract to do both of these things.

We'll start with number 1, and write a function to become King. The first thought is to simply transfer Ether to the King contract to activate the fallback function. However, this won't work. The [fallback function](https://solidity.readthedocs.io/en/v0.4.25/contracts.html#fallback-function) section of the Solidity documentation tells us that in the worst case, fallback functions only have 2300 gas available, and this occurs when `send` or `transfer` is used. It also says that writing to storage will use up more than 2300 gas. Since the King contract's fallback function writes to storage, activating it with `transfer` or `send` won't work, as they will run out of gas.

Instead, we'll have to use `call`, which can be found in the documentation [here](https://solidity.readthedocs.io/en/v0.4.24/types.html#members-of-addresses). This will not limit the amount of gas sent along, and we can even specify how much gas to forward. We'll send plenty of gas to ensure we don't run out. Therefore, the current version of our contract will look this this:

```javascript
pragma solidity ^0.4.18;

contract BecomeKingPermanently {

  // Become king by activating King contract's fallback function
  function becomeKing() public payable {
    address kingContract = 0x4ffe9b870d1393df5f10cbce4813dbcde3929f5e;
    kingContract.call.value(msg.value).gas(1000000)();
  }

}
```

Now let's figure out how to make the fallback function fail. The King contract's fallback function uses `transfer`, and we already know that this only sends 2300 gas. So one option is to force this `transfer` call to fail by consuming all the gas in our fallback function. One way we can do this is by writing to storage in our fallback function.

Another way to force our fallback function to always fail is by adding a `revert()` or similar statement to it. But there is a third option that is even easier, thanks to the following snippet from the documentation:
> Contracts that receive Ether directly (without a function call, i.e. using send or transfer) but do not define a fallback function throw an exception, sending back the Ether

Therefore, if we omit a fallback function altogether, our contract will be unable to directly receive Ether from the `transfer()` function, which will cause the King contract's fallback function to fail. As a result, the final contract will look just like the one above.