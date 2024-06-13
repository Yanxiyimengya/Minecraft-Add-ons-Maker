extends Object;
class_name TreeTools;

static func find_item_to_dir(tree : Tree, path : String) -> TreeItem : 
	var str_array : PackedStringArray = path.split("/");
	var tree_item : TreeItem = tree.get_root();
	if (tree_item == null) :
		return;
	for file : String in str_array : 
		if (file.is_empty()) : 
			continue;
		var item_arr : Array[TreeItem] = tree_item.get_children();
		tree_item = null;
		for item : TreeItem in item_arr : 
			if (item.get_text(0) == file) : 
				tree_item = item;
				break; 
		if (tree_item == null) : 
			break;
	return tree_item;
	# 找到一个路径下的TreeItem

static func get_child_of_dictionary(root : TreeItem) -> Dictionary : 
	var result : Dictionary = {};
	var folder_queue : Array[Array] = [];
	var currect_tree_item : TreeItem = root;
	var currect_path : String = "";
	while(true) : 
		for item : TreeItem in currect_tree_item.get_children() : 
			if (item.get_child_count() > 0) : 
				folder_queue.append([currect_path, item]);
			else :
				result[currect_path + item.get_text(0)] = item;
		if (folder_queue.is_empty()) :
			break;
		var folder : Array = folder_queue.pop_front();
		currect_tree_item = folder[1];
		currect_path = folder[0] + folder[1].get_text(0) + "/";
	return result;
	# 获取TreeItem清单字典
	# path : asset_item

static func get_child_of_array(tree_item : TreeItem) -> Array[TreeItem]:
	var result : Array[TreeItem] = [];
	if (tree_item.get_child_count() > 0) :
		result.append_array(tree_item.get_children());
		for item : TreeItem in tree_item.get_children() :
			result.append_array(TreeTools.get_child_of_array(item));
	return result;
	# 获取 TreeItem 清单数组

static func foreach_tree(root : TreeItem, callable : Callable) : 
	var childrens : Array = root.get_children();
	for item in childrens : 
		if (item.get_child_count() > 0) : 
			callable.callv([item]);
			foreach_tree(item, callable);
			continue;
		callable.callv([item]);
	# 对树中的所有节点调用Callable

static func search_tree(item : TreeItem, text : String) -> bool : 
	var childrens : Array[TreeItem] = item.get_children();
	for child in childrens : 
		if (child.get_text(0) == text) : 
			return true;
	return false;

static func get_valid_itemtext(tree_item : TreeItem, asset_name : String) -> String : 
	var result_name : String = asset_name;
	var count : int = 2;
	for item in tree_item.get_children() : 
		if (item.get_text(0) == asset_name) : 
			result_name = asset_name + str(count);
			count += 1;
			break;
	if (count <= 2) : 
		return asset_name;
	return result_name;
	# 如果在以指定item下面创建项,获取有效的不冲突的文件名
