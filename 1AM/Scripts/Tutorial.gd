extends Node2D
var damage = 25
var enemy_count = 0
var enemies = 3

func _on_Area2D_body_entered(body):
	if body.get_collision_layer() == 1:
		body.ouch(position.x, damage)
		body.position.y = 400
		body.jump_count = 0
	if body.get_collision_layer() == 2:
		queue_free()


func _on_Angle_Biter_dead():
	enemy_count += 1
	
func _process(_delta):
	if enemies == enemy_count:
		pass


func _on_Finish_body_entered(body):
	get_tree().change_scene("res://UI//StageCleared.tscn")
