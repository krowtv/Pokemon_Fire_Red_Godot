extends State
class_name PlayerMove

const WALK_SPEED := int(60)
const SPRINT_SPEED := int(120)
const TILE_SIZE := int(16)

@export var movespeed := WALK_SPEED
@export var collider : Area2D
@export var animator : AnimationPlayer
var player : CharacterBody2D

var can_sprint := bool(true)
var is_moving := bool(false)
var stepped_left := bool(false)
var move_dir := Vector2.ZERO
var target_position := Vector2()
var look_dir := []

func Enter():
	player = get_tree().get_first_node_in_group("Player")
	target_position = player.position

func Update(delta : float):
	if move_dir != Vector2.ZERO:
		player.direction_facing = move_dir

	if not is_moving:
		handle_input()
		
	if is_moving:
		Move(delta)

	if player.position == target_position and move_dir == Vector2.ZERO:
		state_transition.emit(self, "PlayerIdle")

func Move(_delta : float):
	var direction = (target_position - player.position).normalized()
	
	player.position += direction * movespeed * _delta

	if player.position.distance_to(target_position) < 1:
		player.position = target_position
		is_moving = false

func handle_input():
	var input_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	
	if Input.is_action_pressed("ui_up"):
		input_dir = Vector2.UP
	elif Input.is_action_pressed("ui_down"):
		input_dir = Vector2.DOWN
	elif Input.is_action_pressed("ui_left"):
		input_dir = Vector2.LEFT
	elif Input.is_action_pressed("ui_right"):
		input_dir = Vector2.RIGHT
	
	move_dir = input_dir
	if move_dir != Vector2.ZERO:
		move_dir = input_dir
		target_position = player.position + move_dir * TILE_SIZE
		is_moving = true
		handle_steps(move_dir)

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
		movespeed = SPRINT_SPEED
	else:
		animator.speed_scale = 1.2
		movespeed = WALK_SPEED
		
	animator.play(animation_name)
	stepped_left = !stepped_left

func _on_walkable_tiles_body_entered(body):
	print("collision")
