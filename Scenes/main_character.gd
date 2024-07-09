extends CharacterBody2D

const FALL_MOD = 0
const FALL_MOD_MAX = 15
const SPEED = 400.0
const JUMP_VELOCITY = -800.0
@onready var sprite_2d = $Sprite2D

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var lastVelocity = 0
var fallingAcceleration = FALL_MOD

# if not on floor, each frame of falling increase delta

func _physics_process(delta):
	if (velocity.x > 1 || velocity.x < -1):
		sprite_2d.animation = "running"
	else:
		sprite_2d.animation = "default"
	
	# Add the gravity.
	if not is_on_floor():
		velocity.y += (gravity * delta) + fallingAcceleration
		sprite_2d.animation = "jumping"

		if fallingAcceleration < FALL_MOD_MAX:
			fallingAcceleration += 1

		
	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * SPEED
		lastVelocity = velocity.x
	else:
		if not is_on_floor():
			velocity.x = move_toward(velocity.x, 0, 4)
		else:
			velocity.x = move_toward(velocity.x, 0, 20)

	move_and_slide()
	
	var isLeft = velocity.x < 0
	sprite_2d.flip_h = lastVelocity < 0 || isLeft

