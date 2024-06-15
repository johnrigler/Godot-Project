extends Node

@onready var current_level = $GrassLevel

# Called when the node enters the scene tree for the first time.
func _ready():
	# Connect the level_changed signal from the current level to the handle_level_change function
	current_level.connect("level_changed", Callable(self, "handle_level_change"))

# Function to handle the level change
func handle_level_change(current_level_name: String):
	var next_level_path: String
	var next_midi_file: String
	
	# Determine the next level path based on the current level's name
	match current_level_name:
		"grass":
			next_level_path = "res://DessertLevel.tscn"  # Path to the Dessert level scene
			next_midi_file = "res://dessert_level_midi.mid"  # Path to the corresponding MIDI file
		"dessert":
			next_level_path = "res://GrassLevel.tscn"  # Path to the Grass level scene
			next_midi_file = "res://grass_level_midi.mid"  # Path to the corresponding MIDI file
		_:
			return  # If the current level name doesn't match any known level, return without doing anything
	
	# Change the scene to the new level
	get_tree().change_scene_to_file(next_level_path)  # Automatically handles loading the new scene and cleaning up the old one
	
	# Change the MIDI file to the corresponding one
	if has_node("MidiFilePlayer"):
		$MidiFilePlayer.load_and_play_midi(next_midi_file)
