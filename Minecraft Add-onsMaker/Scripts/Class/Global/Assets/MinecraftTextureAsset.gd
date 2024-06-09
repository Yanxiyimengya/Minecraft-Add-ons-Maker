extends BaseMinecraftAsset;
class_name MinecraftTextureAsset;

var texture_ref : TreeItem = null; # 资源树中资源的引用

func get_texture() -> Texture :
	if (texture_ref == null) : 
		return;
	return texture_ref.get_metadata(0).data;

func _init() : 
	type = Global.ASSET_TYPE.TEXTURE;
