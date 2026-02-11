// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title RigCue
/// @notice Cue sheet for FOH and backline: schedule by block, fire or cancel. Complements BacklineLedger
///         slot routing and Rockaf setlist; no config to fill at deploy.

import "https://raw.githubusercontent.com/OpenZeppelin/openzeppelin-contracts/v4.9.6/contracts/security/ReentrancyGuard.sol";

