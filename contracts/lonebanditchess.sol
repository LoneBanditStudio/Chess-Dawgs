// SPDX-License-Identifier: MIT LICENSE

pragma solidity ^0.8.20;

/// _//////    _////           _/       _/////       _// //        _/       _///////          _/       _//     _//
     //      _//    _//       _/ //     _//   _//  _//    _//     _/ //     _//    _//       _/ //     _//     _//
     //    _//        _//    _/  _//    _//    _//  _//          _/  _//    _//    _//      _/  _//    _//     _//
     //    _//        _//   _//   _//   _//    _//    _//       _//   _//   _/ _//         _//   _//   _////// _//
     //    _//        _//  _////// _//  _//    _//       _//   _////// _//  _//  _//      _////// _//  _//     _//
     //      _//     _//  _//       _// _//   _//  _//    _// _//       _// _//    _//   _//       _// _//     _//
     //        _////     _//         _//_/////       _// //  _//         _//_//      _//_//         _//_//     _//


// THIS CONTRACT IS CURRENTLY ON DEVELOPMENT PHASE AND NOT AUDITED YET. 
// YOU ARE SOLELY REPONSIBLE FOR ITS USE. 
// ONLY USE IT IF YOU AGREE TO THE
// TERMS SPECIFIED ABOVE.

// Import ERC20 token interface
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract LoneBanditChess {
  // Define game state enum
  enum GameState { Open, InProgress, Finished }

  // Define player struct
  struct Player {
    address payable walletAddress;
    uint256 depositAmount;
  }

  // Game variables
  address payable[2] public players; // Array to store player addresses
  IERC20 public token; // ERC20 token used for deposits
  uint256 public depositAmount; // Minimum deposit required per player
  GameState public gameState; // Current game state
  address public owner; // Contract owner address

  // Events
  event GameStarted(address player1, address player2, uint256 totalDeposit);
  event PlayerJoined(address player, uint256 depositAmount);
  event GameFinished(address winner, uint256 winnerAmount, uint256 burnedAmount, uint256 ownerAmount);
  event EmergencyWithdraw(uint256 amount);

  // Constructor
  constructor(address payable _owner, address _tokenAddress, uint256 _depositAmount) {
    owner = _owner;
    token = IERC20(_tokenAddress);
    depositAmount = _depositAmount;
    gameState = GameState.Open;
  }

  // Modifier to restrict functions to game owner
  modifier onlyOwner() {
    require(msg.sender == owner, "Only owner can call this function");
    _;
  }

  // Modifier to restrict functions to specific game states
  modifier onlyInState(GameState _state) {
    require(gameState == _state, "Function can only be called in specific game state");
    _;
  }

  // Join the game as a player
  function joinGame() public onlyInState(GameState.Open) {
    require(players[0] == address(0), "Game already has a player 1");
    require(token.balanceOf(msg.sender) >= depositAmount, "Insufficient token balance");

    // Transfer deposit from player to contract
    token.transferFrom(msg.sender, address(this), depositAmount);

    players[0] = payable(msg.sender);
    gameState = GameState.InProgress;

    emit PlayerJoined(msg.sender, depositAmount);
  }

  // Join the game as a second player
  function joinSecondPlayer() public onlyInState(GameState.InProgress) {
    require(players[1] == address(0), "Game already has a player 2");
    require(token.balanceOf(msg.sender) >= depositAmount, "Insufficient token balance");

    // Transfer deposit from player to contract
    token.transferFrom(msg.sender, address(this), depositAmount);

    players[1] = payable(msg.sender);

    emit GameStarted(players[0], players[1], depositAmount * 2);
  }

  // Simulate a game finish (replace with actual chess logic)
  function finishGame(address payable winner) public onlyInState(GameState.InProgress) {
    require(msg.sender == players[0] || msg.sender == players[1], "Only players can finish the game");

    uint256 totalDeposit = depositAmount * 2;
    uint256 winnerAmount = totalDeposit * 80 / 100;
    uint256 burnAmount = totalDeposit * 10 / 100;
    uint256 ownerAmount = totalDeposit * 10 / 100;

    // Transfer winner amount
    token.transfer(winner, winnerAmount);

    // Burn 10% of tokens
    token.transfer(address(0), burnAmount);

    // Transfer 10% to owner
    token.transfer(owner, ownerAmount);

    gameState = GameState.Finished;

    emit GameFinished(winner, winnerAmount, burnAmount, ownerAmount);
  }

  // Emergency withdraw function for owner (restricted)
  function emergencyWithdraw() public onlyOwner {
    uint256 balance = address(this).balance;
    if (balance > 0) {
      payable(owner).transfer(balance);
    }

    uint256 tokenBalance = token.balanceOf(address(this));
    if (tokenBalance > 0) {
      token.transfer(owner, tokenBalance);
    }

    emit EmergencyWithdraw(balance + tokenBalance);
  }
}

