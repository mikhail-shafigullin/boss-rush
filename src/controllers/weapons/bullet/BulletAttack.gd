class_name BulletAttack
extends Area2D

@export var speed: float = 1000.0
var direction: Vector2 = Vector2.ZERO;

var initial_position: Vector2 = Vector2.ZERO;
var delete_distance: float = 2000;

@onready var attack_component: AttackComponent = %AttackComponent;

func _ready() -> void:
	initial_position = global_position;
	attack_component.perform_attack();

func set_direction(new_direction: Vector2) -> void:
	direction = new_direction
	rotation = direction.angle()

func _process(delta: float) -> void:
	position += direction * speed * delta;
	check_distance();

func check_distance():
	if(initial_position.distance_to(global_position) > delete_distance):
		queue_free();
	pass;

func _on_attack_component_attack_hit() -> void:
	queue_free();
