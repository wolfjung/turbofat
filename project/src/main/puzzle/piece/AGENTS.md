# PIECE KNOWLEDGE BASE

## OVERVIEW
Piece management system handling spawning, movement, rotation, and state transitions for active pieces.

## STRUCTURE
```
piece/
└── states/                  # Concrete state implementations (MovePiece, Prelock, etc.)
```

## WHERE TO LOOK
| Task | Location | Notes |
|------|----------|-------|
| Piece Orchestration | `piece-manager.gd` | Main entry point; coordinates input and states |
| State Container | `active-piece.gd` | Holds current pos, orientation, and gravity |
| Metadata & Kicks | `piece-type.gd` | Definitions for shapes, colors, and kick tables |
| Horizontal Movement | `piece-mover.gd` | DAS logic and 20G mid-drop movement |
| Rotation & Kicks | `piece-rotator.gd` | Rotation logic and floor/wall kick application |
| State Machine | `piece-states.gd` | Coordinates piece lifecycle transitions |
| Input Buffering | `piece-input.gd` | Handles initial movement (IRS/IMS) |

## CONVENTIONS
- **State Pattern**: `PieceManager` delegates all frame-by-frame behavior to `PieceStates`.
- **Kick System**: `ActivePiece` delegates kick evaluation to `PieceType` data tables.
- **Initial Actions**: Supports Initial DAS (IMS) and Initial Rotation (IRS) during lock/spawn delays.
- **20G Physics**: `PieceMover` attempts multiple horizontal shifts per frame during high gravity.
- **Signal-Driven**: `PieceManager` emits granular signals (`squish_moved`, `landed`) for UI and VFX.

## ANTI-PATTERNS
- **Direct Variable Mutation**: Avoid modifying `ActivePiece` properties directly; use `PieceMover` or `PieceRotator` methods.
- **Hardcoded Kicks**: Never hardcode kick offsets in movement logic; define them in `PieceType`.
- **Blocked State Updates**: Avoid bypassing the `StateMachine` for state transitions.
