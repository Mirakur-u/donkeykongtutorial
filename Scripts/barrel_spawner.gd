extends Node2D

class_name BarrelSpawner

var barrel_scene = preload("res://Scenes/barrel.tscn")

@onready var spawn_timer: SpawnTimer = $SpawnTimer

func _ready():
	spawn_timer.timeout.connect(on_spawn_timer_timeout)


func on_spawn_timer_timeout():
	spawn_timer.setup()
	spawn_barrel()
	


func spawn_barrel():
	var barrel = barrel_scene.instantiate()
	add_child(barrel)
	
