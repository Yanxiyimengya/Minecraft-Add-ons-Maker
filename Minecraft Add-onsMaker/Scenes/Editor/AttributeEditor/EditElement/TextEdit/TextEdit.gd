@tool
extends EditElement;
@onready var line_edit = $LineEdit;
@onready var label = $Label;

@export var title : String = "";

func get_attribute() -> String : 
	return $LineEdit.text;
	
