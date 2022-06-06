extends KinematicBody2D

#Weapon variables
export var weapon = preload("res://Weapons//Paper Shuriken.tscn")

#Movement variables
export var GRAVITY = 20
export var MAXFALLSPEED = 200
var ACCEL = 10
var motion = Vector2()
var facing_right = true
var jump_count = 0
var on_ground = false
var health = 100
export var MAXSPEED = 250
export var JUMPFORCE = 650

export var top_limit = 0
export var bottom_limit = 1130
export var right_limit = 13248
export var left_limit = 0

#audio variables
onready var Music = $BGMusic
export var bgmusic = preload("res://SFX_Imports/bensound-funkyelement.mp3")

#timer variables
export var reload_time = 0.5
onready var reload := $Reload

func _ready():
	$Camera2D.limit_top = top_limit
	$Camera2D.limit_bottom = bottom_limit
	$Camera2D.limit_right = right_limit
	$Camera2D.limit_left = left_limit
	$BGMusic.stream = bgmusic
	$BGMusic.play()

func shoot():
	$AnimatedSprite.play("THROW")
	var direction = $AnimatedSprite.scale.x
	var shot = weapon.instance()
	shot.direction = direction 
	get_parent().add_child(shot)
	shot.position.y = position.y - 20
	shot.position.x = position.x + 10 * direction

func _physics_process(_delta):
	
	if (Input.is_action_just_pressed("shoot") and reload.is_stopped()):
		reload.start(reload_time)
		$AnimatedSprite.play("THROW")
		shoot()
	
	motion.y += GRAVITY
	if motion.y > MAXFALLSPEED:
		motion.y = MAXFALLSPEED
		
	if facing_right == true:
		$AnimatedSprite.scale.x = 1
	else:
		$AnimatedSprite.scale.x = -1
	motion.x = clamp(motion.x, -MAXSPEED,MAXSPEED)
	
	if Input.is_action_pressed("right"):
		motion.x += ACCEL
		facing_right = true
		$AnimatedSprite.play("RUN")
		if not reload.is_stopped():
			$AnimatedSprite.play("THROW")
	elif Input.is_action_pressed("left"):
		motion.x -=ACCEL
		facing_right = false
		$AnimatedSprite.play("RUN")
		if not reload.is_stopped():
			$AnimatedSprite.play("THROW")
	else:
		$AnimatedSprite.play("IDLE")
		motion.x = lerp(motion.x,0,0.2)
		
	
	if Input.is_action_just_pressed("jump"):
		if jump_count < 2:
			jump_count += 1
			motion.y = -JUMPFORCE
			on_ground = false
	
	if is_on_floor():
		if on_ground == false:
			on_ground = true
			jump_count = 0
	else:
		$AnimatedSprite.play("FALL")
		if not reload.is_stopped():
			$AnimatedSprite.play("THROW")
		if on_ground == true:
			on_ground = false
			jump_count = 1
	if motion.y < 0:
		pass
	elif motion.y > 0:
		motion.y += ACCEL
		
	
	motion = move_and_slide(motion,Vector2.UP)
	
	if health <= 0:
		die()

func ouch(var enemyposx, var damage):
	$Hurt.play()
	health = health - damage
	print (health)
	set_modulate(Color(1,0.3,0.3,0.3))
	motion.y = -500
	if position.x < enemyposx:
		motion.x = -8000
	elif position.x > enemyposx:
		motion.x = 8000
	Input.action_release("left")
	Input.action_release("right")
	Input.action_release("shoot")
	set_collision_layer_bit(1, true)
	$Rest.start()
	for i in 4:
		set_modulate(Color(1,0.3,0.3,0.3))
		yield(get_tree().create_timer(0.25), "timeout")
		set_modulate(Color("#65ffffff"))
		yield(get_tree().create_timer(0.25), "timeout")
	set_modulate(Color("ffffff"))
	
func _on_Rest_timeout():
	set_collision_layer_bit(1, false)

func die():
	set_collision_layer_bit(1, true)
	get_tree().change_scene("res://UI/GameOver.tscn")
