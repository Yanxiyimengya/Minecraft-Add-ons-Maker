extends Object;
class_name ImageTools;

@warning_ignore("integer_division")
static func set_proportional(img : Image) -> Image : 
	var size : Vector2i = img.get_size();
	var cut_rest : Rect2i = Rect2i(Vector2i.ZERO, img.get_size());
	var max_v : int = max(cut_rest.size.x, cut_rest.size.y);
	
	var new_img : Image = Image.create(max_v, max_v, false, Image.FORMAT_RGBA8);
	new_img.blit_rect(img,cut_rest,Vector2i((max_v-cut_rest.size.x)/2,(max_v-cut_rest.size.y)/2));
	
	return new_img;
