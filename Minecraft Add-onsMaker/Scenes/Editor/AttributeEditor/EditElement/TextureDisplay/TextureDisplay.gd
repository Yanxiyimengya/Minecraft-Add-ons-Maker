extends EditElement;

@export var title : String = "" : 
	set(value) :
		title = value;
		%TitleLabel.text = value;

@export var texture : Texture = null : 
	set(value) : 
		%Texture.texture = value;
		if (value != null) : 
			var tex_size : Vector2 = value.get_size();
			%TextureSizeLabel.text = "大小 : " + str(tex_size.x) + "×" + str(tex_size.y);
