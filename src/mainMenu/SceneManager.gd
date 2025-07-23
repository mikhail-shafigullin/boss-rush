class_name SceneManager
extends Control

var _active_scene: Node = null


func _ready() -> void:
	change_scene(Lobby._scenes[Lobby.SCENE.LOBBY])
	Lobby.scene_manager = self
	

func change_scene(scene_res: PackedScene):
	if _active_scene:
		_active_scene.queue_free()

	var scene: Node = scene_res.instantiate()
	add_child(scene, true)
	_active_scene = scene
