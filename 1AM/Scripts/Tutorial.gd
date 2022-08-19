extends Node2D
var damage = 25
export var OBJPTS = 10000
export var SPAWNX = 100
export var SPAWNY = 800
export var SPAWNF = 400

func _ready():
	for _fruit in $Fruits.get_children():
		_fruit.connect("collected", $Score, "_on_Fruit_collected")

func _on_Area2D_body_entered(body):
	if body.get_collision_layer() == 1:
		body.ouch(position.x, damage)
		body.position.y = SPAWNF
		body.jump_count = 0
	if body.get_collision_layer() == 2:
		queue_free()

func _on_Finish_body_entered(body):
	if int($Score/Points.text) >= OBJPTS:
		var _clear = get_tree().change_scene("res://UI//StageCleared.tscn")
	else:
		body.position.x = SPAWNX
		body.position.y = SPAWNY
		for i in 8:
			$Label16.set_modulate("#ff0000")
			yield(get_tree().create_timer(0.25), "timeout")
			$Label16.set_modulate("#ffff00")
			yield(get_tree().create_timer(0.25), "timeout")
