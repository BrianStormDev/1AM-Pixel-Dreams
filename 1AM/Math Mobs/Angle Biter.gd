extends KinematicBody2D

const GRAVITY = 110
const SPEED = 100
export var damage = 30
export var health = 100
export var direction = 1
var velocity = Vector2()
signal dead

func _ready():
	if direction == -1:
		scale.x = -scale.x

func _physics_process(_delta):
	if health > 0:
		velocity.x=SPEED * direction
		$AnimationPlayer.play("Attack")
		velocity.y += GRAVITY
		
		if is_on_wall() or not $floor_checker.is_colliding() and is_on_floor():
			scale.x = -scale.x
			direction = direction * -1
			
		velocity = move_and_slide(velocity, Vector2.UP)
	elif health <= 0:
		emit_signal("dead")
		velocity.x = 0
		set_collision_layer_bit(4, true)
		$AnimationPlayer.play("dead")
	
func _on_Area2D_body_entered(body):
	if body.get_collision_layer() == 1:
		body.ouch(position.x, damage)
	elif body.get_collision_layer() == 2:
		body.queue_free()
		health = health - body.damage
		set_modulate(Color(1,0.3,0.3,0.9))
		yield(get_tree().create_timer(0.25), "timeout")
		set_modulate(Color("ffffff"))

func _on_AnimationPlayer_animation_finished(_anim_name):
	queue_free()
