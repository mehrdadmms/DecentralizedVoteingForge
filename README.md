# Decentralized Voting System Smart Contract

## Project Goal
The goal of this repository is to cater to a test project for learning and experimenting with the following technologies and concepts:
- [Foundry](https://foundry.openzeppelin.com/)
- Solidity Unit Tests: Writing and executing unit tests for Solidity smart contracts.
- Advanced Foundry Testing Tools: Exploring advanced testing tools provided by Foundry, such as fuzzing, FFI (Foreign Function Interface), and invariant testing.

## Problem Description
Create a smart contract for a decentralized voting system using Solidity and Foundry. The system should allow for registration of candidates, voting by participants, and tallying of votes. Ensure that your smart contract handles various edge cases and security concerns.

## Learning Objectives
1. **Foundry Setup and Basics**: Learn to set up a Foundry project, compile your Solidity contract, and run basic tests.
2. **Solidity Unit Tests**: Write unit tests for each function in your smart contract. This includes testing the registration of candidates, voting process, vote tallying, and access control.
3. **Advanced Testing with Foundry**:
   - **Fuzz Testing**: Use fuzzing to test your smart contract with a wide range of inputs to uncover potential vulnerabilities and edge cases.
   - **FFI (Foreign Function Interface)**: Explore the use of Foundry's Foreign Function Interface to call external code or scripts as part of your testing. This can be used to simulate complex interactions or real-world scenarios.
   - **Invariant Testing**: Implement invariant testing to ensure that certain conditions (invariants) always hold true throughout the execution of your contract, regardless of the state or inputs.



## Usage

### Build
```shell
$ forge build
```

### Test
```shell
$ forge test --ffi
```

### Coverage
```shell
$ brew install lcov
$ forge coverage --ffi --report lcov && genhtml lcov.info --branch-coverage --output-dir coverage
```

