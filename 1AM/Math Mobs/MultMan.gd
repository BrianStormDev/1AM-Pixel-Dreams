extends KinematicBody2D

const GRAVITY = 110
const SPEED = 100
const Spit = preload("res://Enemies//Spit.tscn")

var damage = 10
var velocity = Vector2()
var health = 100
var direction = -1
export var switch_time = 3
export var reload_time = 1


func _ready():
	$Reload.start(reload_time)
	$Switch.start(switch_time)

func _physics_process(_delta):
	if health > 0:
		velocity.y = SPEED * direction
		velocity = move_and_slide(velocity, Vector2.UP)
	elif health <= 0:
		queue_free()


func _on_Reload_timeout():
	$AnimationPlayer.play("Mshootg")
	var bullet = Spit.instance()
	get_parent().add_child(bullet)
	bullet.set_modulate(Color("29ff04"))
	bullet.position.x = position.x -10
	bullet.position.y = position.y + 10


func _on_Area2D_body_entered(body):
	if body.get_collision_layer() == 1:
		body.ouch(position.x, damage)
	elif body.get_collision_layer() == 2:
		health = health - body.damage
		body.queue_free()
		set_modulate(Color(1,0.3,0.3,0.9))
		yield(get_tree().create_timer(0.25), "timeout")
		set_modulate(Color("ffffff"))


func _on_Switch_timeout():
	direction = direction * - 1
