extends CharacterBody2D


@export var curr_hp: int = 4 
@export var max_hp: int = 4 
@export var move_speed: float = 20

@export var attack_damage: int = 1
@export var attack_range: float = 10
@export var attack_rate: float = 0.5

var last_attack_time: float

@onready var sprite: Sprite2D = $Sprite

var room: Room
var is_active: bool = false


var player: CharacterBody2D
var player_direction: Vector2
var player_distance: float

func _ready() -> void:
	player = get_tree().get_first_node_in_group("Player")
	GlobalSignals.OnPlayerEnterRoom.connect(_on_player_enter_room)
func initialize(in_room: Room):
	is_active = false
	room = in_room

func _on_player_enter_room(player_room: Room):
	is_active = player_room == room
	
func _physics_process(delta: float) -> void:
	if not is_active or player == null:
		return
	
	player_direction = global_position.direction_to(player.global_position)
	player_distance = global_position.distance_to(player.global_position)
	sprite.flip_h = player_direction.x < 0
	if player_distance < attack_range: 
		_try_attack()
		return
	velocity = player_direction * move_speed 
	move_and_slide()
func _try_attack():
	if Time.get_unix_time_from_system() - last_attack_time < attack_rate:
		return
	last_attack_time = Time.get_unix_time_from_system()
	player.take_damage(attack_damage)
	
func take_damage(amount: int):
	curr_hp -= amount
	if curr_hp <= 0:
		die()

func die():
	queue_free()
