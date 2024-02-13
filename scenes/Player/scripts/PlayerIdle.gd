extends State
class_name PlayerIdle

@export var animator : AnimationPlayer
var has_turned : bool
var last_dir_faced := Vector2.ZERO
var player : CharacterBody2D

func Enter():
	player = get_tree().get_first_node_in_group("Player")
	last_dir_faced = player.direction_facing
	face_direction(player.direction_facing)

func Update(_delta : float):
	if player.input_dir != Vector2.ZERO:
		if player.direction_facing != last_dir_faced:
			Turn(player.direction_facing)
			last_dir_faced = player.direction_facing
		elif player.direction_facing == last_dir_faced and has_turned:
			state_transition.emit(self, "PlayerMove")

func face_direction(move_dir : Vector2):
	var animation_name := ""
	
	match move_dir:
		Vector2.LEFT:
			animation_name = "left_idle"
		Vector2.RIGHT:
			animation_name = "right_idle"
		Vector2.UP:
			animation_name = "back_idle"
		Vector2.DOWN:
			animation_name = "front_idle"
		Vector2.ZERO:
			animation_name = "front_idle"
	player.direction_facing = move_dir
	animator.play(animation_name)

func Turn(move_dir : Vector2):
	var animation_name := ""
	has_turned = false
	
	match move_dir:
		Vector2.LEFT:
			animation_name = "left_left_walk"
		Vector2.RIGHT:
			animation_name = "right_left_walk"
		Vector2.UP:
			animation_name = "back_left_walk"
		Vector2.DOWN:
			animation_name = "front_left_walk"
	animator.speed_scale = 2.8
	animator.play(animation_name)

func _on_animation_player_animation_finished(anim_name):
	has_turned = true
