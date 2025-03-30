extends Area3D

@onready var player = get_tree().get_first_node_in_group("player_body")

var target = null

var state_machine 

var speed = 0.01

func _ready():
	#state_machine.travel("walking")
	state_machine = $AnimationTree.get("parameters/playback")

func _physics_process(delta):
	print(target)
	
	if not target:
		rotate_towards_player()
		state_machine.travel("wave")
	else:
		rotate_towards_player()
		state_machine.travel("walking")
		var direction = (player.global_position - global_position).normalized()
		direction = Vector3(direction.x,0,direction.z)
		$animated_suitman.global_position += direction * speed


func rotate_towards_player():
	var direction = (player.global_position - global_position).normalized()
	$animated_suitman.rotation_degrees.y = rad_to_deg(atan2(-direction.x, -direction.z))

func get_in():
	get_parent().customer_picked()
	queue_free()



func _on_body_entered(body):
	if body.is_in_group("player_body"):
		target = body


func _on_body_exited(body):
	if body.is_in_group("player_body"):
		target = null


func _on_area_3d_body_entered(body):
	if body.is_in_group("player_body"):
		get_in()
