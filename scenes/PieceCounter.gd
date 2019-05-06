extends PanelContainer

const Piece = preload("res://scenes/Piece.gd")


var total = 0
var totals = [0,0,0,0,0,0,0]

var labels = []
onready var total_label = $MarginContainer/Pieces/HBoxContainer8/LabelTotal

func _ready():
    labels = [
        $MarginContainer/Pieces/HBoxContainer2/Label2,
        $MarginContainer/Pieces/HBoxContainer4/Label4,
        $MarginContainer/Pieces/HBoxContainer3/Label3,
        $MarginContainer/Pieces/HBoxContainer7/Label7,
        $MarginContainer/Pieces/HBoxContainer5/Label5,
        $MarginContainer/Pieces/HBoxContainer6/Label6,
        $MarginContainer/Pieces/HBoxContainer1/Label1
    ]


func add_piece(piece: Piece):
    totals[piece.shape] += 1
    labels[piece.shape].text = "%04d" % totals[piece.shape]
    total += 1
    total_label.text = "%04d" % total