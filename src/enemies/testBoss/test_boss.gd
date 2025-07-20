class_name TestBoss
extends CharacterBody2D

@export var circularAttackOnPlayer: PackedScene;

@onready var attackTimer: Timer = %AttackTimer;

func _ready() -> void:
	attackTimer.start()
	pass;

func _process(delta: float) -> void:
	pass;


func _on_attack_timer_timeout() -> void:
	var player: Player = Global.player;
	if player:
		var attackPos: Vector2 = player.global_position;
		var circularAttack: Node2D = circularAttackOnPlayer.instantiate();
		circularAttack.global_position = attackPos;
		get_tree().root.add_child(circularAttack);
	pass # Replace with function body.
