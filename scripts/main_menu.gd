extends Control

# I don't yet know whether or not these signals are needed
signal freeplay
signal level_select
signal tap_exercises
signal quit_request

@onready var container = $CanvasLayer
@onready var main_box = $CanvasLayer/AspectRatioContainer/MainBox
@onready var level_box = $CanvasLayer/AspectRatioContainer/LevelSelectBox
@onready var tap_box = $CanvasLayer/AspectRatioContainer/TapSelectBox
@onready var options_box = $CanvasLayer/AspectRatioContainer/OptionsBox


func get_container():
	return container


func _on_start_button_pressed():
	print("Start button pressed. Changing to main scene.")
	$CanvasLayer/AspectRatioContainer/MainBox/MainMenuVBox/StartButton/SfxrStreamPlayer.play()
	freeplay.emit()
	#get_tree().change_scene_to_file("res://main.tscn")


func _on_level_select_pressed():
	print("Level select button pressed. Changing to level select screen.")
	$CanvasLayer/AspectRatioContainer/MainBox/MainMenuVBox/LevelSelectButton/SfxrStreamPlayer.play()
	_show_hide_level_menu()
	_show_hide_main_box()


func _on_tap_exercises_pressed():
	print("Level select button pressed. Changing to level select screen.")
	$CanvasLayer/AspectRatioContainer/MainBox/MainMenuVBox/TapExercisesButton/SfxrStreamPlayer.play()
	get_tree().change_scene_to_file("res://tap_select_screen.tscn")


func _on_options_button_pressed():
	print("Options button pressed. Changing to options screen.")
	$CanvasLayer/AspectRatioContainer/MainBox/MainMenuVBox/OptionsButton/SfxrStreamPlayer.play()
	get_tree().change_scene_to_file("res://options_screen.tscn")


func _on_quit_button_pressed():
	print("Quit button pressed. Quitting game.")
	$CanvasLayer/AspectRatioContainer/MainBox/MainMenuVBox/QuitButton/SfxrStreamPlayer.play()
	get_tree().quit()	# this is only sufficient for desktop/web


func _show_hide_main_box():
	if main_box.hidden:
		main_box.show()
	else:
		main_box.hide()


func _show_hide_level_menu():
	if level_box.hidden:
		level_box.show()
	else:
		level_box.hide()
	#_show_hide_main_box()


func _show_hide_tap_menu():
	if tap_box.hidden:
		tap_box.show()
	else:
		tap_box.hide()
	_show_hide_main_box()


func _show_hide_options_menu():
	if options_box.hidden:
		options_box.show()
	else:
		options_box.hide()
	_show_hide_main_box()
