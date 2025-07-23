@tool
class_name CircleSegmentChannelingAttack
extends Node2D

@export var radius: float = 200.0;
@export var damage: float = 20.0;
@export var isEnemy: bool = true;

@onready var channelingSprite: Sprite2D = %ChannelingSprite;
@onready var timer = %ChannelingTimer;
@onready var area2D: Area2D = %Area2D

func _ready() -> void:
	channelingSprite.material.set_shader_parameter("progress", 0)
	scale = Vector2(radius, radius);
	start_channeling();

func _process(delta: float) -> void:
	var progress: float = 1 - clampf(timer.time_left/timer.wait_time, 0, 1);
	channelingSprite.material.set_shader_parameter("progress", progress)

func start_channeling() -> void:
	timer.start();

func perform_attack() -> void:
	if(area2D.overlaps_body(Global.player)):
		Global.player.hurt(damage)
	queue_free();

func _on_channeling_timer_timeout() -> void:
	if not Engine.is_editor_hint() and Global.player:
		perform_attack();
