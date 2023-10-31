extends Resource;
class_name LootTable;

var pools:Array[LootTableEntries] = [];

func get_total_weight():
	var result:float = 0.0;
	for entries in pools :
		result += entries.weight;
	return result;
	pass; # 获取战利品表的总权重
