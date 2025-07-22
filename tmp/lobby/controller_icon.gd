class_name ControllerIcon
extends TabContainer

@onready var test_label: Label = %ControllerId

var controller: Controller = null

func _ready() -> void:
    update()

func update():
    if controller:
        current_tab = 1
        test_label.text = "[%d]\ndev_id: %d\ndev_type: %d"%[controller.client.net_id, controller.dev_id, controller.dev_type]
    else:
        current_tab = 0
        test_label.text = ""

func _input(event: InputEvent) -> void:
    if not controller and Lobby.active:
        if event.is_pressed() and Controller.event_is_valid(event):
            var c := Lobby.get_local_client()
            if c and not c.event_handled(event):
                if get_window().has_focus():
                    var t := Controller.get_event_type(event)
                    print(event)
                    c.add_controller(t, event.device)
                    accept_event()
