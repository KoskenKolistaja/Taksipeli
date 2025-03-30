extends Node3D

@onready var ball = $Ball
@onready var car_mesh = $car_mesh
@onready var ground_ray = $taxi_mesh/RayCast3D

@export var points: Array[Node3D]

var point_index = 0

var sphere_offset = Vector3(0,-0.15,0)

var acceleration  = 21

var turn_speed = 5

var speed_input = -0.3
var rotate_input = 0

func take_damage(amount: float):
	pass

func _physics_process(delta):
	car_mesh.global_transform.origin = ball.global_position + sphere_offset
	ball.apply_force(-car_mesh.global_transform.basis.z * speed_input*acceleration)
	
	var distance_to_point = (points[point_index].global_position - ball.global_position).length()
	
	
	if distance_to_point < 0.5:
		point_index += 1
		if point_index >= points.size():
			point_index = 0
	
	
	steer(delta)


func steer(delta):
	var point = points[point_index]
	var car_forward = car_mesh.global_transform.basis.z.normalized()
	var to_target = (point.global_position - car_mesh.global_position).normalized()
	var angle = atan2(car_forward.cross(to_target).y, car_forward.dot(to_target))
	
	angle = clamp(angle,-0.2,0.2)
	speed_input = lerp(-0.15,-0.3,1-abs(angle)/0.2)
	
	#if abs(rad_to_deg(angle)) > 10:
		#speed_input = lerp(-0.1,-0.3,)
	#else:
		#speed_input = -0.3
	
	rotate_input = angle
	
	var new_basis = car_mesh.global_transform.basis.rotated(car_mesh.global_transform.basis.y,
	rotate_input)
	car_mesh.global_transform.basis = car_mesh.global_transform.basis.slerp(new_basis,
	turn_speed * delta)
	car_mesh.global_transform = car_mesh.global_transform.orthonormalized()
