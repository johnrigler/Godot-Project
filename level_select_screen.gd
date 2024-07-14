extends Control

@onready var tap_song_list = $TapSongList
@onready var regular_song_list = $RegularSongList

# Called when the node enters the scene tree for the first time.
func _ready():
	# Populate the song lists here from csv.
	_populate_song_lists()

func _populate_song_lists():
	pass

func _on_song_selected(song_name: String):
	print("Selected song: %s" % song_name)

func _on_back_button_pressed():
	get_parent().call("show_main_menu")
