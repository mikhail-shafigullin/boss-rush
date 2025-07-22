@tool
class_name SendCircleSegmentAttackToPlayer
extends BTAction

var circle_attack_scene: PackedScene = preload("res://objects/attacks/CircleSegmentChannelingAttack.tscn");

func _generate_name() -> String:
	return "Send circle segment attack to player"

func _setup() -> void:
	pass
	
func _enter() -> void:
	var player: Player = Global.player;
	if player:
		var attackPos: Vector2 = player.global_position;
		var circularAttack: Node2D = circle_attack_scene.instantiate();
		circularAttack.global_position = agent.global_position;
		var direction: Vector2 = (attackPos - circularAttack.global_position).normalized();
		circularAttack.rotation = direction.angle();
		agent.get_tree().root.add_child(circularAttack);
	pass;
	
func _exit() -> void:
	pass;
	
func _tick(delta: float) -> Status:
	return SUCCESS;

func _get_configuration_warnings() -> PackedStringArray:
	var warnings := PackedStringArray()
	return warnings;
