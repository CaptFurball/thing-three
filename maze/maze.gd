extends Reference

var Tile = preload("res://maze/tile.gd")

const OUTER_BORDER_WIDTH = 1

# TODO: Temporary hard coded, find a way to populate itself within parameters 
const MAX_ROOMS = 10
#############################################################################

var is_backtrace_mode : bool = false

var size : Vector2
var lane_width : int = 1
var inner_border_width : int = 1
var tiles : Array = [] setget , get_tiles
var start_tile : Vector2 = Vector2.ZERO setget , get_start_tile
var end_tile : Vector2 = Vector2.ZERO setget , get_end_tile

var path_stack : Array = []
var dead_stack : Array = []
var rng : RandomNumberGenerator = RandomNumberGenerator.new()

func _init(total_lanes : Vector2, _lane_width : int = 1, _inner_border_width : int = 1):
	if _lane_width < 1:
		return -1

	self.lane_width = _lane_width
	self.inner_border_width = _inner_border_width

	self.size.x = (total_lanes.x * _lane_width) + ((total_lanes.x - 1) * _inner_border_width) + 2 * self.OUTER_BORDER_WIDTH
	self.size.y = (total_lanes.y * _lane_width) + ((total_lanes.y - 1) * _inner_border_width) + 2 * self.OUTER_BORDER_WIDTH

	rng.randomize()

func get_tiles() -> Array:
	return tiles

func get_start_tile() -> Vector2:
	return start_tile

func get_end_tile() -> Vector2:
	return end_tile

func create_maze():
	self._create_walls()
	self._create_paths()	
	self._create_start_tile()
	self._create_end_tile()
	self._create_rooms()	
	return self.tiles

func _create_walls():
	for row in self.size.y:
		self.tiles.append([])

		for col in self.size.x:
			var tile = Tile.new()
			tile.set_wall()
			tile.set_position(row, col)
			self.tiles[row].append(tile)	

func _create_paths():
	var current_position = Vector2(1, 1)
	var current_rect : Rect2 

	var neighbor_position = Vector2.ZERO
	var neighbor_rect : Rect2

	var path_rect : Rect2

	self.tiles[current_position.x][current_position.y].set_visited()

	while current_position != null:
		neighbor_position = self._get_random_neighbor(current_position)

		if neighbor_position == null:
			if !self.is_backtrace_mode:
				self.dead_stack.append(current_position)
			
			current_position = self.path_stack.pop_front()
			self.is_backtrace_mode = true

		else:
			current_rect = self._create_rect(current_position)
			neighbor_rect = self._create_rect(neighbor_position)

			path_rect = current_rect.merge(neighbor_rect)

			for row in range(path_rect.position.y, path_rect.end.y):
				for col in range(path_rect.position.x, path_rect.end.x):
					self.tiles[col][row].set_path()
					self.tiles[col][row].set_visited()

			self.path_stack.push_front(current_position)

			current_position = neighbor_position
			self.is_backtrace_mode = false

func _get_random_neighbor(point : Vector2):
	var possible_neighbors : Array = []
	var steps : int = self.lane_width + self.inner_border_width

	# top
	if point.y - steps >= 0 && !self.tiles[point.x][point.y - steps].has_visited():
		possible_neighbors.append(Vector2(point.x, point.y - steps))
		
	# right
	if point.x + steps < self.size.x && !self.tiles[point.x + steps][point.y].has_visited():
		possible_neighbors.append(Vector2(point.x + steps, point.y))

	# bottom
	if point.y + steps < self.size.y && !self.tiles[point.x][point.y + steps].has_visited():
		possible_neighbors.append(Vector2(point.x, point.y + steps))

	# left
	if point.x - steps >= 0 && !self.tiles[point.x - steps][point.y].has_visited():
		possible_neighbors.append(Vector2(point.x - steps, point.y))

	randomize()
	possible_neighbors.shuffle()

	return possible_neighbors.pop_front()

func _create_start_tile():
	self.dead_stack.shuffle()
	self.start_tile = self.dead_stack.pop_front()
	self.tiles[self.start_tile.x][self.start_tile.y].set_start_tile()

func _create_end_tile():
	self.dead_stack.shuffle()
	self.end_tile = self.dead_stack.pop_front()
	self.tiles[self.end_tile.x][self.end_tile.y].set_end_tile()

func _create_rooms():
	self.dead_stack.shuffle()
	
	var position : Vector2

	var map_rect : Rect2 = Rect2(Vector2(1, 1), Vector2(self.size.x - 3, self.size.y - 3))
	var map_area : float = map_rect.get_area()

	for i in self.MAX_ROOMS:
		position = self.dead_stack.front()

		var room = Rect2(position, Vector2(self.lane_width * 2 + self.inner_border_width, self.lane_width * 2 + self.inner_border_width))

		if map_rect.encloses(room) && room.get_area() < map_area:
			map_area -= room.get_area()

			for row in range(room.position.y, room.end.y):
				for col in range(room.position.x, room.end.x):
					self.tiles[col][row].set_path()

func _create_rect(position : Vector2):
	return Rect2(position, Vector2(self.lane_width, self.lane_width))
