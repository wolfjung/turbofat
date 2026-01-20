# PROJECT KNOWLEDGE BASE

**Generated:** 2026-01-20 12:33:53
**Commit:** b34a1dc1
**Branch:** main

## OVERVIEW
Godot 4.5 puzzle-adventure game with Tetris-like mechanics (Turbo Fat), built in GDScript. Features career mode, creature customization, and extensive tooling.

## STRUCTURE
```
turbofat/
├── project/                  # Godot project root
│   ├── src/
│   │   ├── main/           # Production code (Maven-style)
│   │   │   ├── puzzle/     # Core gameplay: pieces, board, scoring
│   │   │   ├── world/      # Adventure mode: creatures, environments
│   │   │   ├── ui/         # Menus, HUDs, custom candy-button framework
│   │   │   ├── career/     # Story progression, level unlocks
│   │   │   ├── data/       # PlayerData, PlayerSave, persistence
│   │   │   ├── chat/       # Dialogue system (.chat format)
│   │   │   └── utils/     # StateMachine, ResourceCache, Global
│   │   ├── test/           # GUT unit tests (mirrors main/)
│   │   └── demo/           # Developer prototypes
│   ├── assets/
│   │   └── main/           # Production assets by feature
│   └── addons/gut/         # Godot Unit Test framework
├── delint.sh               # Custom linter (forbids main→test/demo refs)
├── package.sh              # Export packaging script
└── pybabel-extract.sh      # Localization extraction (Gettext)
```

## WHERE TO LOOK
| Task | Location | Notes |
|------|----------|-------|
| Game mechanics | `project/src/main/puzzle/` | Piece types, playfield, box/combo logic |
| Adventure mode | `project/src/main/world/` | Creature AI, environment, save/load |
| UI components | `project/src/main/ui/` | candy-button system, menus |
| Progression | `project/src/main/career/` | Level unlocks, story flow |
| Global state | `project/src/main/data/player-data.gd` | Autoload singleton |
| Autoloads | `project/project.godot` | 34 singleton definitions |
| Asset loading | `project/src/main/utils/resource-cache.gd` | Background caching system |
| Build/Export | `project/export_presets.cfg.template` | Template + secrets injection |
| Linting | `delint.sh` | Enforces type hints, architectural rules |

## CONVENTIONS
- **Maven-style layout**: `src/main/` (production), `src/test/` (tests), `src/demo/` (prototypes)
- **File naming**: kebab-case for files (`active-piece.gd`), PascalCase for classes (`class_name ActivePiece`)
- **State Pattern**: `StateMachine` + `State` nodes for complex behaviors (pieces, creatures)
- **Signal-based**: State changes emit signals, UI reacts via listeners (no direct coupling)
- **Autoload abuse**: 34 autoloads handle most cross-cutting concerns
- **Type hints**: Enforced by `delint.sh` (mandatory)
- **Scene-script pairing**: `.tscn` and `.gd` share names in same directory

## ANTI-PATTERNS (THIS PROJECT)
- **NEVER** reference `src/test/` or `src/demo/` from `src/main/` (blocked by delint.sh)
- **NEVER** use `yield()`/`await` where one-shot signal listeners are safer (UI components)
- **NEVER** omit type hints (enforced by linter)
- **DO NOT** use `dir.list_dir_begin()` without TODOConverter3To4 fixes
- **AVOID** hardcoding scene paths - use `Global.gd` constants
- **Creature constraint**: Beaked creatures can NEVER have noses (`dna-utils.gd`)

## UNIQUE STYLES
- **Custom shell-based build**: No CI/CD files - uses `.sh` scripts for everything
- **Gettext localization**: External `pybabel` workflow instead of Godot CSV importer
- **Box mechanic**: Rectangular same-color scoring (unique puzzle mechanic)
- **Creature DNA**: Fatness determines animations, behavior, and visual appearance
- **Date-based versioning**: Calculated from current date, not semver/git tags
- **Engine bug workarounds**: Extensive "Workaround for Godot #XXXXX" comments (check before using standard APIs)
- **Resource shuffling**: `ResourceCache` randomizes load order to prevent lag spikes

## COMMANDS
```bash
# Lint code (enforces architectural rules)
./delint.sh

# Extract translatable strings
./pybabel-extract.sh

# Export packages (Windows/Linux/HTML5)
./package.sh

# Generate export presets from templates
./generate-export-presets.sh

# Run tests (via Godot editor)
# Open project → GUT panel → Run all tests
```

## NOTES
- **34 autoloads** is unusually high - singletons are primary architectural pattern
- **Godot 4 migration debt**: `TODOConverter3To4` markers need attention (file listing APIs)
- **Testing culture**: `src/test/` mirrors `src/main/` structure comprehensively
- **Editor-first**: Many scripts use `@tool` with `_initialize_onready_variables()` pattern
- **Creature fatness**: Persists across saves, affects gameplay and visuals globally
- **License split**: MIT for code, CC-BY-NC for game resources
