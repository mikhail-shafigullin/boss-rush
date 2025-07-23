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


func is_for(event: InputEvent) -> bool:
  match dev_type:
    TYPE.Keyboard:
      if event is InputEventKey and event.device == dev_id:
        return true
    TYPE.Gamepad:
      if event is InputEventJoypadButton and event.device == dev_id:
        return true
      
  return false

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

static func get_event_type(event: InputEvent) -> TYPE:
  if event is InputEventKey:
    return TYPE.Keyboard
  elif event is InputEventJoypadButton:
    return TYPE.Gamepad
  else:
    return TYPE.None

static func event_is_valid(event: InputEvent) -> bool:
  if event is InputEventMouseButton:
    return false

  elif event is InputEventJoypadMotion:
    return false

  return event is InputEventKey or InputEventJoypadButton


func remove():
  assert(client)
  client.remove_controller(id)