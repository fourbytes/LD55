class_name GameSession

extends Node

const uuid_util = preload('res://uuid.gd')

var id;

# Called when the node enters the scene tree for the first time.
func _ready():
	id = uuid_util.v4()
	print('started session: ', id)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
