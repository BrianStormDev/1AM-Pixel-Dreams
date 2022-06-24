extends KinematicBody2D

var velocity = Vector2()
var damage = 20
export var health = 100
export var direction = 1
export var speed = 500
onready var animatedSprite = $CrabSheet
onready var timer = $Timer

func _ready():
	if direction == -1:
		scale.x = -scale.x

func _process(_delta):
	if is_on_wall() or not $floor_checker.is_colliding() and is_on_floor():
		scale.x = -scale.x
		direction = direction * -1
	
	if health > 0:
		if timer.is_stopped():
			animatedSprite.animation = "CrabWalk"
			velocity.x = speed * direction
		else:
			animatedSprite.animation = "CrabAttack"
			velocity.x = 0
		animatedSprite.play()
		velocity.y += 20
		velocity = move_and_slide(velocity, Vector2.UP)
	elif health <= 0:
		queue_free()

func _on_Area2D_body_entered(body):
	if body.get_collision_layer() == 1:
		body.ouch(position.x, damage)
		timer.start()
	if body.get_collision_layer() == 2:
		body.queue_free()
		health = health - body.damage
		set_modulate(Color(1,0.3,0.3,0.5))
		yield(get_tree().create_timer(0.25), "timeout")
		set_modulate(Color("ffffff"))
