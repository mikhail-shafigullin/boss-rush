class_name Player
extends CharacterBody2D

@export var speed: float = 18 * 1000.0;
@onready var bulletController: BulletController = %BulletController;
@onready var damagable_component: DamagableComponent = %DamagableComponent;
@onready var player_sprite: Sprite2D = %PlayerSprite;

var original_modulate;

func _ready() -> void:
	Global.player = self;
	if(!bulletController):
		print("BulletController is not initialized");
	original_modulate = player_sprite.modulate;
	pass;

func _physics_process(delta: float) -> void:
	var direction := Vector2.ZERO
	
	if Input.is_action_pressed("player-up"):
		direction.y -= 1
	if Input.is_action_pressed("player-down"):
		direction.y += 1
	if Input.is_action_pressed("player-left"):
		direction.x -= 1
	if Input.is_action_pressed("player-right"):
		direction.x += 1
	
	if direction != Vector2.ZERO:
		direction = direction.normalized()
		velocity = direction * speed * delta
	else:
		velocity = Vector2.ZERO
	
	var mouse_pos = get_global_mouse_position()
	bulletController.target_at_position(global_position, mouse_pos);
	
	move_and_slide()


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("player-fire"):
		bulletController.turn_on_shot_at_target();

	if event.is_action_released("player-fire"):
		bulletController.turn_off_shot_at_target();


func _on_damagable_component_took_damage() -> void:
	player_sprite.modulate = Color(10,0,0,1)
	await get_tree().create_timer(0.1).timeout
	player_sprite.modulate = original_modulate


func _on_damagable_component_death() -> void:
	self.queue_free();
