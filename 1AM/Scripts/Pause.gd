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

func _on_Resume_pressed():
	self.is_paused = false
	
func _on_Quit_pressed():
	get_tree().quit()

func _on_Main_Menu_pressed():
	get_tree().paused = false
	get_tree().change_scene("res://main menu.tscn")
	
	

func _on_HSlider_value_changed(value):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"),value)
	

func _on_BrightnessSlider_value_changed(value):
	GlobalSettings.update_brightness(value)


#func _on_Setting_pressed():
	#get_tree().paused = false
	#get_tree().change_scene("res://settings.tscn")
