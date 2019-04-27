extends PanelContainer

var score = 0
var lines = 0

var level = 0 setget set_level

# TODO: Force this array to have four elements
export(Array, int) var line_score = [
    40,
    100,
    300,
    1200
]

onready var level_label = $MarginContainer/VBoxContainer/LevelLabel
onready var lines_label = $MarginContainer/VBoxContainer/HBoxContainer2/LabelLines
onready var score_label = $MarginContainer/VBoxContainer/HBoxContainer/LabelScore

func set_level(new_level:int):
    level = new_level
    level_label.text = "Level %d" % level


func add_lines(new_lines:int):
    lines += new_lines
    score += line_score[new_lines - 1] + line_score[new_lines - 1] * level
    lines_label.text = "%07d" % lines
    score_label.text = "%07d" % score

