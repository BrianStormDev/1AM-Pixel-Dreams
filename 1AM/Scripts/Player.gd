extends KinematicBody2D

enum States {AIR, FLOOR}
var state = States.AIR

#Weapon variables
export var weapon = preload("res://Weapons//Paper Shuriken.tscn")

#Movement variables
export var GRAVITY = 100
export var MAXFALLSPEED = 400
export var MAXSPEED = 250
export var JUMPFORCE = 800
var ACCEL = 50
var motion = Vector2()
var facing_right = true
var jump_count = 0
var on_ground = false

#UI Variables
var health = 100
onready var health_bar = get_node("../HealthBar/HealthBar")


#camera Variables
export var top_limit = 0
export var bottom_limit = 1130
export var right_limit = 13248
export var left_limit = 0

#audio variables
onready var Music = $BGMusic
export var bgmusic = preload("res://SFX_Imports/1. Palm Tree Shade.mp3")

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
	
	match state:
		States.AIR:
			if is_on_floor():
				state = States.FLOOR
				jump_count = 0
				continue
			$AnimatedSprite.play("FALL")
			if Input.is_action_pressed("right"):
				motion.x += ACCEL
				facing_right = true
			elif Input.is_action_pressed("left"):
				motion.x -=ACCEL
				facing_right = false
			else:
				motion.x = lerp(motion.x,0,0.2)
			move_and_fall()
		States.FLOOR:
			if not is_on_floor():
				state = States.AIR
				jump_count = 1
				continue
			if Input.is_action_pressed("right"):
				motion.x += ACCEL
				facing_right = true
				$AnimatedSprite.play("RUN")
			elif Input.is_action_pressed("left"):
				motion.x -=ACCEL
				facing_right = false
				$AnimatedSprite.play("RUN")
			else:
				$AnimatedSprite.play("IDLE")
				motion.x = lerp(motion.x,0,0.2)
			move_and_fall()
	
	if (Input.is_action_just_pressed("shoot") and reload.is_stopped()):
		reload.start(reload_time)
		shoot()
	
	if not reload.is_stopped():
		$AnimatedSprite.play("THROW")
		
	if facing_right == true:
		$AnimatedSprite.scale.x = 1
	else:
		$AnimatedSprite.scale.x = -1
	
	if Input.is_action_just_pressed("jump"):
		if jump_count < 2:
			jump_count += 1
			motion.y = -JUMPFORCE
			$Jump.play()
	
	if health <= 0:
		die()
	
	motion.x = clamp(motion.x, -MAXSPEED,MAXSPEED)

func _on_Rest_timeout():
	set_collision_layer_bit(1, false)
	set_collision_mask_bit(3, false)

func die():
	set_collision_layer_bit(1, true)
	var _gameover = get_tree().change_scene("res://UI/GameOver.tscn")

func move_and_fall():
	motion.y += GRAVITY
	if motion.y > MAXFALLSPEED:
		motion.y = MAXFALLSPEED
	motion = move_and_slide(motion,Vector2.UP)

func ouch(var enemyposx, var damage):
	$Hurt.play()
	health = health - damage
	health_bar.set_value(health)
	set_modulate(Color(1,0.3,0.3,0.3))
	motion.y = -500
	if position.x < enemyposx:
		motion.x = -800
	elif position.x > enemyposx:
		motion.x = 800
	Input.action_release("left")
	Input.action_release("right")
	set_collision_layer_bit(1, true)
	set_collision_mask_bit(3, true)
	$Rest.start()
	for i in 4:
		set_modulate(Color(1,0.3,0.3,0.3))
		yield(get_tree().create_timer(0.25), "timeout")
		set_modulate(Color("#65ffffff"))
		yield(get_tree().create_timer(0.25), "timeout")
	set_modulate(Color("ffffff"))
