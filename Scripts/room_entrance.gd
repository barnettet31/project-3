class_name RoomEntrance
extends Node2D

@export var direction: Room.Direction = Room.Direction.NORTH

@onready var barrier: StaticBody2D =  $Barrier
@onready var barrier_collider : CollisionShape2D = $Barrier/CollisionShape2D

@onready var door: Node2D = $Door
@onready var door_shut : StaticBody2D = $Door/Door_Shut
@onready var door_shut_collider : CollisionShape2D = $Door/Door_Shut/CollisionShape2D

@onready var player_spawn: Node2D = $PlayerSpawn
@onready var exit_trigger: Area2D = $ExitTrigger

var neighbor : Room

func _ready():
	exit_trigger.body_entered.connect(_on_body_entered_exit_trigger)
	toggle_barrier(true)
func set_neighbor(neighbor_room: Room):
	neighbor = neighbor_room
	toggle_barrier(false)

func toggle_barrier(toggle: bool):
	barrier.visible = toggle
	barrier_collider.disabled = !toggle
	door.visible = !toggle

func open_door():
	if barrier.visible: 
		return
	door_shut.visible = false
	door_shut_collider.disabled = true
	

func close_door():
	if barrier.visible: 
		return
	door_shut.visible = true
	door_shut_collider.disabled = false
	
	
func _on_body_entered_exit_trigger(body):
	pass

func _get_neighbor_entry_direction()-> Room.Direction:
	if direction == Room.Direction.NORTH:
		return Room.Direction.SOUTH
	elif direction == Room.Direction.SOUTH:
		return Room.Direction.NORTH
	elif direction == Room.Direction.EAST:
		return Room.Direction.WEST
	else:
		return Room.Direction.EAST
	
