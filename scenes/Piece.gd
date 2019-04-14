tool
extends KinematicBody2D

const BlockColors = preload("res://scenes/Block.gd").BlockColor

enum Rotations { ZERO, NINETY, ONE_EIGTHY, TWO_SEVENTY }

const BLOCK_SIZE = 18

const SHAPE_COLOR = [
    BlockColors.Cyan,     # I
    BlockColors.Red,      # Z
    BlockColors.Green,    # S
    BlockColors.Purple,   # T
    BlockColors.Orange,   # L
    BlockColors.Blue,     # J
    BlockColors.Yellow,   # O
]

const SHAPES = [
    # I
    [
        Vector2(-1.5,0.5),
        Vector2(-0.5,0.5),
        Vector2(0.5,0.5),
        Vector2(1.5,0.5),
    ],    
    # Z
    [
        Vector2(-0.5,-0.5),
        Vector2(0.5,-0.5),
        Vector2(0.5,0.5),
        Vector2(1.5,0.5),
    ],
    # S
    [
        Vector2(-0.5,-0.5),
        Vector2(0.5,-0.5),
        Vector2(-1.5,0.5),
        Vector2(-0.5,0.5),
    ],
    # T
    [
        Vector2(-0.5,-0.5),
        Vector2(0.5,-0.5),
        Vector2(1.5,-0.5),
        Vector2(0.5,0.5),
    ],
    # L
    [
        Vector2(-0.5,0.5),
        Vector2(0.5,0.5),
        Vector2(1.5,0.5),
        Vector2(1.5,-0.5),
    ],
    # J
    [
        Vector2(-0.5,-0.5),
        Vector2(-0.5,0.5),
        Vector2(0.5,0.5),
        Vector2(1.5,0.5),
    ],
    # O
    [
        Vector2(-0.5,-0.5),
        Vector2(0.5,-0.5),
        Vector2(-0.5,0.5),
        Vector2(0.5,0.5),
    ],
]

export(int, "I", "Z", "S", "T", "L", "J", "O") var shape = 0 setget _set_shape
export (Rotations) var rotationPosition = Rotations.ZERO setget _set_rotation

export (Vector2) var velocity = Vector2(0, 100)

var stopped = false

# Called when the node enters the scene tree for the first time.
func _ready():
    self.draw_shape(self.shape)


func _physics_process(delta):
    if !Engine.is_editor_hint() and !stopped:
        var output = self.move_and_slide(velocity)
        if output != velocity:
            self.stopped = true


func draw_shape(shape):
    $Block0.color = SHAPE_COLOR[shape]
    $Block1.color = SHAPE_COLOR[shape]
    $Block2.color = SHAPE_COLOR[shape]
    $Block3.color = SHAPE_COLOR[shape]
    
    $Block0.position = SHAPES[shape][0] * BLOCK_SIZE
    $Block1.position = SHAPES[shape][1] * BLOCK_SIZE
    $Block2.position = SHAPES[shape][2] * BLOCK_SIZE
    $Block3.position = SHAPES[shape][3] * BLOCK_SIZE

func _set_rotation(new_rotation):
    rotationPosition = new_rotation
    self.rotation = deg2rad(90 * rotationPosition)
    

func _set_shape(new_shape: int):
    shape = new_shape
    if Engine.is_editor_hint():
        self.draw_shape(self.shape)