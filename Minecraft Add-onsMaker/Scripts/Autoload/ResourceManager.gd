extends Node;
# 资源管理器
# 维护一张资源树列表

signal added_item(res_data : ResourceData);
# 添加资源时会发出

var resource_tree : Tree = Tree.new();
# 资源树

class ResourceData : 
	extends RefCounted;
	
	var data : MinecraftBaseResource = null;
	var path : String = "";
	var ascription : TreeItem = null;
	var is_folder : bool = true;

func _ready() : 
	resource_tree.columns = 3;
	var root : TreeItem = resource_tree.create_item();
	root.set_text(0, "资源管理器");
	root.set_metadata(0, ResourceData.new());
	# 创建资源树树根


func load_resource(file_path : String) -> MinecraftBaseResource : 
	if (!FileAccess.file_exists(file_path)) : 
		return;
	var result : MinecraftBaseResource;
	var ext : String = file_path.get_extension(); # 获取文件的后缀名称
	match(ext) : 
		"png" : 
			var image : Image = Image.load_from_file(file_path);
			result = MinecraftTextureResource.new(file_path.get_file(), ImageTexture.create_from_image(image));
		_ : 
			return;
	return result;

func load_resource_to_apped(file_path : String, tree_path : String) : 
	var res : MinecraftTextureResource = load_resource(file_path);
	if (res == null) : 
		return;
	var parent_item : TreeItem = TreeTools.find_item_to_dir(resource_tree, tree_path);
	if (parent_item == null) : 
		return;
	append_resource_to_tree(file_path.get_file(), res, parent_item);
	# 从磁盘的某个路径加载一个文件进入资源树

func load_files(file_path : String, root : TreeItem = null) : 
	if (!DirAccess.dir_exists_absolute(file_path)) : 
		return;
	
	var dir : DirAccess = DirAccess.open(file_path);
	if (dir == null) : 
		return;
	dir.list_dir_begin();
	var fname : String = dir.get_next();
	while(!fname.is_empty()) : 
		if (dir.current_is_dir()) : 
			load_files(file_path+"/"+fname, create_folder(fname, root) );
		else : 
			var resource_source : MinecraftBaseResource = load_resource(file_path+"/"+fname);
			if (resource_source != null) : 
				append_resource_to_tree(fname, resource_source, root);
		fname = dir.get_next();
	dir.list_dir_end();
	# 加载一个目录内的所有文件进入资源树

func append_resource_to_tree(res_name : String, res : MinecraftBaseResource, ascription : TreeItem = null) -> TreeItem : 
	if (ascription != null && !ascription.get_metadata(0).is_folder) : 
		return;
	elif (ascription == null) : 
		ascription = resource_tree.get_root();
	for item in ascription.get_children() : 
		if (res_name == item.get_text(0)) : 
			return;
		# 判断是否包含相同的 TreeItem
		# 如果有就不执行添加操作
	var item : TreeItem = ascription.create_child();
	var res_data : ResourceData = ResourceData.new();
	res_data.data = res;
	res_data.ascription = item;
	res_data.path = ascription.get_metadata(0).path + "/" + res_name;
	res_data.is_folder = false;
	item.set_text(0, res_name);
	item.set_metadata(0, res_data);
	added_item.emit(res_data);
	return item;

func create_folder(folder_name : String, ascription : TreeItem = null) -> TreeItem : 
	if (ascription != null && !ascription.get_metadata(0).is_folder) : 
		return;
	elif (ascription == null) : 
		ascription = resource_tree.get_root();
	for item in ascription.get_children() : 
		if (folder_name == item.get_text(0)) : 
			return;
		# 判断是否包含相同的 TreeItem
		# 如果有就不执行添加操作
	var item : TreeItem = ascription.create_child();
	var res_data : ResourceData = ResourceData.new();
	res_data.ascription = item;
	res_data.path = ascription.get_metadata(0).path + "/" + folder_name;
	res_data.is_folder = true;
	item.set_text(0, folder_name);
	item.set_metadata(0, res_data);
	item.collapsed = true;
	added_item.emit(res_data);
	return item;

func free_resources() : 
	resource_tree.clear();
