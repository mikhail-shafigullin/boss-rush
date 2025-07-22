class_name TestBoss
extends CharacterBody2D

@export var circularAttackOnPlayer: PackedScene;
@export var teleport_range: float = 300.0;

@onready var attackTimer: Timer = %AttackTimer;

var random: RandomNumberGenerator;

func _ready() -> void:
	attackTimer.start();
	random = RandomNumberGenerator.new();
	pass;

func _process(delta: float) -> void:
	pass;


func _on_attack_timer_timeout() -> void:
	pass # Replace with function body.
	
func circular_attack_to_player() -> void:
	var player: Player = Global.player;
	if player:
		var attackPos: Vector2 = player.global_position;
		var circularAttack: Node2D = circularAttackOnPlayer.instantiate();
		circularAttack.global_position = attackPos;
		get_tree().root.add_child(circularAttack);

func teleport_to_random_pos_near_player():
	var player: Player = Global.player;
	if player:
		var playerPosition: Vector2 = player.global_position;
		var new_position: Vector2 = Vector2(random.randf_range(playerPosition.x - teleport_range, playerPosition.x + teleport_range), 
			random.randf_range(playerPosition.y - teleport_range, playerPosition.y + teleport_range));
		global_position = new_position;
