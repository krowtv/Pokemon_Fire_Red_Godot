extends TileMap

@onready var grass_sprite = $AnimatedSprite2D
var player : CharacterBody2D

var adjust = Vector2(8,-8)

func _ready():
	player = get_tree().get_first_node_in_group("Player")

func _physics_process(delta):
	pass


func _on_grass_interact_body_entered(body):
	grass_sprite.offset = player.position + adjust
	grass_sprite.play("grass_walk")
