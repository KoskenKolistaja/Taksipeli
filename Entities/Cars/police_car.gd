extends Node3D

@onready var ball = $Ball
@onready var car_mesh = $car_mesh
@onready var ground_ray = $taxi_mesh/RayCast3D

@onready var nav_agent = $car_mesh/NavigationAgent3D


@onready var player = get_tree().get_first_node_in_group("player")
var target


var sphere_offset = Vector3(0,-0.15,0)

var acceleration  = 21

var turn_speed = 5

var speed_input = -0.3
var rotate_input = 0

var stopped = false

var alerted = true

var probing

func take_damage(amount: float):
	pass

func _ready():
	target = player
	update_target_position()
	
	dealert()


func dealert():
	alerted = false
	$car_mesh/siren.stop()
	$car_mesh/siren2.stop()
	$SirenTimer.stop()
	$car_mesh/OmniLight3D.hide()
	$car_mesh/OmniLight3D2.hide()
	


func alert():
	alerted = true
	$car_mesh/siren.play()
	$SirenTimer.start()
	$car_mesh/OmniLight3D.show()
	$car_mesh/OmniLight3D2.show()

func _physics_process(delta):
	car_mesh.global_transform.origin = ball.global_position + sphere_offset
	if not stopped:
		
		if alerted:
			throttle()
			steer(delta)
		
		if probing:
			probe()

func probe():
	var player = get_tree().get_first_node_in_group("player").get_parent()
	
	if player.illegalities and not alerted:
		alert()
		get_tree().get_first_node_in_group("HUD").alert()


func throttle():
	ball.apply_force(-car_mesh.global_transform.basis.z * speed_input*acceleration)

func steer(delta):
	#var point = points[point_index]
	var car_forward = car_mesh.global_transform.basis.z.normalized()
	var to_target = (nav_agent.get_next_path_position() - car_mesh.global_position).normalized()
	var angle = atan2(car_forward.cross(to_target).y, car_forward.dot(to_target))
	
	angle = clamp(angle,-0.2,0.2)
	speed_input = lerp(-0.15,-1.05,1-abs(angle)/0.4)
	
	#if abs(rad_to_deg(angle)) > 10:
		#speed_input = lerp(-0.1,-0.3,)
	#else:
		#speed_input = -0.3
	
	rotate_input = angle*3
	
	var new_basis = car_mesh.global_transform.basis.rotated(car_mesh.global_transform.basis.y,
	rotate_input)
	car_mesh.global_transform.basis = car_mesh.global_transform.basis.slerp(new_basis,
	turn_speed * delta)
	car_mesh.global_transform = car_mesh.global_transform.orthonormalized()

func update_target_position():
	nav_agent.target_position = target.global_position



func _on_siren_timer_timeout():
	if $car_mesh/siren.is_playing():
		$car_mesh/siren.stop()
		$car_mesh/siren2.play()
	else:
		$car_mesh/siren.play()
		$car_mesh/siren2.stop()


func _on_target_update_timer_timeout():
	update_target_position()


func _on_area_3d_body_entered(body):
	if body.is_in_group("player_body"):
		probing = true


func _on_area_3d_body_exited(body):
	if body.is_in_group("player_body"):
		probing = false
