extends Node2D

const Piece = preload("res://scenes/Piece.gd")
const Block = preload("res://scenes/Block.gd")

const BOARD_HEIGHT = 20
const BOARD_WIDTH = 10

export (Vector2) var origin = Vector2(-4.5, 19.5)

# Board Size 10x20
var board = []

func _ready():

    for i in range(BOARD_HEIGHT):
        board.append([])
        for j in range(BOARD_WIDTH):
            board[i].append(null)

    var piece = $PieceSpawner.spawn()
    piece.connect("piece_have_fallen", self, "_on_piece_fallen")


func _on_piece_fallen(piece: Piece):
#    print("#### A piece have fallen!!!!")

    var to_review = add_piece_2_board(piece)
    var to_be_deleted = check_rows(to_review)

    if !to_be_deleted.empty():
        self.clear_rows(to_be_deleted)

    var new_piece = $PieceSpawner.spawn()
    new_piece.connect("piece_have_fallen", self, "_on_piece_fallen")

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

        var position = (self.to_local(b.global_position) / 18) - origin
        position.y *= -1
        # print(" --> Normalized %s" % position)
        if !(position.y in to_review):
            to_review.append(position.y)
        board[position.y][position.x] = b
        b.get_parent().remove_child(b)
        $BoardBody.add_child(b)
        b.global_position = block_position
        b.global_rotation = block_rotation

    return to_review

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
    var delete_min = to_be_deleted.min()
    var delete_max = to_be_deleted.max()
    var count = to_be_deleted.size()

    for row in range(BOARD_HEIGHT):
        var empty = true
        for col in range(BOARD_WIDTH):
            if row >= delete_min and row <= delete_max:
                board[row][col].queue_free()
                board[row][col] = null
                empty = false
            elif row > delete_max:
                var block = board[row][col]
                if block != null:
                    board[row - count][col] = block
                    block.position.y += 18 * count
                    board[row][col] = null
                    empty = false
            elif board[row][col]:
                    empty = false

        if empty:
            break