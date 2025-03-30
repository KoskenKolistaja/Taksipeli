extends StaticBody3D

var player_mesh

func _ready():
	await get_tree().create_timer(5).timeout
	$Area3D/CollisionShape3D.disabled = false


func _on_area_3d_body_entered(body):
	if body.is_in_group("player_body"):
		garage()


func garage():
	player_mesh = get_tree().get_first_node_in_group("player")
	
	$AnimationPlayer.play("drive_in")
	
	
	get_tree().get_first_node_in_group("HUD").trigger_garage()
	get_tree().get_first_node_in_group("HUD").hide_hud()
	$Camera3D.current = true
	get_tree().get_first_node_in_group("player").get_parent().stopped = true
	
	#Just takes player out of screen
	player_mesh.global_position = $start_point.global_position + Vector3.DOWN*100
	
	MetaData.current_position = $start_point.global_position
	MetaData.current_rotation = $start_point.rotation_degrees
	

func _physics_process(delta):
	pass
	#if player_mesh:
		#player_mesh.global_position += player_mesh.global_position.move_toward($end_point.global_position,0)
