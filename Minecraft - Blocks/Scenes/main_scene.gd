extends Control

var a;
# Called when the node enters the scene tree for the first time.
func _ready():
	a = ApplicationBlockAttribute.new();
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _draw():
	draw_texture(a.textures.get_frame_texture("Default", 0), position);
