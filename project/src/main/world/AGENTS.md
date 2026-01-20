# ADVENTURE MODE (WORLD)

**Generated:** 2026-01-20 12:45:00

## OVERVIEW
Adventure mode world management, including DNA-driven creature assembly, procedural overworld environments, and cutscene sequencing.

## STRUCTURE
- `creature/`: Modular creature system using DNA resources (`CreatureDef`, `CreatureLoader`) and persistent state (`CreatureLibrary`).
- `environment/`: Procedural terrain tilers (Water, Grass, Goop) and biome-specific definitions (Lava, Sand, Marsh, Restaurant).
- `career-*.gd`: Files managing career mode progression maps and overworld navigation.
- `cutscene-*.gd`: Logic for sequencing in-game cinematics, dialogue, and camera movements.
- `chat-*.gd`: Interactive dialogue elements and letter-based projectile mechanics.

## WHERE TO LOOK
| Task | Location | Notes |
|------|----------|-------|
| Creature behavior | `project/src/main/world/creature/creature.gd` | Root node for creature state, fatness, and visuals |
| DNA assembly | `project/src/main/world/creature/creature-loader.gd` | Handles asynchronous loading and part assembly |
| Persistence | `project/src/main/world/creature/creature-library.gd` | Tracks fatness, names, and DNA across saves |
| Environment container | `project/src/main/world/environment/overworld-environment.gd` | Holds tilers, spawners, and obstacles |
| Overworld logic | `project/src/main/world/overworld-world.gd` | Main entry point; manages environment transitions |
| Spawning logic | `project/src/main/world/creature-spawner.gd` | Evaluates boolean expressions for conditional spawns |

## CONVENTIONS
- **DNA-Driven Visuals**: Creatures must be initialized via `CreatureLoader` or `DnaUtils` to ensure valid part combinations.
- **Fatness Persistence**: All weight/comfort changes should be committed via `CreatureLibrary.save_fatness()`.
- **Terrain Tiling**: New terrain types should extend `Node` and implement autotiling logic (see `water-overworld-tiler.gd`).
- **Asynchronous Spawning**: Use `CreatureLoader` for background assembly to prevent frame drops during gameplay.

## ANTI-PATTERNS
- **Hardcoded DNA**: Never manually set creature parts; use `CreatureDef` resources to maintain valid logic (e.g., beaks vs noses).
- **Direct Save Access**: Avoid writing creature data directly to `PlayerData`; use `CreatureLibrary` as the dedicated interface.
- **Manual Node Cleanup**: Let `OverworldWorld` handle environment replacement to ensure groups and signals are properly reset.
