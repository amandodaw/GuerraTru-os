extends Node

var items

func random_direction():
	match randi() % 4:
		0:
			return Vector2.DOWN
		1:
			return Vector2.UP
		2:
			return Vector2.RIGHT
		3:
			return Vector2.LEFT
