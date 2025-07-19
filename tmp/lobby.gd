class_name Lobby
extends Control

enum
{
  CLIENT_ID = 0,
}

const PORT: int = 31221;
const MAX_CLIENTS: int = 8;
const client_res := preload("res://tmp/client.tscn")

var clients: Dictionary[int, Client]
@onready var spawner: MultiplayerSpawner = $MultiplayerSpawner


func _ready() -> void:
  multiplayer.connected_to_server.connect(_on_connected_to_server)
  multiplayer.peer_connected.connect(_on_peer_connected)
  multiplayer.peer_disconnected.connect(_on_peer_disconnected)
  multiplayer.server_disconnected.connect(_on_server_disconnected)

  spawner.spawn_function = _spawn_client
  

func get_local_client() -> Client:
  var net_id := multiplayer.get_unique_id()
  assert(clients.has(net_id))
  
  return clients[net_id]
  


func _spawn_client(data: Variant) -> Client:
  var c: Client = client_res.instantiate()
  c.lobby = self

  c.net_id = data[CLIENT_ID]
  c.name = "Client[%d]"%c.net_id
  clients[c.net_id] = c
  

  return c


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


func _on_peer_disconnected(id: int):
  print("[%d] peer(%d) disconnected"%[multiplayer.get_unique_id(), id])
  assert(clients.has(id))
  if clients.has(id):
    clients[id].queue_free()
  clients.erase(id)
  pass


func _on_server_disconnected():
  var net_id: int = multiplayer.get_unique_id()
  print("[%d] disconnected from the server"%net_id)
  # pass
  get_tree().quit()


func _on_host_button_pressed() -> void:
  var p: MultiplayerPeer = ENetMultiplayerPeer.new()
  p.create_server(PORT, MAX_CLIENTS)
  multiplayer.multiplayer_peer = p

  _on_connected_to_server()


func _on_join_button_pressed() -> void:
  var p: MultiplayerPeer = ENetMultiplayerPeer.new()
  p.create_client("localhost", PORT)
  multiplayer.multiplayer_peer = p
