extends CanvasLayer

signal level_changed(level_name)

@export var level_name = "level"

func _ready():
	$ChangeSceneButton.connect("pressed", Callable(self, "_on_ChangeSceneButton_pressed"))

func _on_ChangeSceneButton_pressed():
	emit_signal("level_changed", level_name)
