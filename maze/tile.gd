extends Reference

const TYPE_WALL: String = "wall"
const TYPE_PATH: Array = [
	"path_0",
	"path_1",
	"path_2",
	"path_3",
	"path_4",
	"path_5",
	"path_6",
	"path_7",
	"path_8",
	"path_9",
	"path_10",
	"path_11",
]

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
