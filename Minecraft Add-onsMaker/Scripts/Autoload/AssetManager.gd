extends Node;
# 资产管理器
# 管理正在编辑的项目拥有的工程资产

class AssetData : 
	extends RefCounted;
	var data : BaseMinecraftAsset = null;	# 数据
	var ascription : TreeItem = null;		# 指这个资产在树中的哪个TreeItem中
	var type : int = Global.ASSET_TYPE.NULL;	# 类型
	
	var is_folder : bool = false;

var asset_tree : Tree = Tree.new();
# 资源树

func _ready() : 
	asset_tree.columns = 3;
	asset_tree.create_item();
	# 创建根节点

func append_asset_to_tree(asset_name : String, asset : BaseMinecraftAsset, ascription : TreeItem = null) -> TreeItem :
	if (ascription != null && !ascription.get_metadata(0).is_folder) : 
		return;
	elif (ascription == null) : 
		ascription = asset_tree.get_root();
	
	var tree_item : TreeItem = ascription.create_child();
	tree_item.set_text(0, asset_name);
	var data : AssetData = AssetData.new();
	data.data = asset;
	data.ascription = tree_item;
	asset.name = asset_name;
	if (asset is MinecraftTextureAsset) : 
		data.type = Global.ASSET_TYPE.TEXTURE;
	tree_item.set_metadata(0, data);
	
	return tree_item;
	# 添加一个资产到资产树

func append_folder_to_tree(folder_name : String, ascription : TreeItem = null) -> TreeItem :
	if (ascription != null && !ascription.get_metadata(0).is_folder) : 
		return;
	elif (ascription == null) : 
		ascription = asset_tree.get_root();
	var item : TreeItem = ascription.create_child();
	
	var tree_item : TreeItem = ascription.create_child();
	tree_item.set_text(0, folder_name);
	var data : AssetData = AssetData.new();
	data.ascription = tree_item;
	tree_item.set_metadata(0, data);
	
	return item;
	# 添加一个文件夹到资产树

func get_asset_items_of_dictionary(root : TreeItem = null) : 
	if (root == null) : 
		root = asset_tree.get_root();
		if (root == null) : 
			return;
	var result : Dictionary = {};
	var folder_queue : Array[Array] = [];
	var currect_tree_item : TreeItem = root;
	var currect_path : String = "";
	while(true) : 
		for item : TreeItem in currect_tree_item.get_children() : 
			var data : AssetData = item.get_metadata(0);
			if (data.is_folder) : 
				folder_queue.append([currect_path, item]);
			else :
				result[currect_path + item.get_text(0)] = item;
		
		if (folder_queue.is_empty()) :
			break;
		var folder : Array = folder_queue.pop_front();
		currect_tree_item = folder[1];
		currect_path = folder[0] + folder[1].get_text(0) + "/";
	return result;
	# 获取资产清单字典
	# path : asset_item

func foreach_tree(callable : Callable, root : TreeItem = null) : 
	if (root == null) : 
		root = asset_tree.get_root();
		if (root == null) : 
			return;
	
	var childrens : Array = root.get_children();
	for item in childrens : 
		if (item.get_child_count() > 0) : 
			foreach_tree(callable, item);
			callable.callv([item]);
			continue;
		callable.callv([item]);


