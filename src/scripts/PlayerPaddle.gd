extends Area2D

var speed = 500
var direction = Vector2(0, 0)

onready var screen_size = get_viewport().size
onready var shape = $CollisionShape2D.shape.extents

func _physics_process(delta):
	
	direction = Vector2(0, 0)
	
	if Input.is_action_pressed("ui_up"):
		direction.y -= 1
	if Input.is_action_pressed("ui_down"):
		direction.y += 1
	
	direction = direction.normalized()
	translate(speed * direction * delta)
	
	if global_position.y < 0 + shape.y:
		global_position.y = 0 + shape.y
	if global_position.y > screen_size.y - shape.y:
		global_position.y = screen_size.y - shape.y

func _ready():
	set_physics_process(true)
