extends Area2D

signal hit

@export var explosion: AnimatedSprite2D

func _on_body_entered(_body):
	explosion.show()
	explosion.play()
	$AudioStreamPlayer2D.play()
	hit.emit()

func _on_body_exited(_body):
	explosion.hide()
