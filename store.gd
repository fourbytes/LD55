extends Node

var score = 0

signal score_changed(new_value)

func increment_score():
	score += 1
	score_changed.emit(score)
