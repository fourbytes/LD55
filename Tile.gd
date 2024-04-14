class_name Tile
extends Node

const square_size = 64.0
const MAX_DUPLICATE_LETTERS = 3
const MIN_VOWELS = 1
const VOWELS = ['A', 'E', 'I', 'O', 'U']

var letter: String
var isSelected: bool = false
var isHovered: bool = false

var default_letter_weights = {
	'E': 12.02, 'T': 9.10, 'A': 8.12, 'O': 7.68, 'I': 7.31,
	'N': 6.95, 'S': 6.28, 'R': 6.02, 'H': 5.92, 'D': 4.32,
	'L': 3.98, 'U': 2.88, 'C': 2.71, 'M': 2.61, 'F': 2.30,
	'Y': 2.11, 'W': 2.09, 'G': 2.03, 'P': 1.82, 'B': 1.49,
	'V': 1.11, 'K': 0.69, 'X': 0.17, 'Q': 0.11, 'J': 0.10,
	'Z': 0.07
}

var letter_score_points = {
	'A': 1, 'B': 3, 'C': 3, 'D': 2, 'E': 1, 'F': 4,
	'G': 2, 'H': 4, 'I': 1, 'J': 8, 'K': 5, 'L': 1,
	'M': 3, 'N': 1, 'O': 1, 'P': 3, 'Q': 10, 'R': 1,
	'S': 1, 'T': 1, 'U': 1, 'V': 4, 'W': 4, 'X': 8,
	'Y': 4, 'Z': 10
}

func _init():
	var rng = RandomNumberGenerator.new()
	rng.randomize()  # Ensure a different seed each time the game starts
	
	var letter_weights = default_letter_weights.duplicate()
	var requires_vowel = len(Store.tiles.filter(func(t: Tile): return VOWELS.has(t.letter))) < MIN_VOWELS
	
	for l in default_letter_weights.keys():
		if requires_vowel and not VOWELS.has(l):
			letter_weights.erase(l)
		if len(Store.tiles.filter(func(t: Tile): return t.letter == l)) >= MAX_DUPLICATE_LETTERS:
			letter_weights.erase(l)
		
	var total_weight = letter_weights.values().reduce(func(a, b): return a + b)
	var random_weight = rng.randf() * total_weight
	
	var cumulative_weight = 0.0
	for letter_char in letter_weights.keys():
		cumulative_weight += letter_weights[letter_char]
		if random_weight <= cumulative_weight:
			letter = letter_char
			break

func calculate_multiplier(length: float) -> float:
	var shift: float = 9.0  # This shifts the curve to the right
	var steepness: float = 0.4  # Controls the steepness of the curve
	var max_increase: float = 15.0  # Maximum increase over the base value of 1
	var exponent = -steepness * (length - shift)
	var denominator = 1.0 + exp(exponent)
	var multiplier = 1.0 + max_increase / denominator
	return multiplier

func get_score_points():
	return letter_score_points[letter] * calculate_multiplier(len(Store.selected_tiles))

func get_sprite():
	var sprite
	sprite = Sprite2D.new()
	sprite.texture = load("res://assets/sprites/alpha_tiles/Tile " + letter + ".png")
	var sprite_scale = Vector2(square_size / sprite.texture.get_width(), square_size / sprite.texture.get_height())
	sprite.set_scale(sprite_scale)
	return sprite
