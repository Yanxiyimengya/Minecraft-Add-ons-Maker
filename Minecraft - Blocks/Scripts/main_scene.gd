extends Node;

func _ready():
	DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED);
	# 设置垂直同步
	
	var a = LootTable.new();
	
	a.pools.append(LootTableEntries.new());
	a.pools.append(LootTableEntries.new());
	a.pools.append(LootTableEntries.new());
	a.pools.append(LootTableEntries.new());
	
