extends BoxContainer

const client_res := preload("res://tmp/lobby/client_icon.tscn")
var _clients: Array[ClientIcon] = []
var mutex: Mutex = Mutex.new()

func _ready() -> void:
    Lobby.connected.connect(redraw_clients)
    Lobby.disconnected.connect(redraw_clients)
    Lobby.client_connected.connect(on_lobby_size_change)
    Lobby.client_disconnected.connect(on_lobby_size_change)

func on_lobby_size_change(_c: Client):
    redraw_clients()

func clear() -> void:
    while not _clients.is_empty():
        _clients.pop_back().queue_free()

func redraw_clients():
    mutex.lock()
    clear()
    for c: Client in Lobby.get_clients():
        var icon: ClientIcon = client_res.instantiate()
        icon.client = c
        add_child(icon)
        _clients.push_back(icon)
    mutex.unlock()
