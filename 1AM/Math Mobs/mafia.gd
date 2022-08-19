extends KinematicBody2D

const GRAVITY = 110
const SPEED = 100
const value = 500
const Bullet = preload ("res://Enemies//Spit.tscn")
var health = 100
var velocity = Vector2()
var direction = -1
var damage = 20
signal dead

func _ready():
	$Reload.start()

func _physics_process(_delta):
	if health > 0:
		velocity.x = SPEED * direction
		velocity.y += GRAVITY
		if is_on_wall() or not $floor_checker.is_colliding() and is_on_floor():
			scale.x = -scale.x
			direction = direction * -1
		velocity = move_and_slide(velocity, Vector2.UP)
	elif health <= 0:
		emit_signal("dead", value)
		queue_free()


func _on_Reload_timeout():
	$AnimationPlayer.play("shoot")
	var bullet = Bullet.instance()
	bullet.direction = direction
	bullet.SPEED = 200
	bullet.wait_time = 5
	get_parent().add_child(bullet)
	bullet.position.x = position.x + 30 * direction
	bullet.position.y = position.y - 10

func _on_Area2D_body_entered(body):
	if body.get_collision_layer() == 1:
		body.ouch(position.x, damage)
	if body.get_collision_layer() == 2:
		health = health - body.damage
		body.queue_free()
		set_modulate(Color(1,0.3,0.3,0.9))
		yield(get_tree().create_timer(0.25), "timeout")
		set_modulate(Color("ffffff"))
