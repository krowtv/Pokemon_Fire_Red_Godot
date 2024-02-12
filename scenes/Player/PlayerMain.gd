extends SpriteBase
class_name PlayerMain

@export var label = Label
@export var animator : AnimationPlayer

var animation_name := ""
var input_dir : Vector2
var direction_facing : Vector2

func _ready():
	pass
	
func _process(_delta):
	input_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	label.text = fsm.get_curr_state_name()

