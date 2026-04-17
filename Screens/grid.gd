extends Node2D

var gridWidth = 10
var gridHeight = 10
var start = Vector2(760,1000)
var offset = 100

var gem_list = [
	preload("res://Objects/emerald.tscn"),
	preload("res://Objects/ruby.tscn"),
	preload("res://Objects/topaz.tscn"),
	preload("res://Objects/sapphire.tscn"),
	preload("res://Objects/amethyst.tscn"),
	preload("res://Objects/aquamarine.tscn")
]

var gem_array = []

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




# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
