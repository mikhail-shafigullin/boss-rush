@tool
extends BTAction

var circle_attack_scene: PackedScene = preload("res://objects/attacks/CircleChannelingAttack.tscn");
var circle_attack: CircleChannelingAttack;

func _generate_name() -> String:
	return "Send circular attack to player"

func _setup() -> void:
	pass
	
func _enter() -> void:
	var player: Player = Global.player;
	if player:
		var attackPos: Vector2 = player.global_position;
		var circularAttack: Node2D = circle_attack_scene.instantiate();
		circularAttack.global_position = attackPos;
		agent.get_tree().root.add_child(circularAttack);
	pass;
	
func _exit() -> void:
	pass;
	
func _tick(delta: float) -> Status:
	return SUCCESS;

func _get_configuration_warnings() -> PackedStringArray:
	var warnings := PackedStringArray()
	return warnings;
