extends MinecraftBaseAsset;
class_name MinecraftItemAsset;
# 物品资源的实例

var id : String = "test_item" : 
	set(value) : 
		id = value.replace(" ", "_");
# 物品短ID
var texture : MinecraftTextureResource = null;
var texture_path : String = "";
# 纹理及纹理路径

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

enum Category {
	Construction,
	Equipment,
	Items,
	Nature
};
var category : Category = Category.Equipment;
# 指明物品被放在创造模式的物品栏的哪一项

func _init() : 
	type = Global.ASSET_MC_ITEM;

func _save_attribute() -> Array[String] : 
	return ["id","texture_path","stacked_by_data","max_stack_size","has_damage",
	"max_damage","hand_equipped","foil"];

func _load_attribute(att : Dictionary) -> void : 
	id = att.get("id", id);
	texture_path = att.get("texture_path", texture_path);
	var res_item : TreeItem = TreeTools.find_item_to_dir(ResourceManager.resource_tree, texture_path);
	if (res_item != null && !res_item.get_metadata(0).is_folder) : 
		texture = res_item.get_metadata(0).data.texture;
	
	stacked_by_data = att.get("stacked_by_data", stacked_by_data);
	max_stack_size = att.get("max_stack_size", max_stack_size);
	has_damage = att.get("has_damage", has_damage);
	max_damage = att.get("max_damage", max_damage);
	hand_equipped = att.get("hand_equipped", hand_equipped);
	foil = att.get("foil", foil);
	return;
