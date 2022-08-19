extends Area2D

const value = 10

signal collected

func _ready():
	$Sprite.frame = randi() % 228

func _on_Area2D_body_entered(body):
	if body.collision_layer == 1:
		body.heal(40)
		emit_signal("collected", 250)
		queue_free()
