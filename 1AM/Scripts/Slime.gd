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
export var color_index = 0
var color = ["green", "blue", "red", "purple"]
var split = false

func _ready():
	if direction == -1:
		scale.x = -scale.x
	if color[color_index] == "red":
		walk = "RedWalk"
		death = "RedDeath"
		speed = 400
	elif color[color_index] == "blue":
		walk = "BlueWalk"
		death = "BlueDeath"
		speed = 200
	elif color[color_index] == "purple":
		walk = "BlueWalk"
		death = "BlueDeath"
		speed = 600
		$SlimeSheet.set_modulate(Color("a900ff"))
		

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
	if health<= 0:
		if split == false:
			var slime = load("res://Enemies/Slime.tscn") as PackedScene
			var Slime1 = slime.instance()
			Slime1.position.x = position.x + 10
			Slime1.position.y = position.y
			Slime1.direction = 1
			Slime1.color_index = color_index + 1
			Slime1.split = true
			get_parent().add_child(Slime1)
			var Slime2 = slime.instance()
			Slime2.position.x = position.x - 10
			Slime2.position.y = position.y
			Slime2.direction = -1
			Slime2.color_index = color_index + 1
			Slime2.split = true
			get_parent().add_child(Slime2)
		queue_free()
