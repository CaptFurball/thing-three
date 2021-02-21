extends Node2D

var Maze = preload("res://maze/maze.gd")
var Player = preload("res://player.tscn")
var Tile = preload("res://maze/tile.gd")

export(int, 3, 320, 1) var map_size_x : int = 10
export(int, 3, 320, 1) var map_size_y : int = 10

func _ready():
	var map_size : Vector2 = Vector2(map_size_x, map_size_y)
	var maze = Maze.new(map_size, 2, 1)
	var tiles = maze.create_maze()

	draw_tiles(tiles)

	var player = Player.instance()
	player.position = maze.start_tile
	add_child(player)


func draw_tiles(tiles):
	var x = tiles.size()
	var y = tiles[0].size()

	var tile_map : TileMap = get_node("TileMap")

	for col in x:
		for row in y:
			var tile_name : String = tiles[col][row].type
			var tile_set_idx : int = tile_map.tile_set.find_tile_by_name(tile_name)
			
			if tile_name == Tile.TYPE_PATH:
				var rng = RandomNumberGenerator.new()
				rng.randomize()
				
				tile_map.set_cell(col, row, tile_set_idx, rng.randi_range(0, 1), rng.randi_range(0, 1))
			else:
				tile_map.set_cell(col, row, tile_set_idx)
			
	tile_map.update_bitmask_region(Vector2.ZERO, Vector2(x - 1, y - 1))

func _get_subtile_coord(id):
	var tiles = $TileMap.tile_set
	var rect = Tile.tile_set.tile_get_region(id)
	var x = randi() % int(rect.size.x / tiles.autotile_get_size(id).x)
	var y = randi() % int(rect.size.y / tiles.autotile_get_size(id).y)
	return Vector2(x, y)
