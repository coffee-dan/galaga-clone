extends Area2D

signal hit

# How fast the player will move (pixels/sec).
# exported so that it can be edited from the inspector sidebar
export var speed = 400 
var screen_size # Size of the game window.
var hitbox_radius

onready var animated_sprite = get_node("AnimatedSprite")
onready var hitbox = get_node("CollisionShape2D")

# Called when the node enters the scene tree for the first time.
func _ready():
	hide()
	hitbox_radius = hitbox.get_shape().radius
	# A good of time as any to get the screen size
	var screen_rect = get_viewport_rect()
	screen_size = screen_rect.size
	var temp_start = screen_rect.get_center()
	temp_start.y = screen_size.y - 100
	start(temp_start)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# Check for input.
	var velocity = Vector2.ZERO # The player's movement vector.
	if Input.is_action_pressed("ui_right"):
		velocity.x += 1
	if Input.is_action_pressed("ui_left"):
		velocity.x -= 1

	if velocity.length() > 0:
		# No vertical movement!
		velocity = Vector2(velocity.x, 0.0) * speed
		animated_sprite.play()
	else:
		animated_sprite.stop()
	
	# Move in the given direction.
	# Bounded by the screen 
	position += velocity * delta
	position.x = clamp(position.x, 0 + hitbox_radius, screen_size.x - hitbox_radius)

	# Play the appropriate animation.
	# No animations currently	

# Player initialzation call
func start(pos=Vector2()):
	position = pos
	show()
	hitbox.disabled = false

func _on_Player_body_entered(_body):
	hide() # Player disappears after being hit
	emit_signal("hit")
	# Must be deferred as we can't change physics properties on a physics callback.
	hitbox.set_deferred("disabled", true) # <- I-Frames !
	
