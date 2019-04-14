extends Node2D

const Piece = preload("res://scenes/Piece.tscn")

export (float) var rate = 1


func _ready():
    $Timer.wait_time = rate
    $Timer.start()

func _process(delta):
    pass    

func _on_Timer_timeout():
    var piece = Piece.instance()
    piece.shape = randi() % 7
    add_child(piece)
