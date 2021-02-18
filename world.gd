extends Node2D

var Tile = preload("res://maze/tile.gd")
var MazeGenerator = preload("res://maze/generator.gd")

export(int, 3, 320, 1) var map_size_x : int = 10
export(int, 3, 320, 1) var map_size_y : int = 10

var actual_map_size : Vector2
var tiles : Array = []

func _ready():
	self.actual_map_size.x = map_size_x + map_size_x + 1
	self.actual_map_size.y = map_size_y + map_size_y + 1

	self.tiles = MazeGenerator.new(self.actual_map_size).get_tiles()
	self.draw_tiles()

func draw_tiles():
	for col in self.actual_map_size.x:
		for row in self.actual_map_size.y:
			var tile_map : TileMap = self.get_node("TileMap")
			var tile_name : String = tiles[col][row].type
			var tile_set_idx : int = tile_map.tile_set.find_tile_by_name(tile_name)
			
			tile_map.set_cell(col, row, tile_set_idx)
