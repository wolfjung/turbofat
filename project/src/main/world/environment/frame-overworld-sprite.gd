@tool
extends Sprite2D
## Overworld sprite with different cosmetic variations in a sprite sheet.

## Editor toggle which randomizes the obstacle's appearance
@export var shuffle: bool: set = set_shuffle


## Randomizes the obstacle's appearance.
func set_shuffle(value: bool) -> void:
	if not value:
		return
	
	set_frame(randi() % (hframes * vframes))
	set_flip_h(randf() < 0.5)
