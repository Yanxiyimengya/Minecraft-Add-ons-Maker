extends BlockAttribute;
class_name ApplicationBlockAttribute;
# 加载并应用的方块属性信息

func _init() :
	if textures == null:
		textures = SpriteFrames.new();
		textures.add_animation("Default");
		textures.add_frame("Default", load("res://Sprites/Blocks/lose.png"));
	pass; # 构造函数
