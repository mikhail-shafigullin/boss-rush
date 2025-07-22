extends Node

enum
{
  CLIENT_ID = 0,
}

signal connected
signal disconnected
signal client_connected(client: Client)
signal client_disconnected(client: Client)

const PORT: int = 31221;
const MAX_CLIENTS: int = 8;
const client_res := preload("res://tmp/client.tscn")

var clients: Dictionary[int, Client]
var spawner: MultiplayerSpawner 

var active: bool = false

func on_button():
  get_local_client().controllers[1].dev_id += 1

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

  active = true
  var p: MultiplayerPeer = ENetMultiplayerPeer.new()
  p.create_server(PORT, MAX_CLIENTS)
  multiplayer.multiplayer_peer = p

  _on_connected_to_server()


func join() -> void:
  if active:
    reset()

  active = true
  var p: MultiplayerPeer = ENetMultiplayerPeer.new()
  p.create_client("localhost", PORT)
  multiplayer.multiplayer_peer = p

func reset():
  if active:
    multiplayer.multiplayer_peer = null

    # for uid: int in clients.keys():
    #   clients[uid].queue_free()
    clients.clear()

  disconnected.emit()

func get_clients() -> Array[Client]:
  return clients.values()

func get_local_client() -> Client:
  var net_id := multiplayer.get_unique_id()
  assert(clients.has(net_id))
  
  return clients[net_id]
  

#Spawner will call this
func _spawn_client(data: Variant) -> Client:
  var c: Client = client_res.instantiate()
  c.lobby = self

  c.net_id = data[CLIENT_ID]
  c.name = "Client[%d]"%c.net_id
  clients[c.net_id] = c

  client_connected.emit.call_deferred(c)

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
