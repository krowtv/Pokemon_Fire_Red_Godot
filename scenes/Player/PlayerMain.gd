extends SpriteBase
class_name PlayerMain

const TILE_SIZE = 16
const WALK_SPEED := int(60)
const SPRINT_SPEED := int(120)

@export var label = Label
@export var animator : AnimationPlayer
@export var raycast : RayCast2D
@export var movespeed := WALK_SPEED

var animation_name := ""
var input_dir : Vector2
var direction_facing := Vector2.ZERO
var walked_left := bool(false)

func _ready():
	pass
	
func _process(_delta):
	if input_dir.y == 0:
		input_dir.x = int(Input.is_action_pressed("ui_right")) - int(Input.is_action_pressed("ui_left"))
	if input_dir.x == 0:
		input_dir.y = int(Input.is_action_pressed("ui_down")) - int(Input.is_action_pressed("ui_up"))
	if input_dir:
		direction_facing = input_dir
		if raycast.target_position != input_dir:
			raycast.target_position = input_dir * -(TILE_SIZE - 6)

	label.text = fsm.get_curr_state_name()

