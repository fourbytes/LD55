extends Node

var score = 0
var available_letters: Array[Tile] = []
var selected_letters = {}

signal score_changed(new_score)
signal available_letters_changed(new_letters)
signal selected_letters_changed(new_selected_letters)

func increment_score():
	score += 1
	score_changed.emit(score)

func add_available_letter():
	available_letters.append(Tile.new())
	
func clear_available_letters(tiles: Array[Tile]):
	for tile in tiles:
		available_letters.erase(tile)

func select_letter(letter: String):
	assert(len(letter) == 1)
	var random_index = randi() % (len(available_letters_changed) + 1)
	# Insert the letter at the random index
	selected_letters_changed.emit(selected_letters)

func unselect_letter(letter: String):
	assert(len(letter) == 1)
	selected_letters.erase(letter)
	selected_letters_changed.emit(selected_letters)

func reset_selected_letters():
	selected_letters = []
	selected_letters_changed.emit(selected_letters)
