extends CanvasLayer
## A blue background with vertical lines which shows up when the player and Fat Sensei are launched into the air.

## Duration in seconds for the background to fade in or fade out.
const FADE_DURATION := 0.3

var _tween: Tween

@onready var _texture_rect: TextureRect = $TextureRect

## Gradually fades the background in.
func pop_in() -> void:
	if not visible:
		visible = true
		_texture_rect.modulate = Color.TRANSPARENT
	
	_tween = Utils.recreate_tween(self, _tween)
	_tween.tween_property(_texture_rect, "modulate", Color.WHITE, FADE_DURATION)


## Gradually fades the background out.
func pop_out() -> void:
	_tween = Utils.recreate_tween(self, _tween)
	_tween.tween_property(_texture_rect, "modulate", Color.TRANSPARENT, FADE_DURATION)
	_tween.tween_callback(Callable(self, "set").bind("visible", false)).set_delay(FADE_DURATION)


## When the 'midair' flag changes, we fade our background in or out appropriately.
func _on_Environment_midair_changed(value: bool) -> void:
	if value:
		pop_in()
	else:
		pop_out()
