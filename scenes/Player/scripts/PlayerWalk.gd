extends State
class_name PlayerWalk

@export var animator : AnimationPlayer
var player : CharacterBody2D

var stepped_left := bool(false)

func Enter():
	player = get_tree().get_first_node_in_group("Player")
	player.target_position = player.position

func Update(delta : float):
	if !player.is_moving and !player.has_collided:
		player.handle_input()
		anim_move(player.direction_facing)
	if player.is_moving:
		player.Move(delta)
	if player.position == player.target_position:
		state_transition.emit(self, "PlayerIdle")

func anim_move(step_dir : Vector2):
	var animation_name = ""
	var is_sprinting = Input.is_action_pressed("sprint")
	match step_dir:
		Vector2.LEFT:
			animation_name = "left_" + ("left" if not stepped_left else "right")
		Vector2.RIGHT:
			animation_name = "right_" + ("left" if not stepped_left else "right")
		Vector2.UP:
			animation_name = "back_" + ("left" if not stepped_left else "right")
		Vector2.DOWN:
			animation_name = "front_" + ("left" if not stepped_left else "right")
	
	if !is_sprinting:
		animator.speed_scale = 1.2
		player.movespeed = player.WALK_SPEED
		animation_name += "_walk"
	elif is_sprinting:
		animator.speed_scale = 1.4
		player.movespeed = player.SPRINT_SPEED
		animation_name += "_sprint"
	
	animator.play(animation_name)
	stepped_left = !stepped_left
