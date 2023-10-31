extends Resource;
class_name LootTable;

var pools:Array[LootTableEntries] = []; # 物品条目列表

func get_total_weight():
	var result:float = 0.0;
	for entries in pools :
		result += entries.weight;
	return result; # 获取战利品表的总权重
