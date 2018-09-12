The `transfer()` functon of this contract is shown below:

```
  function transfer(address _to, uint _value) public returns (bool) {
    require(balances[msg.sender] - _value >= 0);
    balances[msg.sender] -= _value;
    balances[_to] += _value;
    return true;
  }
```

In this contract, `balances` and `value` are both of type `uint`. Because they are both unsigned, the difference between them will also be unsigned, meaning the difference cannot be negative. Consequently the `require()` statement above will always evaluate to true.

We start with 20 tokens, so if we call `transfer()` and pass it any value over 20, `balances[msg.sender] -= _value` will underflow and be set to a very large number.