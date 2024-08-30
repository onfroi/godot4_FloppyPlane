extends Area2D

signal hit
signal scored
var has_player_entered: bool = false

func _on_body_entered(_body):
	if not has_player_entered:
		hit.emit()
		$AudioStreamPlayer2D.play()
		has_player_entered = true

func _on_score_area_body_entered(_body):
	scored.emit()
