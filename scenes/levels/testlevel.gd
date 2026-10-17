extends Node2D

# Preload projectiles and points
var projectile_scene: PackedScene = load("res://scenes/characters/projectile.tscn")
var point_scene: PackedScene = load("res://scenes/characters/point.tscn")

# vars
@export var diftime:int = 10
var dtime = diftime
@export var difficulty:int = 1
static var healthimg = load("res://imgs/testbird.png")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	# Reset Score
	Global.points = 0
	Global.time = 0
	
	# Some things have to be connected manually through code
	$DeathPlane.connect('body_entered', _on_player_fall)
	$DeathPlane.connect('area_entered', _delete_projectile)
	
	# Set initial health display
	for i in $Player.health:
		var hicon = TextureRect.new()
		hicon.texture = healthimg
		$CanvasLayer/MarginContainer2/HBoxContainer.add_child(hicon)
		hicon.stretch_mode = TextureRect.STRETCH_KEEP
		
	# Hide life and difficulty display for effect
	$CanvasLayer/MarginContainer2/HBoxContainer.hide()
	$CanvasLayer/MarginContainer/VBoxContainer/Difficulty.hide()
	
	# Create a single point before game starts to teach player
	var point_obj = point_scene.instantiate()
	add_child(point_obj)
	point_obj.connect('body_entered', _on_player_point , 16)
	point_obj.position.x = 930
	point_obj.position.y = 300

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# Updating display values
	$CanvasLayer/MarginContainer/VBoxContainer/Difficulty.text = "Difficulty: " + str(difficulty) + "  Increases in: " + str(dtime)
	$CanvasLayer/MarginContainer/VBoxContainer/HBoxContainer/Time.text = "Time: " + str(Global.time)
	$CanvasLayer/MarginContainer/VBoxContainer/HBoxContainer/Points.text = "Points: " + str(Global.points)
	
	# Game properly starts when space is pressed
	if (Input.is_action_just_pressed("start")):
		$DifficultyT.start()
		$PointsTimer.start()
		$ProjectileT.start()
		$CanvasLayer/MarginContainer2/HBoxContainer.show()
		$CanvasLayer/MarginContainer/StartL.hide()
		$CanvasLayer/MarginContainer/VBoxContainer/Difficulty.show()
	
# What makes player actually take damage
func _player_damage_update():
	$Player.health -= 1
	if $Player.health <= 0:
		get_tree().change_scene_to_file("res://scenes/player/game_over.tscn")
	
	for i in $Player.health:
		for child in $CanvasLayer/MarginContainer2/HBoxContainer.get_children():
			child.queue_free()
			
	for i in $Player.health:
		var hicon = TextureRect.new()
		hicon.texture = healthimg
		$CanvasLayer/MarginContainer2/HBoxContainer.add_child(hicon)
		hicon.stretch_mode = TextureRect.STRETCH_KEEP

# When hit by something
func _on_player_hit(body:Node2D, source:Area2D) -> void:
	_player_damage_update()
	source.queue_free()

# When falling off the stage
func _on_player_fall(body:Node2D):
	_player_damage_update()
	$Player.position.x = 900
	$Player.position.y = 100
	$Player.direction.x = 0
	$Player.direction.y = 0

#Ticks every 1 second
# Difficulty increases progressively
# Recycled for general time
func _on_difficulty_t_timeout() -> void:
	Global.time += 1
	dtime -= 1
	
	if dtime <= 0:
		dtime = diftime
		difficulty += 1

# Ticks every 3 seconds
# Spawns a point at a random spot
func _on_points_timer_timeout() -> void:
	var point_obj = point_scene.instantiate()
	add_child(point_obj)
	point_obj.connect('body_entered', _on_player_point , 16)
	point_obj.position.x = randi_range(50, 1800)
	point_obj.position.y = randi_range(50, 850)

# Point pickup logic
func _on_player_point(body: Node2D, source:Area2D) -> void:
	Global.points += 1
	source.queue_free()

# Ticks every 1 second
# Spawns projectiles, with n being equal to difficulty
func _on_projectile_t_timeout() -> void:
	for i in range(difficulty):
		var projectile_obj = projectile_scene.instantiate()
		add_child(projectile_obj)
		projectile_obj.connect('body_entered', _on_player_hit , 16)
	
# Cleanup, delete after crossing screen
func _delete_projectile(area: Area2D) -> void:
	area.queue_free()
