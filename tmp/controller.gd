class_name Controller
extends Node

enum TYPE
{
  None,
  Keyboard,
  Gamepad
}

enum
{
  ID = 0,
  DEV_TYPE,
  DEV_ID
}

@export var id: int = -1
@export var dev_type: TYPE = TYPE.None
@export var dev_id: int = -1

var _client: WeakRef = weakref(null)
var client: Client:
  get(): return _client.get_ref()
  set(val): _client = weakref(val)


func _enter_tree() -> void:
  print("[%d] controller(%d) connected"%[client.net_id, id])
  

func _exit_tree() -> void:
  print("[%d] controller(%d) disconnected"%[client.net_id, id])


func to_dict() -> Dictionary:
  return {
    ID : id,
    DEV_TYPE : dev_type,
    DEV_ID : dev_id,
  }

func from_dict(dict: Dictionary) -> void:
  id = dict.get(ID, id)
  dev_type = dict.get(DEV_TYPE, dev_type)
  dev_id = dict.get(DEV_ID, dev_id)

  name = "Controller[%d]"%id
