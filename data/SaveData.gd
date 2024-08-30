class_name savedata extends Resource

@export var high_score:int = 0
const SAVE_PATH:String = "user://save_data.tres"

func save() -> void:
	ResourceSaver.save(self, SAVE_PATH)
	
static func load_create() -> savedata:
	var res:savedata
	if FileAccess.file_exists(SAVE_PATH):
		res = load(SAVE_PATH) as savedata
	else:
		res = savedata.new()
	return res
