extends KinematicBody2D

const BASE_SPEED = 300
var speed = BASE_SPEED
var direction = Vector2(0, 0)
export(int) var speed_increase = 30

var last_score = 0

var collision
# Directions the ball can go in from start
var starting_directions = [ -1, 1 ]

func _physics_process(delta):
	direction = direction.normalized()
	collision = move_and_collide(speed * direction * delta)
	
	if collision != null:
		direction = direction.bounce(collision.normal)
	
	if position.x < -128:
		last_score = -1
		start()
	elif position.x > get_viewport_rect().size.x + 128:
		last_score = 1
		start()

func start():
	position = get_viewport_rect().size / 2
	speed = BASE_SPEED
#	direction = starting_directions[ randi() % len(starting_directions) ]
	direction.y = starting_directions[ randi() % len(starting_directions) ]
	if last_score == 0:
		direction.x = starting_directions[ randi() % len(starting_directions) ]
	else:
		direction.x = last_score

func _on_Area2D_area_entered(area):
	if area.get_name() == "Left":
		direction.x = abs(direction.x)
		direction.y += (area.get_global_position().y - self.get_global_position().y) / -48
	if area.get_name() == "Right":
		direction.x = -direction.x
		direction.y += (area.get_global_position().y - self.get_global_position().y) / -48
	
	speed += 25

func _ready():
	# Generate random seed
	# TODO: Put this in global singleton script?
	randomize()
	start()
	set_physics_process(true)
