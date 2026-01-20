# PUZZLE ENGINE KNOWLEDGE BASE

## OVERVIEW
Core gameplay logic for the Turbo Fat puzzle engine, handling piece movement, box/line mechanics, and scoring.

## STRUCTURE
- `piece/`: Piece types, movement logic (`ActivePiece`), and management.
- `level/`: Level definitions, scoring rules, and rank calculation.
- `night/`: Specialized mechanics and playfield for "Night Mode" levels.
- `critter/`: Visuals and animations for creatures appearing during puzzle play.
- `tutorial/`: Interactive tutorial sequences and logic.
- `pan/`: Playfield positioning and camera control.
- `intro/` / `result/`: Pre-game start sequences and post-game tallying.

## WHERE TO LOOK
- `PuzzleState.gd`: Global autoload managing match lifecycle, state transitions, and signals.
- `playfield.gd`: The central coordinator; manages the tilemap and delegates to builders/clearers.
- `piece/active-piece.gd`: Piece state machine (falling, sliding, locking) and kick tables.
- `box-builder.gd`: Detects same-color rectangular boxes and triggers box scoring.
- `line-clearer.gd`: Logic for row completion, line clears, and piece removal.
- `combo-tracker.gd`: Tracks clear history to manage multipliers and combo signals.

## CONVENTIONS
- **Signal-driven**: Components react to `PuzzleState` and `Playfield` signals to remain decoupled.
- **Tilemap Delegation**: Writing to the `PuzzleTileMap` automatically triggers `BoxBuilder` and `LineClearer`.
- **State Machine**: `ActivePiece` uses a Node-based state machine for complex movement/locking logic.
- **Strict Separation**: Pieces and Tiles are distinct entities until locked into the Playfield.

## ANTI-PATTERNS
- **Direct Tilemap Access**: Avoid modifying the tilemap directly; use `Playfield.gd` methods.
- **Node Coupling**: Do not reference `PieceManager` or `ActivePiece` directly from scoring logic.
- **Input Polling**: Puzzle input should be handled via the `active-piece.gd` input states, not globally.
