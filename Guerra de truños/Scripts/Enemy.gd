extends KinematicBody2D

onready var manzana_scene = load("res://Scenes/Manzana.tscn")
onready var truno_scene = load("res://Scenes/Truno.tscn")

const TYPE = "Enemy"

var caca = 0
var items = 0
var hp = 3
var speed = 150
var throw_strength

var state = "idle"
var direction = Vector2.ZERO
var target


func _ready():
	$ProgressBar.hide()
	$WanderTimer.wait_time = randf()*3

func _process(delta):
	match state:
		"idle":
			if $WanderTimer.is_stopped():
				$WanderTimer.start()
			if items > 0:
				eat()
			check_vision()
		"wandering", "picking":
			movement()
		"eating":
			pass
		"throwing":
			charge_throw()

func movement():
	move_and_slide(direction.normalized()*speed)
	position.x = clamp(position.x, 0, get_viewport_rect().size.x)
	position.y = clamp(position.y, 0, get_viewport_rect().size.y)

func pick_item():
	items += 1
	state = "idle"

func eat():
	if items <= 0:
		return
	state = "eating"
	$WanderTimer.stop()
	items -= 1
	var manzana = manzana_scene.instance()
	add_child(manzana)
	$EatTimer.start()

func throw():
	$ProgressBar.hide()
	var truno = truno_scene.instance()
	truno.speed = $ProgressBar.value*2
	truno.position = position
	truno.thrown_by = self
	truno.direction = target - position
	get_parent().add_child(truno)
	state = "idle"
	$ProgressBar.value = 0

func charge_throw():
	if state == "idle" and caca > 0:
		$ProgressBar.show()
		state = "throwing"
		$WanderTimer.stop()
		caca -= 1
		throw_strength = randi() % 100
	if $ProgressBar.value < $ProgressBar.max_value and state == "throwing":
		$ProgressBar.value += 2
	if $ProgressBar.value >= throw_strength:
		throw()


func take_damage():
	hp -= 1
	if hp <= 0:
		queue_free()


func check_vision():
	for body in $vision.get_overlapping_bodies():
		if body != self:
			if state == "idle" and caca > 0:
				target = body.position
				charge_throw()
				return
	for area in $vision.get_overlapping_areas():
		if area.get_parent() != self and not area.get_parent() is KinematicBody2D:
			if state == "idle" and area.TYPE == "Manzana":
				direction = area.position - position
				state = "picking"
				$WanderTimer.stop()


func _on_EatTimer_timeout():
	caca += 1
	if get_node("Manzana") == null or get_node("Manzana").animation():
		$EatTimer.stop()
		state = "idle"


func _on_WanderTimer_timeout():
	if state == "idle":
		state = "wandering"
		direction = Global.random_direction()
		$WanderTimer.wait_time = randf()*3
	elif state == "wandering":
		state = "idle"
		$WanderTimer.wait_time = randf()*3


