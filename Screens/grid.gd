extends Node2D

var gridWidth = 10
var gridHeight = 10
var x_start = 760
var y_start = 1000
var offset = 100

var gem_list = [
	preload("res://Objects/emerald.tscn"),
	preload("res://Objects/ruby.tscn"),
	preload("res://Objects/topaz.tscn"),
	preload("res://Objects/sapphire.tscn"),
	preload("res://Objects/amethyst.tscn"),
	preload("res://Objects/aquamarine.tscn")
]

var all_pieces = []

# Called when the node enters the scene tree for the first time.
func _ready():
	var gem_array = make_grid_array()
	print(gem_array)
	print(randi() % gem_list.size())
	for i in gridWidth:
		for j in gridHeight:
			spawn_gem(i, j)
	
func grid_to_pixel(column, row):
	var new_x = x_start + offset * column
	var new_y = y_start + -offset * row
	return Vector2(new_x, new_y)

func make_grid_array():
	var array = []
	for i in gridWidth:
		array.append([])
		for j in gridHeight:
			array[i].append(null)
	return array

func spawn_gem(column, row):
	var random_gem = randi() % gem_list.size()
	var gem_instance = gem_list[random_gem].instantiate()
	add_child(gem_instance)
	gem_instance.position = grid_to_pixel(column, row)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
