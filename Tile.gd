class_name Tile
extends Node

const MAX_INT = 9223372036854775807

var letter: String
var id: int

func _init():
	var rng = RandomNumberGenerator.new()
	rng.randomize()  # Ensure a different seed each time the game starts
	var ascii_value = rng.randi_range(65, 90)  # ASCII values from 65 to 90
	letter = char(ascii_value)
	id = randi()
