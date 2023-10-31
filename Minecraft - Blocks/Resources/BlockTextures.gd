extends Resource;
class_name BlockTextures;

func _init(tex = null):
	textures = SpriteFrames.new();
	textures.add_animation("Default");
	match (tex) :
		SpriteFrames:
			if (tex.has_animation("Default")):
				var frame_count:int = tex.get_frame_count("Default");
				if (frame_count > 0):
					for count in frame_count:
						textures.add_frame("Default", tex.get_frame_texture("Default", count));
					return;
			else :
				textures.add_frame("Default", load("res://Sprites/Blocks/lose.png"));
		_:
			textures.add_frame("Default", load("res://Sprites/Blocks/lose.png"));
	
var textures:SpriteFrames = null;
var display_texture = null:
	set(_val):
		emit_changed();
		textures.set_frame("Default", 0, _val, textures.get_frame_duration("Default", 0));
		pass;
	get:
		return textures.get_frame_texture("Default", 0);
