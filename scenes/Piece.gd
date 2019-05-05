tool
extends KinematicBody2D

signal piece_have_fallen(piece)
signal piece_is_soft_dropped(piece)

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

# Audio Streams
onready var pre_lock_fx = $PreLock
onready var lock_fx = $Lock
onready var lock_timer = $LockTimer

var stopped = false
var lock_time = 0

var blocks = []

var level_time = 0
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

    if !self.static_mode and !Engine.is_editor_hint():
        yield(fall(), "completed")


func fall():
    while !self.stopped:
        if game != null and !self.get_tree().paused:
            if game.is_valid_position(self, Vector2(0,-1)):
                self.position.y += BLOCK_SIZE
                if Input.is_action_pressed("down"):
                    self.emit_signal("piece_is_soft_dropped", self)
            elif self.lock_timer.is_stopped():
                self.pre_lock_fx.play()
                self.lock_timer.start(self.lock_delay)

        yield(wait_time(), "completed")

func lock():
    if !game.is_valid_position(self, Vector2(0,-1)):
        self.lock_fx.play()
        self.emit_signal("piece_have_fallen", self)
        self.lock_time = 0
        self.stopped = true
    else:
        self.position.y += BLOCK_SIZE
        self.lock_timer.start(self.lock_delay)

func wait_time():
    var time = 0
    yield(get_tree(), "idle_frame")
    while time < self.time:
        time += self.get_process_delta_time()
        yield(get_tree(), "idle_frame")

func _physics_process(delta):
    if self.static_mode or Engine.is_editor_hint():
        return

    if !self.stopped:

        if Input.is_action_pressed("down"):
            self.time = BLOCK_SIZE / 360.0
        else:
            self.time = self.level_time

        if Input.is_action_just_pressed("rotate_right"):
            self.rotationPosition = self.rotationPosition + 1 % 4
            if !self.game.is_valid_position(self):
                self.rotationPosition = self.rotationPosition - 1 % 4

        if Input.is_action_just_pressed("rotate_left"):
            self.rotationPosition = self.rotationPosition - 1 % 4
            if !self.game.is_valid_position(self):
                self.rotationPosition = self.rotationPosition + 1 % 4

        if Input.is_action_just_pressed("left"):
            if game.is_valid_position(self, Vector2(-1,0)):
                self.position.x -= BLOCK_SIZE

        if Input.is_action_just_pressed("right"):
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
    self.level_time = get_time(level)
    self.velocity = Vector2(0, BLOCK_SIZE / self.level_time)
    # Time = (0.8-((Level-1)*0.007))^(Level-1)


func _set_shape(new_shape: int):
    shape = new_shape
    self.draw_shape(self.shape)