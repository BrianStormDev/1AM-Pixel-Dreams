extends KinematicBody2D

const GRAVITY = 110
var damage = 50
var velocity = Vector2()
export var direction = 1
export var health = 150
export var speed = 0
const value = 1000
signal dead

func dead():
	speed = 0
	set_collision_layer_bit(4, false) 
	$Area2D.set_monitoring(false)
	emit_signal("dead", value)
	queue_free()
	
func _ready(): 
	if direction == 1:
		$Sprite.flip_h = !$Sprite.flip_h

func _physics_process(delta):
	if health > 0:
		velocity.x = speed * direction
		velocity.y += GRAVITY
		velocity = move_and_slide(velocity, Vector2.UP)
	elif health<=0:
		dead()
		
	if $LeftDetect.is_colliding() && $LeftDetect.get_collider().facing_right:
		speed = 500 * -direction
		$Sprite.set_frame(2)
	elif $RightDetect.is_colliding() && !$RightDetect.get_collider().facing_right:
		speed = -500 * -direction
		$Sprite.set_frame(1)
	else:
		speed = 0
		$Sprite.set_frame(0)

func _on_Area2D_body_entered(body): 
	if body.get_collision_layer() == 1: 
		body.ouch(position.x, damage)
	if body.get_collision_layer() == 2: 
		health = health - body.damage 
		body.queue_free() 
		set_modulate(Color(1,0.3,0.3,0.9))
		yield(get_tree().create_timer(0.25), "timeout")
		set_modulate(Color("ffffff"))
		
