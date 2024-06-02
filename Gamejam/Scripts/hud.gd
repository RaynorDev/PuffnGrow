extends CanvasLayer

@onready var player = %Player
@onready var canvas = $"."
@onready var health = player.get_node("Health")
@onready var score = $Score
@onready var title = $Title
@onready var instructions = $Instructions
@onready var music = %Music
@onready var icon = $Title/Icon
@onready var warning = $Title/Warning


# Called when the node enters the scene tree for the first time.
func _ready():
	music.stop()
	score.hide()
	Global.ingame = false
	canvas.visible = true
	Engine.time_scale = 0
	
func _process(_delta):
	if Input.is_action_pressed("startgame") and Global.ingame == false:
		icon.visible = false
		warning.visible = false
		Global.ingame = true
		music.play()
		title.hide()
		instructions.hide()
		Engine.time_scale = 1
		score.show()
	score.text = str(Global.score)

func _on_timer_timeout():
	Global.score += 1
	var scale_difference = player.scale.x - 1
	if player.scale.x < 1:
		health.value -= abs(scale_difference) * 5 # Adjust the multiplier as needed
	elif player.scale.x > 1:
		health.value += abs(scale_difference) * 5 # Adjust the multiplier as needed
	elif player.scale.x == 1:
		health.value -= 1
