extends MinecraftBaseAsset;
class_name MinecraftItemAsset;
# 物品资源的实例

var id : String = "";
# 物品展示的ID

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

func _init() : 
	type = Global.ASSET_MC_ITEM;


func _save_attribute() -> Array[String] : 
	return ["id","stacked_by_data","max_stack_size","has_damage",
	"max_damage","hand_equipped","foil"];

func _load_attribute(att : Dictionary) -> void : 
	id = att.get("id", id);
	stacked_by_data = att.get("stacked_by_data", stacked_by_data);
	max_stack_size = att.get("max_stack_size", max_stack_size);
	has_damage = att.get("has_damage", has_damage);
	max_damage = att.get("max_damage", max_damage);
	hand_equipped = att.get("hand_equipped", hand_equipped);
	foil = att.get("foil", foil);
	return;
