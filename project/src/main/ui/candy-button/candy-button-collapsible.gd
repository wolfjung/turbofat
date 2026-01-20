@tool
class_name CandyButtonCollapsible
extends TextureButton
## An eye-catching button with customizable colors and textures.
##
## This button alternates between 'c3' and 'a3' sizes, and is used for the categories in the creature editor.

signal color_changed

signal disabled_changed

signal hovered_changed

## Bright shiny reflection texture which overlays the button and text when the button is not pressed.
const SHINE_TEXTURE_COLLAPSED_NORMAL: Texture2D = preload("res://assets/main/ui/candy-button/a3-shine.png")

## Less shiny reflection texture which overlays the button and text when the button is pressed.
const SHINE_TEXTURE_COLLAPSED_PRESSED: Texture2D = preload("res://assets/main/ui/candy-button/a3-shine-pressed.png")

## Bright shiny reflection texture which overlays the button and text when the button is not pressed.
const SHINE_TEXTURE_UNCOLLAPSED_NORMAL: Texture2D = preload("res://assets/main/ui/candy-button/c3-shine.png")

## Less shiny reflection texture which overlays the button and text when the button is pressed.
const SHINE_TEXTURE_UNCOLLAPSED_PRESSED: Texture2D = preload("res://assets/main/ui/candy-button/c3-shine-pressed.png")

## Texture to display when the node has mouse or keyboard focus while the button is collapsed.
const TEXTURE_FOCUSED_COLLAPSED: Texture2D = preload("res://assets/main/ui/candy-button/a3-focused.png")

## Texture to display when the node has mouse or keyboard focus while the button is uncollapsed.
const TEXTURE_FOCUSED_UNCOLLAPSED: Texture2D = preload("res://assets/main/ui/candy-button/c3-focused.png")

## Textures for the various ButtonShape presets.
##
## key: (int) Enum from ButtonShape
## value: (Array, Texture) Array with two entries for the textures for the specified shape:
## 	value[0]: (Texture) texture to use when the button is not pressed.
## 	value[1]: (Texture) texture to use when the button is pressed.
const TEXTURES_BY_SHAPE_COLLAPSED := {
	CandyButtons.ButtonShape.NONE: [
		preload("res://assets/main/ui/candy-button/a3-blank.png"),
		preload("res://assets/main/ui/candy-button/a3-blank-pressed.png")],
	CandyButtons.ButtonShape.PIECE_J: [
		preload("res://assets/main/ui/candy-button/a3-j.png"),
		preload("res://assets/main/ui/candy-button/a3-j-pressed.png")],
	CandyButtons.ButtonShape.PIECE_L: [
		preload("res://assets/main/ui/candy-button/a3-l.png"),
		preload("res://assets/main/ui/candy-button/a3-l-pressed.png")],
	CandyButtons.ButtonShape.PIECE_O: [
		preload("res://assets/main/ui/candy-button/a3-o.png"),
		preload("res://assets/main/ui/candy-button/a3-o-pressed.png")],
	CandyButtons.ButtonShape.PIECE_P: [
		preload("res://assets/main/ui/candy-button/a3-p.png"),
		preload("res://assets/main/ui/candy-button/a3-p-pressed.png")],
	CandyButtons.ButtonShape.PIECE_Q: [
		preload("res://assets/main/ui/candy-button/a3-q.png"),
		preload("res://assets/main/ui/candy-button/a3-q-pressed.png")],
	CandyButtons.ButtonShape.PIECE_T: [
		preload("res://assets/main/ui/candy-button/a3-t.png"),
		preload("res://assets/main/ui/candy-button/a3-t-pressed.png")],
	CandyButtons.ButtonShape.PIECE_U: [
		preload("res://assets/main/ui/candy-button/a3-u.png"),
		preload("res://assets/main/ui/candy-button/a3-u-pressed.png")],
	CandyButtons.ButtonShape.PIECE_V: [
		preload("res://assets/main/ui/candy-button/a3-v.png"),
		preload("res://assets/main/ui/candy-button/a3-v-pressed.png")],
}

## Icon shown to the top of the button's text.
@export var icon: Texture2D: set = set_icon

@export var color : set = set_color

## Repeating piece shapes which decorate the button.
@export var shape : set = set_shape

## 'true' if the button is in its narrow 'a3' size, or 'false' if the button is in its wider 'c3' size.
@export var collapsed := false: set = set_collapsed

## Textures for the various ButtonShape presets.
##
## key: (int) Enum from ButtonShape
## value: (Array, Texture) Array with two entries for the textures for the specified shape:
## 	value[0]: (Texture) texture to use when the button is not pressed.
## 	value[1]: (Texture) texture to use when the button is pressed.
var _textures_by_shape := CandyButtons.C3_TEXTURES_BY_SHAPE

