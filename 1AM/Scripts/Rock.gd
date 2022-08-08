extends KinematicBody2D

var SPEED = 300
var velocity = Vector2()
var direction = -1
var damage = 25
var wait_time = 3

func _ready():
	$Timer.start()
	if direction == 1:
		scale.x = -scale.x

func _physics_process(_delta):
	velocity.x = SPEED * direction
	velocity = move_and_slide(velocity, Vector2.UP)

func _on_Area2D_body_entered(body):
	if body.get_collision_layer() == 1:
		body.ouch(position.x, damage)

func _on_Timer_timeout():
	queue_free()
