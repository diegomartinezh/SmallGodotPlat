extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$MarginContainer/VBoxContainer/Score.text = "Points: " + str(Global.points)
	$MarginContainer/VBoxContainer/Time.text = "Time Survived: " + str(Global.time) + " seconds"
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if (Input.is_action_just_pressed("start")):
		get_tree().change_scene_to_file("res://scenes/levels/testlevel.tscn")
	
