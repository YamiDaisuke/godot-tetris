extends Node2D

const Piece = preload("res://scenes/Piece.tscn")

var next_piece = null

func spawn():
    if next_piece == null:
        self.next_piece = randi() % 7

    var piece = Piece.instance()
    piece.shape = self.next_piece
    self.next_piece = randi() % 7
    self.add_child(piece)

    var output = {}
    output['piece'] = piece
    output['next'] = self.next_piece
    return output



    add_child(piece)
    return piece


