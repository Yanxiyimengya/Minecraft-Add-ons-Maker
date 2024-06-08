extends Node;
# 资源管理器
# 维护一张资源树列表

var resource_tree : Tree = Tree.new();
# 资源树

enum ITEM_TYPE {
	FOLDER,
	
	TEXTURE
};
enum COLUMN_NAME {
	NAME,
	TYPE,
	DATA
};

func _ready() : 
	resource_tree.columns = 3;
	resource_tree.create_item().set_text(0, "资源管理器");
	# 创建资源树树根
	
	load_files("C:/Users/guosh/Desktop/根");

func load_file(file_path : String) -> Resource : 
	if (!FileAccess.file_exists(file_path)) : 
		return;
	var result : Resource;
	var ext : String = file_path.get_extension(); # 获取文件的后缀名称
	match(ext) : 
		"png" : 
			var image : Image = Image.load_from_file(file_path);
			result = ImageTexture.create_from_image(image);
		_ : 
			return;
	return result;

func load_resource_to_apped(file_path : String, tree_path : String) : 
	var res : Resource = load_file(file_path);
	if (res == null) : 
		return;
	var parent_item : TreeItem = find_item_to_dir(tree_path);
	if (parent_item == null) : 
		return;
	append_resource_to_tree(parent_item, file_path.get_file(), res);
	# 从磁盘的某个路径加载一个文件进入资源树

func load_files(file_path : String, root : TreeItem = null) : 
	if (root == null) : 
		root = resource_tree.get_root();
		if (root == null) : 
			return;
	if (!DirAccess.dir_exists_absolute(file_path)) : 
		return;
	
	var dir : DirAccess = DirAccess.open(file_path);
	if (dir == null) : 
		return;
	dir.list_dir_begin();
	var fname : String = dir.get_next();
	while(!fname.is_empty()) : 
		if (dir.current_is_dir()) : 
			load_files(file_path+"/"+fname, create_folder(fname, root));
		else : 
			append_resource_to_tree(root, fname, load_file(file_path+"/"+fname));
			pass;
		fname = dir.get_next();
	dir.list_dir_end();
	# 加载一个目录内的所有文件进入资源树

func append_resource_to_tree(tree_item : TreeItem, res_name : String, res : Resource) -> TreeItem : 
	var type : ITEM_TYPE = ITEM_TYPE.TEXTURE;
	if (res is Texture) : 
		type = ITEM_TYPE.TEXTURE;
	else : 
		return;
	var item : TreeItem = tree_item.create_child();
	item.set_metadata(COLUMN_NAME.NAME, res_name);
	item.set_metadata(COLUMN_NAME.TYPE, type);
	item.set_metadata(COLUMN_NAME.DATA, res);
	return item;

func create_folder(folder_name : String, tree_item : TreeItem) -> TreeItem :
	var item : TreeItem = tree_item.create_child();
	item.set_metadata(COLUMN_NAME.NAME, folder_name);
	item.set_metadata(COLUMN_NAME.TYPE, ITEM_TYPE.FOLDER);
	item.collapsed = true;
	return item;

func foreach_tree(callable : Callable, root : TreeItem = null) : 
	if (root == null) : 
		root = resource_tree.get_root();
		if (root == null) : 
			return;
	
	var childrens : Array = root.get_children();
	for item in childrens : 
		if (item.get_child_count() > 0) : 
			foreach_tree(callable, item);
			callable.callv([item]);
			continue;
		callable.callv([item]);


func find_item_to_dir(path : String) -> TreeItem : 
	var str_array : PackedStringArray = path.split("/");
	var tree_item : TreeItem = resource_tree.get_root();
	if (tree_item == null) :
		return;
	for file : String in str_array : 
		var item_arr : Array[TreeItem] = tree_item.get_children();
		var i : int = -1;
		for item : TreeItem in item_arr : 
			if (item.get_metadata(COLUMN_NAME.NAME) == file) : 
				tree_item = item;
				break; 
			i += 1;
	return tree_item;
	# 找到一个路径下的TreeItem
