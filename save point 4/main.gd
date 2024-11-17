extends Node2D

const almond = preload("res://almond.tscn")
const coffee = preload("res://coffee.tscn")
const hazelnut = preload("res://hazelnut.tscn")
const macadamia = preload("res://macadamia.tscn")
const nutmeg = preload("res://nutmeg.tscn")
const peacun = preload("res://peacun.tscn")

var rng = RandomNumberGenerator.new()
var sprite = null

var nut_type

var rng_no
var nut_no = 6

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

var merge_counter = 0
var Position
func _merge(a):
	a=a-1
	print(a)
	if a != 0:
		nut_type = nuts[a]
		merge_counter +=1
		print("current count: ", merge_counter)
		if merge_counter == 2:
			Merge()
	else:
		print("end game")
func Merge():
	var nut = nut_type.instantiate()
	nut.position = Position
	get_parent().add_child(nut)
	nut.connect("merge",_merge)
	nut.connect("_position",Set)
	merge_counter = 0
func Set(value):
	Position = value

func _physics_process(_delta):
	_preview(nut_no)
	
	if Input.is_action_just_pressed("drop"):
		
		print("drop the nut")
		
		nut_type = nuts[nut_no]
		var nut = nut_type.instantiate()
		
		var mouse = get_global_mouse_position()
		nut._set_position(mouse.x, %spawn.position.y)
		get_parent().add_child(nut)
#		for some reason if i delete the get parent from the line above the nuts wont despawn. weird
		nut.connect("merge", _merge)
		nut.connect("_position",Set)
		
		print("nut dropped")
		
		rng_no = rng.randi_range(0,21)
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
		
		#21 15 10 6 3 1 0
