class_name BulletAttack
extends Area2D

@export var speed: float = 1000.0
var direction: Vector2 = Vector2.ZERO;

var enemyBitMask = 1 << 4

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func set_direction(new_direction: Vector2) -> void:
	direction = new_direction
	rotation = direction.angle()

func _process(delta: float) -> void:
	position += direction * speed * delta

func _on_body_entered(body: Node) -> void:
	if body.get_collision_layer() & enemyBitMask == enemyBitMask:
		var enemyController: EnemyController = body.get_node("EnemyController");
		enemyController.on_hit()
		queue_free();
	
