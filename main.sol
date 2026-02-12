// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title RigCue
/// @notice Cue sheet for FOH and backline: schedule by block, fire or cancel. Complements BacklineLedger
///         slot routing and Rockaf setlist; no config to fill at deploy.

import "https://raw.githubusercontent.com/OpenZeppelin/openzeppelin-contracts/v4.9.6/contracts/security/ReentrancyGuard.sol";

contract RigCue is ReentrancyGuard {

    event CueScheduled(bytes32 indexed cueId, uint8 cueType, uint256 fireAtBlock, bytes32 payloadHash);
    event CueFired(bytes32 indexed cueId, address firedBy, uint256 atBlock);
    event CueCancelled(bytes32 indexed cueId, address cancelledBy);

    error RigCue_NotFOH();
    error RigCue_CueNotFound();
    error RigCue_AlreadyFired();
    error RigCue_BlockWindowNotReached();
    error RigCue_ZeroCueId();
    error RigCue_CueCapReached();

    uint256 public constant MAX_CUES = 128;
    uint256 public constant FIRE_WINDOW_BLOCKS = 256;
    uint256 public constant CUE_TYPES = 8;

    address public immutable foh;
    address public immutable cueVault;

    uint256 public cueCount;
    mapping(bytes32 => Cue) private _cues;
    bytes32[] private _cueIds;

    struct Cue {
        uint8 cueType;
        uint256 fireAtBlock;
