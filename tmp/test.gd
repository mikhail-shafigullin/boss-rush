extends Control


func _on_join_button_pressed() -> void:
  Lobby.join()


func _on_host_button_pressed() -> void:
  Lobby.host()


func _on_button_pressed() -> void:
  Lobby.reset()
