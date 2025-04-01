# 🗳️ Decentralized Voting System

## 🚀 Introduction
The **Decentralized Voting System** is a blockchain-based smart contract designed to provide a **transparent, tamper-proof, and secure** voting mechanism. Built using **Solidity** and **OpenZeppelin**, this contract ensures a fair electoral process by leveraging **Ethereum's** decentralized nature.

## 📌 Features
- ✅ **Secure Voting Process**: Each registered voter can cast a single vote.
- 🔄 **Delegation System**: Voters can delegate their vote to another voter.
- 📊 **Real-Time Vote Counting**: Votes are updated dynamically.
- 🔐 **Immutable & Transparent**: Results are stored on-chain for maximum security.
- 🏆 **Automated Winner Computation**: The contract determines the winning proposal automatically.

## 📜 Smart Contract Overview
The smart contract includes the following key components:

### 📌 Structs
- **Voter**: Stores the voter’s address, delegate, vote choice, and voting status.
- **Proposal**: Contains the proposal name and vote count.

### 🗂️ Mappings
- `voters`: Maps each address to a **Voter** struct to track voting rights and status.

### ✨ Events
- `VotingStarted`: Emitted when the voting process begins.
- `VoteCasted`: Emitted when a voter successfully casts a vote.
- `DelegationSuccessful`: Emitted when a voter delegates their vote.

### 🛠️ Functions
- **`vote(address _voter, uint256 _proposalIndex)`** → Cast a vote.
- **`delegate(address _to)`** → Delegate a vote to another address.
- **`computeWinners()`** → Determines the winning proposal(s).
- **`getWinningProposals()`** → Returns the winning proposal(s).

## 📦 Installation
To deploy and interact with this contract, follow these steps:

1️⃣ Clone the repository:
```sh
 git clone https://github.com/your-repo/voting-dapp.git
```

2️⃣ Install dependencies:
```sh
 npm install
```


## 🔍 Usage
- Deploy the contract with a list of proposals and registered voters.
- Voters can either vote directly or delegate their vote.
- The contract calculates and announces the winning proposal(s).
