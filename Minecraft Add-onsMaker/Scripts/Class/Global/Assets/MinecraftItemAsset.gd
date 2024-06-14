extends MinecraftBaseAsset;
class_name MinecraftItemAsset;
# 物品资源的实例

var id_namespace : String = "default" : 
	set(value) : 
		id_namespace = value.replace(" ", "_");
# 物品的命名空间
var id : String = "test_item" : 
	set(value) : 
		id = value.replace(" ", "_");
# 物品短ID

var texture_path : String = "";
# 纹理路径

var stacked_by_data : bool = false;
# 设置物品是否可以堆叠
var max_stack_size : int = 1;
# 物品最大堆叠数量

var has_damage : bool = false;
# 使得物品持有耐久
var max_damage : int = 0;
# 物品耐久

var hand_equipped : bool = false;
# 物品是否为手持 这会改变物品手持样式
var foil : bool = false;
# 物品是否显示附魔样式

const CATEGORYS : PackedStringArray = ["construction","equipment","items","nature"];
var category : int = 1;
# 指明物品被放在创造模式的物品栏的哪一项

var is_food : bool = false;
var can_always_eat : bool = false;
# 食物属性相关

func _init() : 
	type = Global.ASSET_MC_ITEM;

func _save_attribute() -> Array[String] : 
	return ["id","id_namespace",
	"texture_path",
	"stacked_by_data","max_stack_size",
	"has_damage","max_damage",
	"hand_equipped",
	"foil","category",
	"is_food","can_always_eat"];

func _load_attribute(att : Dictionary) -> void : 
	id = att.get("id", id);
	id_namespace = att.get("id_namespace", id_namespace);
	texture_path = att.get("texture_path", texture_path);
	stacked_by_data = att.get("stacked_by_data", stacked_by_data);
	max_stack_size = att.get("max_stack_size", max_stack_size);
	has_damage = att.get("has_damage", has_damage);
	max_damage = att.get("max_damage", max_damage);
	hand_equipped = att.get("hand_equipped", hand_equipped);
	foil = att.get("foil", foil);
	category = att.get("category", category);
	
	is_food = att.get("is_food", is_food);
	can_always_eat = att.get("can_always_eat", can_always_eat);
	return;
