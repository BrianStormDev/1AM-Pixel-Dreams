extends KinematicBody2D

var velocity = Vector2()
var walk = "GreenWalk"
var death = "GreenDeath"
var animation
var damage = 20
const JUMPFORCE = 50
export var health = 100
export var direction = 1
export var speed = 50
export var color = "green"

func _ready():
	if direction == -1:
		scale.x = -scale.x
	if color == "red":
		walk = "RedWalk"
		death = "RedDeath"
		speed = 400
	elif color == "blue":
		walk = "BlueWalk"
		death = "BlueDeath"
		speed = 200

func _process(_delta):
	if is_on_wall() or not $floor_checker.is_colliding() and is_on_floor():
		scale.x = -scale.x
		direction = direction * -1
	
	if health > 0:
		velocity.x = speed * direction
		$SlimeSheet.play(walk)
		velocity.y += 20
		velocity = move_and_slide(velocity, Vector2.UP)
	elif health <= 0:
		set_collision_layer_bit(4, false)
		$Area2D.set_monitoring(false)
		speed = 0
		animation = death
		$SlimeSheet.play(death)

func _on_Area2D_body_entered(body):
	if body.get_collision_layer() == 1:
		body.ouch(position.x, damage)
	if body.get_collision_layer() == 2:
		health = health - body.damage
		set_modulate(Color(1,0.3,0.3,0.9))
		yield(get_tree().create_timer(0.25), "timeout")
		set_modulate(Color("ffffff"))

func _on_SlimeSheet_animation_finished():
	if animation == death:
		queue_free()

#hello I am going to be wokring on this part of the project today 6/2
