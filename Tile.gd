class_name Tile
extends Node

const square_size = 50.0

var letter: String
var isSelected: bool = false

var letter_weights = {
	'E': 12.02, 'T': 9.10, 'A': 8.12, 'O': 7.68, 'I': 7.31,
	'N': 6.95, 'S': 6.28, 'R': 6.02, 'H': 5.92, 'D': 4.32,
	'L': 3.98, 'U': 2.88, 'C': 2.71, 'M': 2.61, 'F': 2.30,
	'Y': 2.11, 'W': 2.09, 'G': 2.03, 'P': 1.82, 'B': 1.49,
	'V': 1.11, 'K': 0.69, 'X': 0.17, 'Q': 0.11, 'J': 0.10,
	'Z': 0.07
}

func _init():
	var rng = RandomNumberGenerator.new()
	rng.randomize()  # Ensure a different seed each time the game starts
	
	var total_weight = 100.0
	var random_weight = rng.randf() * total_weight
	
	var cumulative_weight = 0.0
	for letter_char in letter_weights.keys():
		cumulative_weight += letter_weights[letter_char]
		if random_weight <= cumulative_weight:
			letter = letter_char
			break

func get_sprite():
	var sprite
	sprite = Sprite2D.new()
	sprite.texture = load("res://assets/sprites/alpha_tiles/letter_" + letter + ".png")
	var sprite_scale = Vector2(square_size / sprite.texture.get_width(), square_size / sprite.texture.get_height())
	sprite.set_scale(sprite_scale)
	return sprite
