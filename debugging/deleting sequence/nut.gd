extends RigidBody2D

@onready var area = get_node("Area2D")
var nut_name
var root = get_parent()
signal merge_up(int)
signal new_position(Vector2i)
signal to_destroy

var nuts_name = {"almond": 3,
			"coffee": 6,
			"hazelnut": 2,
			"macadamia": 1,
			"nutmeg": 4,
			"peacun": 5}

func _remove_numbers(Name):
	Name.replace("0","")
	Name.replace("1","")
	Name.replace("2","")
	Name.replace("3","")
	Name.replace("4","")
	Name.replace("5","")
	Name.replace("6","")
	Name.replace("7","")
	Name.replace("8","")
	Name.replace("9","")
	return Name

func _set_position(a,b):
	self.position.x = a
	self.position.y = b

func _destruct():
	#body.queue_free()
	#queue_free()
	emit_signal("new_position",position)
	emit_signal("to_destroy",self)
	print("sent to queue")

#func _timer():
	#var timer = Timer.new()
	#timer.wait_time = 0.5
	#timer.one_shot = true
	#timer.connect("timeout",_destruct)
	#add_child(timer)
	#timer.start()

func _collision_handler(body):
	_get_nut_name(body)
	_delete_check(body)

func _get_nut_name(body):
	if body:
		var nut = body.get_parent()
		nut_name = _remove_numbers(nut.name)
		return nut.name

func _delete_check(body):
	if _remove_numbers(name) in nut_name:
		print("deleting")
		print(name)
		emit_signal("merge_up",nuts_name[name])
		_destruct()

func _ready():
	#""""
	#var collision_shape = get_node("CollisionShape")
	#"""
	area.area_entered.connect(_collision_handler)
