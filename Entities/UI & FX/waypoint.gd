extends Area3D
var player

var probed = null

func ready():
	player = get_tree().get_first_node_in_group("player")



func _physics_process(delta):
	player = get_tree().get_first_node_in_group("player")
	
	if player:
		if (player.global_position - self.global_position).length() > 10:
			update_waypoint(false)
			$Label3D.text = str((player.global_position - self.global_position).length())
		else:
			update_waypoint(true)
			$Label3D.text = str((player.global_position - self.global_position).length())
	
	if probed:
		var speed = round(player.get_parent().ball.linear_velocity.length()*10)
		if speed < 10:
			waypoint_reached()




func update_waypoint(is_on_map: bool):
	if is_on_map:
		$close.show()
		$far.hide()
	else:
		$close.hide()
		$far.show()
		
		var direction = (self.global_position - player.global_position).normalized()
		
		var heightless = Vector3(direction.x,0,direction.z)
		
		$far.rotation_degrees.y = -rad_to_deg(heightless.signed_angle_to(Vector3.FORWARD,Vector3.UP))
		
		$far.global_position = player.global_position + direction * 9.5
	

func waypoint_reached():
	get_parent().waypoint_reached()
	queue_free()


func _on_body_entered(body):
	if body.is_in_group("player_body"):
		probed = true


func _on_body_exited(body):
	if body.is_in_group("player_body"):
		probed = false
