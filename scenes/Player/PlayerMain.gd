extends SpriteBase
class_name PlayerMain

const TILE_SIZE = 16
const WALK_SPEED := int(60)
const SPRINT_SPEED := int(120)

@export var raycast : RayCast2D
@export var movespeed := WALK_SPEED

var input_dir : Vector2
var direction_facing := Vector2.ZERO
var target_position := Vector2()
var is_moving : bool
var is_sprinting : bool

func _ready():
	pass
	
func _process(_delta):
	is_sprinting = Input.is_action_pressed("sprint")
	
	if input_dir.y == 0:
		input_dir.x = int(Input.is_action_pressed("ui_right")) - int(Input.is_action_pressed("ui_left"))
	if input_dir.x == 0:
		input_dir.y = int(Input.is_action_pressed("ui_down")) - int(Input.is_action_pressed("ui_up"))
	if input_dir:
		direction_facing = input_dir
		if raycast.target_position != input_dir:
			raycast.target_position = input_dir * -(TILE_SIZE - 6)

func Move(_delta : float):
	var direction = (target_position - position).normalized()
	position += direction * movespeed * _delta
	
	if position.distance_to(target_position) < 1:
		position = target_position
		is_moving = false

func handle_input():
	if input_dir != Vector2.ZERO:
		target_position = position + input_dir * TILE_SIZE
		is_moving = true
