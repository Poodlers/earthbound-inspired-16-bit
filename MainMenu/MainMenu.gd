extends Control

const start_scene = preload("res://Assets/Levels/Level1.tscn")

# number of options in main menu
onready var options_vbox_container = self.get_node("MarginContainer/CenterContainer/VBoxContainer/OptionsContainer/VBoxContainer")
onready var options_number = options_vbox_container.get_child_count() 

var current_selected = 0 # starting selector option


func _ready():
	set_current_selected(current_selected)

# moves selector
func _process(_delta):
	if Input.is_action_just_pressed("ui_down"):
		current_selected += 1
		if current_selected > options_number-1:
			current_selected = 0
		set_current_selected(current_selected)	
	elif Input.is_action_just_pressed("ui_up"):
		current_selected -= 1
		if current_selected < 0:
			current_selected = options_number-1
		set_current_selected(current_selected)
	elif Input.is_action_just_pressed("ui_accept"):
		handle_selection(current_selected)	
	
	
	
	
func handle_selection(_current_selected):
	if _current_selected == 0:
		get_parent().add_child(start_scene.instance())
		queue_free()
	elif _current_selected == 1:
		print("ADD OPTIONS PLEASE")
	elif _current_selected == 2:
		get_tree().quit()
		
		

	
func set_current_selected(_current_selected):
	var _selector_containers = self.get_node("MarginContainer/CenterContainer/VBoxContainer/OptionsContainer/VBoxContainer")
	
	for index in range(_selector_containers.get_child_count()):
		var selector = _selector_containers.get_child(index).get_node("HBoxContainer/Arrow")
		if current_selected == index:
			selector.text = ">"
		else:
			selector.text = ""


