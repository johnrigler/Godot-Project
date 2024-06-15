extends Control
signal start_level

const LevelButtonScene = preload("res://level_button.tscn")

# debug stuff
var levelList = ["level 1", "level 2", "level 3", "level 4"]
@onready var levelBox = $AspectRatioContainer/GridContainer

# Called when the node enters the scene tree for the first time.
func _ready():
	make_level_buttons()


func make_level_buttons():
	for i in levelList:
		add_button(i, levelBox)


func add_button(level:String, container:GridContainer):
	container.add_child(create_button(level))
	

func create_button(level):
	var button : LevelButton
	button = LevelButtonScene.instantiate()
	button.setup(level)
	button.level_selected.connect(_on_level_selected)
	return button
	

# level buttons connect to this
func _on_level_selected(level):
	#debug print
	print(level)
	start_level.emit(level)
