extends KinematicBody2D

var velocity = Vector2()
const GRAVITY = 20
var damage = 20

func _physics_process(_delta):
	velocity.y += GRAVITY
	velocity = move_and_slide(velocity, Vector2.UP)
	if is_on_floor():
		$Sprite.visible = false
		$AnimatedSprite.play("BOOM")
		$Hitbox.monitoring = false

func _on_AnimatedSprite_animation_finished():
	queue_free()

func _on_Explosion_body_entered(body):
	if body.get_collision_layer() == 1:
		body.ouch(position.x, damage)

func _on_Hitbox_body_entered(body):
	if body.get_collision_layer() == 1:
		body.ouch(position.x, damage)
