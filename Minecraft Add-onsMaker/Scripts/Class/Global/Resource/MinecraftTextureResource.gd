extends MinecraftBaseResource;
class_name MinecraftTextureResource;

var texture : Texture = null; # 资源树中资源的引用

func _init(_name : String, res : Texture) : 
	self.name = _name
	self.texture = res;