## If true, the button's size is rounded up while being tweened. If false, the button's size is rounded down while
## being tweened.
##
## This allows a row of collapsible buttons to maintain their width, as long as two of them are being tweened in
## opposite directions simultaneously. Without this rounding fix, there is noticable jitter.
var _round_size_up := false

@onready var _animation_player := $AnimationPlayer

@onready var _click_sound := $ClickSound
@onready var _hover_sound := $HoverSound

## Icon shown to the top of the button's text
@onready var _icon_node := $Icon

## Shiny reflection effect which overlays the button and text
@onready var _shine := $Shine

@onready var _gradient_helper: GradientHelper = $GradientHelper

func _ready() -> void:
	# Connect signals in code to prevent them from showing up in the Godot editor.
	#
	# This is a generic button used in many places, we want to be able to quickly see the unique signals connected to
	# each button instance, not the generic signals connected to all button instances.
	connect("focus_entered", Callable(self, "_on_focus_entered"))
	connect("mouse_entered", Callable(self, "_on_mouse_entered"))
	connect("mouse_exited", Callable(self, "_on_mouse_exited"))
	_gradient_helper.connect("gradient_changed", Callable(self, "_on_GradientHelper_gradient_changed"))
	
	_refresh_icon_position()
	_refresh_collapsed()
	_refresh_icons()
	_refresh_shape()
	_refresh_color()


## Preemptively initializes onready variables to avoid null references.
func _enter_tree() -> void:
	_initialize_onready_variables()


func _pressed() -> void:
	_click_sound.pitch_scale = randf_range(0.95, 1.05)
	SfxKeeper.copy(_click_sound).play()


func set_disabled(new_disabled: bool) -> void:
	if disabled == new_disabled:
		return
	
	disabled = new_disabled
	_refresh_color()
	emit_signal("disabled_changed")


func set_collapsed(new_collapsed: bool) -> void:
	collapsed = new_collapsed
	_refresh_collapsed()
	_refresh_shape()


func set_icon(new_icon: Texture2D) -> void:
	icon = new_icon
	_refresh_icons()


func set_color(new_color: int) -> void:
	color = new_color
	_refresh_color()
	emit_signal("color_changed")


func set_shape(new_shape: int) -> void:
	shape = new_shape
	_refresh_shape()


func uncollapse(animate: bool = false) -> void:
	collapsed = false
	if animate:
		_round_size_up = false
		_animation_player.play("uncollapse")
	else:
		_animation_player.stop()
		_refresh_collapsed()


func collapse(animate: bool = false) -> void:
	collapsed = true
	if animate:
		_round_size_up = true
		_animation_player.play("collapse")
	else:
		_animation_player.stop()
		_refresh_collapsed()


func assign_collapsed_textures() -> void:
	_shine.texture_normal = SHINE_TEXTURE_COLLAPSED_NORMAL
	_shine.texture_pressed = SHINE_TEXTURE_COLLAPSED_PRESSED
	_textures_by_shape = TEXTURES_BY_SHAPE_COLLAPSED
	texture_focused = TEXTURE_FOCUSED_COLLAPSED
	_refresh_shape()


func assign_uncollapsed_textures() -> void:
	_shine.texture_normal = SHINE_TEXTURE_UNCOLLAPSED_NORMAL
	_shine.texture_pressed = SHINE_TEXTURE_UNCOLLAPSED_PRESSED
	_textures_by_shape = CandyButtons.C3_TEXTURES_BY_SHAPE
	texture_focused = TEXTURE_FOCUSED_UNCOLLAPSED
	_refresh_shape()


func get_current_animation() -> String:
	return _animation_player.current_animation


## Preemptively initializes onready variables to avoid null references.
func _initialize_onready_variables() -> void:
	_animation_player = $AnimationPlayer
	_click_sound = $ClickSound
	_hover_sound = $HoverSound
	_icon_node = $Icon
	_shine = $Shine
	_gradient_helper = $GradientHelper


func _apply_mouse_entered_effects() -> void:
	# disconnect our one-shot method
	if get_tree().is_connected("idle_frame", Callable(self, "_apply_mouse_entered_effects")):
		get_tree().disconnect("idle_frame", Callable(self, "_apply_mouse_entered_effects"))
	emit_signal("hovered_changed")
	_hover_sound.pitch_scale = randf_range(0.95, 1.05)
	SfxKeeper.copy(_hover_sound).play()


