extends PanelContainer


var seconds = 0

onready var label = $MarginContainer/HBoxContainer/Label2

func _ready():
    pass # Replace with function body.


func start():
    $Timer.start()

func stop():
    $Timer.stop()

func _on_Timer_timeout():
    seconds += 1
    var minutes = seconds / 60
    var hours = minutes / 60
    label.text = "%02d:%02d:%02d" % [hours, minutes % 60, seconds % 60]


