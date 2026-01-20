extends Control
## Plays different movies during the credits scroll.

@export var CrowdWalkCutsceneScene: PackedScene
@export var CrowdSurfCutsceneScene: PackedScene

@onready var _viewport := $SubViewportContainer/SubViewport

@onready var _crowd_walk_cutscene := CrowdWalkCutsceneScene.instantiate()
@onready var _crowd_surf_cutscene := CrowdSurfCutsceneScene.instantiate()

func _ready() -> void:
	_viewport.add_child(_crowd_walk_cutscene)
	_viewport.add_child(_crowd_surf_cutscene)


## Plays a cutscene where the player and Fat Sensei walk through a cheering crowd.
func play_crowd_walk_cutscene(time_until_launch: float) -> void:
	_replace_cutscene(_crowd_walk_cutscene)
	_crowd_walk_cutscene.play(time_until_launch)


## Plays a cutscene where the player and Fat Sensei crowd surf on a cheering crowd.
func play_crowd_surf_cutscene() -> void:
	_replace_cutscene(_crowd_surf_cutscene)
	_crowd_surf_cutscene.play()


func _replace_cutscene(new_cutscene: Node) -> void:
	# remove the old cutscene
	for child in _viewport.get_children():
		child.hide()
	
	# add the new cutscene
	new_cutscene.show()
