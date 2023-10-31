extends BlockAttribute;
class_name ApplicationBlockAttribute;
# 加载并应用的方块属性信息

var texture:Texture2D = null;

func _init() :
	if textures == null:
		textures = SpriteFrames.new();
	pass; # 构造函数
