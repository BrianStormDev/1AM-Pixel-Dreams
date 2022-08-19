extends Control

var is_paused = false setget set_Paused

func _ready():
	visible = false

func _input(event):
	if event.is_action_pressed("pause"):
		self.is_paused = !is_paused
		visible = is_paused
		
func set_Paused(value):
	is_paused = value
	get_tree().paused = is_paused
	visible = is_paused

func _on_Resume_pressed():
	self.is_paused = false
	get_tree().paused = false

func _on_Quit_pressed():
	var _levels = get_tree().change_scene("res://UI//levels.tscn")
