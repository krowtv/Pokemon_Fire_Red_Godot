extends State
class_name PlayerMove

@export var collider : Area2D
@export var animator : AnimationPlayer
var player : CharacterBody2D

var can_sprint := bool(true)
var is_moving := bool(false)
var stepped_left := bool(false)
var target_position := Vector2()

func Enter():
	player = get_tree().get_first_node_in_group("Player")
	target_position = player.position

func Update(delta : float):
	if !is_moving and !player.raycast.is_colliding():
		handle_input()
	if is_moving:
		Move(delta)
	if player.position == target_position:
		state_transition.emit(self, "PlayerIdle")

func Move(_delta : float):
	var direction = (target_position - player.position).normalized()
	
	player.position += direction * player.movespeed * _delta
	
	if player.position.distance_to(target_position) < 1:
		player.position = target_position
		is_moving = false

func handle_input():
	if player.input_dir != Vector2.ZERO:
		target_position = player.position + player.input_dir * player.TILE_SIZE
		is_moving = true
		handle_steps(player.input_dir)

func handle_steps(step_dir : Vector2):
	var animation_name = ""
	var is_sprinting = Input.is_action_pressed("sprint")
	match step_dir:
		Vector2.LEFT:
			if is_sprinting:
				animation_name = "left_sprint"
			else:
				animation_name = "left_" + ("left" if not stepped_left else "right") + "_walk"
		Vector2.RIGHT:
			if is_sprinting:
				animation_name = "right_sprint"
			else:
				animation_name = "right_" + ("left" if not stepped_left else "right") + "_walk"
		Vector2.UP:
			if is_sprinting:
				animation_name = "back_sprint"
			else:
				animation_name = "back_" + ("left" if not stepped_left else "right") + "_walk"
		Vector2.DOWN:
			if is_sprinting:
				animation_name = "front_sprint"
			else:
				animation_name = "front_" + ("left" if not stepped_left else "right") + "_walk"
	
	if is_sprinting:
		animator.speed_scale = 1.5
		player.movespeed = player.SPRINT_SPEED
	else:
		animator.speed_scale = 1.2
		player.movespeed = player.WALK_SPEED
		
	animator.play(animation_name)
	stepped_left = !stepped_left

