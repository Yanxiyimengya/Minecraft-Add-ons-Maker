extends Node;

@export var a:BlockAttribute = null;

func _ready():
	DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED);
	# 设置垂直同步
	
