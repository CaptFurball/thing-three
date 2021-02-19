extends Node2D

var MazeGenerator = preload("res://maze/generator.gd")
var Player = preload("res://player.tscn")

export(int, 3, 320, 1) var map_size_x : int = 10
export(int, 3, 320, 1) var map_size_y : int = 10

func _ready():
	var map_size : Vector2 = Vector2(map_size_x, map_size_y)
	var maze_generator = MazeGenerator.new(map_size)
	var tiles = maze_generator.get_tiles()

	draw_tiles(tiles)

	var player = Player.instance()
	player.position = maze_generator.get_start_point_coordinates()
	add_child(player)


func draw_tiles(tiles):
	var x = tiles.size()
	var y = tiles[0].size()

	for col in x:
		for row in y:
			var tile_map : TileMap = get_node("TileMap")
			var tile_name : String = tiles[col][row].type
			var tile_set_idx : int = tile_map.tile_set.find_tile_by_name(tile_name)
			
			tile_map.set_cell(col, row, tile_set_idx)
