class_name Tile
extends Node

var letter: String
var isSelected: bool = false

func _init():
	var rng = RandomNumberGenerator.new()
	rng.randomize()  # Ensure a different seed each time the game starts
	var ascii_value = rng.randi_range(65, 90)  # ASCII values from 65 to 90
	letter = char(ascii_value)

func select():
	isSelected = true
	
func deselect():
	isSelected = false
