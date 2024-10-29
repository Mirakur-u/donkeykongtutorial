extends CanvasLayer

class_name UI

@onready var score: Label = $MarginContainer/HBoxContainer/Score
@onready var win_label: Label = $MarginContainer/HBoxContainer/WinLabel
@onready var center_container: CenterContainer = $MarginContainer/CenterContainer

func show_lose_ui():
	center_container.show()

func show_win_ui():
	win_label.show()

func set_points(points:int):
	score.text = "Points: %d" %points



func _on_restart_button_pressed() -> void:
	get_tree().reload_current_scene()
