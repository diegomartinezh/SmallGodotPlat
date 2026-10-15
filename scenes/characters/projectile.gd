extends Area2D

var direction := Vector2()
var speed:int = randi_range(5, 15)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var start = randi_range(1, 3)
	
	#Left
	if (start == 1):
		position.x = -100
		position.y = randi_range(50, 850)
		direction.x = 1
		direction.y = 0
	#Right
	if (start == 2):
		position.x = 2000
		position.y = randi_range(50, 850)
		direction.x = -1
		direction.y = 0
	#Up
	if (start == 3):
		position.x = randi_range(50, 1800)
		position.y = -100
		direction.x = 0
		direction.y = 1
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position += direction * speed * 50 * delta
