extends KinematicBody2D

const BASE_SPEED = 300
var speed = BASE_SPEED
var direction = Vector2(0, 0)
export(int) var speed_increase = 30

var collision

var starting_directions = [ Vector2(1, 1), Vector2(-1, 1), Vector2(-1, -1), Vector2(1, -1) ]

func _physics_process(delta):
	
	direction = direction.normalized()
	collision = move_and_collide(speed * direction * delta)
	
	if collision != null:
		direction = direction.bounce(collision.normal)
	
	if position.x < -128 or position.x > get_viewport().size.x + 128:
		start()

func start():
	position = get_viewport().size / 2
	speed = BASE_SPEED
	direction = starting_directions[ randi() % len(starting_directions) ]

func _on_Area2D_area_entered(area):
	if area.get_name() == "Left":
		direction.x = abs(direction.x)
		direction.y += (area.get_global_position().y - self.get_global_position().y) / -48
	if area.get_name() == "Right":
		direction.x = -direction.x
		direction.y += (area.get_global_position().y - self.get_global_position().y) / -48
	
	speed += 25

func _ready():
	
	randomize()
	start()
	set_physics_process(true)
