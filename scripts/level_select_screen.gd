extends Control

@export var button_scene : PackedScene
@onready var level_list = $AspectRatioContainer/VBoxContainer/ScrollContainer/LevelList

signal selected
signal back

# Called when the node enters the scene tree for the first time.
func _ready():
	_populate_level_list(name)


# should populate buttons into LevelList
func _build_buttons(levels):
	levels.sort()
	for i in range(0, levels.size()):
		var btn = button_scene.instantiate()
		btn.LEVEL_NAME = levels[i]
		btn.text = sanitized(levels[i])
		btn.connect("level_selected", Callable(self, "_on_level_selected"))
		level_list.add_child(btn)
		


func _populate_level_list(levels : String):
	match levels:
		"Level Select Screen":
			_build_buttons(LevelManager.get_levels())
		"Tap Screen":
			_build_buttons(LevelManager.get_taps())


# this removes unwanted characters/substrings from level string for
# 	level_buttons
func sanitized(song : String) -> String:
	song = song.replace("\\", "")
	song = song.trim_suffix(".tscn")
	return song


func _on_level_selected(level_name: String):
	print(level_name)
	match name:
		"Level Select Screen":
			var level_path = "res://levels/%s" %level_name
			get_tree().change_scene_to_file(level_path)
		"Tap Screen":
			var level_path = "res://taps/%s" %level_name
			get_tree().change_scene_to_file(level_path)


func _on_back_button_pressed():
	hide()
	back.emit()
