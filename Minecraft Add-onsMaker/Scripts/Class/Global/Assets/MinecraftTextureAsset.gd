extends BaseMinecraftAsset;
class_name MinecraftTextureAsset;

var texture_ref : WeakRef = null; # 纹理资源的引用

func get_texture() -> Texture :
	if (texture_ref == null) : 
		return;
	return texture_ref.get_ref();


func _init() : 
	pass;
