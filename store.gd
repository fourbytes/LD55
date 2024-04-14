extends Node

var score = 0
var tiles: Array[Tile] = []
var selected_tiles: Array[Tile] = []
var detectWord = DetectWord.new()

signal score_changed(new_score)
signal tiles_changed(new_tiles)
signal selected_tiles_changed(new_tiles)

func increment_score(amount = 1):
	score += amount
	score_changed.emit(score)

func add_random_tile(random_index: int):
	tiles.insert(random_index, Tile.new())
	tiles_changed.emit(tiles)
	
func delete_tiles(tilesToDelete: Array[Tile]):
	for tile in tilesToDelete:
		tiles.erase(tile)
		deselect_tile(tile)
	tiles_changed.emit(tiles)

func select_tile(tile: Tile):
	tile.isSelected = true
	selected_tiles.append(tile)
	selected_tiles_changed.emit(tiles)

func deselect_tile(tile: Tile):
	selected_tiles.erase(tile)
	tile.isSelected = false
	selected_tiles_changed.emit(tiles)

func deselect_all_tiles():
	selected_tiles = []
	for tile in tiles:
		tile.isSelected = false
	selected_tiles_changed.emit(tiles)
	
func submit_word():
	var word = ''
	var selected_tiles_clone = selected_tiles.duplicate()
	var word_score_points = 0
	for tile in selected_tiles_clone:
		word += tile.letter
		word_score_points += tile.get_score_points()
	if detectWord.is_word_recognised(word):
		delete_tiles(selected_tiles_clone)
		increment_score(word_score_points*len(word))
	else:
		print("DIDN'T RECOGNISE %s " % word)

func reset_game():
	selected_tiles = []
	tiles = []
	tiles_changed.emit(tiles)
	selected_tiles_changed.emit(selected_tiles)
	score = 0
	score_changed.emit(score)
