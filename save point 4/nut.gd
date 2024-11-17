extends RigidBody2D

@onready var area = get_node("Area2D")
signal merge (int)
signal _position (Vector2i)

func _set_position(a,b):
	self.position.x = a
	self.position.y = b
