extends Node

var score = 0
var tiles: Array[Tile] = []

signal score_changed(new_score)
signal tiles_changed(new_tiles)

func increment_score():
	score += 1
	score_changed.emit(score)

func add_random_tile():
	tiles.append(Tile.new())
	tiles_changed.emit(tiles)
	
func delete_tiles(tiles: Array[Tile]):
	for tile in tiles:
		tiles.erase(tile)
	tiles_changed.emit(tiles)

func select_tile(tile: Tile):
	tile.select()
	tiles_changed.emit(tiles)

func deselect_tile(tile: Tile):
	tile.deselect()
	tiles_changed.emit(tiles)

func deselect_all_tiles():
	for tile in tiles:
		tile.deselect()
	tiles_changed.emit(tiles)
