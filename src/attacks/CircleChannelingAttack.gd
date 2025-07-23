@tool
class_name CircleChannelingAttack
extends Node2D

@export var radius: float = 200.0;
@export var damage: float = 20.0;
@export var is_enemy: bool = true;

@onready var channeling_sprite: Sprite2D = %ChannelingSprite;
@onready var timer = %ChannelingTimer;
@onready var area2D: Area2D = %Area2D;
@onready var attack_component: AttackComponent = %AttackComponent;

func _ready() -> void:
	channeling_sprite.material.set_shader_parameter("progress", 0)
	scale = Vector2(radius, radius);
	attack_component.start_channeling();
	
func _process(delta: float) -> void:
	channeling_sprite.material.set_shader_parameter("progress", attack_component.progress)

func _on_attack_component_attack_performed() -> void:
	if not Engine.is_editor_hint():
		queue_free();
