class_name Client
extends Node

const controller_res := preload("res://tmp/controller.tscn")

var _lobby: WeakRef = weakref(null)
var lobby: Lobby:
  get(): return _lobby.get_ref()
  set(val): _lobby = weakref(val)

@onready var spawner: MultiplayerSpawner = $ControllerSpawner

var net_id: int = -1

var _controllers_counter: int = 0
var controllers: Dictionary[int, Controller]

func _ready() -> void:
  spawner.spawn_function = _ctl_add

func _enter_tree() -> void:
  print("[%d] Client spawned by %s"%[net_id, lobby])

func _exit_tree() -> void:
  print("[%d] Client despawned by %s"%[net_id, lobby])

  
func add_controller(type: Controller.TYPE, id: int) -> void:
  _ctl_add_process.rpc_id(1, type, id)


func remove_controller(uid: int) -> void:
  _ctl_remove_process.rpc_id(1, uid)


func has_controller(type: Controller.TYPE , id: int):
  for cid: int in controllers.keys():
    var c: Controller = controllers[cid]
    if c.dev_type == type and c.dev_id == id:
      return true
  return false


@rpc("any_peer", "call_local", "reliable")
func _ctl_add_process(type: Controller.TYPE , id: int):
  if multiplayer.is_server() and not has_controller(type, id):
    _controllers_counter += 1
    assert(not controllers.keys().has(_controllers_counter))
    spawner.spawn({
      Controller.ID : _controllers_counter,
      Controller.DEV_TYPE : type,
      Controller.DEV_ID : id,
    })


#spawner function
func _ctl_add(data: Variant) -> Controller:
  assert(data.has(Controller.ID))
  print("[%d] custom spawn function with: \n %s"%[multiplayer.get_unique_id(), data])
  var c: Controller = controller_res.instantiate()
  c.from_dict(data)
  controllers[c.id] = c
  return c


@rpc("any_peer", "call_local", "reliable")
func _ctl_remove_process(uid: int):
  if multiplayer.is_server() and controllers.has(uid):
    _ctl_remove.rpc(uid)


@rpc("authority", "call_local", "reliable")
func _ctl_remove(uid: int):
  assert(controllers.has(uid) and controllers[uid] != null)
  if controllers.has(uid):
    controllers[uid].queue_free()
  controllers.erase(uid)
