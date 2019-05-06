extends PanelContainer

const SCORES_FILE_NAME = "user://scores.save"

onready var label = $GameOverLabel

var max_score = 0
var best_time = 0

func _process(delta):
    if self.visible:
        if Input.is_action_just_released("pause"):
            get_tree().reload_current_scene()

func finish(score: int, time: int):
    self.load_data()
    var output = ""
    if score > self.max_score:
        self.max_score = score

    if time > self.best_time:
        self.best_time = time

    self.label.text = "GAME OVER\n\nScore:%d\nTime:%s\n\nBest Score:%d\nBest Time:%s" % [
        score,
        self.format_time(time),
        self.max_score,
        self.format_time(self.best_time)
    ]

    self.save_data()

func format_time(seconds: int) -> String:
    var minutes = seconds / 60
    var hours = minutes / 60
    return "%02d:%02d:%02d" % [hours, minutes % 60, seconds % 60]

func load_data():
    var save_game = File.new()
    if not save_game.file_exists(SCORES_FILE_NAME):
        self.max_score = 0
        self.best_time = 0
        return

    save_game.open(SCORES_FILE_NAME, File.READ)
    while not save_game.eof_reached():
        var data = parse_json(save_game.get_line())
        self.max_score = data['max_score']
        self.best_time = data['best_time']
        break
    save_game.close()

func save_data():
    var save_game = File.new()
    save_game.open(SCORES_FILE_NAME, File.WRITE)
    var node_data = {
        "max_score": self.max_score,
        "best_time": self.best_time,
    }
    save_game.store_line(to_json(node_data))
    save_game.close()