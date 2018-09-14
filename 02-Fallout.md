There's a reason the hint for this level is to use the Remix IDE. If you look carefully on the Ethernaut site you might notice it, but copying this contract into Remix makes it much more apparent &mdash; the constructor function is not actually the constructor!

The function that _appears_ to be the constructor actually has the letter "l" replaced with the number "1". This means we can simply call the `Fal1out()` function to become the owner.

For reasons like this, this constructor syntax was [deprecated](https://github.com/ethereum/solidity/releases/tag/v0.4.22) in favor of the more explicit `constructor()` syntax in Solidity version 0.4.22