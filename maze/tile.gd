extends Reference

const TYPE_WALL : String = "wall"
const TYPE_PATH : String = "path"
const TYPE_START_POINT : String = "start_point"
const TYPE_END_POINT   : String = "end_point"

var position : Vector2 = Vector2.ZERO setget set_position, get_position
var type : String = TYPE_WALL setget set_type, get_type
var visited : bool = false setget set_visited, has_visited

func set_visited(_visited : bool = true) :
	visited = _visited
	
func has_visited() -> bool :
	return visited

func set_type(type_name: String) :
	type = type_name

func get_type() -> String:
	return type

func set_position(value : Vector2):
	position = value

func get_position():
	return position

func _init(x : int, y : int):
	self.position = Vector2(x, y)

func set_wall():
	self.type = self.TYPE_WALL

func set_path():
	self.type = self.TYPE_PATH

func set_start_tile():
	self.type = self.TYPE_START_POINT

func set_end_tile():
	self.type = self.TYPE_END_POINT
