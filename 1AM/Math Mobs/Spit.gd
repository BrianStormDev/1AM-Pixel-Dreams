extends KinematicBody2D

var SPEED = 100
var velocity = Vector2()
var direction = -1
var damage = 20
var color = "ffffff"
var wait_time = 3

func _ready():
	$Timer.start(wait_time)
	if direction == 1:
		scale.x = -scale.x
	$Sprite.set_modulate(Color(color))

func _physics_process(_delta):
	velocity.x = SPEED * direction
	velocity = move_and_slide(velocity, Vector2.UP)

func _on_Area2D_body_entered(body):
	if body.get_collision_layer() == 1:
		body.ouch(position.x, damage)

func _on_Timer_timeout():
	queue_free()
