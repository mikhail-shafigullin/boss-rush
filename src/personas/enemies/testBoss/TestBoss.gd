class_name TestBoss
extends CharacterBody2D

@export var circularAttackOnPlayer: PackedScene;
@export var teleport_range: float = 300.0;

@onready var attackTimer: Timer = %AttackTimer;
@onready var enemy_component: EnemyComponent = %EnemyComponent;

var random: RandomNumberGenerator;

func _ready() -> void:
	attackTimer.start();
	random = RandomNumberGenerator.new();
	pass;

func _process(delta: float) -> void:
	pass;
	

func teleport_to_random_pos_near_player():
	var player: Player = Global.player;
	if player:
		var playerPosition: Vector2 = player.global_position;
		var new_position: Vector2 = Vector2(random.randf_range(playerPosition.x - teleport_range, playerPosition.x + teleport_range), 
			random.randf_range(playerPosition.y - teleport_range, playerPosition.y + teleport_range));
		global_position = new_position;
