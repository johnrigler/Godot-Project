extends Node

signal score_changed

var score: int = 0

func increase_score(amount: int):
	score += amount
	print("Score increased to: ", score)  # Debugging statement
	emit_signal("score_changed")
