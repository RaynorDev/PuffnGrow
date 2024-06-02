extends CharacterBody2D

var screensize
var speed = 120.0
@onready var player = $"."
@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var health = player.get_node("Health")
@onready var death = %Death
@onready var collision_shape_2d = $CollisionShape2D
@onready var music = %Music
@onready var instructions = $"../Hud/Instructions" 
@onready var title = $"../Hud/Title" 


func _ready():
	var rand_x = randf_range(0, 320)
	var rand_y = randf_range(90, 180)
	screensize = get_viewport_rect().size
	position.x = rand_x
	position.y = rand_y
	

func _process(_float):
	if Global.ingame == true:
		print(position)
		player.show()
	else:
		player.hide()
		title.show()
		instructions.show()
	if 0 >= health.value:
		Engine.time_scale = 0
		Global.ingame = false
		music.stop()
		death.play()
		title.text = "Gameover:" + str(Global.score)
		if Input.is_action_pressed("startgame"):
			Global.score = 0
			get_tree().reload_current_scene()
	if Input.is_action_pressed("growsize") and player.scale.x < 2:
		player.scale.x += 0.05
		player.scale.y += 0.05
		speed -= 2
	elif Input.is_action_pressed("shrinksize") and player.scale.x > 0.55:
		speed += 2
		player.scale.x -= 0.05
		player.scale.y -= 0.05

func _physics_process(delta):
	velocity = Vector2.ZERO
	var direction = {"right": Vector2(1, 0), "left": Vector2(-1, 0), "down": Vector2(0, 1), "up": Vector2(0, -1)}
	for action in direction.keys():
		if Input.is_action_pressed(action):
			velocity += direction[action]
	position += velocity * delta
	position = position.clamp(Vector2.ZERO, screensize)
	
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
	if velocity.x > 0:
		animated_sprite_2d.flip_h = true
	elif velocity.x < 0:
		animated_sprite_2d.flip_h = false
	position += velocity * delta
	move_and_slide()
