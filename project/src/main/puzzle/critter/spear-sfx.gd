class_name SpearSfx
extends Node
## Sound effects for spears, puzzle critters which add veggie blocks from the sides.

## If 'true', these sound effects are for wide spears. We play certain sounds lower-pitched and more sustained.
@export var wide: bool = false

@onready var _poof: AudioStreamPlayer = $Poof
@onready var _pop: AudioStreamPlayer = $Pop
@onready var _voice_warn: AudioStreamPlayer = $VoiceWarn
@onready var _voice_hello: AudioStreamPlayer = $VoiceHello

func play_poof_sound() -> void:
	_poof.pitch_scale = randf_range(0.95, 1.05)
	_poof.play()


func play_pop_sound() -> void:
	_pop.pitch_scale = randf_range(0.95, 1.05)
	_pop.play()


func play_warning_voice() -> void:
	_voice_warn.pitch_scale = randf_range(0.45, 0.55) if wide else randf_range(0.9, 1.1)
	_voice_warn.play()


func play_hello_voice() -> void:
	_voice_hello.pitch_scale = randf_range(0.45, 0.55) if wide else randf_range(0.9, 1.1)
	_voice_hello.play()
