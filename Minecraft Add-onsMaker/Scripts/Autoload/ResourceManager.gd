extends Node;
# 资源管理器
# 维护一张资源树列表

signal added_item(res_item : TreeItem);
# 添加资源时会发出
signal remove_item(res_item : TreeItem);
# 移除资源时会发出

var resource_tree : Tree = Tree.new();
# 资源树

class ResourceData : 
	extends RefCounted;
	var data : MinecraftBaseResource = null;
	var path : String = "" : 
		get : 
			if (ascription == null) : 
				return "";
			return ascription.get_parent().get_metadata(0).path + "/" + ascription.get_text(0);
	var ascription : TreeItem = null;
	var is_folder : bool = true;

func _ready() : 
	resource_tree.columns = 1;
	var root : TreeItem = resource_tree.create_item();
	var data : ResourceData = ResourceData.new();
	data.is_folder = true;
	root.set_metadata(0, data);
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

func load_resource_to_apped(file_path : String, tree_item : TreeItem) : 
	var res : MinecraftTextureResource = load_resource(file_path);
	if (res == null) : 
		return;
	append_resource_to_tree(file_path.get_file(), res, tree_item);
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
	res_data.is_folder = false;
	item.set_text(0, res_name);
	item.set_metadata(0, res_data);
	added_item.emit(item);
	return item;

func create_folder_no_signal(folder_name : String, ascription : TreeItem = null) -> TreeItem : 
	if (ascription != null && !ascription.get_metadata(0).is_folder) : 
		return;
	elif (ascription == null) : 
		ascription = resource_tree.get_root();
	folder_name = TreeTools.get_valid_itemtext(ascription, folder_name);
	
	var item : TreeItem = ascription.create_child();
	var res_data : ResourceData = ResourceData.new();
	res_data.ascription = item;
	res_data.is_folder = true;
	item.set_text(0, folder_name);
	item.set_metadata(0, res_data);
	item.collapsed = true;
	return item;
func create_folder(folder_name : String, ascription : TreeItem = null) -> TreeItem :
	var folder_item : TreeItem = create_folder_no_signal(folder_name, ascription);
	added_item.emit(folder_item);
	return folder_item;

func remove_resource_item(res_item : TreeItem) -> bool : 
	if (resource_tree.get_root() == res_item) : 
		return false;
	var res_data : ResourceData = res_item.get_metadata(0);
	if (res_data != null) : 
		FileTools.remove_dir(ProjectManager.current_project_config.project_path + "/res/" + res_data.path)
	res_item.free();
	return true;

func move_resource_item(from : TreeItem, target_itm : TreeItem) : 
	if (!target_itm.get_metadata(0).is_folder || from == target_itm) : 
		return;
	var file_path : String = ProjectManager.current_project_config.project_path + "/res" + from.get_metadata(0).path;
	var target_path : String = ProjectManager.current_project_config.project_path + "/res" + \
			target_itm.get_metadata(0).path + "/" + from.get_text(0);
	DirAccess.rename_absolute(file_path, target_path);
	from.get_parent().remove_child(from);         # 先从原来的父节点删除
	target_itm.add_child(from);                      # 添加到目标位置的TreeItem
	# 移动一个项

func rename_resource_item(res_item : TreeItem, new_name : String) -> void : 
	var file_path : String = ProjectManager.current_project_config.project_path + "/res" + res_item.get_metadata(0).path;
	if (FileAccess.file_exists(file_path) || DirAccess.dir_exists_absolute(file_path)) : 
		var parent_path : String = res_item.get_parent().get_metadata(0).path;
		DirAccess.rename_absolute(file_path, ProjectManager.current_project_config.project_path + \
				"/res" + parent_path + "/" + new_name);
	res_item.set_text(0, new_name);

func open_resource_in_file_manager(res_item : TreeItem) : 
	var file_path : String = ProjectManager.current_project_config.project_path + \
			"/res" + res_item.get_metadata(0).path;
	if (DirAccess.dir_exists_absolute(file_path) || FileAccess.file_exists(file_path)) : 
		OS.shell_show_in_file_manager(file_path);
