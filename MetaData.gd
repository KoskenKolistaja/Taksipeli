extends Node

var money = 500
var hp = 100

var lights = false
var handbrake = false
var medium = false
var large = false
var turbo = false



var current_position = Vector3.ZERO
var current_rotation = Vector3(0,90,0)




func restore_defaults():
	money = 500
	hp = 100
	current_position = Vector3.ZERO
	current_rotation = Vector3(0,90,0)
	lights = false
	handbrake = false
	medium = false
	large = false
	turbo = false
