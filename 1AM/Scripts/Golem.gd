extends KinematicBody2D

const GRAVITY = 110
var damage = 20
var velocity = Vector2()
export var direction = 1
export var health = 250
export var speed = 100
const value = 1000
signal dead
var rock = preload("res://Enemies//Rock.tscn")

var animation = "Walk"

func dead():
	animation = "Death" #Set animation to death animation
	speed = 0
	set_collision_layer_bit(4, false) #Turn off platform detection
	$Area2D.set_monitoring(false) #Turn off player detection
	
func _ready(): #Responds to what direction the enemy is initialized to face
	if direction == -1:
		scale.x = -scale.x

func _physics_process(_delta):
	#Flips enemy if it touches wall or reaches cliff
	if is_on_wall() or not $floor_checker.is_colliding() and is_on_floor():
		scale.x = -scale.x 
		direction = direction * -1
	#Detects what the enemy health is
	if health > 0:
		velocity.x = speed * direction
		velocity.y += GRAVITY
		velocity = move_and_slide(velocity, Vector2.UP)
		if $Player_Detect.is_colliding():
			animation = "Arm_Shot"
			speed = 0
	elif health<=0:
		dead()
		$Timer.stop()
	#Plays whatever animation is loaded
	$AnimationPlayer.play(animation)

func _on_Area2D_body_entered(body): #A kinematic body enters a collision box
	if body.get_collision_layer() == 1: #Hurt player entering area
		body.ouch(position.x, damage)
	if body.get_collision_layer() == 2: #Deal damage to enemy 
		health = health - body.damage 
		body.queue_free()
		#Enemy blinks red when taking damage
		set_modulate(Color(1,0.3,0.3,0.9))
		yield(get_tree().create_timer(0.25), "timeout")
		set_modulate(Color("ffffff"))

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "Death": #If enemy has finished death animation
		emit_signal("dead", value) #Add appropriate points
		queue_free() #Removes entire node from tree
	elif anim_name == "Arm_Shot": #If enemy has finished arm shot
		animation = "Walk"
		var shot = rock.instance()
		shot.direction = direction
		get_parent().add_child(shot)
		shot.position.y = position.y - 15
		shot.position.x = position.x + 60 * direction
		speed = 100
	elif anim_name == "Regen": #If enemy is regenerating health
		animation = "Walk"
		speed = 100
		$Player_Detect.enabled = true

func _on_Timer_timeout(): #Initiate health regeneration every 10 seconds
	if health < 250:
		if health + 50 > 250:
			health = 250
		else:
			health += 50
	animation = "Regen"
	$Player_Detect.enabled = false
	speed = 0
