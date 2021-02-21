extends Reference

var Tile = preload("res://maze/tile.gd")

const OUTER_BORDER_THICKNESS = 1
const STEPS = 2

var is_backtrace_mode : bool = false

var size : Vector2
var tiles : Array = [] setget , get_tiles
var start_tile : Vector2 = Vector2.ZERO setget , get_start_tile
var end_tile : Vector2 = Vector2.ZERO setget , get_end_tile

var path_stack : Array = []
var dead_stack : Array = []
var rng : RandomNumberGenerator = RandomNumberGenerator.new()

func _init(lanes : Vector2):
	rng.randomize()
	self.size.x = lanes.x * 2 - 1 + self.OUTER_BORDER_THICKNESS * 2
	self.size.y = lanes.y * 2 - 1 + self.OUTER_BORDER_THICKNESS * 2

func get_tiles() -> Array:
	return tiles

func get_start_tile() -> Vector2:
	return start_tile

func get_end_tile() -> Vector2:
	return end_tile

func create_maze() -> Array:
	self._create_walls()
	self._create_paths()
	self._create_start_tile()
	self._create_end_tile()
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
	var current_position  = Vector2(1, 1)
	var neighbor_position = Vector2.ZERO

	self.tiles[current_position.x][current_position.y].set_visited()

	while current_position != null:
		neighbor_position = self._get_random_neighbor(current_position)

		if neighbor_position == null:
			if !self.is_backtrace_mode:
				self.dead_stack.append(current_position)
			
			current_position = self.path_stack.pop_front()
			self.is_backtrace_mode = true

		else:
			var distance : int = current_position.distance_to(neighbor_position)

			for i in distance + 1:
				var middle_tile : Vector2 = current_position.move_toward(neighbor_position, i)
				self.tiles[middle_tile.x][middle_tile.y].set_path()

			self.path_stack.push_front(current_position)

			current_position = neighbor_position

			self.tiles[current_position.x][current_position.y].set_visited()
			self.is_backtrace_mode = false

func _get_random_neighbor(point : Vector2):
	var possible_neighbors : Array = []

	# top
	if point.y - self.STEPS >= 0 && !self.tiles[point.x][point.y - self.STEPS].has_visited():
		possible_neighbors.append(Vector2(point.x, point.y - self.STEPS))
		
	# right
	if point.x + self.STEPS < self.size.x && !self.tiles[point.x + self.STEPS][point.y].has_visited():
		possible_neighbors.append(Vector2(point.x + self.STEPS, point.y))

	# bottom
	if point.y + self.STEPS < self.size.y && !self.tiles[point.x][point.y + self.STEPS].has_visited():
		possible_neighbors.append(Vector2(point.x, point.y + self.STEPS))

	# left
	if point.x - self.STEPS >= 0 && !self.tiles[point.x - self.STEPS][point.y].has_visited():
		possible_neighbors.append(Vector2(point.x - self.STEPS, point.y))

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
