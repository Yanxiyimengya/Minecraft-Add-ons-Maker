extends Resource;
class_name BlockAttribute;
# 方块属性信息

enum BLOCK_TYPE {
	GASEOUS, # 气态的 方块可以移动到它的位置,并替换它
	GRAVITY, # 下方无方块时,方块会自动向下移动掉落
	SOLID, # 不会自主移动位置,除非被其他方块或机制影响
	ADDITIONAL # 当下方没有固体方块时,它会被摧毁
}

@export var id:String = "NULL"; # 方块唯一ID
@export var types:BLOCK_TYPE = BLOCK_TYPE.SOLID; # 方块类型
@export var textures:SpriteFrames = null; # 应用的纹理信息
@export var loot_table:LootTable = null; # 应用的战利品表

var point:int = 1; # 被正常消除后给予的分值
var particles:bool = true; # 决定方块被销毁后是否基于texture播放粒子动画

func get_textures():
	if textures is SpriteFrames:
		return textures;
	return load("res://Sprites/Blocks/lose.png");
	pass; # 获取方块纹理
