extends Node2D

onready var manzana_scene = load("res://Scenes/Manzana.tscn")
onready var enemy_scene = load("res://Scenes/Enemy.tscn")

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
	manzana.position = Vector2(rand_range(32, get_viewport_rect().size.x-32), rand_range(32, get_viewport_rect().size.y-32))
	add_child(manzana)

func spawn_enemies():
	for i in range(5):
		var enemy = enemy_scene.instance()
		enemy.position = Vector2(rand_range(32, get_viewport_rect().size.x-32), rand_range(32, get_viewport_rect().size.y-32))
		add_child(enemy)

func _on_ManzanaSpawnTimer_timeout():
	spawn_food()
