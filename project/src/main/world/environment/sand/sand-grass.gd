@tool
extends Sprite2D

enum Size {
	SMALL,
	LARGE,
}

@export var size := Size.SMALL

## Editor toggle which randomizes the obstacle's appearance
@export var shuffle: bool: set = set_shuffle

@onready var _animation_player := $AnimationPlayer

func _ready() -> void:
	if Engine.is_editor_hint():
		# update the tree's appearance, but don't play any animations
		_refresh_grass_in_editor()
	else:
		# launch the grass's animations
		_animation_player.play("small" if size == Size.SMALL else "large")
		_animation_player.advance(randf_range(0, _animation_player.get_current_animation_length()))


func _refresh_grass_in_editor() -> void:
	frame = 3 if size == Size.SMALL else 0


## Randomizes the grass's appearance.
func set_shuffle(value: bool) -> void:
	if not value:
		return
	
	size = Utils.rand_value([Size.SMALL, Size.LARGE])
	flip_h = randf() < 0.5
	
	_refresh_grass_in_editor()
	notify_property_list_changed()
