@tool
class_name CircularChannelingAttack
extends Node2D

@export var radius: float = 200.0;
@export var damage: float = 0.0;

@onready var channelingSprite: Sprite2D = %ChannelingSprite;
@onready var timer = %ChannelingTimer;

func _ready() -> void:
	channelingSprite.material.set_shader_parameter("progress", 0)
	scale = Vector2(radius, radius);
	start_channeling();
	
func _process(delta: float) -> void:
	var progress: float = 1 - clampf(timer.time_left/timer.wait_time, 0, 1);
	channelingSprite.material.set_shader_parameter("progress", progress)

func start_channeling() -> void:
	timer.start();

func _on_channeling_timer_timeout() -> void:
	if not Engine.is_editor_hint():
		queue_free();
