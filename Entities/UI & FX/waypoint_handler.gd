extends Node3D

@export var waypoint: PackedScene
@export var customer: PackedScene

var spawns = []


func _ready():
	spawns = get_tree().get_nodes_in_group("waypoint_spawn")
	
	
	
	

func customer_picked():
	spawn_waypoint(random_spawn().global_position)


func spawn_waypoint(spawn_position):
	var waypoint_instance = waypoint.instantiate()
	waypoint_instance.global_position = spawn_position
	add_child(waypoint_instance)

func random_spawn():
	var random_spawn = spawns[randi_range(0,spawns.size()-1)]
	return random_spawn

func spawn_customer(spawn_position):
	var customer_instance = customer.instantiate()
	customer_instance.global_position = spawn_position
	add_child(customer_instance)


func waypoint_reached():
	
	spawn_customer(random_spawn().global_position)
	
	MetaData.money += 100
	get_tree().get_first_node_in_group("HUD").update_money()
	
