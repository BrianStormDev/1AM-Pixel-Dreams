extends KinematicBody2D

var velocity = Vector2()
var damage = 20
var health = 100
const value = 500
export var speed = 200
export var direction = -1
export var switch_time = 6
const BOMB = preload("res://Enemies/Bomb.tscn")
signal dead

func _ready():
	if direction == 1:
		$Sprite.flip_h = true
	$Reload.start() 
	$Switch.start(switch_time)


func _process(_delta):
	if health > 0:
		velocity = move_and_slide(velocity, Vector2.UP)
		velocity.x = speed*direction
	elif health <= 0:
		emit_signal("dead", value)
		queue_free()

func _on_Area2D_body_entered(body):
	if body.get_collision_layer() == 1:
		body.ouch(position.x, damage)
	elif body.get_collision_layer() == 2:
		health = health - body.damage
		body.queue_free()
		set_modulate(Color(1,0.3,0.3,0.9))
		yield(get_tree().create_timer(0.25), "timeout")
		set_modulate(Color("ffffff"))

func _on_Reload_timeout():
	var bomb = BOMB.instance()
	get_parent().add_child(bomb)
	bomb.position.x = position.x
	bomb.position.y = position.y + 10

func _on_Switch_timeout():
	scale.x = -scale.x
	direction = direction * -1
