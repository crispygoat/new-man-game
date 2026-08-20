extends CharacterBody2D

const SPEED := 90.0

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

var input_locked := false
var facing := Vector2.DOWN

func _physics_process(_delta: float) -> void:
	if input_locked:
		velocity = Vector2.ZERO
		move_and_slide()
		return

	var input_dir := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	velocity = input_dir * SPEED
	move_and_slide()

	if input_dir != Vector2.ZERO:
		facing = input_dir
		_update_animation()


func _update_animation() -> void:
	if absf(facing.x) > absf(facing.y):
		sprite.play("idle_side")
		sprite.flip_h = facing.x > 0
	elif facing.y > 0:
		sprite.play("idle_down")
	else:
		sprite.play("idle_up")
