class_name Player
extends CharacterBody2D

@export var speed: float = 18 * 1000.0;
@onready var bulletController: BulletAttackComponent = %BulletController;
@onready var damagable_component: DamagableComponent = %DamagableComponent;
@onready var player_sprite: Sprite2D = %PlayerSprite;

@onready var synchronizer: StateSynchronizer = %StateSynchronizer
@onready var interpolator: TickInterpolator = %TickInterpolator

var original_modulate;


func _ready() -> void:
	interpolator.add_property(self, "position")
	synchronizer.add_state(self, "position")

	if is_multiplayer_authority():
		$Camera2D.make_current()
		Global.player = self;
		interpolator.enabled = false
		interpolator.enable_recording = false
	else:
		interpolator.enabled = true
		interpolator.enable_recording = true

	if(!bulletController):
		print("BulletController is not initialized");
	original_modulate = player_sprite.modulate;
	

func _physics_process(delta: float) -> void:
	if is_multiplayer_authority():
		player_master_move(delta)
	else:
		velocity = Vector2.ZERO


func player_master_move(delta: float) -> void:
		var direction := Input.get_vector("player-left", "player-right", "player-up", "player-down")
		
		if direction != Vector2.ZERO:
			velocity = direction * speed * delta
		else:
			velocity = Vector2.ZERO
		
		var mouse_pos = get_global_mouse_position()
		bulletController.target_at_position(global_position, mouse_pos);

		move_and_slide()


func _input(event: InputEvent) -> void:
	if is_multiplayer_authority():
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


func despawn() -> void:
	queue_free()
