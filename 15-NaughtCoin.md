In this level we need to bypass the time lock mechanism and withdraw our tokens without waiting for 10 years. Reading through the [ERC20 spec](https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md), we see there are two ways to transfer tokens:
1. The `transfer()` method
2. The `transferFrom()` method

Option 1 won't work, since the `transfer()` method in the `NaughtCoin` contract uses the time lock modifier we want to bypass. Instead, let's look deeper into option 2.

The OpenZeppelin codebase seems to have changed a bit since this level was made, but if we dig around on GitHub we can find the [`StandardToken.sol` contract](https://github.com/OpenZeppelin/openzeppelin-solidity/blob/c5d66183abcb63a90a2528b8333b2b17067629fc/contracts/token/ERC20/StandardToken.sol) being inherited by `NaughtCoin`. By examining this contract, we see the `transferFrom()` method has a `require()` statement checking a variable called `allowed`. This mapping is configured in the `approve()` function in the same contract, and ensures the caller has permission to withdraw the tokens from the `_from` address. Because `NaughtCoin` inherits this contract, these methods are available to us, which we can confirm by examining the `contract` object in the console.

Therefore, we can move the coins by calling `approve()` to approve ourselves to transfer them out, then calling `transferFrom()` to execute the transfer. First, we approve ourselves using the command below. The first input is the address of the approver, and the second is the amount of tokens that will be approved to withdraw.
`contract.approve("yourMainAccountAddress", "1e24")`

The number of tokens we used in the previous command was found using:
`bal = String(await contract.balanceOf("0xd4506245b4b017ecafa30471d020fee7970112ab"))`

Afterwards, we use MetaMask to switch to a different account. We use this simply to copy the address and use it as a recipient address to transfer the coins to. Copy that address, switch back to your primary account, and use it in the command below to initiate the transfer:
`contract.transferFrom("yourMainAccountAddress", "yourSecondAccountAddress", "1e24")`

If we check our balance afterwards, we'll see it has dropped to zero!
