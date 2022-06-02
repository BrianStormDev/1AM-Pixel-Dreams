extends Node

signal brightness_updated(value)


func update_brightness(value):
	emit_signal("brightness_updated", value)
	
func _on_HSlider_value_changed(value):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"),value)
	

