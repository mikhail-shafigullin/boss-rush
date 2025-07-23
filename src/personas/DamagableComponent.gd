class_name DamagableComponent
extends Node

@export var hp: float;
@export var area: CollisionObject2D;
var is_dead = false;

signal death;
signal took_damage;

func hurt(damage: float):
	if(!is_dead):
		hp-= damage;
		print(self.get_parent(), " have hp ", hp);
		checkDeath();
		took_damage.emit()


func checkDeath():
	if(hp <= 0):
		hp = 0;
		is_dead = true;
		death.emit();
