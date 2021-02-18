extends Reference

var Tile = preload("res://maze/tile.gd")

const STEPS = 2

var _map_size : Vector2
var start_point : Vector2 = Vector2(-1, -1)
var end_point : Vector2 = Vector2(-1, -1)
var tiles : Array
var stack : Array
var deadend_stack : Array
var rng = RandomNumberGenerator.new()
var is_backtracing : bool = false;

func _init(map_size : Vector2):
	self._map_size = map_size
	self.rng.randomize()
	
	# step 1 - Create a template tile
	self.create_tiles()
	
	# step 2 - Create the maze
	self.create_maze()
	
	# step 3 - Create starting point
	self.create_start_point()
	
	# step 4 - Create ending point
	self.create_end_point()

func get_tiles() -> Array:
	return self.tiles

func create_tiles():
	for col in self._map_size.x:
		if col + 1 > self.tiles.size():
			self.tiles.append([])
		
		for row in self._map_size.y:
			if  row + 1 > self.tiles[col].size():
				self.tiles[col].append([])
			
			var tile = Tile.new()
			
			if row == 0 || col == 0 || row == self._map_size.y - 1 || col == self._map_size.x - 1:
				tile.type = "wall"
			elif col % 2 == 0 || row % 2 == 0:
				tile.type = "wall"
			else:
				tile.type = "floor"
				
			tile.position.x = col
			tile.position.y = row
			self.tiles[col][row] = tile

func create_maze():
	var current = Vector2(5, 5)
	var neighbor : Vector2 = Vector2.ZERO
	
	self.tiles[current.x][current.y].set_visited()

	while current != null:
		neighbor = get_random_neighbor(current)
		
		if current == neighbor:
			if self.is_backtracing == false: 
				self.deadend_stack.append(current)
				
			current = self.stack.pop_front()
			self.is_backtracing = true			
		else: 
			if neighbor.x - current.x > 0:
				for i in range (current.x, neighbor.x + 1, 1):
					self.tiles[i][current.y].set_type(Tile.TYPE_PATH)
			elif neighbor.x - current.x < 0:
				for i in range (current.x, neighbor.x - 1, -1):
					self.tiles[i][current.y].set_type(Tile.TYPE_PATH)
			elif neighbor.y - current.y > 0:
				for i in range (current.y, neighbor.y + 1, 1):
					self.tiles[current.x][i].set_type(Tile.TYPE_PATH)
			elif neighbor.y - current.y < 0:
				for i in range (current.y, neighbor.y - 1, -1):
					self.tiles[current.x][i].set_type(Tile.TYPE_PATH)
					
			self.stack.push_front(current)
			
			current = neighbor
			self.tiles[current.x][current.y].set_visited()
			self.is_backtracing = false			

func get_random_neighbor(current) -> Vector2:
	var possible_neighbors: Array = []

	# top
	if current.y - self.STEPS >= 0:
		if !self.tiles[current.x][current.y - self.STEPS].has_visited():
			possible_neighbors.append(Vector2(current.x, current.y - self.STEPS))
	
	# right
	if current.x + self.STEPS < self._map_size.x:
		if !self.tiles[current.x + self.STEPS][current.y].has_visited():
			possible_neighbors.append(Vector2(current.x + self.STEPS, current.y))
		
	# bottom
	if current.y + self.STEPS < self._map_size.y:
		if !self.tiles[current.x][current.y + self.STEPS].has_visited():
			possible_neighbors.append(Vector2(current.x, current.y + self.STEPS))
	
	# left
	if current.x - self.STEPS >= 0:
		if !self.tiles[current.x - self.STEPS][current.y].has_visited():
			possible_neighbors.append(Vector2(current.x - self.STEPS, current.y))
	
	# pick a random neighbor
	if possible_neighbors.size() > 0:
		var random_index : int = int(round(self.rng.randf_range(0, possible_neighbors.size() - 1)))
		return possible_neighbors[random_index]
	
	return current

func create_start_point():
	while self.start_point == Vector2(-1, -1):
		var random_idx = round(self.rng.randf_range(0, self.deadend_stack.size() - 1))
		var random_deadend = self.deadend_stack[random_idx]
		
		if self.tiles[random_deadend.x][random_deadend.y].get_type() == Tile.TYPE_PATH:
			self.start_point = self.tiles[random_deadend.x][random_deadend.y].position
			self.tiles[self.start_point.x][self.start_point.y].set_type(Tile.TYPE_START_POINT)
			
func create_end_point():
	while self.end_point == Vector2(-1, -1):
		var random_idx = round(self.rng.randf_range(0, self.deadend_stack.size() - 1))
		var random_deadend = self.deadend_stack[random_idx]
		
		if self.tiles[random_deadend.x][random_deadend.y].get_type() == Tile.TYPE_PATH:
			self.end_point = self.tiles[random_deadend.x][random_deadend.y].position
			self.tiles[self.end_point.x][self.end_point.y].set_type(Tile.TYPE_END_POINT)
