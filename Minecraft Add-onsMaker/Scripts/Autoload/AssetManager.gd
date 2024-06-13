extends Node;
# 资产管理器
# 管理正在编辑的项目拥有的工程资产

signal added_item(res_item : TreeItem);
# 添加资源时会发出
signal remove_item(res_item : TreeItem);
# 移除资源时会发出

var tree : Tree = Tree.new();
# 资源树

class AssetData : 
	extends RefCounted;
	var data : MinecraftBaseAsset = null;	# 数据
	var ascription : TreeItem = null;		# 指这个资产在树中的哪个TreeItem中
	
	var is_folder : bool = true;
	var path : String = "" : 
		get : 
			if (ascription == null) : 
				return "";
			return ascription.get_parent().get_metadata(0).path + "/" + ascription.get_text(0);



func _ready() : 
	tree.columns = 1;
	var root = tree.create_item();
	var data : AssetData = AssetData.new();
	root.set_metadata(0, data);
	# 创建根节点
	
	#var win = Window.new();
	#win.size = Vector2i(640, 480);
	#win.position = Vector2i(100, 100);
	#get_tree().root.add_child.call_deferred(win);
	#win.add_child(tree);
	#tree.size = win.size;
	


func append_item_asset(item_name : String, ascription : TreeItem = null) : 
	if (ascription == null) : 
		ascription = tree.get_root();
	var item_data : MinecraftItemAsset = MinecraftItemAsset.new();
	item_data.name = item_name;
	
	var tree_item : TreeItem = append_asset_to_tree(item_name, item_data, ascription);
	return tree_item;

func append_asset_to_tree_no_signal(asset_name : String, asset : MinecraftBaseAsset, ascription : TreeItem = null) -> TreeItem :
	if (ascription != null && !ascription.get_metadata(0).is_folder) : 
		return;
	elif (ascription == null) : 
		ascription = tree.get_root();
	var tree_item : TreeItem = ascription.create_child();
	tree_item.set_text(0, TreeTools.get_valid_itemtext(ascription, asset_name) );
	var data : AssetData = AssetData.new();
	data.data = asset;
	data.ascription = tree_item;
	data.is_folder = false;
	asset.name = asset_name;
	tree_item.set_metadata(0, data);
	return tree_item;
	# 添加一个资产到资产树
func append_asset_to_tree(asset_name : String, asset : MinecraftBaseAsset, ascription : TreeItem = null) -> TreeItem :
	var tree_item : TreeItem = append_asset_to_tree_no_signal(asset_name, asset, ascription);
	added_item.emit(tree_item);
	return tree_item;# 添加一个资产到资产树

func create_folder_no_signal(folder_name : String, ascription : TreeItem = null) -> TreeItem : 
	if (ascription != null && !ascription.get_metadata(0).is_folder) : 
		return;
	elif (ascription == null) : 
		ascription = tree.get_root();
	folder_name = TreeTools.get_valid_itemtext(ascription, folder_name);
	
	var item : TreeItem = ascription.create_child();
	var data : AssetData = AssetData.new();
	data.ascription = item;
	data.is_folder = true;
	item.set_text(0, folder_name);
	item.set_metadata(0, data);
	item.collapsed = true;
	return item;
func create_folder(folder_name : String, ascription : TreeItem = null) -> TreeItem :
	var folder_item : TreeItem = create_folder_no_signal(folder_name, ascription);
	added_item.emit(folder_item);
	return folder_item;
	# 添加一个文件夹到资产树

func remove_tree_item(item : TreeItem) -> bool : 
	if (tree.get_root() == item) : 
		return false;
	item.free();
	return true;

func rename_tree_item(item : TreeItem, new_name : String) -> void : 
	var file_path : String = ProjectManager.current_project_config.project_path + "/res" + item.get_metadata(0).path;
	if (FileAccess.file_exists(file_path) || DirAccess.dir_exists_absolute(file_path)) : 
		var parent_path : String = item.get_parent().get_metadata(0).path;
		DirAccess.rename_absolute(file_path, ProjectManager.current_project_config.project_path + \
				"/res" + parent_path + "/" + new_name);
	item.set_text(0, new_name);


func save_asset_tree() : 
	var cfg_file : ConfigFile = ConfigFile.new();
	TreeTools.foreach_tree(tree.get_root(), func(item : TreeItem) : 
		var section : String = item.get_metadata(0).path;
		cfg_file.set_value(section, "parent", item.get_parent().get_metadata(0).path);
		if (item.get_metadata(0).is_folder) : 
			cfg_file.set_value(section, "type", "folder");
			return;
		var asset : MinecraftBaseAsset = item.get_metadata(0).data;
		cfg_file.set_value(section, "type", asset.type);
		if (asset.has_method("_save_attribute")) :
			var save_data : Array[String] = asset.call("_save_attribute");
			for attribute in save_data : 
				var varibute : Variant = asset.get(attribute);
				cfg_file.set_value(section, attribute, varibute);
	);
	cfg_file.save(ProjectManager.current_project_config.project_path + "/assets.cfg");

func load_asset_tree(file_path : String) : 
	var cfg_file : ConfigFile = ConfigFile.new();
	var err = cfg_file.load(file_path);
	if (err != OK) : 
		return;
	var sections : PackedStringArray = cfg_file.get_sections();
	for item : String in sections : 
		var type : String = cfg_file.get_value(item, "type");
		var parent : String = cfg_file.get_value(item, "parent");
		
		var parent_item : TreeItem = tree.get_root();
		if (!parent.is_empty()) :
			parent_item = TreeTools.find_item_to_dir(tree, parent);
		
		var item_name : String = item.get_file();
		var asset : MinecraftBaseAsset = null;
		var attributes : Dictionary = {};
		for key in cfg_file.get_section_keys(item) : 
			attributes[key] = cfg_file.get_value(item, key);
		match(type) : 
			"folder" : 
				create_folder(item_name, parent_item);
				continue;
			Global.ASSET_MC_ITEM : 
				asset = MinecraftItemAsset.new();
		
		if (asset != null) : 
			asset.callv(&"_load_attribute", [attributes]);
			append_asset_to_tree(item_name, asset, parent_item);











