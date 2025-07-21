class_name Player
extends CharacterBody2D

@export var hp: float = 100;
@export var speed: float = 18 * 1000.0;
@onready var bulletController: BulletController = %BulletController;

func _ready() -> void:
	Global.player = self;
	if(!bulletController):
		print("BulletController is not initialized");
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


func hurt(damage: float) -> void:
	hp -= damage;
	print("Player HP: ", hp)
	check_death()


func check_death():
	if( hp<=0 ):
		queue_free();


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("player-fire"):
		bulletController.turn_on_shot_at_target();

	if event.is_action_released("player-fire"):
		bulletController.turn_off_shot_at_target();
