class_name RoomGeneration
extends Node

@export var map_size: int = 7
@export var rooms_to_generate: int = 12
var room_count: int = 0
var map: Array[bool] 
var rooms: Array[Room]
var room_pos_offset: float = 160

var first_room_x: int = 3
var first_room_y : int = 3 
var first_room: Room
var room_scene: PackedScene = preload("res://Scenes/Rooms/room_template.tscn")
@export var player : CharacterBody2D

func  _ready() -> void:
	_generate()
func _generate():
	room_count = 0
	map.resize(map_size * map_size)
	_check_room(first_room_x, first_room_y, Vector2.ZERO, true)
	_instantiate_rooms()

func _check_room(x:int, y:int, desired_direction: Vector2, is_first_room: bool = false ): 
	pass


func _instantiate_rooms():
	pass
