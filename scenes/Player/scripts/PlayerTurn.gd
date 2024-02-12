extends State
class_name PlayerTurn

var input_dir := Vector2.ZERO
var animation_name := ""

@export var animator : AnimationPlayer
@export var player : CharacterBody2D

func Enter():
	pass
	
func Update(_delta):
	input_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	player.direction_facing = input_dir
	if input_dir:
		Turn(input_dir)
	

func Turn(move_dir : Vector2):
	match move_dir:
		Vector2.LEFT:
			animation_name = "left_left_walk"
		Vector2.RIGHT:
			animation_name = "right_left_walk"
		Vector2.UP:
			animation_name = "back_left_walk"
		Vector2.DOWN:
			animation_name = "front_left_walk"
	animator.speed_scale = 2.5
	animator.play(animation_name)


func _on_animation_player_animation_finished(_anim_name):
	if input_dir != Vector2.ZERO:
		state_transition.emit(self, "PlayerMove")
	else:
		state_transition.emit(self, "PlayerIdle")
