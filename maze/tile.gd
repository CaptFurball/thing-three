extends Reference

const TYPE_WALL: String = "wall"
const TYPE_PATH: String = "path"

const TYPE_START_POINT: String = "start_point"
const TYPE_END_POINT: String = "end_point"

var type = TYPE_WALL
var position : Vector2 = Vector2.ZERO

var visited : bool = false

func set_visited() :
	self.visited = true
	
func has_visited() -> bool :
	return self.visited

func set_type(type_name: String) :
	self.type = type_name

func get_type():
	return self.type
	
func set_wall():
	self.type = self.TYPE_WALL

func set_path():
	self.type = self.TYPE_PATH

func set_start_tile():
	self.type = self.TYPE_START_POINT

func set_end_tile():
	self.type = self.TYPE_END_POINT

func set_position(x : int, y : int):
	self.position = Vector2(x, y)
