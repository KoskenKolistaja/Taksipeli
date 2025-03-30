extends Label3D



func _ready():
	position += Vector3(0,0.4,0)
	await get_tree().create_timer(1).timeout
	queue_free()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	position += Vector3(0,0.01,0)
