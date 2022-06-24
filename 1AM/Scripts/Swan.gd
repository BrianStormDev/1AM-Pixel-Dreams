extends KinematicBody2D

var velocity = Vector2()
var health = 100
var damage = 20
export var direction = 1
export var speed = 50

func _ready():
	if direction == -1:
		scale.x = -scale.x

func _process(_delta):
	
	if is_on_wall() or not $floor_checker.is_colliding() and is_on_floor():
		scale.x = -scale.x
		direction = direction * -1
	velocity.y += 20
	velocity.x = speed * direction
	$SwanSheet.play()
	velocity = move_and_slide(velocity, Vector2.UP)
	
	if health <= 0:
		queue_free()

func _on_Area2D_body_entered(body):
	if body.get_collision_layer() == 1:
		body.ouch(position.x, damage)
	if body.get_collision_layer() == 2:
		health = health - body.damage
		body.queue_free()
		set_modulate(Color(1,0.3,0.3,0.9))
		yield(get_tree().create_timer(0.25), "timeout")
		set_modulate(Color("ffffff"))
