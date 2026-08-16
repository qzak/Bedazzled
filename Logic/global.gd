extends Node

var scoring_in_progress = false
var ability_in_progress = false
var amethyst_ability_cost = 1

var total_gems_matched = {
	"emerald": 0,
	"ruby": 0,
	"topaz": 0,
	"sapphire": 0,
	"amethyst": 0,
	"aquamarine": 0
}

func reset_game_state() -> void:
	scoring_in_progress = false
	ability_in_progress = false
	for gem_type in total_gems_matched:
		total_gems_matched[gem_type] = 0
