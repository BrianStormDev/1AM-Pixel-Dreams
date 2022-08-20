extends Control

func _ready():
	randomize()  # initialize RNG for fruit frames

func _on_L0_pressed():
	get_tree().paused = false
	var _tutorial = get_tree().change_scene("res://Tutorial.tscn")

func _on_L1_pressed():
	get_tree().paused = false
	var _math = get_tree().change_scene("res://Math.tscn")

func _on_L2_pressed():
	get_tree().paused = false
	var _english = get_tree().change_scene("res://English.tscn")

func _on_L3_pressed():
	get_tree().paused = false
	var _art = get_tree().change_scene("res://Art.tscn")

func _on_L4_pressed():
	get_tree().paused = false
	var _chemistry = get_tree().change_scene("res://Chemistry.tscn")
