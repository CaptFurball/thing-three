extends Node2D

var Maze   = preload("res://maze/maze.gd")
var Player = preload("res://player.tscn")
var Tile   = preload("res://maze/tile.gd")

export(int, 5, 320, 1) var map_size_x : int = 10
export(int, 5, 320, 1) var map_size_y : int = 10
export var lane_width : int = 1
export var wall_width : int = 1

onready var floor_map : TileMap = $Floor
onready var wall_map  : TileMap = $Wall

func _ready():
	var map_size : Vector2 = Vector2(map_size_x, map_size_y)
	var maze  = Maze.new(map_size, lane_width, wall_width)
	var tiles = maze.create_maze()

	self._draw_floor(tiles)
	self._draw_walls(tiles)
	self._set_player(maze.start_tile)

func _set_player(start_tile : Vector2):
	var player = Player.instance()
	player.position = start_tile * 16 + Vector2(8, 8)
	add_child(player)

func _draw_floor(tiles):
	for col in tiles.size():
		for row in tiles.front().size():
			var tile_name : String = tiles[col][row].type
			var tile_set_idx : int = self.floor_map.tile_set.find_tile_by_name(tile_name)
			
			if tile_name == Tile.TYPE_PATH:
				var sub_tile = self._get_subtile_coord(tile_set_idx)
				self.floor_map.set_cell(col, row, tile_set_idx, false, false, false, sub_tile)
			else:
				self.floor_map.set_cell(col, row, tile_set_idx)

func _draw_walls(tiles):
	for col in tiles.size():
		for row in tiles.front().size():
			var tile_name : String = tiles[col][row].type
			var tile_set_idx : int = self.wall_map.tile_set.find_tile_by_name(tile_name)
			
			if tile_name == Tile.TYPE_WALL:
				self.wall_map.set_cell(col, row, tile_set_idx)
			
	self.wall_map.update_bitmask_region(Vector2.ZERO, Vector2(tiles.size() - 1, tiles.front().size() - 1))

func _get_subtile_coord(id : int) -> Vector2:
	var tiles = self.floor_map.tile_set
	var rect  = tiles.tile_get_region(id)

	var x = randi() % int(rect.size.x / tiles.autotile_get_size(id).x)
	var y = randi() % int(rect.size.y / tiles.autotile_get_size(id).y)
	
	return Vector2(x, y)
