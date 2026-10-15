extends CharacterBody2D

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


func _movement(delta) -> void:
	var tru_grav:int = gravity * 100
	
	#Horizontal movement
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
	if (Input.is_action_just_released("up") || is_on_ceiling()):
		if (!is_on_floor() && direction.y < -100):
			direction.y = -100
			
	#fastfall
	if (Input.is_action_just_pressed("down")):
		if (!is_on_floor()):
			direction.y = 2000
		elif(is_on_floor()):
			set_collision_mask_value(3, false)
		
			
	#gravity acceleration
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
	
	velocity = direction
	move_and_slide()
	
# Called when the node enters the scene tree for the first time.
# See if one can pass values, like player direction when entering scene
func _ready() -> void:
	$Sprite2D.flip_h = true
	facing = 1

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	_movement(delta)

func _on_semi_platform_body_entered(body: Node2D) -> void:
	set_collision_mask_value(3, true)


func _on_semi_platform_body_exited(body: Node2D) -> void:
	set_collision_mask_value(3, false)
