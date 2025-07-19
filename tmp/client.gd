class_name Client
extends Node

enum CTLTYPE
{
  None,
  Keyboard,
  Gamepad
}

var _lobby: WeakRef = weakref(null)
var lobby: Lobby:
  get(): return _lobby.get_ref()
  set(val): _lobby = weakref(val)


var id: int = -1
var controllers: Dictionary[int, Controller]

class Controller:
  var dev_type: CTLTYPE
  var dev_id: int
  
  # enum
  # {
  #   DEV_TYPE,
  #   DEV_ID
  # }
  
  # func to_dict() -> Dictionary:
  #   return {
  #     DEV_TYPE : dev_type,
  #     DEV_ID : dev_type
  #   }

  # func from_dict(dict: Dictionary) -> void:
  #   dev_type = dict.get(DEV_TYPE, CTLTYPE.None)
  #   dev_id = dict.get(DEV_ID, -1)


func _enter_tree() -> void:
  print("[%d] Client spawned by %s"%[id, lobby])

func _exit_tree() -> void:
  print("[%d] Client despawned by %s"%[id, lobby])
  
func controller_add_request(type: CTLTYPE, id: int) -> void:
  controller_add.rpc_id(1, type, id)

func controller_remove_request(uid: int) -> void:
  controller_remove.rpc_id(1, uid)

@rpc("authority", "call_local", "reliable")
func controller_add(type: CTLTYPE , id: int):
  var c := Controller.new()
  c.dev_type = type
  c.dev_id = id

  print("hello")
  pass


@rpc("authority", "call_local", "reliable")
func controller_remove(uid: int):
  print("goodby")
  pass