func _apply_mouse_exited_effects() -> void:
	if get_tree().is_connected("idle_frame", Callable(self, "_apply_mouse_exited_effects")):
		get_tree().disconnect("idle_frame", Callable(self, "_apply_mouse_exited_effects"))
	emit_signal("hovered_changed")


func _refresh_collapsed() -> void:
	if not is_inside_tree():
		return
	
	if Engine.is_editor_hint():
		if not _shine:
			# initialize variables to avoid nil reference errors in the editor when editing tool scripts
			_initialize_onready_variables()
	
	if collapsed:
		custom_minimum_size = Vector2(30, 64)
		_icon_node.custom_minimum_size = Vector2(25, 25)
		assign_collapsed_textures()
	else:
		custom_minimum_size = Vector2(80, 64)
		_icon_node.custom_minimum_size = Vector2(50, 50)
		assign_uncollapsed_textures()
	
	size = custom_minimum_size
	_icon_node.size = _icon_node.custom_minimum_size


## Reapplies the colors for our texture, text and icons.
func _refresh_color() -> void:
	if not is_inside_tree():
		return
	
	if Engine.is_editor_hint():
		if not _shine:
			# initialize variables to avoid nil reference errors in the editor when editing tool scripts
			_initialize_onready_variables()
	
	material.get_shader_parameter("gradient").gradient = _gradient_helper.gradient
	_refresh_icon_color()


## Reapplies the colors for our icons.
func _refresh_icon_color() -> void:
	# both icons use the same material; setting one sets the other
	_icon_node.material.set_shader_parameter("black", _gradient_helper.gradient.sample(
			0.25 if has_focus() else 0.15))


## Toggles the visibility of the top icon and updates its properties.
func _refresh_icons() -> void:
	if not is_inside_tree():
		return
	
	if Engine.is_editor_hint():
		if not _shine:
			# initialize variables to avoid nil reference errors in the editor when editing tool scripts
			_initialize_onready_variables()
	
	_icon_node.visible = true if icon else false
	_icon_node.texture = icon
	
	_refresh_icon_color()


## Reapplies the various textures for our button.
func _refresh_shape() -> void:
	if not is_inside_tree():
		return
	
	if Engine.is_editor_hint():
		if not _shine:
			# initialize variables to avoid nil reference errors in the editor when editing tool scripts
			_initialize_onready_variables()
	
	var textures: Array = _textures_by_shape[shape]
	texture_normal = textures[0]
	texture_pressed = textures[1]
	texture_hover = textures[0]


func _refresh_icon_position() -> void:
	_icon_node.position = size / 2 - _icon_node.size / 2


## When we gain focus, we reapply a bright cyan color for our texture, text and icons.
func _on_focus_entered() -> void:
	_hover_sound.pitch_scale = randf_range(0.95, 1.05)
	SfxKeeper.copy(_hover_sound).play()


## When the player hovers over us, we reapply a brighter color for our texture, text and icons.
func _on_mouse_entered() -> void:
	if disabled:
		return
	
	if is_inside_tree():
		# Wait a frame before applying mouse entered effects. We use a one-shot listener method instead of a yield
		# statement to avoid 'class instance is gone' errors.
		if not get_tree().is_connected("idle_frame", Callable(self, "_apply_mouse_entered_effects")):
			get_tree().connect("idle_frame", Callable(self, "_apply_mouse_entered_effects"))
	else:
		_apply_mouse_entered_effects()


## When the player hovers away from us, we reapply the normal color for our texture, text and icons.
func _on_mouse_exited() -> void:
	if disabled:
		return
	
	if is_inside_tree():
		# Wait a frame before applying mouse exited effects. We use a one-shot listener method instead of a yield
		# statement to avoid 'class instance is gone' errors.
		if not get_tree().is_connected("idle_frame", Callable(self, "_apply_mouse_exited_effects")):
			get_tree().connect("idle_frame", Callable(self, "_apply_mouse_exited_effects"))
	else:
		_apply_mouse_exited_effects()


func _on_Icon_resized() -> void:
	_refresh_icon_position()


## When the button's size changes, we apply the 'round_size_up' property instead of rounding to the nearest int.
##
## This allows a row of collapsible buttons to maintain their width, as long as two of them are being tweened in
## opposite directions simultaneously. Without this rounding fix, there is noticable jitter.
func _on_CandyButton_item_rect_changed() -> void:
	if size.x != int(size.x) or size.y != int(size.y):
		if _round_size_up:
			custom_minimum_size = Vector2(ceil(size.x), ceil(size.y))
		else:
			custom_minimum_size = Vector2(floor(size.x), floor(size.y))
		size = custom_minimum_size


func _on_GradientHelper_gradient_changed() -> void:
	_refresh_color()
