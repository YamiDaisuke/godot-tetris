extends PanelContainer

var score = 0 setget _set_score
var lines = 0 setget _set_lines

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

func _set_score(new_score: int):
    score = new_score
    self.score_label.text = "%07d" % score

func _set_lines(new_lines: int):
    lines = new_lines
    self.lines_label.text = "%07d" % lines

func set_level(new_level:int):
    level = new_level
    level_label.text = "Level %d" % level

func add_bonus(points:int):
    self.score += points


func add_lines(new_lines:int):
    self.lines += new_lines
    self.score += line_score[new_lines - 1] + line_score[new_lines - 1] * level



