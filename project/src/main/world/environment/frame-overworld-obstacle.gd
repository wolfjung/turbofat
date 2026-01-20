@tool
extends OverworldObstacle
## Overworld obstacle with different cosmetic variations in a sprite sheet.

## Current frame to display from the sprite sheet.
@export var frame: int: set = set_frame

## If true, the sprite's texture is flipped horizontally.
@export var flip_h: bool: set = set_flip_h

## Editor toggle which randomizes the obstacle's appearance
@export var shuffle: bool: set = set_shuffle

## List of frames to allow when shuffling. If omitted, all frames will be used.
@export var shuffle_frames: Array # (Array, int)

@onready var _sprite := $Sprite2D

func _ready() -> void:
	_refresh()


## Preemptively initializes onready variables to avoid null references.
func _enter_tree() -> void:
	_initialize_onready_variables()


func set_frame(new_frame: int) -> void:
	frame = new_frame
	_refresh()


func set_flip_h(new_flip_h: bool) -> void:
	flip_h = new_flip_h
	_refresh()


## Randomizes the obstacle's appearance.
func set_shuffle(value: bool) -> void:
	if not value:
		return
	
	var new_frame
	if shuffle_frames:
		new_frame = Utils.rand_value(shuffle_frames)
	else:
		new_frame = randi() % (_sprite.hframes * _sprite.vframes)
	
	set_frame(new_frame)
	set_flip_h(randf() < 0.5)
	scale = Vector2.ONE
	
	notify_property_list_changed()


func _initialize_onready_variables() -> void:
	_sprite = $Sprite2D


func _refresh() -> void:
	if not is_inside_tree():
		return
	
	if Engine.is_editor_hint() and not _sprite:
		_initialize_onready_variables()
	
	_sprite.frame = frame
	_sprite.flip_h = flip_h
