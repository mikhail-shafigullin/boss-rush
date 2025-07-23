class_name ControllerIcon
extends TabContainer

@onready var test_label: Label = %ControllerId
@onready var input_device_texture: TextureRect = %InputDeviceTexture

const gamepad_texture := preload("res://tmp/gamepad.svg")
const keyboard_texture := preload("res://tmp/keydoard.svg")

var controller: Controller = null

func _ready() -> void:
	update()

func update():
	if controller:
		current_tab = 1
		test_label.text = "[%d]\ndev_id: %d\n"%[controller.client.net_id, controller.dev_id]
		match controller.dev_type:
			Controller.TYPE.Gamepad:
				test_label.text += "gamepad"
				input_device_texture.texture = gamepad_texture

			Controller.TYPE.Keyboard:
				test_label.text += "keyboard"
				input_device_texture.texture = keyboard_texture

	else:
		current_tab = 0
		test_label.text = ""
		input_device_texture = null

func _input(event: InputEvent) -> void:
	if not controller and Lobby.active:
		if event.is_pressed() and Controller.event_is_valid(event):
			var client := Lobby.get_local_client()
			if client and not client.event_handled(event):
				if get_window().has_focus():
					var t := Controller.get_event_type(event)
					print(event)
					client.add_controller(t, event.device)
					accept_event()


func _on_kick_button_pressed() -> void:
	if controller:
		controller.remove()
		
