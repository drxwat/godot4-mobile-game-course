extends Target

const ACCELERATION := PI / 8

var speed_min := PI / 2.0
var speed_max := PI * 1.5

var acceleration := ACCELERATION

func move(delta: float):
	if speed <= speed_min:
		acceleration = ACCELERATION
	elif speed >= speed_max:
		acceleration = -ACCELERATION
	
	move_with_acceleration(delta)

func move_with_acceleration(delta: float):
	speed = speed + (acceleration * delta)
	rotation -= speed * delta
