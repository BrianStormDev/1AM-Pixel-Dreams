extends KinematicBody2D

var velocity = Vector2()
var aim_direction = Vector2.RIGHT
var direction = 1
var damage = 5
const SPEED = 400
const DROP = preload("res://Weapons//Drop.tscn")

func _ready():
	velocity.x = SPEED * direction
	$Timer.start()

func _physics_process(_delta):
	velocity = move_and_slide(velocity, Vector2.UP)
	$Sprite.rotation_degrees += 25
	
	if is_on_wall():
		queue_free()

func _on_Timer_timeout():
	queue_free()
	for angle in [-45, -20, 0, 20, 45]:
		var droplet = DROP.instance()
		var radians = deg2rad(angle)
		droplet.direction = direction
		get_parent().add_child(droplet)
		droplet.position.x = position.x
		droplet.position.y = position.y
		droplet.aim_direction = aim_direction.rotated(radians)
		
