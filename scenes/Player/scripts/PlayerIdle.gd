extends State
class_name PlayerIdle

@export var animator : AnimationPlayer
var last_move := []
var player : CharacterBody2D

func Enter():
	player = get_tree().get_first_node_in_group("Player")
	if last_move.size() <= 2:
		last_move.push_front(player.direction_facing)
		
	face_direction(player.direction_facing)

func Update(_delta : float):
	if player.input_dir != Vector2.ZERO:
		if player.direction_facing != last_move[0]:
			Turn(player.direction_facing)
			last_move = []
		else:
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
	
	animator.play(animation_name)

func Turn(move_dir : Vector2):
	var animation_name := ""
	
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
	if player.input_dir != Vector2.ZERO:
		state_transition.emit(self, "PlayerMove")
	else:
		state_transition.emit(self, "PlayerIdle")
