class_name ClientIcon
extends Label

var client: Client:
    set(c):
        if c:
            client = c
            text = str(c.net_id)
