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
