extends Node

@onready var current_level = $GrassLevel

# Called when the node enters the scene tree for the first time.
func _ready():
	current_level.connect("level_changed", Callable(self, "handle_level_change")) # Replace with function body.


func handle_level_change(current_level_name: String):
	var next_level
	var next_level_name: String
	
	match current_level_name:
		"grass":
			next_level_name = "Dessert"
		"dessert":
			next_level_name = "Grass"
		_:
			return
	next_level = load("res://" + next_level_name + "Level.tscn").instantiate()
	add_child(next_level)
	next_level.connect("level_changed", Callable(self, "handle_level_change"))
	current_level.queue_free()
	current_level = next_level

