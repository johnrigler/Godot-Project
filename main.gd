extends Node2D

@onready var current_level = $Level
@onready var level_manager = $LevelManager

# Called when the node enters the scene tree for the first time.
func _ready():
	level_manager.connect("level_loaded", Callable(self, "_on_level_loaded"))
	switch_level("1-1")


func switch_level(level_name: String):
	if current_level != null:
		remove_child(current_level)
		current_level.queue_free()
	var next_level = level_manager.load_level(level_name)
	if next_level != null:
		add_child(next_level)
		current_level = next_level
		current_level.connect("level_end", Callable(self, "_on_level_level_end"))
		current_level.start_track()
	else:
		print("Failed to load level: %s" % level_name)


func _on_level_level_end(level_name, score):
	print(level_name, ": ", score)
	var next_level = "1-%s" % (int(level_name[-1]) + 1)
	switch_level(next_level)
