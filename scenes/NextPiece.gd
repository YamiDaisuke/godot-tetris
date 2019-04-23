extends PanelContainer

onready var container = $MarginContainer/VBoxContainer/Control
onready var piece = $MarginContainer/VBoxContainer/Control/Piece

func _ready():
    container.hide()

func set_piece_shape(shape:int):
    # if container.is_visible_in_tree():
    container.show()

    piece.shape = shape
