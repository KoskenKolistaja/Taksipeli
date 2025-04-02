extends Node3D

@export var waypoint: PackedScene
@export var customer: PackedScene

var spawns = []

var current

func _ready():
	spawns = get_tree().get_nodes_in_group("waypoint_spawn")
	
	
	
	

func customer_picked():
	var spawn = random_spawn()
	current = spawn
	spawn_waypoint(spawn.global_position)


func spawn_waypoint(spawn_position):
	var waypoint_instance = waypoint.instantiate()
	waypoint_instance.global_position = spawn_position
	add_child(waypoint_instance)

func random_spawn():
	var spawns_erased = spawns
	spawns_erased.erase(current)
	var random_spawn = spawns_erased[randi_range(0,spawns.size()-1)]
	return random_spawn

func spawn_customer(spawn_position):
	var customer_instance = customer.instantiate()
	customer_instance.global_position = spawn_position
	add_child(customer_instance)


func waypoint_reached():
	var spawn = random_spawn()
	current = spawn
	spawn_customer(spawn.global_position)
	
	MetaData.money += 100
	get_tree().get_first_node_in_group("HUD").update_money()
	
