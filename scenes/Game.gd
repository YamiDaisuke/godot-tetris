extends Node2D

const Piece = preload("res://scenes/Piece.gd")
const Block = preload("res://scenes/Block.gd")

const BOARD_HEIGHT = 40
const BOARD_WIDTH = 20

export (Vector2) var origin = Vector2(-9.5, 39.5)
export (int, 0, 999) var level = 5 setget set_level
export (int, 1, 99) var level_targe_lines = 10

# Board Size 10x20
var board = []
# The lines done since the last level change
var lines_in_level = 0

onready var spawner = $BoardBody/PieceSpawner
onready var board_body = $BoardBody
onready var piece_counter = $PieceCounter
onready var next_display = $NextPiece

func _ready():
    for i in range(BOARD_HEIGHT):
        board.append([])
        #warning-ignore:unused_variable
        for j in range(BOARD_WIDTH):
            board[i].append(null)

    self.spawn_piece()
    $Score.level = self.level
    $Timer.start()

func set_level(new_level:int):
    if new_level != level:
        lines_in_level = 0

    level = new_level
    print("Changing level to %d" % self.level)
    $Score.level = self.level


func spawn_piece():
    var pieces = spawner.spawn()
    var new_piece = pieces['piece']
    new_piece.game = self
    new_piece.set_level(self.level)
    piece_counter.add_piece(new_piece)
    new_piece.connect("piece_have_fallen", self, "_on_piece_fallen")
    new_piece.connect("piece_is_soft_dropped", self, "_on_piece_softdropped")
    next_display.set_piece_shape(pieces['next'])

#warning-ignore:unused_argument
func _on_piece_softdropped(piece: Piece):
    $Score.add_bonus(1)

func _on_piece_fallen(piece: Piece):
#    print("#### A piece have fallen!!!!")
    var to_review = add_piece_2_board(piece)

    # If to_review is null then game is over!
    if to_review == null:
        print("GAME OVER!!!")
        $Timer.stop()
        return

    var to_be_deleted = check_rows(to_review)

    if !to_be_deleted.empty():
        self.clear_rows(to_be_deleted)

    self.spawn_piece()

func is_valid_position(piece: Piece, delta: Vector2 = Vector2.ZERO) -> bool:
    for b in piece.blocks:
        var position = normalize_position(b.global_position)
        position += delta
        if position.y < 0 or position.x < 0 or position.x >= BOARD_WIDTH or self.board[position.y][position.x] != null:
            return false

    return true


"""
Adds the piece blocks to board and returns
the affected rows
"""
func add_piece_2_board(piece: Piece):
    var to_review = []
    # print("Piece Position: %s" % self.to_local(piece.position))
    for b in piece.blocks:
        # print(" --> Block Position: %s" % self.to_local(b.global_position))
        var block_position = b.global_position
        var block_rotation = b.global_rotation
        var position = normalize_position(block_position)

        if position.y >= BOARD_HEIGHT - 1:
            to_review = null
        else:
            board[position.y][position.x] = b

        # print(" --> Normalized %s" % position)
        if to_review != null and !(position.y in to_review):
            to_review.append(position.y)

        b.get_parent().remove_child(b)
        board_body.add_child(b)
        b.global_position = block_position
        b.global_rotation = block_rotation

    return to_review


"""
Translate world position to board spaces
"""
func normalize_position(position: Vector2) -> Vector2:
    var normalized = (board_body.to_local(position) / Piece.BLOCK_SIZE)
    normalized -= origin
    normalized.y *= -1
    return normalized


"""
Check the provided rows to see if they are full
returns the complete rows found
"""
func check_rows(to_review: Array):
    var to_be_deleted = []
    for row in to_review:
#        print("Checking row %d" % row)
        var full = true
        for col in range(BOARD_WIDTH):
#            print(" --> Checking col %d" % row)
            if board[row][col] == null:
                full = false
                break

        if full:
            to_be_deleted.append(row)
#            print("Huston we got a line!")
    return to_be_deleted


"""
Clears the provided rows and moves all the
pieces to their new position
"""
func clear_rows(to_be_deleted: Array):
    var count = to_be_deleted.size()

    $Score.add_lines(count)
    self.lines_in_level += count
    if self.lines_in_level >= self.level_targe_lines:
        self.level += 1


    var last_deleted = BOARD_HEIGHT
    var deleted = 0

    for row in range(BOARD_HEIGHT):
        var empty = true
        var delete = false
        if row in to_be_deleted:
            delete = true
            deleted += 1
            last_deleted = row

        for col in range(BOARD_WIDTH):
            if delete:
                board[row][col].queue_free()
                board[row][col] = null
                empty = false
            elif row > last_deleted:
                var block = board[row][col]
                if block:
                    board[row - deleted][col] = block
                    block.position.y += 18 * deleted
                    board[row][col] = null
                    empty = false
            elif board[row][col]:
                    empty = false

        if empty:
            break


"""
For debug porpuses, don't call in a real game
"""
func print_board():
    for row in range(BOARD_HEIGHT):
        var to_print = ""
        for col in range(BOARD_WIDTH):
            var x = "X" if board[row][col] != null else " "
            to_print = "%s[%s]" % [to_print,x]
        print(to_print)
    print("      ")