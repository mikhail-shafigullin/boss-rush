class_name BulletAttackComponent
extends Node

@export var bullet_scene: PackedScene
@export var cooldown: float = 0.2;

var is_shoting: bool = false;
var source_position: Vector2;
var target_position: Vector2;

var cooldown_wait = 0;

func _ready() -> void:
	print("Bullet cooldown:", cooldown);

func _process(delta: float) -> void:
	if is_shoting and cooldown_wait <= 0:
		shot_at_position.rpc(source_position, target_position);
	
	if cooldown_wait > 0:
		cooldown_wait -= delta;

func target_at_position(_source_position: Vector2, _target_position: Vector2) -> void:
	source_position = _source_position;
	target_position = _target_position
	pass;

func turn_on_shot_at_target() -> void:
	is_shoting = true;

func turn_off_shot_at_target() -> void:
	is_shoting = false;

@rpc("authority", "reliable", "call_local")
func shot_at_position(position: Vector2, target_position: Vector2) -> void:
	var bullet = bullet_scene.instantiate() as Node2D
	bullet.position = position
	var direction = (target_position - position).normalized()
	bullet.set_direction(direction)
	Global.attacks_pool.add_child(bullet)
	cooldown_wait += cooldown;
