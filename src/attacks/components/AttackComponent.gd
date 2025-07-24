@tool
class_name AttackComponent
extends Node

@export var damage: float;
@export var channeling_timer: Timer;
@export var area: CollisionObject2D;
var progress: float = 0.0;
var is_active: bool = false;

signal channeling_started;
signal channeling_finished;
signal attack_performed;
signal attack_hit;

func start_channeling():
	if(channeling_timer):
		channeling_started.emit();
		channeling_timer.start();
		channeling_timer.timeout.connect(perform_attack);

func perform_attack() -> void:
	if(channeling_timer):
		channeling_finished.emit()
	attack_performed.emit();
	is_active = true
	check_attack_collision();
	pass;

func _physics_process(delta: float) -> void:
	if(channeling_timer):
		progress = 1 - clampf(channeling_timer.time_left / channeling_timer.wait_time, 0, 1);
	if(is_active):
		check_attack_collision();


func check_attack_collision():
	for node in area.get_overlapping_bodies():
		var damageableComponent: DamagableComponent = node.get_node_or_null("DamagableComponent");
		damageableComponent.hurt(damage);
		attack_hit.emit()
