extends PanelContainer

var score = 0
var lines = 0

var level = 0

# TODO: Force this array to have four elements
export(Array, int) var line_score = [
    40,
    100,
    300,
    1200
]

onready var lines_label = $MarginContainer/VBoxContainer/HBoxContainer2/LabelLines
onready var score_label = $MarginContainer/VBoxContainer/HBoxContainer/LabelScore

func add_lines(new_lines:int):
    lines += new_lines
    score += line_score[new_lines - 1] + line_score[new_lines - 1] * level
    lines_label.text = "%07d" % lines
    score_label.text = "%07d" % score

