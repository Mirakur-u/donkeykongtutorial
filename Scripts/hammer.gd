extends Area2D

class_name Hammer



func _on_body_entered(body: Node2D) -> void:
	(body as Player).hammer_fetched()
	queue_free()
