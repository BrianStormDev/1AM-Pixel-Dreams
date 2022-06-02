extends KinematicBody2D

var velocity = Vector2()
var direction = 1
var speed = 400
var rotSpeed = 15
var hasGone = false
var damage = 15

func _ready():
	$AudioStreamPlayer2D.play()
	$Timer.start()
	velocity.x = speed * direction
	var flip = false if direction==1 else true
	$Sprite.flip_h = flip
	
	
func _physics_process(_delta):
	$Sprite.rotation_degrees += rotSpeed * direction
	
	if is_on_wall() && !hasGone:
		hasGone = true
		queue_free()
	
	velocity = move_and_slide(velocity, Vector2.UP)


func _on_Timer_timeout(): #to better adjust weapon delay
	$Timer.stop()
	queue_free()
