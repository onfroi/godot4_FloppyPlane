extends Node

@export var tree_scene: PackedScene

var game_running: bool
var game_over: bool
var scroll
var score
const SCROLL_SPEED: int = 400
var screen_size: Vector2i
var ground_height: int
var trees: Array
const TREE_DELAY: int = 100
const TREE_RANGE: int = 200
var save_data:savedata


# Called when the node enters the scene tree for the first time.
func _ready():
	save_data = savedata.load_create()
	screen_size = get_window().size
	ground_height = $Ground.get_node("Sprite2D").texture.get_height()
	new_game()
	
func new_game():
	$GameOver.hide()
	$HighScore.hide()
	game_running = false
	game_over = false
	scroll = 0
	score = 0
	$ScoreLabel.text = "SCORE: " + str(score)
	get_tree().call_group("trees", "queue_free")
	trees.clear()
	generate_trees()
	$Plane.reset()
	
func _input(event):
	if game_over == false:
		if event is InputEventMouseButton:
			if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
				if game_running == false && game_over == false:
					start_game()
			else:
				if $Plane.flying:
					$Plane.flap()
					check_top()

func start_game():
	game_running = true
	$Plane.flying = true
	$Plane.flap()
	$TreeTimer.start()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if game_over == false:
		scroll += SCROLL_SPEED * delta
		if scroll >= screen_size.x:
			scroll = 0 * delta
		$Ground.position.x = -scroll
	
	if game_running:
		for tree in trees:
			tree.position.x -= SCROLL_SPEED * delta


func _on_tree_timer_timeout():
	generate_trees()
	
func generate_trees():
	var tree = tree_scene.instantiate()
	tree.position.x = screen_size.x + TREE_DELAY
	tree.position.y = (screen_size.y - ground_height) / 2.0 + randi_range(-TREE_RANGE, TREE_RANGE)
	tree.hit.connect(plane_hit)
	tree.scored.connect(scored)
	add_child(tree)
	trees.append(tree)
	
func scored():
	score += 1
	$ScoreLabel.text = "SCORE: " + str(score)
	
func check_top():
	if $Plane.position.y < 0:
		$Plane.falling = true
		stop_game()
		
func stop_game():
	$TreeTimer.stop()
	$GameOver.show()
	if score > save_data.high_score:
		save_data.high_score = score
		save_data.save()
	$HighScore.text = "HIGH SCORE: " + str(save_data.high_score)
	$HighScore.show()
	$Plane.flying = false
	game_running = false
	game_over = true
	$Plane/PlaneAnimation.stop()
	$Plane/PlaneSound.stop()

func plane_hit():
	$Plane.falling = true
	stop_game()

func _on_ground_hit():
		$Plane.falling = false
		stop_game()

func _on_game_over_restart():
	new_game()
	
