extends AttributeEdit;
@onready var texture_display = %TextureDisplay;

func _set_target() : 
	texture_display.texture = target.data.texture;
	texture_display.title = target.ascription.get_text(0);
