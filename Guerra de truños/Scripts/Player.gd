extends KinematicBody2D

onready var manzana_scene = load("res://Scenes/Manzana.tscn")
onready var truno_scene = load("res://Scenes/Truno.tscn")

signal refresh_hud

var caca = 0
var items = 0
var hp = 3
var speed = 250

var state = "default"

func _ready():
	connect("refresh_hud", get_parent(), "refresh_hud")
	$ProgressBar.hide()

func _process(delta):
	match state:
		"default":
			player_control()
			if Input.is_action_just_pressed("right_click"):
				eat()
			if Input.is_action_pressed("left_click"):
				charge_throw()
		"eating":
			pass
		"throwing":
			if Input.is_action_pressed("left_click"):
				charge_throw()
			if Input.is_action_just_released("left_click"):
				throw($ProgressBar.value)
func player_control():
	var direction = Vector2.ZERO
	direction.x = int(Input.is_action_pressed("d")) - int(Input.is_action_pressed("a"))
	direction.y = int(Input.is_action_pressed("s")) - int(Input.is_action_pressed("w"))
	
	move_and_slide(direction.normalized()*speed)
	position.x = clamp(position.x, 0, get_viewport_rect().size.x)
	position.y = clamp(position.y, 0, get_viewport_rect().size.y)

func pick_item():
	items += 1
	emit_signal("refresh_hud")

func eat():
	if items <= 0:
		print("No tienes comida")
		return
	state = "eating"
	items -= 1
	var manzana = manzana_scene.instance()
	add_child(manzana)
	$EatTimer.start()

func throw(strength):
	$ProgressBar.hide()
	var truno = truno_scene.instance()
	truno.speed = strength*2
	truno.position = position
	truno.thrown_by = self
	truno.direction = get_global_mouse_position() - position
	get_parent().add_child(truno)
	state = "default"
	$ProgressBar.value = 0
	emit_signal("refresh_hud")

func charge_throw():
	if state != "throwing" and caca > 0:
		$ProgressBar.show()
		state = "throwing"
		caca -= 1
		emit_signal("refresh_hud")
	if $ProgressBar.value < $ProgressBar.max_value and state == "throwing":
		print($ProgressBar.value)
		$ProgressBar.value += 2

func take_damage():
	hp -= 1
	if hp <= 0:
		queue_free()

func _on_EatTimer_timeout():
	caca += 1
	if get_node("Manzana").animation():
		$EatTimer.stop()
		state = "default"
	emit_signal("refresh_hud")
	
