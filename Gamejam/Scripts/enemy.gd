extends CharacterBody2D
var rng = RandomNumberGenerator.new()

var SPEED = round(rng.randf_range(100,120)) 
@onready var enemysprite = $AnimatedSprite2D
@onready var player = %Player
@onready var hitbox = $Hitbox
@onready var health = player.get_node("Health")
@onready var enemy = $"."
@onready var warning = $Warning

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


func _process(delta):
	if Global.ingame == true:
		enemy.show()
	elif Global.ingame == false:
		enemy.hide()

func _ready():
	var rand_x = randf_range(0, 320)
	position.x = rand_x
	warning.hide()

func _physics_process(_delta):
	if Global.score >= 25:
		SPEED = Global.score * 90 / round(rng.randf_range(5,50))
		warning.show()
		await get_tree().create_timer(1.0).timeout
		
	var angle_to_player = enemysprite.global_rotation - enemysprite.get_angle_to(%Player.position)
	if abs(angle_to_player) > PI / 2:
		enemysprite.flip_v = true
	else:
		enemysprite.flip_v = false
	enemysprite.flip_h = true
	enemysprite.look_at(Vector2(%Player.position.x, %Player.position.y))
	velocity = position.direction_to(%Player.position) * SPEED
	move_and_slide()
	

func _on_hitbox_body_entered(body):
	if body == %Player:
		health.value = 0
