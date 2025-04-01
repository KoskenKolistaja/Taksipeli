extends RigidBody3D



func get_speed() -> int:
	var speed = round(linear_velocity.length()*10)
	
	return speed


func _on_body_shape_entered(body_rid, body, body_shape_index, local_shape_index):
	if not get_parent().stopped:
		# Ensure the collided body exists
		if body == null:
			return
		
		# Check if the body is in Collision Layer 4
		#if (body.get_collision_layer() & (1 << 4)) == 0:
			#return  # Ignore collisions that are NOT on layer 4

		# Get the collision point (approximate, since Jolt doesn’t expose it directly)
		var collision_point = body.global_transform.origin
		
		# Estimate collision normal (direction towards the other body)
		var collision_normal = (global_transform.origin - collision_point).normalized()

		# Calculate velocity component towards collision point
		var velocity_towards_collision = linear_velocity.project(collision_normal)
		var impact_speed = velocity_towards_collision.length()

		# Adjust for static bodies (since they have no velocity)
		if body is StaticBody3D:
			impact_speed = abs(linear_velocity.dot(collision_normal)) # abs() correctly applied
		
		if body.is_in_group("police"):
			get_tree().get_first_node_in_group("HUD").busted("BUSTED",500)
			get_parent().stop()
			get_tree().call_group("police", "set_freeze_enabled",true)
		
		if body.is_in_group("civilian"):
			get_parent().add_crime("Destruction",10)
		
		
		if impact_speed > 0.1:
			get_parent().take_damage(impact_speed)
			print("yeah")
	else:
		return
