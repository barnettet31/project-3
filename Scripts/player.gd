extends CharacterBody2D


@export var move_speed: float = 50 
@onready var sprite: Sprite2D = $sprite
@onready var weapon_origin: Node2D = $Weapon
@onready var muzzle: Node2D = $Weapon/Muzzle

@export var cur_hp: int = 8
@export var max_hp: int = 8
@export var shoot_rate: float = 0.4
var last_shoot_time: float 
var projectile_scene: PackedScene = preload("res://Scenes/Projectiles/projectile.tscn")
func _ready() -> void:
	GlobalSignals.OnPlayerUpdateHealth.emit.call_deferred(cur_hp, max_hp)
func _physics_process(delta: float) -> void:
	var move_input: Vector2 = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity =  move_input * move_speed
	move_and_slide()

func _process(delta: float) -> void:
	var mouse_pos: Vector2 = get_global_mouse_position()
	var mouse_dir: Vector2 = (mouse_pos - global_position).normalized()
	weapon_origin.rotation_degrees = rad_to_deg(mouse_dir.angle()) + 90 
	sprite.flip_h = mouse_dir.x < 0
	
	if Input.is_action_pressed("attack"):
		if Time.get_unix_time_from_system() - last_shoot_time > shoot_rate:
			_shoot()

func _shoot():
	last_shoot_time = Time.get_unix_time_from_system()
	
	var proj = projectile_scene.instantiate()
	get_tree().root.add_child(proj)
	proj.global_position = muzzle.global_position
	proj.rotation = weapon_origin.rotation
	proj.owner_character = self
	$ShootSound.play()
func take_damage(amount : int):
	cur_hp -= amount
	GlobalSignals.OnPlayerUpdateHealth.emit(cur_hp, max_hp)
	$DamageSound.play()
	_damage_flash()
	if cur_hp <= 0:
		die()

func die():
	get_tree().change_scene_to_file("res://Scenes/menu.tscn")

func heal(amount: int):
	cur_hp += amount
	if cur_hp >= max_hp:
		cur_hp = max_hp
	GlobalSignals.OnPlayerUpdateHealth.emit(cur_hp, max_hp)

func _damage_flash():
	visible = false
	await get_tree().create_timer(0.07).timeout
	visible = true
