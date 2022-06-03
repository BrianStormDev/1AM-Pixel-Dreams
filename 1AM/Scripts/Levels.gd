extends Control

var is_paused = false setget set_Paused

func _input(event):
	if event.is_action_pressed("pause"):
		self.is_paused = !is_paused
		visible = is_paused
		
func set_Paused(value):
	is_paused = value
	get_tree().paused = is_paused
	visible = is_paused

func _on_L0_pressed():
	get_tree().paused = false
	get_tree().change_scene("res://Tutorial.tscn")

func _on_L1_pressed():
	get_tree().paused = false
	get_tree().change_scene("res://Math.tscn")


func _on_L2_pressed():
	get_tree().paused = false
	get_tree().change_scene("res://English.tscn")

func _on_L3_pressed():
	get_tree().paused = false
	get_tree().change_scene("res://Art.tscn")


func _on_L4_pressed():
	get_tree().paused = false
	get_tree().change_scene("res://Chemistry.tscn")

func _on_Quit_pressed():
	get_tree().quit()

