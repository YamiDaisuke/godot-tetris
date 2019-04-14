extends Node2D

const Piece = preload("res://scenes/Piece.tscn")

func _ready():
    pass
    
func spawn():
    var piece = Piece.instance()
    piece.shape = randi() % 7
    add_child(piece)
    return piece

    
