extends KinematicBody2D

var velocity = Vector2()
var direction = 1
var speed = 350
var rotSpeed = 10
var hasGone = false
var gravity = 20
var color
var damage = 25
const floorSplash = preload("res://Image_Imports/Splash0.png")
const wallSplash = preload("res://Image_Imports/Splash01.png")


func _ready():
	$Particles2D.hide()
	velocity.x = speed * direction * 0.70711
	velocity.y = speed * -1.5
	randomize()
	var colors = [Color("1900f7"), Color("ff27d8"), Color("ff3000")]
	color = colors[randi()%3]
	set_modulate(color)
	
	
func _physics_process(_delta):
	$Sprite.rotation_degrees += rotSpeed * direction
	velocity.y += gravity
	
	if is_on_wall() && !hasGone:
		hasGone = true
		splash(wallSplash)
	if is_on_floor() && !hasGone:
		hasGone = true
		splash(floorSplash)
	if is_on_ceiling() && !hasGone:
		hasGone = true
		splash(wallSplash)
	
	velocity = move_and_slide(velocity, Vector2.UP)


func splash(splash):
	set_modulate(color)
	damage = 5
	$Sprite.set_texture(splash)
	var flipn = randi() % 2  # randomizes splash orientation
	var flip = true if flipn==1 else false
	$Sprite.flip_h = flip
	
	# Makes Area2D detection box larger for AOE damage effect
	$Area2D/CollisionShape2D.shape.extents = Vector2(25, 18)
	
	velocity = Vector2()  #Stops from moving
	gravity = 0
	rotSpeed = 0
	$Sprite.rotation_degrees = 0
	
	$Particles2D.show()  # Potion particles
	
	$AudioStreamPlayer2D.play()  # Acid sound
	

func _on_AudioStreamPlayer2D_finished():
	queue_free()

func _on_Area2D_body_entered(body):
	if body.get_collision_layer() == 4:
		splash(wallSplash)
