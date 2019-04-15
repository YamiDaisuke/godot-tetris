tool
extends KinematicBody2D

signal piece_have_fallen(piece)

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

export (Vector2) var velocity = Vector2(0, 18)

var stopped = false

var blocks = []

# Called when the node enters the scene tree for the first time.
func _ready():
    self.blocks = [
        $Block0,
        $Block1,
        $Block2,
        $Block3,
    ]
    self.draw_shape(self.shape)


func _physics_process(delta):
    if !Engine.is_editor_hint() and !stopped:

        if Input.is_action_just_pressed("rotate_right"):
            self.rotationPosition = self.rotationPosition + 1 % 4

        if Input.is_action_just_pressed("rotate_left"):
            self.rotationPosition = self.rotationPosition - 1 % 4


        var speed = Vector2(velocity.x, velocity.y)

        if Input.is_action_pressed("down"):
            speed.y *= 10

        var output = self.move_and_slide(speed)
        if output.y != speed.y:
            self.stopped = true
            self.position.x = round(self.position.x / 18) * 18
            self.position.y = round(self.position.y / 18) * 18
            self.emit_signal("piece_have_fallen", self)

        if Input.is_action_just_pressed("left"):
            #warning-ignore:return_value_discarded
            self.move_and_slide(-Vector2(BLOCK_SIZE / delta, 0))

        if Input.is_action_just_pressed("right"):
            #warning-ignore:return_value_discarded
            self.move_and_slide(Vector2(BLOCK_SIZE / delta, 0))




func draw_shape(shape):
    if self.blocks.empty():
        return

    for i in range(self.blocks.size()):
        self.blocks[i].color = SHAPE_COLOR[shape]
        self.blocks[i].position = SHAPES[shape][i] * BLOCK_SIZE


func _set_rotation(new_rotation):
    rotationPosition = new_rotation

    if self.blocks.empty():
        return

    for i in range(self.blocks.size()):
        self.blocks[i].rotation = deg2rad(-90 * rotationPosition)

    self.rotation = deg2rad(90 * rotationPosition)




func _set_shape(new_shape: int):
    shape = new_shape
    self.draw_shape(self.shape)