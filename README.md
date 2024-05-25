
This contract is currently under development and not audited yet. Use it at your own risk.

This Solidity contract implements a chess game where two players can compete by depositing a certain amount of $DDAWGS ERC20 tokens. The winner of the game (simulated for now) receives a portion of the combined deposits, while a percentage 
is burned and another percentage goes to the contract owner.

Key Features:

Play-to-Earn Model: Players deposit tokens to participate in the game.
NFT Ownership Requirement: Players must hold a specific NFT to join the game ( Will implement on front end).
Minimum Deposit: A minimum amount of $DDAWGS tokens is required to participate.
Game State Management: The contract tracks the current game state (Open, InProgress, Finished).
Emergency Withdraw: The contract owner can withdraw any remaining $DDAWGS tokens in case of emergency.

Disclaimer:

This contract is on development. It is not audited and should not be used in production environments without thorough security checks. You are solely responsible for its use
