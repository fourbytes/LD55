extends Node

var score = 0
var tiles: Array[Tile] = []
var selected_tiles: Array[Tile] = []
var detectWord = DetectWord.new()

signal score_changed(new_score)
signal tiles_changed(new_tiles)

func get_selected_tiles():
	return selected_tiles.duplicate()

func increment_score(amount = 1):
	score += amount
	score_changed.emit(score)

func add_random_tile():
	tiles.append(Tile.new())
	tiles_changed.emit(tiles)
	
func delete_tiles(tilesToDelete: Array[Tile]):
	for tile in tilesToDelete:
		tiles.erase(tile)
		deselect_tile(tile)

func select_tile(tile: Tile):
	tile.isSelected = true
	selected_tiles.append(tile)
	tiles_changed.emit(tiles)

func deselect_tile(tile: Tile):
	selected_tiles.erase(tile)
	tile.isSelected = false
	tiles_changed.emit(tiles)

func deselect_all_tiles():
	selected_tiles = []
	for tile in tiles:
		tile.isSelected = false
	tiles_changed.emit(tiles)
	
func submit_word():
	var word = ''
	var selectedTiles = get_selected_tiles()
	var word_score_points = 0
	for tile in selectedTiles:
		word += tile.letter
		word_score_points += tile.get_score_points()
	if detectWord.is_word_recognised(word):
		delete_tiles(selectedTiles)
		increment_score(word_score_points)
	else:
		print("DIDN'T RECOGNISE %s " % word)
