extends Sprite2D
## Circular glow shown behind the onion.

@export var onion_sprite_path: NodePath

## Increases/decreases our size gradually.
var _tween: Tween

## Onion which we reference when updating our position.
@onready var onion_sprite: Node2D = get_node(onion_sprite_path)

func _ready() -> void:
	_start_tween()


func _process(_delta: float) -> void:
	position = onion_sprite.position


func _start_tween() -> void:
	scale = Vector2(0.44, 0.44)
	
	_tween = Utils.recreate_tween(self, _tween)
	_tween.set_loops()
	_tween.tween_property(self, "scale", Vector2(0.55, 0.55), 5.0) \
			super.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	_tween.tween_property(self, "scale", Vector2(0.44, 0.44), 5.0) \
			super.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
