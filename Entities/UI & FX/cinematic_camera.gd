extends Node3D

var speed = 0.5
var dir = Vector3(0,2,1)
var pos = Vector3(0,2,1)
var rot = Vector3(-60,0,0)

func _ready():
	
	$Camera3D.position = pos
	$Camera3D.rotation_degrees = rot



func _physics_process(delta):
	
	$Camera3D.position += dir*0.01*speed
	
	
	speed = move_toward(speed,0.1,0.001)
