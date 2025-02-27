extends CharacterBody2D

const GRAVITY: int = 1000
const MAX_VEL: int = 600
const FLAP_SPEED: int = -500
var flying: bool = false
var falling: bool = false
const START_POS = Vector2(100,400)

func _ready():
	reset()

func reset():
	flying = false
	falling = false
	position = START_POS
	set_rotation(0)
	$Tap.show()
	$TapAnimation.show()
	$PlaneAnimation.play()
	$PlaneSound.play()
	
func _physics_process(delta):
	if flying or falling:
		velocity.y += GRAVITY * delta
	
		if velocity.y > MAX_VEL:
			velocity.y = MAX_VEL
		if flying:
			set_rotation(deg_to_rad(velocity.y * 0.05))
		elif falling:
			set_rotation(PI/2)
			$PlaneAnimation.stop()
			$PlaneSound.stop()
		move_and_collide(velocity * delta)

func flap():
	velocity.y = FLAP_SPEED
	$Tap.hide()
	$TapAnimation.hide()
