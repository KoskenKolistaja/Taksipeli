extends Area3D

@onready var player = get_tree().get_first_node_in_group("player_body")

var target = null

var state_machine: AnimationNodeStateMachinePlayback

var speed = 0.01

var getting_in = false

var door

func _ready():
	#state_machine.travel("walking")
	state_machine = $AnimationTree.get("parameters/playback")


func _physics_process(delta):
	
	
	if not getting_in:
		if not target:
			rotate_towards_player()
			state_machine.travel("wave")
		else:
			if target.get_speed() < 2:
				state_machine.travel("walking")
				
				var doors = get_tree().get_first_node_in_group("player_root").doors
				
				
				var pos_1 = doors[0].global_position
				var pos_2 = doors[1].global_position 
				var man_pos = $animated_suitman.global_position
				
				var dis_1 = (pos_1 - man_pos).length()
				var dis_2 = (pos_2 - man_pos).length()
				
				
				if dis_1 < dis_2:
					door = doors[0]
				else:
					door = doors[1]
				
				rotate_towards_point(door)
				var direction = (door.global_position - $animated_suitman.global_position).normalized()
				direction = Vector3(direction.x,0,direction.z)
				$animated_suitman.global_position += direction * speed
				
				if door:
					if (door.global_position - $animated_suitman.global_position).length() < 0.1:
						get_in()
				
			elif get_distance_to(target) < 1.5:
				rotate_towards_player()
				state_machine.travel("back_walk")
				var direction = (player.global_position - $animated_suitman.global_position).normalized()
				direction = Vector3(direction.x,0,direction.z)
				$animated_suitman.global_position += -direction * speed * 0.7
			else:
				state_machine.travel("idle")
				rotate_towards_player()
	else:
		rotate_towards_point(target)
		var door_pos = door.global_position
		$animated_suitman.global_position = Vector3(door_pos.x,0.1,door_pos.z)



func get_distance_to(target: Node3D):
	var distance = ($animated_suitman.global_position - target.global_position).length()
	print(distance)
	return distance


func rotate_towards_player():
	if player:
		var direction = (player.global_position - $animated_suitman.global_position).normalized()
		$animated_suitman.rotation_degrees.y = rad_to_deg(atan2(-direction.x, -direction.z))

func rotate_towards_point(point):
	var direction = (point.global_position - $animated_suitman.global_position).normalized()
	
	var desired = rad_to_deg(atan2(-direction.x, -direction.z))
	
	#var to_be = move_toward($animated_suitman.rotation_degrees.y,desired,1)
	
	$animated_suitman.rotation_degrees.y = desired

func get_in():
	getting_in = true
	state_machine.travel("enter_car")
	
	
	await get_tree().create_timer(3).timeout
	get_parent().customer_picked()
	queue_free()



func _on_body_entered(body):
	if body.is_in_group("player_body"):
		target = body


func _on_body_exited(body):
	if body.is_in_group("player_body"):
		target = null


#func _on_area_3d_body_entered(body):
	#if body.is_in_group("player_body"):
		#get_in()
