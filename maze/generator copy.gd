extends Reference

var Tile = preload("res://maze/tile.gd")

const STEPS = 2
const TILE_SIZE = 16
const TILE_OFFSET = 8

# local
var stack : Array
var deadend_stack : Array
var rng = RandomNumberGenerator.new()
var is_backtracing : bool = false;

# public
var size : Vector2 setget set_size, get_size
var start_point : Vector2 = Vector2(-1, -1) setget , get_start_point
var end_point : Vector2 = Vector2(-1, -1) setget , get_end_point
var tiles : Array setget , get_tiles

func _init(map_size : Vector2):
	self.size = map_size
	rng.randomize()
	
	# step 1 - Create a template tile
	create_tiles()
	
	# step 3 - Create starting point
	create_start_point()

	# step 2 - Create the maze
	create_maze()
	
	# step 4 - Create ending point
	create_end_point()

# setter/getter
func set_size(vector : Vector2):
	size.x = 2 * vector.x + 1
	size.y = 2 * vector.y + 1

func get_size() -> Vector2:
	return size

func get_tiles() -> Array:
	return tiles

func get_start_point() -> Vector2:
	return start_point

func get_start_point_coordinates() -> Vector2:
	var x = start_point.x * TILE_SIZE + TILE_OFFSET
	var y = start_point.y * TILE_SIZE + TILE_OFFSET

	return Vector2(x, y)

func get_end_point() -> Vector2:
	return end_point

func get_end_point_coordinates() -> Vector2:
	var x = end_point.x * TILE_SIZE + TILE_OFFSET
	var y = end_point.y * TILE_SIZE + TILE_OFFSET

	return Vector2(x, y)

# logics
func create_tiles():
	for x in size.x:
		tiles.append([])
		
		for y in size.y:
			var tile = Tile.new()
			
			if x == 0 || y == 0 :
				tile.type = Tile.TYPE_WALL
			elif x == size.x - 1 || y == size.y - 1:
				tile.type = Tile.TYPE_WALL
			elif x % 2 == 0 || y % 2 == 0:
				tile.type = Tile.TYPE_WALL
			else:
				tile.type = Tile.TYPE_PATH
				
			tile.position = Vector2(x, y)
			tiles[x].append(tile)

func create_maze():
	var current = start_point
	var neighbor : Vector2 = Vector2.ZERO
	
	tiles[current.x][current.y].set_visited()

	while current != null:
		neighbor = get_random_neighbor(current)
		
		if current == neighbor:
			if is_backtracing == false: 
				deadend_stack.append(current)
				
			current = stack.pop_front()
			is_backtracing = true			
		else: 
			
			if neighbor.x - current.x > 0:
				tiles[current.x + 1][current.y].set_type(Tile.TYPE_PATH)
			elif neighbor.x - current.x < 0:
				tiles[current.x - 1][current.y].set_type(Tile.TYPE_PATH)
			elif neighbor.y - current.y > 0:
				tiles[current.x][current.y + 1].set_type(Tile.TYPE_PATH)
			elif neighbor.y - current.y < 0:
				tiles[current.x][current.y - 1].set_type(Tile.TYPE_PATH)
					
			stack.push_front(current)
			
			current = neighbor
			tiles[current.x][current.y].set_visited()
			is_backtracing = false
				
func get_random_neighbor(current) -> Vector2:
	var possible_neighbors: Array = []

	# top
	if current.y - STEPS >= 0:
		if !tiles[current.x][current.y - STEPS].has_visited():
			possible_neighbors.append(Vector2(current.x, current.y - STEPS))
	
	# right
	if current.x + STEPS < size.x:
		if !tiles[current.x + STEPS][current.y].has_visited():
			possible_neighbors.append(Vector2(current.x + STEPS, current.y))
		
	# bottom
	if current.y + STEPS < size.y:
		if !tiles[current.x][current.y + STEPS].has_visited():
			possible_neighbors.append(Vector2(current.x, current.y + STEPS))
	
	# left
	if current.x - STEPS >= 0:
		if !tiles[current.x - STEPS][current.y].has_visited():
			possible_neighbors.append(Vector2(current.x - STEPS, current.y))
	
	# pick a random neighbor
	if possible_neighbors.size() > 0:
		var random_index : int = int(round(rng.randi_range(0, possible_neighbors.size() - 1)))
		return possible_neighbors[random_index]
	
	return current

func create_start_point():
	var random_x : int
	var random_y : int

	while start_point == Vector2(-1, -1):
		random_x = rng.randi_range(1, size.x - 2)
		random_y = rng.randi_range(1, size.y - 2)

		if tiles[random_x][random_y].get_type() == Tile.TYPE_PATH:
			tiles[random_x][random_y].set_type(Tile.TYPE_START_POINT)
			start_point = Vector2(random_x, random_y)
			
func create_end_point():
	while end_point == Vector2(-1, -1):
		var random_idx = round(rng.randi_range(0, deadend_stack.size() - 1))
		var random_deadend = deadend_stack[random_idx]
		
		if tiles[random_deadend.x][random_deadend.y].get_type() == Tile.TYPE_PATH:
			end_point = tiles[random_deadend.x][random_deadend.y].position
			tiles[end_point.x][end_point.y].set_type(Tile.TYPE_END_POINT)
