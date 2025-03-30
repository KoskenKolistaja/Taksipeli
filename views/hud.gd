extends Control

@export var taxi: Node3D
@export var cinematic_camera: PackedScene

var alerted = false


func _ready():
	update_money()
	update_hp(MetaData.hp)



func _physics_process(delta):
	#Updating minimap camera position
	$TextureRect/SubViewportContainer/SubViewport/Camera3D.global_position = taxi.ball.global_position + Vector3(0,10,0)
	
	
	

func alert():
	if not alerted:
		$AudioStreamPlayer.stop()
		$AudioStreamPlayer2.play()
		alerted = true


func update_hp(new_value):
	$ProgressBar.value = new_value

func update_money():
	$Money.text = str(MetaData.money) + "$"

func busted(text: String, cost:int,game_over: bool = false):
	MetaData.money -= cost
	update_money()
	
	
	$BUSTED.text = text
	
	if MetaData.money < 0:
		$BUSTED.text = "GAME OVER"
	
	if game_over:
		$BUSTED.text = "GAME OVER"
	
	
	$BUSTED.show()
	$TextureRect.hide()
	
	
	var cinematic_camera_instance = cinematic_camera.instantiate()
	
	get_tree().get_first_node_in_group("player").add_child(cinematic_camera_instance)
	
	await get_tree().create_timer(1.5).timeout

	show_menu(game_over)

func update_speed(speed: int):
	$Speedmeter.text = str(speed) + "km/h"

func trigger_garage():
	get_tree().call_group("police", "set_freeze_enabled",true)
	
	await get_tree().create_timer(5).timeout
	get_tree().change_scene_to_file("res://views/garage_shop.tscn")
	

func hide_hud():
	$TextureRect.hide()
	$ProgressBar.hide()
	$Money.hide()
	$Speedmeter.hide()
	$AnimationPlayer.play("bars")

func show_menu(is_game_over):
	$VBoxContainer/RESTART.grab_focus()
	
	$VBoxContainer.show()
	$VBoxContainer.modulate.a = 0.0
	if MetaData.money <= 0 or is_game_over:
		$VBoxContainer/RESTART.hide()
		$VBoxContainer/BackToMenu.grab_focus()
	var tween = get_tree().create_tween()
	tween.tween_property($VBoxContainer, "modulate:a", 1.0, 1.0)

func _on_restart_pressed():
	get_tree().reload_current_scene()


func _on_back_to_menu_pressed():
	get_tree().change_scene_to_file("res://views/menu.tscn")
