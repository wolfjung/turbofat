# UI AGENTS KNOWLEDGE BASE

## OVERVIEW
Custom UI framework and components for menus, settings, and in-game overlays built with a reactive pattern.

## STRUCTURE
- `candy-button/`: Core component system using `GradientHelper` and `gradient-map.gdshader`.
- `difficulty/`: UI for game difficulty selection and piece preview panels.
- `level-select/`: Components for level/region navigation and grade display.
- `menu/`: Main menu logic, splash screens, and submenu navigation.
- `settings/`: Tabbed configuration menus for audio, video, gameplay, and keybinds.
- `squeak/`: Standardized UI helpers for buttons, checkboxes, and option buttons.
- `theme/`: Global theme definitions and font resources (Blogger Sans, Fredoka).
- `touch/`: Touch-specific on-screen controls and action buttons.
- `wallpaper/`: Dynamic backgrounds and sticker decoration systems.

## WHERE TO LOOK
| Task | Location | Notes |
|------|----------|-------|
| Core Buttons | `candy-button/` | Primary interactive components with hover/press effects |
| Input Mapping | `settings/keybind/` | Logic for remapping keys and gamepad buttons |
| Backgrounds | `wallpaper/` | UI backdrop logic including borders and stickers |
| Navigation | `menu/` | Splash screens and main menu state transitions |

## CONVENTIONS
- **Reactive Refresh**: Setters (e.g., `set_text`) must call local `_refresh_...()` methods.
- **Dependency Injection**: Use `@export var target_path: NodePath` for cross-node references.
- **Editor Tooling**: Use `@tool` with `_initialize_onready_variables()` for editor-safe UI.
- **Signal Hygiene**: Connect generic signals (focus/mouse) in `_ready()` via code to keep the editor panel clean for instance-specific connections.
- **Font Scaling**: Use `_refresh_font_size()` to dynamically fit translated text into fixed-size buttons.

## ANTI-PATTERNS
- **Yield/Await**: Never use `yield()` or `await` in UI components; use one-shot signal listeners (e.g., `idle_frame`) to avoid "class instance is gone" errors.
- **Direct Node Access**: Avoid `get_node()` in logic; prefer `@onready` variables or `@export` paths.
- **Hardcoded Strings**: Always use `tr()` for user-facing text to support Gettext localization.
