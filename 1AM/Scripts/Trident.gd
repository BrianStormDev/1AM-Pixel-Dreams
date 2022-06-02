extends KinematicBody2D

var velocity = Vector2()
var direction = 1
var speed = 800
var damage = 10


func _ready():
	$Timer.start()
	velocity.x = speed * direction
	var flip = false if direction==1 else true
	$Sprite.flip_v = flip

func _physics_process(delta):
	if is_on_wall():
		queue_free()
	velocity = move_and_slide(velocity, Vector2.UP)
	
func _on_Timer_timeout():
	queue_free()
