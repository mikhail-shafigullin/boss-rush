class_name EnemyComponent
extends Node

var root_collided_object: CollisionObject2D;
@export var changeable_sprite: Sprite2D;
@export var damageable_component: DamagableComponent

var original_modulate: Color;

func _ready() -> void:
	root_collided_object = get_parent();
	original_modulate = changeable_sprite.modulate
	assert(damageable_component != null, "ERROR: Enemy component must be linked with DamagableComponent.")
	damageable_component.took_damage.connect(on_hit);
	damageable_component.death.connect(set_dead);
	pass;

func on_hit() -> void:
	if changeable_sprite:
		changeable_sprite.modulate = Color(10,10,10,10)
		await get_tree().create_timer(0.1).timeout
		changeable_sprite.modulate = original_modulate

func set_dead() -> void:
	get_parent().queue_free();
