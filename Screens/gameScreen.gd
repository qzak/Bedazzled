extends Node2D

#Grid vars
var gridWidth = 10
var gridHeight = 10
var grid_start = Vector2(760,1000)
var offset = 100
var base_gem_score = 100
var combo = 1
var score = 0

#Gem vars
var gem_list = [
	preload("res://Objects/emerald.tscn"),
	preload("res://Objects/ruby.tscn"),
	preload("res://Objects/topaz.tscn"),
	preload("res://Objects/sapphire.tscn"),
	preload("res://Objects/amethyst.tscn"),
	preload("res://Objects/aquamarine.tscn")
]

var gem_array = []

#Action vars
var action_start = Vector2()
var action_end = Vector2()
var action_start_grid_pos = Vector2()
var action_end_grid_pos = Vector2()
var direction = Vector2()
var action_legal = false

# Called when the node enters the scene tree for the first time.
func _ready():
	gem_array = make_grid_array()
	print(gem_array)
	for column in gridHeight:
		for row in gridWidth:
			print("Spawning gem at column: " + str(column) + " row: " + str(row))
			print("gem array location: " + str(gem_array[column][row]))
			spawn_gem(column, row)
	
	#spawn the spend gem buttons and connect their signals to the on_spend_button_pressed function

	var spend_button = preload("res://Objects/spendAmethystButton.tscn").instantiate()
	add_child(spend_button)
	spend_button.position = Vector2(85, 250)  # Set your desired position
	spend_button.spend_button_pressed.connect(on_spend_button_pressed)


func grid_to_pixel(column, row):
	var new_x = grid_start.x + offset * column
	var new_y = grid_start.y + -offset * row
	return Vector2(new_x, new_y)

func pixel_to_grid(pos):
	var column = round((pos.x - grid_start.x) / offset)
	var row = round((grid_start.y - pos.y) / offset)
	return Vector2(column, row)

func make_grid_array():
	var array = []
	for i in gridWidth:
		array.append([])
		for j in gridHeight:
			array[i].append("temp")
	return array

func spawn_gem(column, row, animate = true):
	var random_gem = randi() % gem_list.size()
	var gem_instance = gem_list[random_gem].instantiate()
	var random_gem_type = gem_instance.gemType
	if check_match(column, row, random_gem_type):
		if random_gem == gem_list.size() - 1:
			random_gem = 0
		else:
			random_gem += 1
		gem_instance = gem_list[random_gem].instantiate()
		random_gem_type = gem_instance.gemType
		if check_match(column, row, random_gem_type):
			if random_gem == gem_list.size() - 1:
				random_gem = 0
			else:
				random_gem += 1
			gem_instance = gem_list[random_gem].instantiate()
			random_gem_type = gem_instance.gemType
	add_child(gem_instance)
	if animate:
		gem_instance.position = grid_to_pixel(column, row + gridHeight)
		var tween = get_tree().create_tween()
		tween.tween_property(gem_instance, "position", grid_to_pixel(column, row), 0.5)
	else:
		gem_instance.position = grid_to_pixel(column, row)
	print ("Spawned gem at column: " + str(column) + " row: " + str(row) + " of type: " + str(random_gem))
	gem_array[column][row] = gem_instance

func check_match(column, row, gemType):
	if column > 1:
		if gem_array[column - 1][row] != null and gem_array[column - 2][row] != null:
			if gemType == gem_array[column - 1][row].gemType and gemType == gem_array[column - 2][row].gemType:
				return true
	if row > 1:
		if gem_array[column][row - 1] != null and gem_array[column][row - 2] != null:
			if gemType == gem_array[column][row - 1].gemType and gemType == gem_array[column][row - 2].gemType:
				return true
	return false

func is_in_grid(column, row):
	if column < 0 or column >= gridWidth or row < 0 or row >= gridHeight:
		return false
	return true

func check_matches():
	var found_at_least_one_match = false
	for column in gridWidth:
		for row in gridHeight:
			if gem_array[column][row] != null:
				var gemType = gem_array[column][row].gemType
				if column > 1:
					if gem_array[column - 1][row] != null and gem_array[column - 2][row] != null:
						if gemType == gem_array[column - 1][row].gemType and gemType == gem_array[column - 2][row].gemType:
							print("Match found at column: " + str(column) + " row: " + str(row))
							gem_array[column][row].match()
							gem_array[column - 1][row].match()
							gem_array[column - 2][row].match()
							found_at_least_one_match = true
				if row > 1:
					if gem_array[column][row - 1] != null and gem_array[column][row - 2] != null:
						if gemType == gem_array[column][row - 1].gemType and gemType == gem_array[column][row - 2].gemType:
							print("Match found at column: " + str(column) + " row: " + str(row))
							gem_array[column][row].match()
							gem_array[column][row - 1].match()
							gem_array[column][row - 2].match()
							found_at_least_one_match = true
	if found_at_least_one_match:
		return true
	else:
		return false

func movement_direction(start, end):
	var mov_direction = end - start
	if abs(mov_direction.x) > abs(mov_direction.y):
		mov_direction.y = 0
		if mov_direction.x > 0:
			mov_direction.x = 1
		else:
			mov_direction.x = -1
	else:
		mov_direction.x = 0
		if mov_direction.y > 0:
			mov_direction.y = -1
		else:
			mov_direction.y = 1
	return mov_direction

