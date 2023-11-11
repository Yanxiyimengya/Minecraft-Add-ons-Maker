extends Sprite2D
@export var next_T:Texture2D = null;

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _draw():
	draw_texture_rect($Sprite2D,Rect2(0,0,100,100),false);
