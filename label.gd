# TimerLabel.gd (Godot 4.x)
extends Label

var t := 0.0
@export var running := true  # set false if you want to start later


func _process(delta: float) -> void:
	
	
	if running:
		t += delta
		Globals.TOTAL_TIME = _fmt(t)
	text = _fmt(t)
	
	

func _fmt(s: float) -> String:
	var m := int(s) / 60
	var sec := int(s) % 60
	var ms := int((s - floor(s)) * 1000.0)
	return "%02d:%02d.%03d" % [m, sec, ms]

# Optional helpers:
func start(): running = true
func stop(): running = false
func reset():
	t = 0.0
	text = _fmt(0.0)
