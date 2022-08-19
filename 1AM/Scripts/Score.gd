extends CanvasLayer

var points = 0

func _ready():
	$Points.text = String(points)
	
func _add_score(score):
	points += score
	$Points.text = String(points)
	
#TutorialMobs
func _on_Swan_dead(value):
	_add_score(value)
	$AudioStreamPlayer.play()
func _on_Plane_dead(value):
	_add_score(value)
	$AudioStreamPlayer.play()
	
#MathMobs
func _on_Angle_Biter_dead(value):
	_add_score(value)
	$AudioStreamPlayer.play()
func _on_Mafia_dead(value):
	_add_score(value)
	$AudioStreamPlayer.play()
func _on_MultMan_dead(value):
	_add_score(value)
	$AudioStreamPlayer.play()
	
#EnglishMobs
func _on_Golem_dead(value):
	_add_score(value)
	$AudioStreamPlayer.play()
func _on_Minotaur_dead(value):
	_add_score(value)
	$AudioStreamPlayer.play()

#ArtMobs
func _on_Statue_dead(value):
	_add_score(value)
	$AudioStreamPlayer.play()
func _on_Weeping_Angel_dead(value):
	_add_score(value)
	$AudioStreamPlayer.play()
	
#Chemistry Mobs
func _on_Crab_dead(value):
	_add_score(value)
	$AudioStreamPlayer.play()
func _on_Slime_dead(value):
	_add_score(value)
	$AudioStreamPlayer.play()

# Fruit Collection
func _on_Fruit_collected(value):
	_add_score(value)
	$AudioStreamPlayer.play()
	
