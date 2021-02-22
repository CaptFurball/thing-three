extends Node2D

var Maze   = preload("res://maze/maze.gd")
var Player = preload("res://player.tscn")
var Tile   = preload("res://maze/tile.gd")

export(int, 5, 320, 1) var map_size_x : int = 10
export(int, 5, 320, 1) var map_size_y : int = 10
export var lane_width : int = 1
export var wall_width : int = 1

func _ready():
	var map_size : Vector2 = Vector2(map_size_x, map_size_y)
	var maze  = Maze.new(map_size, lane_width, wall_width)
	var tiles = maze.create_maze()

	draw_floor(tiles)
	draw_walls(tiles)
	
	var player = Player.instance()
	player.position = maze.start_tile * 16 + Vector2(8, 8)
	add_child(player)

func draw_floor(tiles):
	var x = tiles.size()
	var y = tiles[0].size()

	var tile_map : TileMap = get_node("Floor")

	for col in x:
		for row in y:
			var tile_name : String = tiles[col][row].type
			var tile_set_idx : int = tile_map.tile_set.find_tile_by_name(tile_name)
			
			if tile_name == Tile.TYPE_PATH:
				var rng = RandomNumberGenerator.new()
				rng.randomize()
				
				var sub_tile = self._get_subtile_coord(tile_set_idx)
				tile_map.set_cell(col, row, tile_set_idx, false, false, false, sub_tile)
			else:
				tile_map.set_cell(col, row, tile_set_idx)
			
	tile_map.update_bitmask_region(Vector2.ZERO, Vector2(x - 1, y - 1))

func draw_walls(tiles):
	var x = tiles.size()
	var y = tiles[0].size()

	var tile_map : TileMap = get_node("Wall")

	for col in x:
		for row in y:
			var tile_name : String = tiles[col][row].type
			var tile_set_idx : int = tile_map.tile_set.find_tile_by_name(tile_name)
			
			if tile_name == Tile.TYPE_WALL:
				tile_map.set_cell(col, row, tile_set_idx)
			
	tile_map.update_bitmask_region(Vector2.ZERO, Vector2(x - 1, y - 1))

func _get_subtile_coord(id):
	var tiles = $Floor.tile_set
	var rect = $Floor.tile_set.tile_get_region(id)
	var x = randi() % int(rect.size.x / tiles.autotile_get_size(id).x)
	var y = randi() % int(rect.size.y / tiles.autotile_get_size(id).y)
	return Vector2(x, y)
