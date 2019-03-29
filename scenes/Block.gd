tool
extends Node2D

enum BlockColor { 
    Blue, 
    Purple, 
    Red,
    Green,
    Yellow,
    Cyan,
    Orange,
    Navy
 }

export(BlockColor) var color = BlockColor.Blue setget _set_color

# Called when the node enters the scene tree for the first time.
func _ready():
    pass # Replace with function body.


func _set_color(new_color:int):
    color = new_color
    if Engine.is_editor_hint():
        $Sprite.region_rect = Rect2(color * 18, 0, 18, 18)