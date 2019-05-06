extends Node

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

onready var parent_tree = self.get_parent().get_tree()
onready var board = $".."/BoardBody
onready var next = $".."/NextPiece

func _ready():
    pass # Replace with function body.

func _process(delta):
    if Input.is_action_just_pressed("pause"):
        self.parent_tree.paused = !self.parent_tree.paused

        if self.parent_tree.paused:
            self.board.hide()
            self.next.hide()
        else:
            self.board.show()
            self.next.show()
