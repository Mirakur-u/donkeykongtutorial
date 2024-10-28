extends Area2D

class_name Ladder

const BASE_REGION_SIZE = 8

@export var length:float = 2
@export var can_barrel_go_down = false
@export var barrel_goes_down_chance = 0.5
@export var ladder_top_length: float = 6

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D



func _ready() -> void:
	
	sprite_2d.region_rect = Rect2(0, BASE_REGION_SIZE * length, BASE_REGION_SIZE, BASE_REGION_SIZE * length)
		
	collision_shape_2d.shape = RectangleShape2D.new()
	collision_shape_2d.shape.set_size(Vector2(0.025, length * BASE_REGION_SIZE + ladder_top_length))
	collision_shape_2d.position.y = -ladder_top_length
	Rect2()


func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		(body as Player).start_climbing(position.x)


func _on_body_exited(body: Node2D) -> void:
	if body is Player:
		(body as Player).stop_climbing()
