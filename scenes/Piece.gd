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
        Vector2(-1.5,-0.5),
        Vector2(-0.5,-0.5),
        Vector2(0.5,-0.5),
        Vector2(1.5,-0.5),
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
        Vector2(0.5,-0.5),
        Vector2(1.5,-0.5),
        Vector2(-0.5,0.5),
        Vector2(0.5,0.5),
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
        Vector2(-0.5,-0.5),
        Vector2(0.5,-0.5),
        Vector2(1.5,-0.5),
        Vector2(-0.5,0.5),
    ],
    # J
    [
        Vector2(1.5,0.5),
        Vector2(-0.5,-0.5),
        Vector2(0.5,-0.5),
        Vector2(1.5,-0.5),
    ],
    # O
    [
        Vector2(-0.5,-0.5),
        Vector2(0.5,-0.5),
        Vector2(-0.5,0.5),
        Vector2(0.5,0.5),
    ],
]

export(bool) var static_mode = false

export(int, "I", "Z", "S", "T", "L", "J", "O") var shape = 0 setget _set_shape
export (Rotations) var rotationPosition = Rotations.ZERO setget _set_rotation
export (Vector2) var velocity = Vector2(0, 18)
export (float) var lock_delay = 0.5

var stopped = false
var lock_time = 0

var blocks = []

var time = 0

var game = null

# Called when the node enters the scene tree for the first time.
func _ready():
    self.blocks = [
        $Block0,
        $Block1,
        $Block2,
        $Block3,
    ]
    self.draw_shape(self.shape)

    if !self.static_mode:
        yield(fall(), "completed")


func fall():
    while true:
        var time = self.time
        if self.static_mode:
            return

        if !Engine.is_editor_hint() and !self.stopped and game != null:
            if game.is_valid_position(self, Vector2(0,-1)):
                self.position.y += BLOCK_SIZE
            elif self.lock_time > self.lock_delay:
                self.emit_signal("piece_have_fallen", self)
                self.lock_time = 0
                self.stopped = true
            else:
                self.lock_time += self.time


            if Input.is_action_pressed("down"):
                time = BLOCK_SIZE / 360
        yield(get_tree().create_timer(time), "timeout")

func _physics_process(delta):
    if self.static_mode:
        return

    if !Engine.is_editor_hint() and !self.stopped:

        if Input.is_action_just_pressed("rotate_right"):
            self.rotationPosition = self.rotationPosition + 1 % 4
            if !self.game.is_valid_position(self):
                self.rotationPosition = self.rotationPosition - 1 % 4

        if Input.is_action_just_pressed("rotate_left"):
            self.rotationPosition = self.rotationPosition - 1 % 4
            if !self.game.is_valid_position(self):
                self.rotationPosition = self.rotationPosition + 1 % 4

        if Input.is_action_just_pressed("left"):
            print("Try to move left!!")
            if game.is_valid_position(self, Vector2(-1,0)):
                self.position.x -= BLOCK_SIZE

        if Input.is_action_just_pressed("right"):
            print("Try to move left!!")
            if game.is_valid_position(self, Vector2(1,0)):
                self.position.x += BLOCK_SIZE


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


func get_time(level:int):
    return pow((0.8 - ((level - 1) * 0.007)), level - 1)


func set_level(level:int):
    var time = get_time(level)
    self.time = time
    self.velocity = Vector2(0, BLOCK_SIZE / time)
    # Time = (0.8-((Level-1)*0.007))^(Level-1)


func _set_shape(new_shape: int):
    shape = new_shape
    self.draw_shape(self.shape)