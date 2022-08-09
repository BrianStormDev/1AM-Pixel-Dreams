extends KinematicBody2D

const GRAVITY = 110
var damage = 30
var velocity = Vector2()
export var direction = 1
export var health = 100
export var speed = 400
var value = 500
signal dead

var animation = "Swalk"

func _ready(): #Responds to what direction the enemy is initialized to face
	if direction == -1:
		scale.x = -scale.x
	#hides sprites that belong to other animations
	$dead.hide()
	$attack.hide()

func dead():
	$dead.show()
	$movement.hide()
	$attack.hide()
	animation = "dead"; #Set animation to death animation
	speed = 0
	set_collision_layer_bit(4, false) #Turn off platform detection
	#Turn off player detection
	$movement/Area2D.set_monitoring(false) 
	$attack/Area2D.set_monitoring(false)

func _physics_process(delta):
	#Flips enemy if it touches wall or reaches cliff
	if is_on_wall() or not $floor_checker.is_colliding() and is_on_floor():
		scale.x = -scale.x 
		direction = direction * -1
	#Detects what the enemy health is
	if health > 0:
		velocity.x = speed * direction
		velocity.y += GRAVITY
		velocity = move_and_slide(velocity, Vector2.UP)
	elif health<=0:
		dead();
	#Plays whatever animation is loaded
	$AnimationPlayer.play(animation)

func _on_Area2D_body_entered(body): #A kinematic body enters a collision box
	if body.get_collision_layer() == 1: #Hurt player entering area
		body.ouch(position.x, damage)
	if body.get_collision_layer() == 2: #Deal damage to enemy 
		health = health - body.damage 
		body.queue_free() #projectile disappears on impact
		#Enemy blinks red when taking damage
		set_modulate(Color(1,0.3,0.3,0.9))
		yield(get_tree().create_timer(0.25), "timeout")
		set_modulate(Color("ffffff"))

func _on_AttackRadius_body_entered(body): #Enemy detects when to attack
	if body.get_collision_layer() == 1:
		$dead.hide()
		$movement.hide()
		$attack.show()
		speed = 0 #Stop for attack
		animation = "Attack"

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "Attack": #If enemy has finished an attack
		$attack.hide()
		$movement.show()
		speed = 400
		animation = "Swalk" 

	elif anim_name == "dead": #If enemy has finished death animation
		emit_signal("dead", value) #Add appropriate points
		queue_free() #Removes entire node from tree
