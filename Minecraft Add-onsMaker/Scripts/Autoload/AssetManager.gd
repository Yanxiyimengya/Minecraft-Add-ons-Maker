extends Node;
# 资产管理器
# 管理正在编辑的项目拥有的工程资产


enum ITEM_TYPE {
	FOLDER,
	
	TEXTURE
};
enum COLUMN_NAME {
	NAME,
	TYPE,
	DATA
};

var asset_tree : Tree = Tree.new();
# 资源树

func _ready() : 
	asset_tree.columns = 3;
	asset_tree.create_item();
	# 创建根节点
	
	append_asset_to_tree(MinecraftTextureAsset.new(), "测试资源");
	

func append_asset_to_tree(asset : BaseMinecraftAsset, asset_name : String, parent : TreeItem = null) -> TreeItem :
	if (parent == null) :
		parent = asset_tree.get_root();
		if (parent == null) : 
			return;
	elif (parent.get_metadata(COLUMN_NAME.TYPE) != ITEM_TYPE.FOLDER) : 
		return;
	var item : TreeItem = parent.create_child();
	var type : ITEM_TYPE;
	if (asset is MinecraftTextureAsset) : 
		type = ITEM_TYPE.TEXTURE;
	item.set_metadata(COLUMN_NAME.NAME, asset_name);
	item.set_metadata(COLUMN_NAME.TYPE, type);
	item.set_metadata(COLUMN_NAME.DATA, asset);
	return item;
	# 添加一个资产到资产树

func append_folder_to_tree(folder_name : String, parent : TreeItem = null) -> TreeItem :
	if (parent == null) :
		parent = asset_tree.get_root();
		if (parent == null) : 
			return;
	elif (parent.get_metadata(COLUMN_NAME.TYPE) != ITEM_TYPE.FOLDER) : 
		return;
	var item : TreeItem = parent.create_child();
	item.set_metadata(COLUMN_NAME.NAME, folder_name);
	item.set_metadata(COLUMN_NAME.TYPE, ITEM_TYPE.FOLDER);
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
			var type : ITEM_TYPE = item.get_metadata(COLUMN_NAME.TYPE);
			if (type == ITEM_TYPE.FOLDER) : 
				folder_queue.append([currect_path, item]);
			else :
				result[currect_path + item.get_metadata(COLUMN_NAME.NAME)] = item;
		
		if (folder_queue.is_empty()) :
			break;
		var folder : Array = folder_queue.pop_front();
		currect_tree_item = folder[1];
		currect_path = folder[0] + folder[1].get_metadata(COLUMN_NAME.NAME) + "/";
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


