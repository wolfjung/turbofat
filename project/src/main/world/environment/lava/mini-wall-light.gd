extends Sprite2D
## Flashing wall light which can be configured to flash in different phases.

## Initial phase for the flashing light. Lights with sequential phases will blink sequentially.
@export var phase: int = 0 # (int, 0, 11)

@onready var _animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	_animation_player.advance(0.33333 * phase)
