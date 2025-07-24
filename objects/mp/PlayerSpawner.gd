extends Node2D

enum {
	POSITION,
	CLIENT_ID,
}

const player_res := preload("res://objects/player/Player.tscn")
@onready var spawner: MultiplayerSpawner = $Spawner


func _spawn_player(data: Dictionary) -> Node:
	var player = player_res.instantiate()
	print(data[CLIENT_ID])
	player.set_multiplayer_authority(data[CLIENT_ID])
	player.global_position = data[POSITION]
	return player


func _ready() -> void:
	spawner.spawn_function = _spawn_player
	spawner.spawn_path = "../"
	spawner.despawned.connect(_on_despawn)

	if is_multiplayer_authority():
		for c: Client in Lobby.get_clients():
			spawner.spawn({
				CLIENT_ID : c.net_id,
				POSITION : global_position,
			})



func _on_despawn(player: Node):
	player.despawn()
	
