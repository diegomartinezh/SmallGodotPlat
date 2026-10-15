extends CharacterBody2D

#These are kept low for clarity and then multiplied later
@export var speed = 10
@export var jump_power = 10
@export var gravity:int = 10
@export var maxfall:int = 10
var direction: Vector2
# 0 left 1 right
var facing: bool = 1
#These two could be merged
var jumping:bool = false
var jumpmem:bool = false

@export var health:int = 3

# These two might be unnecessary
# Check later
signal hit(health:int, source:Area2D)
signal point(path: Area2D)

# General player movement handling
func _movement(delta) -> void:
	var tru_grav:int = gravity * 100
	
	#Horizontal movement based on button press
	if (Input.is_action_pressed("left")):
		direction.x = -1 * speed * 50
		$Sprite2D.flip_h = false
	elif (Input.is_action_pressed("right")):
		direction.x = 1 * speed * 50
		$Sprite2D.flip_h = true
	else:
		direction.x = 0
		
	#vertical movement
	if (Input.is_action_just_pressed("up")):
		if (is_on_floor()):
			direction.y = (-1 * jump_power * 75)
			jumping = true
	# Early drop, holding button makes player jump better
	if (Input.is_action_just_released("up") || is_on_ceiling()):
		if (!is_on_floor() && direction.y < -100):
			direction.y = -100
			
	# fastfall
	if (Input.is_action_just_pressed("down")):
		if (!is_on_floor()):
			direction.y = 1000
		elif(is_on_floor()):
			set_collision_mask_value(3, false)
		
			
	# gravity acceleration
	if(!is_on_floor()):
		direction.y += tru_grav * delta
		jumpmem = true
	#reset gravity acceleration if on floor
	elif(is_on_floor() && !jumping):
		direction.y = 1
	#know when jumping and landing
	if(is_on_floor() && jumpmem == true):
		jumping = false
		jumpmem = false
		
	#fall speed limiter
	if (direction.y > maxfall * 300):
		direction.y = maxfall * 300
	
	# Apply movement
	velocity = direction
	move_and_slide()

# Logic for the semi-solid platforms
func _on_semi_platform_body_entered(body: Node2D) -> void:
	set_collision_mask_value(3, true)

func _on_semi_platform_body_exited(body: Node2D) -> void:
	set_collision_mask_value(3, false)
	
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Make sure to check this when inserting sprite
	$Sprite2D.flip_h = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	_movement(delta)
