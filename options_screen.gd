extends Control

@onready var volume_slider = $VBoxContainer/HBoxContainer/Master_Volume
@onready var music_slider = $VBoxContainer/HBoxContainer/Music_Volume
@onready var sfx_slider = $VBoxContainer/HBoxContainer/Sfx_Volume
@onready var back_button = $VBoxContainer/BackButton

# Called when the node enters the scene tree for the first time.
func _ready():
	# Connect signals
	volume_slider.connect("value_changed", Callable(self, "_on_volume_value_changed"))
	sfx_slider.connect("value_changed", Callable(self, "_on_sfx_value_changed"))
	back_button.connect("pressed", Callable(self, "_on_back_button_pressed"))

# Called when the master slider value changes
func _on_volume_value_changed(value):
	_update_volume("Master", value)

# Called when the music slider value changes
func _on_music_value_changed(value):
	_update_volume("Music", value)

# Called when the sfx slider value changes
func _on_sfx_value_changed(value):
	_update_volume("Sfx", value)

# Update the volume in the game
func _update_volume(bus_name: String, value):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index(bus_name), linear_to_db(value / 1))

# Handle back button press
func _on_back_button_pressed():
	get_tree().change_scene_to_file("res://main_menu.tscn")


func _on_sfx_volume_value_changed(value):
	pass # Replace with function body.


func _on_master_volume_value_changed(value):
	pass # Replace with function body.
