extends Node2D

const almond = preload("res://almond.tscn")
const coffee = preload("res://coffee.tscn")
const hazelnut = preload("res://hazelnut.tscn")
const macadamia = preload("res://macadamia.tscn")
const nutmeg = preload("res://nutmeg.tscn")
const peacun = preload("res://peacun.tscn")

"""
@onready var almond = get_node("almond")
@onready var coffee = get_node("coffee")
@onready var hazelnut = get_node("hazelnut")
@onready var macadamia = get_node("macadamia nuts")
@onready var nutmeg = get_node("nutmeg")
@onready var peacun = get_node("peacun")
"""

var rng = RandomNumberGenerator.new()
var sprite = null
var rng_no
var nut_no = 6
@onready var new_nut_position = %spawn.position

var destroy_queue = []

var nuts = {3 : almond,
			6 : coffee,
			2 : hazelnut,
			1 : macadamia,
			4 : nutmeg,
			5 : peacun}
var nuts_name = {3 : "almond",
			6 : "coffee",
			2 : "hazelnut",
			1 : "macadamia",
			4 : "nutmeg",
			5 : "peacun"}

func _delete_preview():
	sprite.queue_free()
	sprite = null

func _preview(a):
	if sprite:
		_delete_preview()
	var nut = nuts[a].instantiate()
	var og_sprite = nut.get_node("Sprite2D")
	sprite = og_sprite.duplicate()
	sprite.position = %preview.position
	get_parent().add_child(sprite)

func _set_new_position(_position):
	new_nut_position=_position

func _merge(a):
	a=a-1
	print(a)
	if a != 0:
		var nut_type = nuts[a]
		var nut = nut_type.instantiate()
		nut._set_position(new_nut_position.x, new_nut_position.y)
		get_parent().add_child(nut)
		nut.name = nuts_name[a]
		nut.connect("merge_up", _merge)
		nut.connect("new_position", _set_new_position)
		nut.connect("to_destroy", _add_to_destroy_queue)
	else:
		print("end game")

func _add_to_destroy_queue(body):
	if body not in destroy_queue:
		destroy_queue.append(body)
		print(body.name, " added to destroy queue")

func _physics_process(_delta):
	_preview(nut_no)
	
	if Input.is_action_just_pressed("drop"):
		
		print("drop the nut")
		
		var nut_type = nuts[nut_no]
		var nut = nut_type.instantiate()
		
		var mouse = get_global_mouse_position()
		nut._set_position(mouse.x, %spawn.position.y)
		get_parent().add_child(nut)
#		for some reason if i delete the get parent from the line above the nuts wont despawn. weird
		
		nut.name = nuts_name[nut_no]
		nut.connect("merge_up", _merge)
		nut.connect("new_position", _set_new_position)
		nut.connect("to_destroy", _add_to_destroy_queue)
		
		print("nut dropped")
		
		rng_no = rng.randi_range(0,21)
		print(rng_no)
		if (rng_no<=21):
			nut_no = 6
		if(rng_no<=10):
			nut_no = 5
		if(rng_no<=7):
			nut_no = 4
		if(rng_no<=4):
			nut_no = 3
		if(rng_no<=2):
			nut_no =2
		if(rng_no==0):
			nut_no = 1
	
		"""
		var nut_position = nut.position
		nut_position.y = %spawn.position.y
		nut_position.x = mouse.x
		21 15 10 6 3 1 0
		"""
	
	for body in destroy_queue:
		body.queue_free()
		print("destroying...")
	destroy_queue.clear()
