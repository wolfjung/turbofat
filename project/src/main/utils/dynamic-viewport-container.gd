extends SubViewportContainer
## Container which resizes its child viewport based on the container size.

@export var world_viewport_path: NodePath

@onready var _viewport := $SubViewport

func _ready() -> void:
	connect("item_rect_changed", Callable(self, "_on_item_rect_changed"))
	
	if world_viewport_path:
		_viewport.world_2d = get_node(world_viewport_path).world_2d
	_refresh_viewport_size()


func _refresh_viewport_size() -> void:
	_viewport.size = size * stretch_shrink


## When the viewport's dimensions change, we refresh the viewport's size. Otherwise, Godot automatically changes the
## viewport's size to something nonsensical.
func _on_item_rect_changed() -> void:
	_refresh_viewport_size()
