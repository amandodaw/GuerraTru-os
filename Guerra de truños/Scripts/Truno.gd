extends Area2D

const TYPE = "Truno"

var direction = Vector2.ZERO
var speed = 100
var thrown_by

func _process(delta):
	position += direction.normalized()*speed*delta

func take_damage():
	queue_free()

func _on_Truno_body_entered(body):
	if body == thrown_by:
		return
	body.take_damage()
	queue_free()

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()


func _on_Truno_area_entered(area):
	if area == thrown_by or area is KinematicBody2D or area.get_parent() is KinematicBody2D:
		return
	area.take_damage()
	queue_free()
