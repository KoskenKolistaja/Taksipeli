extends Node3D

var repair_cost

func _ready():
	update_money()
	
	repair_cost = ((100-MetaData.hp)*5)
	
	$Button.grab_focus()
	
	if MetaData.hp < 100:
		$RepairButton.text = "REPAIR (" + str(repair_cost) + ")"
		$RepairButton.show()
	
	check_buttons()

func update_money():
	$Money.text = str(MetaData.money) + "$"


func check_buttons():
	if MetaData.lights:
		$VBoxContainer/Lights.hide()
	if MetaData.handbrake:
		$VBoxContainer/Handbrake.hide()
	if MetaData.medium:
		$VBoxContainer/Medium.hide()
	if MetaData.large:
		$VBoxContainer/Large.hide()
		$VBoxContainer/Medium.hide()
	if MetaData.turbo:
		$VBoxContainer/Turbo.hide()
		$VBoxContainer/Large.hide()
		$VBoxContainer/Medium.hide()

func _physics_process(delta):
	
	if abs(Input.get_joy_axis(0,JOY_AXIS_RIGHT_X)) > 0.2:
		$car_taxi2.rotation_degrees.y += Input.get_joy_axis(0,JOY_AXIS_RIGHT_X)*2


func _on_button_pressed():
	get_tree().change_scene_to_file("res://views/main.tscn")


func _on_repair_button_pressed():
	if MetaData.money >= repair_cost:
		MetaData.money -= repair_cost
		MetaData.hp = 100
		$AudioStreamPlayer2.play(0.25)
		update_money()
	
	$Button.grab_focus()
	$RepairButton.hide()


func _on_lights_pressed():
	if MetaData.money >= 50:
		MetaData.lights = true
		MetaData.money -= 50
		$VBoxContainer/Lights.disabled = true
		$VBoxContainer/Lights.text = "Purchased"
		update_money()
		$AudioStreamPlayer2.play(0.25)


func _on_handbrake_pressed():
	if MetaData.money >= 200:
		MetaData.handbrake = true
		MetaData.money -= 200
		$VBoxContainer/Handbrake.disabled = true
		$VBoxContainer/Handbrake.text = "Purchased"
		update_money()
		$AudioStreamPlayer2.play(0.25)


func _on_medium_pressed():
	if MetaData.money >= 200:
		MetaData.medium = true
		MetaData.money -= 200
		$VBoxContainer/Medium.disabled = true
		$VBoxContainer/Medium.text = "Purchased"
		update_money()
		$AudioStreamPlayer2.play(0.25)



func _on_large_pressed():
	if MetaData.money >= 500:
		MetaData.large = true
		MetaData.money -= 500
		$VBoxContainer/Large.disabled = true
		$VBoxContainer/Large.text = "Purchased"
		update_money()
		$AudioStreamPlayer2.play(0.25)
		$VBoxContainer/Medium.hide()


func _on_turbo_pressed():
	if MetaData.money >= 1000:
		MetaData.turbo = true
		MetaData.money -= 1000
		$VBoxContainer/Turbo.disabled = true
		$VBoxContainer/Turbo.text = "Purchased"
		update_money()
		$AudioStreamPlayer2.play(0.25)
		$VBoxContainer/Medium.hide()
		$VBoxContainer/Large.hide()
		
