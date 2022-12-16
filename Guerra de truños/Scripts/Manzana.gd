extends Area2D

const TYPE = "Manzana"

func _ready():
	if get_parent() is KinematicBody2D:
		$CollisionShape2D.disabled = true

func _on_Manzana_body_entered(body):
	body.pick_item()
	queue_free()

func animation():
	if $AnimatedSprite.frame >= 2:
		queue_free()
		return true
	$AnimatedSprite.frame += 1
	return false

func take_damage():
	queue_free()


