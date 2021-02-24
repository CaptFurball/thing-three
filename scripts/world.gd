extends Node2D

var Maze = preload("res://scripts/maze/maze.gd")
var Tile = preload("res://scripts/maze/tile.gd")
var Player = preload("res://player.tscn")
var TargetArea = preload("res://target_area.tscn")

export var fog_mode: bool = true
export(int, 5, 300, 1) var map_size_x : int = 10
export(int, 5, 300, 1) var map_size_y : int = 10
export var lane_width : int = 1
export var wall_width : int = 1

onready var floor_map : TileMap = $Floor
onready var wall_map : TileMap = $Wall
onready var fog : CanvasModulate = $Fog

func _ready():
	if fog_mode:
		fog.color = Color(0, 0, 0)
	else: 
		fog.color = Color(1, 1, 1)
		
	var map_size : Vector2 = Vector2(map_size_x, map_size_y)
	var maze = Maze.new(map_size, lane_width, wall_width)
	maze.create_maze()

	self._draw_floor(maze.get_tiles())
	self._draw_walls(maze.get_tiles())
	self._set_player(maze.start_tile)
	self._set_win_area(maze.end_tile * 16 + Vector2(8, 8))
	
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
			elif tile_name != Tile.TYPE_WALL:
				self.floor_map.set_cell(col, row, tile_set_idx)

func _draw_walls(tiles):
	for col in tiles.size():
		for row in tiles.front().size():
			var tile_name : String = tiles[col][row].type
			var tile_set_idx : int = self.wall_map.tile_set.find_tile_by_name(tile_name)
			
			if tile_name == Tile.TYPE_WALL:
				self.wall_map.set_cell(col, row, tile_set_idx)
			
	self.wall_map.update_bitmask_region(Vector2.ZERO, Vector2(tiles.size() - 1, tiles.front().size() - 1))

func _set_win_area(target_pos : Vector2):
	var target_area = TargetArea.instance()
	target_area.position = target_pos 
	add_child(target_area)

	target_area.connect("body_entered", self, "_on_TargetArea_body_entered")
	pass

func _get_subtile_coord(id : int) -> Vector2:
	var tiles = self.floor_map.tile_set
	var rect  = tiles.tile_get_region(id)

	var x = randi() % int(rect.size.x / tiles.autotile_get_size(id).x)
	var y = randi() % int(rect.size.y / tiles.autotile_get_size(id).y)
	
	return Vector2(x, y)

func _on_TargetArea_body_entered(body):
	if body.get_name() == "Player":
		print("win")
		pass
