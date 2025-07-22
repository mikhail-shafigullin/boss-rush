extends BoxContainer

const icon_res := preload("res://tmp/lobby/controller_icon.tscn")
var icons: Array[ControllerIcon] = []

func _ready() -> void:
    Lobby.connected.connect(update)
    Lobby.disconnected.connect(update)
    Lobby.controller_connected.connect(_on_ctl_connected)
    Lobby.controller_disconnected.connect(_on_ctl_disconnected)
    update()

    
func _on_ctl_connected(_c: Controller):
    update()

func _on_ctl_disconnected(_c: Controller):
    update()

func update() -> void:
    clear()
    for client: Client in Lobby.get_clients():
        for ctl: Controller in client.get_controllers():
            add_icon(ctl)

    if Lobby.has_controller_slot():
        add_icon()
        

func add_icon(controller: Controller = null):
    var i: ControllerIcon = icon_res.instantiate()
    i.controller = controller
    add_child(i)
    icons.push_back(i)

func clear():
    while not icons.is_empty():
        icons.pop_front().queue_free()
