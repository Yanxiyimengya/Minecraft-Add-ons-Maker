extends Resource;
class_name BlockAttribute;

enum BLOCK_TYPE {
	GASEOUS, # 气态的 方块可以移动到它的位置,并替换它
	GRAVITY, # 下方无方块时,方块会自动向下移动掉落
	SOLID, # 不会自主移动位置,除非被其他方块或机制影响
	ADDITIONAL # 当下方没有固体方块时,它会被摧毁
}

@export var name:String = "NULL";
@export var types:Array[BLOCK_TYPE] = [];


