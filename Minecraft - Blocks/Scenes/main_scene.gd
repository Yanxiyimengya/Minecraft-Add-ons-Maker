extends Control

var a;
var b;
# Called when the node enters the scene tree for the first time.
func _ready():
	a = BlockTextures.new();
	b = BlockTextures.new();
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _draw():
	draw_texture(a.display_texture,position);
	pass;
