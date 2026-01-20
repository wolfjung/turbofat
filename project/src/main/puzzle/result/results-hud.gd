class_name ResultsHud
extends Control
## Results screen shown after the player finishes a level.

## Emitted when the 'show_results_message' method is called, and the receipt pops out.
signal receipt_shown

## Emitted when Fat Sensei stamps the player's grade on the receipt.
signal stamped

## Receipt paper position when it is hidden
const POSITION_HIDDEN := Vector2(185, 800)

## Receipt paper position when it is shown
const POSITION_SHOWN := Vector2(185, 4)

@onready var _sfx_receipt_show := $Sfx/ReceiptShow
@onready var _sfx_receipt_hide := $Sfx/ReceiptHide

@onready var _receipt_paper := $Clipper/ReceiptPaper
@onready var _header := $Clipper/ReceiptPaper/Header
@onready var _table := $Clipper/ReceiptPaper/Table
@onready var _bar_graph := $Clipper/ReceiptPaper/BarGraph
@onready var _stamp := $Clipper/ReceiptPaper/Stamp
@onready var _medal := $Clipper/ReceiptPaper/Medal

## Directs the long animation of showing the receipt, building up a bar graph, and showing the player's grade.
@onready var _tween: Tween

## Briefly animates the receipt when it is stamped.
@onready var _shake_tween: Tween

func _ready() -> void:
	PuzzleState.connect("game_prepared", Callable(self, "_on_PuzzleState_game_prepared"))
	PuzzleState.connect("after_game_ended", Callable(self, "_on_PuzzleState_after_game_ended"))
	_receipt_paper.visible = false


## Animates the receipt when it is stamped, shaking it slightly.
func stamp() -> void:
	_shake_tween = Utils.recreate_tween(self, _shake_tween)
	_shake_tween.tween_property(_receipt_paper, "position:x", POSITION_SHOWN.x + 5, 0.04)
	_shake_tween.tween_property(_receipt_paper, "position:x", POSITION_SHOWN.x - 3, 0.04)
	_shake_tween.tween_property(_receipt_paper, "position:x", POSITION_SHOWN.x + 2, 0.04)
	_shake_tween.tween_property(_receipt_paper, "position:x", POSITION_SHOWN.x - 1, 0.04)
	_shake_tween.tween_property(_receipt_paper, "position:x", POSITION_SHOWN.x, 0.04)
	emit_signal("stamped")


func is_results_message_shown() -> bool:
	return _receipt_paper.visible


## Animates hiding the receipt, swooshing it offscreen.
func hide_results_message() -> void:
	if _receipt_paper.visible == false:
		# already hidden
		return
	
	var blueprint := ResultsHudBlueprint.new()
	
	_tween = Utils.recreate_tween(self, _tween)
	
	_sfx_receipt_hide.play()
	_tween.tween_property(_receipt_paper, "position:y", POSITION_HIDDEN.y, 0.2) \
			super.set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)
	_tween.tween_interval(0.2)
	_tween.tween_callback(Callable(_receipt_paper, "set").bind("visible", false))
	_tween.tween_callback(Callable(_bar_graph, "reset").bind(blueprint))
	_tween.tween_callback(Callable(_header, "reset").bind(blueprint))
	_tween.tween_callback(Callable(_table, "reset").bind(blueprint))
	_tween.tween_callback(Callable(_stamp, "reset").bind(blueprint))
	_tween.tween_callback(Callable(_medal, "reset").bind(blueprint))


## Animates showing the receipt, building up a bar graph, and showing the player's grade.
func show_results_message() -> void:
	if _receipt_paper.visible == true:
		# already shown
		return
	
	var blueprint := ResultsHudBlueprint.new()
	
	_sfx_receipt_show.play()
	_tween = Utils.recreate_tween(self, _tween)
	
	_receipt_paper.position.y = POSITION_HIDDEN.y
	_tween.tween_property(_receipt_paper, "position:y", POSITION_SHOWN.y, 0.2) \
			super.set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	
	_receipt_paper.visible = true
	_receipt_paper.modulate = Color.TRANSPARENT
	_tween.parallel().tween_property(_receipt_paper, "modulate", Color.WHITE, 0.1)
	
	_tween.tween_interval(0.4)
	
	_header.reset(blueprint)
	_tween.tween_callback(Callable(_header, "play").bind(blueprint))
	
	_tween.tween_interval(0.4)
	
	_table.reset(blueprint)
	_tween.tween_callback(Callable(_table, "play").bind(blueprint))
	_bar_graph.reset(blueprint)
	_tween.parallel().tween_callback(Callable(_bar_graph, "play").bind(blueprint))
	
	_tween.tween_interval(blueprint.total_duration())
	
	_stamp.reset(blueprint)
	_tween.tween_callback(Callable(_stamp, "play").bind(blueprint))
	
	_medal.reset(blueprint)
	if blueprint.should_show_medal():
		_tween.tween_interval(0.8)
		_tween.tween_callback(Callable(_medal, "play").bind(blueprint))
	
	emit_signal("receipt_shown")


## Immediately hides the receipt, blinking it offscreen and resetting any animations.
func reset() -> void:
	_tween = Utils.kill_tween(_tween)
	_receipt_paper.visible = false
	_receipt_paper.position = POSITION_HIDDEN


func _on_PuzzleState_game_prepared() -> void:
	hide_results_message()


func _on_PuzzleState_after_game_ended() -> void:
	var rank_result: RankResult = PlayerData.level_history.prev_result(CurrentLevel.settings.id)
	if not rank_result or CurrentLevel.settings.rank.skip_results:
		return
	
	show_results_message()
