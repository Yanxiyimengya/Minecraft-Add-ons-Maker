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
enum Component {
	MaxStackSize,	# 最大堆叠数
	Icon,			# 物品贴图
	Food,	# 食物
	Glint,	# 附魔光效
	Durability,		# 耐久
	HandEquipped,	# 手持模式
};
func add_component(comp : Component) : 
	match (comp) : 
		Component.MaxStackSize : 
			components["max_stack_size"] = {
				"value" : 64
			};
		Component.Icon : 
			components["icon"] = {
				"textures" : ""
			};
		Component.Food : 
			components["food"] = {
				"can_always_eat": false,	# 忽略饱食度
				"nutrition" : 3,			# 营养价值
				"saturation_modifier": 0.6,	# 饱和度
				"effects" : [],				# 使用后的效果
			}
		Component.Glint : 
			components["glint"] = false;
		Component.Durability : 
			components["durability"] = {
				"damage_chance" : {
					"min" : 100,
					"max" : 100,
				},
				"max_durability" : 100
			};
		Component.HandEquipped : 
			components["hand_equipped"] = false;

func _save_attribute() -> Array[String] : 
	return ["id","id_namespace", "components"];

func _load_attribute(att : Dictionary) -> void : 
	id = att.get("id", id);
	id_namespace = att.get("id_namespace", id_namespace);
	components = att.get("components", components);
	return;
