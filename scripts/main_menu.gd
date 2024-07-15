extends Control

# Signals for various button actions
signal start_continue
signal level_select
signal quit_request
signal options_request

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func _on_start_button_pressed():
	print("Start button pressed. Changing to main scene.")
	$CanvasLayer/AspectRatioContainer/MainMenuVBox/StartButton/SfxrStreamPlayer.play()
	get_tree().change_scene_to_file("res://main.tscn")

func _on_level_select_pressed():
	print("Level select button pressed. Changing to level select screen.")
	$CanvasLayer/AspectRatioContainer/MainMenuVBox/LevelSelectButton/SfxrStreamPlayer.play()
	get_tree().change_scene_to_file("res://level_select_screen.tscn")

func _on_options_button_pressed():
	print("Options button pressed. Changing to options screen.")
	$CanvasLayer/AspectRatioContainer/MainMenuVBox/OptionsButton/SfxrStreamPlayer.play()
	get_tree().change_scene_to_file("res://options_screen.tscn")

func _on_quit_button_pressed():
	print("Quit button pressed. Quitting game.")
	$CanvasLayer/AspectRatioContainer/MainMenuVBox/QuitButton/SfxrStreamPlayer.play()
	get_tree().quit()
