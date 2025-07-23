class_name EnemyController
extends Node2D

var root_collided_object: CollisionObject2D;
@export var changeable_sprite: Sprite2D;
@export var hp: float = 100;

var original_modulate: Color;


func _ready() -> void:
	root_collided_object = get_parent();
	original_modulate = changeable_sprite.modulate
	pass;

func on_hit() -> void:
	if changeable_sprite:
		changeable_sprite.modulate = Color(10,10,10,10)
		await get_tree().create_timer(0.1).timeout
		changeable_sprite.modulate = original_modulate
		hp -= 2;
		print("Boss hit hp: ", hp)
		if(hp <= 0.0 and root_collided_object):
			root_collided_object.queue_free();
