extends Area2D

var speed = 500
var direction = Vector2(0, 0)
var prediction_point
onready var base_point = position
var target

onready var screen_size = get_viewport().size
onready var shape = $CollisionShape2D.shape.extents
onready var ball = get_node("../Ball")

func _physics_process(delta):
	
	direction = Vector2(0, 0)
	prediction_point = Vector2(position.x, intercept_x_at(position.x, ball.direction, ball.position))
#	prediction_point = Vector2(position.x, predict(position.x, ball.direction, ball.position))
	
	if name == "Left":
		if ball.direction.x < 0:
			target = prediction_point
		else:
			target = base_point
	if name == "Right":
		if ball.direction.x > 0:
			target = prediction_point
		else:
			target = base_point
	
	if position.y < target.y - shape.y:
		direction.y = 1
	if position.y > target.y + shape.y:
		direction.y = -1
	
	direction = direction.normalized()
	translate(speed * direction * delta)
	
	if global_position.y < 0 + shape.y:
		global_position.y = 0 + shape.y
	if global_position.y > screen_size.y - shape.y:
		global_position.y = screen_size.y - shape.y
	
func predict(x, dir, pos):
	var y = intercept_x_at(x, dir, pos)
	
	if intercept_x_at(x, dir, pos) < 0 + 8:
		y = predict(x, -dir, Vector2( intercept_y_at(0 + 8, dir, pos), 0 ))
	elif intercept_x_at(x, dir, pos) > screen_size.y - 8:
		y = predict(x, -dir, Vector2( intercept_y_at(screen_size.y - 8, dir, pos), 0 ))
	else:
		y = intercept_x_at(x, dir, pos)
	
	return y

func intercept_x_at(x, dir, pos):
	# Find the y coordinate the target will be at x coordinate x using the linear formula y - y1 = m(x - x1)
	return (dir.y / dir.x) * (x - pos.x) + pos.y

func intercept_y_at(y, dir, pos):
	# Find the point the ball will be at once its y coordinate is at the paddle using the linear formula y - y1 = m(x - x1)
	return (y - pos.y) / (dir.y / dir.x) + pos.x

func _ready():
	set_physics_process(true)
