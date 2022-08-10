extends KinematicBody2D

var aim_direction = Vector2.RIGHT
var direction = 1
var damage = 5

const splat1 = preload("res://Image_Imports/Splat1.png")
const splat2 = preload("res://Image_Imports/Splat2.png")
const splat3 = preload("res://Image_Imports/Splat3.png")
const splat4 = preload("res://Image_Imports/Splat4.png")
const splat5 = preload("res://Image_Imports/Splat5.png")
var speed = 400

func _ready():
	randomize()
	var colors = [randf(), 1, rand_range(0.8, 1)]
	#Saturation should be at 1, the rest of the values can vary (h,s,v)
	set_modulate(Color.from_hsv(colors[0], colors[1], colors[2]))
	$Timer.start()

func _physics_process(_delta):
	var _move = move_and_slide(aim_direction * speed * direction)
	if is_on_wall():
		splat()

func _on_Timer_timeout():
	splat()

func splat():
	var splats = [splat1, splat2, splat3, splat4, splat5]
	var splat = splats[randi() % splats.size()]
	$Sprite.set_texture(splat)
	speed = 0
	$AudioStreamPlayer2D.play()

func _on_AudioStreamPlayer2D_finished():
	queue_free()
