# CAREER MODE KNOWLEDGE BASE

## OVERVIEW
Manages story progression, level unlocks, and region-based travel via a "career day" cycle.

## WHERE TO LOOK
| Task | Location | Notes |
|------|----------|-------|
| Career State | `career-data.gd` | Distance, money, day, and session stats |
| Progression Logic | `career-flow.gd` | Scene transitions (level -> map -> cutscene) |
| Time/Calendar | `career-calendar.gd` | Advancing hours and days |
| Level Data | `career-level-library.gd` | Loads regions/levels from `career-regions.json` |
| Region/Level Models | `career-region.gd`, `career-level.gd` | Data structures for career entities |
| Cutscene Management | `career-cutscene-library.gd` | Finds relevant cutscenes for progression |
| Career Map UI | `ui/career-map-ui.gd` | Main hub for level selection |
| Progress Board | `ui/progress-board.gd` | Visual summary of distance and earnings |

## CONVENTIONS
- **Distance-based**: Progression is measured in "distance". Regions unlock at specific distance thresholds.
- **Career Day**: A cycle of ~6 "hours" (levels). Each hour is one played level.
- **JSON Driven**: All level/region data is loaded from `assets/main/puzzle/career-regions.json`.
- **Milestones**: Boss levels and Intro levels act as progress gates that block further distance until cleared.
- **Cutscene Integration**: Progression triggers `.chat` cutscenes via `CareerCutsceneLibrary`.
- **Speed Scaling**: Piece speed in career levels scales based on the player's distance within a region.

## ANTI-PATTERNS
- **NO Hardcoded Levels**: Never hardcode level IDs for progression; use `CareerLevelLibrary` queries.
- **NO Direct Scene Changes**: Use `PlayerData.career.push_career_trail()` to let the flow manager decide the next scene.
- **Avoid Global Sync**: Let `CareerFlow` handle synchronizing state between puzzle results and career data.

## NOTES
- **Banked Steps**: If a player is blocked by a boss, earned distance is "banked" until the boss is defeated.
- **Hardcore Levels**: Randomly offered during the day; completing them awards extra lives.
- **Region Completion**: Calculated by comparing viewed cutscenes and finished levels against region totals.
