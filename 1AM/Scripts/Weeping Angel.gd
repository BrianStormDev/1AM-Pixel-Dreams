extends KinematicBody2D

const GRAVITY = 110
var damage = 60
var velocity = Vector2()
export var direction = 1
export var health =150
export var speed = 20


func dead():
	speed = 0
	set_collision_layer_bit(4, false) 
	$Area2D.set_monitoring(false)
	
func _ready(): 
	if direction == 1:
		scale.x = -scale.x

func _physics_process(delta):
	
	if is_on_wall() or not $floor_checker.is_colliding() and is_on_floor():
		scale.x = -scale.x 
		direction = direction * -1
	
	if health > 0:
		velocity.x = speed * direction
		velocity.y += GRAVITY
		velocity = move_and_slide(velocity, Vector2.UP)
	elif health<=0:
		dead();

func _on_Area2D_body_entered(body): 
	if body.get_collision_layer() == 1: 
		body.ouch(position.x, damage)
	if body.get_collision_layer() == 2: 
		health = health - body.damage 
		body.queue_free() 
		set_modulate(Color(1,0.3,0.3,0.9))
		yield(get_tree().create_timer(0.25), "timeout")
		set_modulate(Color("ffffff"))
func _on_Movement_detection_body_entered(body):
	if body.get_collision_layer() == 1:
		if ((body.facing_right && direction == -1) || (!body.facing_right && direction == 1)):
			speed = 0


func _on_Movement_detection_body_exited(body):
	if body.get_collision_layer()== 1:
		speed=20
