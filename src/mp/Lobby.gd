extends Node

enum
{
	CLIENT_ID = 0,
}

enum SCENE
{
	LOBBY,
	GAME,
}

const _scenes: Dictionary[SCENE, PackedScene] = {  
	SCENE.LOBBY : preload("res://objects/mainMenu/lobbyScene/LobbyScene.tscn"),
	SCENE.GAME : preload("res://levels/MainLevel.tscn"),
}

signal connected
signal disconnected
signal client_connected(client: Client)
signal client_disconnected(client: Client)

signal controller_connected(controller: Controller)
signal controller_disconnected(controller: Controller)

const PORT: int = 31221;
const MAX_CLIENTS: int = 8;
const MAX_CONTROLLERS: int = 8;
const client_res := preload("res://objects/mp/Client.tscn")

var clients: Dictionary[int, Client]
var spawner: MultiplayerSpawner 

var active: bool = false # hosted or joined
var running: bool = false # game in progress

var scene_manager: SceneManager = null

@rpc("authority", "call_local", "reliable")
func change_scene(scene: SCENE):
	assert(scene_manager)
	scene_manager.change_scene(_scenes[scene])


func start_game() -> bool:
	if is_multiplayer_authority():
		if active and not running:
			running = true
			change_scene.rpc(SCENE.GAME)
			return true
	else:
		push_warning("only host can start the game")

	return false

func has_controller_slot():
	# if multiplayer.is_server(): # test
	#   return get_controllers().size() < 2
	return get_controllers().size() < MAX_CONTROLLERS

func get_controllers() -> Array[Controller]:
	var out: Array[Controller] = []
	for c: Client in get_clients():
		for cc: Controller in c.get_controllers():
			out.push_back(cc)
	return out

func _ready() -> void:
	multiplayer.connected_to_server.connect(_on_connected_to_server)
	multiplayer.peer_connected.connect(_on_peer_connected)
	multiplayer.peer_disconnected.connect(_on_peer_disconnected)
	multiplayer.server_disconnected.connect(_on_server_disconnected)

	spawner = MultiplayerSpawner.new()
	spawner.name = "ClientSpawner"
	add_child(spawner)
	spawner.spawn_path = get_path()
	spawner.spawn_function = _spawn_client

func host() -> void:
	if active:
		reset()

	var p: MultiplayerPeer = ENetMultiplayerPeer.new()
	var err: int = p.create_server(PORT, MAX_CLIENTS)
	if err == OK:
		multiplayer.multiplayer_peer = p

		_on_connected_to_server()


func join() -> void:
	if active:
		reset()

	var p: MultiplayerPeer = ENetMultiplayerPeer.new()
	var err: int = p.create_client("localhost", PORT)
	if err == OK:
		multiplayer.multiplayer_peer = p

func reset():
	if active:
		multiplayer.multiplayer_peer = null
		active = false

		for c: Client in get_clients():
			c.queue_free()
		clients.clear()

	disconnected.emit()

func get_clients() -> Array[Client]:
	return clients.values()

func get_local_client() -> Client:
	var net_id := multiplayer.get_unique_id()
	if not clients.has(net_id):
		# assert(clients.has(net_id))
		push_warning("trying to get non existing client")
		return null
	
	return clients[net_id]
	

#Spawner will call this
func _spawn_client(data: Variant) -> Client:
	var c: Client = client_res.instantiate()
	c.lobby = self

	c.net_id = data[CLIENT_ID]
	c.name = "Client[%d]"%c.net_id
	clients[c.net_id] = c

	client_connected.emit.call_deferred(c)
	c.controller_connected.connect(controller_connected.emit)
	c.controller_disconnected.connect(controller_disconnected.emit)

	return c

func _despawn_client(id: int):
	if clients.has(id):
		var c: Client = clients[id]
		clients.erase(id)
		client_disconnected.emit(c)
		c.queue_free()
	

func _on_peer_connected(id: int):
	print("[%d] peer(%d) connected"%[multiplayer.get_unique_id(), id])
	if multiplayer.is_server():
		spawner.spawn({
			CLIENT_ID : id,
		})


func _on_connected_to_server():
	var net_id: int = multiplayer.get_unique_id()
	print("[%d] connected to the server"%net_id)
	_on_peer_connected(net_id)
	
	active = true
	connected.emit()


func _on_peer_disconnected(id: int):
	print("[%d] peer(%d) disconnected"%[multiplayer.get_unique_id(), id])
	assert(clients.has(id))
	_despawn_client(id)
	pass


func _on_server_disconnected():
	var net_id: int = multiplayer.get_unique_id()
	print("[%d] disconnected from the server"%net_id)
	# pass
