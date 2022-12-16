extends Node2D

onready var manzana_scene = load("res://Scenes/Manzana.tscn")
onready var enemy_scene = load("res://Scenes/Enemy.tscn")
onready var checker_scene = load("res://Scenes/Checker.tscn")

onready var items_label = get_node("HUD/Items")
onready var caca_label = get_node("HUD/Caca")
onready var HP_label = get_node("HUD/HP")
onready var player = get_node("Player")

func _ready():
	randomize()
	player.position = get_viewport_rect().size/2
	refresh_hud()
	spawn_enemies()
	
func refresh_hud():
	items_label.text = "Comida: " + str(player.items)
	caca_label.text = "Caca: " + str(player.caca)
	HP_label.text = "HP: " + str(player.hp)

func spawn_food():
	var manzana = manzana_scene.instance()
	var checker = checker_scene.instance()
	checker.position = Vector2(rand_range(32, get_viewport_rect().size.x-32), rand_range(32, get_viewport_rect().size.y-32))
	add_child(checker)
	while(checker.get_overlapping_areas().size() > 0):
		checker.position = Vector2(rand_range(32, get_viewport_rect().size.x-32), rand_range(32, get_viewport_rect().size.y-32))
	manzana.position = checker.position
	checker.queue_free()
	add_child(manzana)

func spawn_enemies():
	for i in range(15):
		var enemy = enemy_scene.instance()
		enemy.position = Vector2(rand_range(32, get_viewport_rect().size.x-32), rand_range(32, get_viewport_rect().size.y-32))
		add_child(enemy)

func _on_ManzanaSpawnTimer_timeout():
	spawn_food()
