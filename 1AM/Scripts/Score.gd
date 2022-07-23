extends CanvasLayer

var points = 0

func _ready():
	$Points.text = String(points)
#TutorialMobs
func _on_Swan_dead(value):
	points += value
	_ready()
func _on_Plane_dead(value):
	points += value
	_ready()
#MathMobs
func _on_Angle_Biter_dead(value):
	points += value
	_ready()
func _on_Mafia_dead(value):
	points += value
	_ready()
func _on_MultMan_dead(value):
	points += value
	_ready()

#EnglishMobs


#Chemistry Mobs
func _on_Crab_dead(value):
	points += value
	_ready()
func _on_Slime_dead(value):
	points += value
	_ready()

#ArtMobs
func _on_Statue_dead(value):
	points += value
	_ready()
func _on_Weeping_Angel_dead(value):
	points += value
	_ready()




