extends Nut

#these changes according to the nut
const no = 3
const Name = "almond"

#these are the same but need the individual const so here they are
func _collided(body):
	var nut = body.get_parent()
	if Name in nut.Name:
		emit_signal("merge",no)
		queue_free()

func _ready():
	area.area_entered.connect(_collided)
