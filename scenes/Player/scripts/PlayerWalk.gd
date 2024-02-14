extends State
class_name PlayerWalk

@export var animator : AnimationPlayer
@export var sprite : AnimatedSprite2D
var player : CharacterBody2D

var stepped_left := bool(false)
var animation_playing := bool(false)
var curr_anim := ""

func Enter():
	player = get_tree().get_first_node_in_group("Player")
	player.target_position = player.position

func Update(delta : float):
	if !player.is_moving and !player.raycast.is_colliding():
		player.handle_input()
		if !player.is_sprinting:
			anim_walk(player.input_dir)
		else:
			anim_sprint(player.input_dir)
	if player.is_moving:
		player.Move(delta)
	if player.position == player.target_position:
		state_transition.emit(self, "PlayerIdle")

func anim_walk(step_dir : Vector2):
	var animation_name = ""
	match step_dir:
		Vector2.LEFT:
			animation_name = "left_" + ("left" if not stepped_left else "right") + "_walk"
		Vector2.RIGHT:
			animation_name = "right_" + ("left" if not stepped_left else "right") + "_walk"
		Vector2.UP:
			animation_name = "back_" + ("left" if not stepped_left else "right") + "_walk"
		Vector2.DOWN:
			animation_name = "front_" + ("left" if not stepped_left else "right") + "_walk"
	
	animator.speed_scale = 1.2
	player.movespeed = player.WALK_SPEED
	animator.play(animation_name)
	
	stepped_left = !stepped_left

func anim_sprint(step_dir : Vector2):
	var animation_name = ""
	match step_dir:
		Vector2.LEFT:
			animation_name = "left_sprint"
		Vector2.RIGHT:
			animation_name = "right_sprint"
		Vector2.UP:
			animation_name = "back_sprint"
		Vector2.DOWN:
			animation_name = "front_sprint"
	
	animator.speed_scale = 2
	player.movespeed = player.SPRINT_SPEED
	
	animator.play(animation_name)

