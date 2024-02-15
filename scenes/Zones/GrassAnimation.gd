extends AnimatedSprite2D

var player : CharacterBody2D
var grassAnimScene = preload("res://scenes/Misc/grass_animation.tscn")
var input_dir : Vector2
var end_tile : Vector2
var walking_in_grass := bool(false)

func _ready():
	player = get_tree().get_first_node_in_group("Player")

func _process(delta):
	if input_dir.y == 0:
		input_dir.x = int(Input.is_action_pressed("ui_right")) - int(Input.is_action_pressed("ui_left"))
	if input_dir.x == 0:
		input_dir.y = int(Input.is_action_pressed("ui_down")) - int(Input.is_action_pressed("ui_up"))

	if walking_in_grass and player.is_moving:
		grass_anim()

func grass_anim():
	if player.position.distance_to(player.target_position) < 2:
		var grassAnimInstance = grassAnimScene.instantiate()
		get_parent().add_child(grassAnimInstance)
		grassAnimInstance.offset = player.position + Vector2(8, -8)
		grassAnimInstance.play("grass_walk") 
		grassAnimInstance.connect("animation_finished", _on_GrassAnimation_finished.bind(grassAnimInstance))

func _on_GrassAnimation_finished(instance):
	instance.queue_free()

func _on_grass_interact_body_entered(body):
	walking_in_grass = true

func _on_grass_interact_body_exited(body):
	walking_in_grass = false
