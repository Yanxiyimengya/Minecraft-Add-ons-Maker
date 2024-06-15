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

const CATEGORYS : PackedStringArray = ["Construction","Equipment","Items","Nature"];
var category : int = 1;
# 指明物品被放在创造模式的物品栏的哪一项

func _init() : 
	type = Global.ASSET_MC_ITEM;

var components : Dictionary = {};

#minecraft:block
#minecraft:food
#minecraft:foil
#minecraft:hand_equipped
#minecraft:max_damage
#minecraft:max_stack_size
#minecraft:seed
#minecraft:stacked_by_data
#minecraft:use_duration

func add_component(comp : String) : 
	match (comp) : 
		"max_stack_size" : 
			components["max_stack_size"] = 64;
		"hand_equipped" : 
			components["hand_equipped"] = false;
		"food" : 
			components["food"] = {
				"can_always_eat": false,	# 忽略饱食度
				"nutrition" : 3,			# 营养价值
				"saturation_modifier": 0.6,	# 饱和度
				"effects" : [],				# 使用后的效果
			}
		
		"durability" : 
			if (ProjectManager.current_project_config.use_new_item_api) : 
				components["durability"] = {
					"damage_chance" : {
						"min" : 100,
						"max" : 100,
					},
					"max_durability" : 100
				};
			else : 
				components["max_damage"] = 100; # 耐久度
		"glint" : 
			if (ProjectManager.current_project_config.use_new_item_api) : 
				components["glint"] = false; # 旧版物品API
			else : 
				components["foil"] = false;
		"icon" : 
			components["icon"] = {
				"textures" : ""
			};

func _save_attribute() -> Array[String] : 
	return ["id","id_namespace", "components"];

func _load_attribute(att : Dictionary) -> void : 
	id = att.get("id", id);
	id_namespace = att.get("id_namespace", id_namespace);
	components = att.get("components", components);
	return;
