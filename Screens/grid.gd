extends Node2D

#Grid vars
var gridWidth = 10
var gridHeight = 10
var start = Vector2(760,1000)
var offset = 100

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
var action_active = false

# Called when the node enters the scene tree for the first time.
func _ready():
	gem_array = make_grid_array()
	print(gem_array)
	for column in gridHeight:
		for row in gridWidth:
			print("Spawning gem at column: " + str(column) + " row: " + str(row))
			print("gem array location: " + str(gem_array[column][row]))
			spawn_gem(column, row)

func grid_to_pixel(column, row):
	var new_x = start.x + offset * column
	var new_y = start.y + -offset * row
	return Vector2(new_x, new_y)

func pixel_to_grid(position):
	var column = int((position.x - start.x + offset / 2) / offset)
	var row = int((start.y - position.y + offset / 2) / offset)
	return Vector2(column, row)

func make_grid_array():
	var array = []
	for i in gridWidth:
		array.append([])
		for j in gridHeight:
			array[i].append("temp")
	return array

func spawn_gem(column, row):
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

func _input(event):
	if Input.is_action_just_pressed("mouse_click"):
		action_start = get_global_mouse_position()
		print("Action start: " + str(action_start))
		var grid_pos = pixel_to_grid(action_start)
		if is_in_grid(grid_pos.x, grid_pos.y):
			action_active = true
	if Input.is_action_just_released("mouse_click"):
		action_end = get_global_mouse_position()
		print("Action end: " + str(action_end))
		var grid_pos = pixel_to_grid(action_end)
		if is_in_grid(grid_pos.x, grid_pos.y) && action_active:
			if action_start.distance_to(action_end) > 50:
				swap_gems(pixel_to_grid(action_start).x, pixel_to_grid(action_start).y, pixel_to_grid(action_end).x, pixel_to_grid(action_end).y)
			print("Action from " + str(pixel_to_grid(action_start)) + " to " + str(pixel_to_grid(action_end)))

func swap_gems(column1, row1, column2, row2):
	var first_gem = gem_array[column1][row1]
	var second_gem = gem_array[column2][row2]
	var temp = gem_array[column1][row1]
	gem_array[column1][row1] = gem_array[column2][row2]
	gem_array[column2][row2] = temp
	first_gem.position = grid_to_pixel(column2, row2)
	second_gem.position = grid_to_pixel(column1, row1)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