func swap_gems(column1, row1, swap_direction):
	var first_gem = gem_array[column1][row1]
	var second_gem = gem_array[column1 + swap_direction.x][row1 + swap_direction.y]
	print("Swap gems triggered, first gem: " + str(first_gem) + " second gem: " + str(second_gem))
	gem_array[column1][row1] = second_gem
	gem_array[column1 + swap_direction.x][row1 + swap_direction.y] = first_gem
	print("Gems swapped in array")
	var first_gem_tween = get_tree().create_tween()
	first_gem_tween.tween_property(first_gem, "position", grid_to_pixel(column1 + swap_direction.x, row1 + swap_direction.y), 0.5)
	var second_gem_tween = get_tree().create_tween()
	second_gem_tween.tween_property(second_gem, "position", grid_to_pixel(column1, row1), 0.5)
	await first_gem_tween.finished
	await second_gem_tween.finished
	print("Gem animations triggered")
	if check_matches():
		print("Match found, keeping swap")
		var continue_matching = true
		while continue_matching:
			await score_matches()
			print("Scored matches, dropping gems")
			#wait 100ms to allow for player to be satisfied with numbers
			await get_tree().create_timer(0.3).timeout
			drop_gems()
			print("Dropped gems, spawning new gems")
			spawn_new_gems()
			await get_tree().create_timer(0.5).timeout
			continue_matching = check_matches()
		combo = 1
	else:
		print("No match found, swapping back")
		var first_gem_tween_back = get_tree().create_tween()
		first_gem_tween_back.tween_property(first_gem, "position", grid_to_pixel(column1, row1), 0.5)
		var second_gem_tween_back = get_tree().create_tween()
		second_gem_tween_back.tween_property(second_gem, "position", grid_to_pixel(column1 + swap_direction.x, row1 + swap_direction.y), 0.5)
		gem_array[column1][row1] = first_gem
		gem_array[column1 + swap_direction.x][row1 + swap_direction.y] = second_gem
		#wait until the tweens are done before allowing another swap
		await first_gem_tween_back.finished
	Global.swap_in_progress = false

func drop_gems():
	for column in gridWidth:
		var empty_spots = 0
		for row in gridHeight:
			if gem_array[column][row] == null:
				empty_spots += 1
			elif empty_spots > 0:
				gem_array[column][row - empty_spots] = gem_array[column][row]
				gem_array[column][row] = null
				var gem_tween = get_tree().create_tween()
				gem_tween.tween_property(gem_array[column][row - empty_spots], "position", grid_to_pixel(column, row - empty_spots), 0.5)
	await get_tree().create_timer(0.5).timeout

func spawn_new_gems():
	for column in gridWidth:
		for row in gridHeight:
			if gem_array[column][row] == null:
				spawn_gem(column, row, true)
	await get_tree().create_timer(0.5).timeout

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	$Debug.text = "Swap in progress: " + str(Global.swap_in_progress) + "\nAction legal: " + str(action_legal) + "\nAction start: " + str(action_start) + "\nAction end: " + str(action_end) + "\nAction start grid pos: " + str(action_start_grid_pos) + "\nAction end grid pos: " + str(action_end_grid_pos) + "\nDirection: " + str(direction)
	if Global.swap_in_progress == false:
		if Input.is_action_just_pressed("mouse_click"):
			print("mouse clicked")
			action_start = get_global_mouse_position()
			print("Action start: " + str(action_start))
			action_start_grid_pos = pixel_to_grid(action_start)
			if is_in_grid(action_start_grid_pos.x, action_start_grid_pos.y):
				action_legal = true
		if Input.is_action_just_released("mouse_click"):
			Global.swap_in_progress = true
			print("mouse released")
			action_end = get_global_mouse_position()
			action_end_grid_pos = pixel_to_grid(action_end)
			if (action_start_grid_pos.x == 0 && action_end_grid_pos.x < 0) or (action_start_grid_pos.x == gridWidth - 1 && action_end_grid_pos.x > gridWidth - 1) or (action_start_grid_pos.y == 0 && action_end_grid_pos.y < 0) or (action_start_grid_pos.y == gridHeight - 1 && action_end_grid_pos.y > gridHeight - 1) or action_start_grid_pos == action_end_grid_pos:
				action_legal = false
				Global.swap_in_progress = false
			if action_legal:
				print ("Action start: " + str(action_start_grid_pos) + " Action end: " + str(action_end_grid_pos))
				direction = movement_direction(action_start, action_end)
				if !((direction.x + action_start_grid_pos.x) >= gridWidth or (direction.y + action_start_grid_pos.y) >= gridHeight or (direction.x + action_start_grid_pos.x) < 0 or (direction.y + action_start_grid_pos.y) < 0 or action_start == action_end):
					swap_gems(action_start_grid_pos.x, action_start_grid_pos.y, direction)
			else:
				Global.swap_in_progress = false
			action_legal = false

func score_matches():
	var gem_value = 0
	for column in gridWidth:
		for row in gridHeight:
			if gem_array[column][row] != null and gem_array[column][row].matched:
				gem_value = base_gem_score * combo
				score += gem_value
				var gem_type = gem_array[column][row].score(gem_value)
				Global.total_gems_matched[gem_type] += 1
				$ScoreValue.text = str(score)
				gem_array[column][row] = null
	combo += 1

# Function called by spend_button and similar buttons
func on_spend_button_pressed(spend_gem_type):
	print("Spend button pressed for gem type: " + str(spend_gem_type))
	match spend_gem_type == "amethyst":
		
		pass
