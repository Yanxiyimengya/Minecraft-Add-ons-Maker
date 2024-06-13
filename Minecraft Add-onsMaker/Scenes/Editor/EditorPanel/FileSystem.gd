extends Control;

@onready var res_tree : Tree = %Tree;

var drag_item : TreeItem = null;

func _ready() : 
	$FilePopupMenu.add_item("打开");
	$FilePopupMenu.add_separator("");
	$FilePopupMenu.add_item("剪切");
	$FilePopupMenu.add_item("复制");
	$FilePopupMenu.add_item("重命名");
	$FilePopupMenu.add_item("删除");
	$FilePopupMenu.add_separator("");
	$FilePopupMenu.add_item("在文件管理器打开");
	$FilePopupMenu.id_pressed.connect(func(id : int) : 
		var selected_item : TreeItem = res_tree.get_selected();
		if (selected_item == null) : 
			return;
		print(id);
		match(id) : 
			4 : 
				selected_item.set_editable(0, true);
				res_tree.set_selected(selected_item, 0);
				res_tree.edit_selected();
				get_viewport().set_input_as_handled();
			5 : 
				remove_resource_item(selected_item);
			7 : 
				var file_path : String = ProjectManager.current_project_config.project_path + \
						"/res" + selected_item.get_metadata(0).get_metadata(0).ascription.get_parent().get_metadata(0).path;
				if (DirAccess.dir_exists_absolute(file_path)) : 
					OS.shell_open(file_path);
					
	);
	
	$FolderPopupMenu.add_submenu_item("新建", "CreateMenu");
	$FolderPopupMenu/CreateMenu.add_item("纹理");
	$FolderPopupMenu/CreateMenu.add_item("模型");
	$FolderPopupMenu/CreateMenu.add_item("文件夹");
	$FolderPopupMenu.add_separator("");
	$FolderPopupMenu.add_item("展开文件夹");
	$FolderPopupMenu.add_item("收起文件夹");
	$FolderPopupMenu.add_separator("");
	$FolderPopupMenu.add_item("剪切");
	$FolderPopupMenu.add_item("复制");
	$FolderPopupMenu.add_item("重命名");
	$FolderPopupMenu.add_item("删除");
	$FolderPopupMenu.add_separator("");
	$FolderPopupMenu.add_item("在文件管理器打开");
	$FolderPopupMenu/CreateMenu.id_pressed.connect(func(id : int) : 
		var selected_item : TreeItem = res_tree.get_selected();
		match(id) : 
			2 : 
				create_folder("new folder", selected_item, true);
	);
	$FolderPopupMenu.id_pressed.connect(func(id : int) : 
		var selected_item : TreeItem = res_tree.get_selected();
		if (selected_item == null) : 
			return;
		match(id) : 
			7 : 
				selected_item.set_editable(0, true);
				res_tree.set_selected(selected_item, 0);
				res_tree.edit_selected();
				get_viewport().set_input_as_handled();
			8 : 
				remove_resource_item(selected_item);
			10 : 
				ResourceManager.open_resource_in_file_manager(selected_item.get_metadata(0));
	);

func _enter_tree() : 
	ResourceManager.added_item.connect(_resource_tree_added_item);

func _exit_tree() : 
	ResourceManager.added_item.disconnect(_resource_tree_added_item);

func _input(event : InputEvent) : 
	if (event is InputEventKey && event.is_pressed() && event.keycode == KEY_DELETE) : 
		var select_item : TreeItem = res_tree.get_selected();
		if (select_item != null) : 
			remove_resource_item(select_item);
		# 选中项 按Delete键移除项
	

func _resource_tree_added_item(res_item : TreeItem) :
	if (res_item == null) : 
		return;
	var res_data : ResourceManager.ResourceData = res_item.get_metadata(0);
	var res_path : String = res_data.path; 
	if (res_data.ascription != null) : 
		res_path = res_data.ascription.get_parent().get_metadata(0).path;
	else : 
		res_path = "";
	append_resource_data(TreeTools.find_item_to_dir(res_tree, res_path), res_data);

enum PorupState {
	Folder,
	File
};
func _on_tree_item_mouse_selected(pos : Vector2, mouse_button_index : int) : 
	var item : TreeItem = res_tree.get_item_at_position(pos);
	if (item == null) : 
		return;
	if (item == res_tree.get_root()) : 
		pass;
	match(mouse_button_index) : 
		2 : 
			var restree_item : TreeItem = item.get_metadata(0);
			if (restree_item == null) :
				return;
			if (restree_item.get_metadata(0).is_folder) : 
				set_porup_menu(PorupState.Folder);
			else : 
				set_porup_menu(PorupState.File);

func set_porup_menu(state : PorupState) : 
	match(state) : 
		PorupState.File : 
			$FilePopupMenu.show();
			$FolderPopupMenu.hide();
			$FilePopupMenu.position = DisplayServer.mouse_get_position();
		PorupState.Folder :
			$FilePopupMenu.hide();
			$FolderPopupMenu.show();
			$FolderPopupMenu.position = DisplayServer.mouse_get_position();

func append_resource_data(current_root : TreeItem, re_data : ResourceManager.ResourceData) : 
	var new_item : TreeItem = current_root.create_child();
	new_item.set_text(0, re_data.ascription.get_text(0));
	new_item.set_metadata(0, re_data.ascription);
	var res_data : MinecraftBaseResource = re_data.data;
	if (res_data is MinecraftTextureResource) :
		new_item.set_icon(0, res_data.texture);
	new_item.set_text_overrun_behavior(0, TextServer.OVERRUN_TRIM_ELLIPSIS);
	# 从资源树中的资源数据加载一项进入可视资源树

func reset_resource_tree() :
	res_tree.clear();
	var res_root : TreeItem = res_tree.create_item();
	res_root.set_text(0, "资源包资产");
	res_root.set_metadata(0, ResourceManager.resource_tree.get_root());
	res_root.set_text_overrun_behavior(0, TextServer.OVERRUN_TRIM_ELLIPSIS);
	#self.queue_sort();
	# 重置可视资源树 并设置可视资源树根节点

func create_folder(folder_name : String, current_root : TreeItem, edit : bool = false) -> TreeItem : 
	var res_folder : TreeItem = ResourceManager.create_folder_no_signal(folder_name, current_root.get_metadata(0));
	if (res_folder == null) : 
		return;
	var folder_item : TreeItem = current_root.create_child();
	folder_item.set_text(0, folder_name);
	folder_item.set_metadata(0, res_folder);
	folder_item.set_text_overrun_behavior(0, TextServer.OVERRUN_TRIM_ELLIPSIS);
	
	var folder_absolute_path : String = ProjectManager.current_project_config.project_path + "/res" + res_folder.get_metadata(0).path;
	if (!DirAccess.dir_exists_absolute(folder_absolute_path)) : 
		DirAccess.make_dir_absolute(folder_absolute_path);
	
	if (edit) : 
		res_tree.set_selected(folder_item, 0);
		res_tree.edit_selected();
	
	return folder_item;
	# 在可视资源树中创建文件夹
	# 在资源树中也同样会创建

func remove_resource_item(res_item : TreeItem) : 
	var res_tree_item : TreeItem = res_item.get_metadata(0);
	if (res_tree_item != null) : 
		if(ResourceManager.remove_resource_item(res_tree_item)) : 
			res_item.free();
	# 从可视资源树中移除一项
	# 资源树中的项也会被一并移除

func reload_resource_tree() : 
	reset_resource_tree();
	var rsmanager_root : TreeItem = ResourceManager.resource_tree.get_root();
	var folder_queue : Array = [];
	var current_root : TreeItem = res_tree.get_root();
	var children_list : Array;
	while (true) : 
		children_list = rsmanager_root.get_children();
		for rs_item : TreeItem in children_list : 
			if (rs_item.get_metadata(0).is_folder) : 
				folder_queue.push_back([rs_item, current_root]);
			else : 
				append_resource_data(current_root, rs_item.get_metadata(0));
		if (folder_queue.is_empty()) : 
			break;
		var folder_data : Array = folder_queue.pop_front();
		rsmanager_root = folder_data[0];
		current_root = folder_data[1].create_child();
		current_root.set_text(0, rsmanager_root.get_text(0));
		current_root.set_metadata(0, rsmanager_root);
		current_root.set_text_overrun_behavior(0, TextServer.OVERRUN_TRIM_ELLIPSIS);
# 更新整个可视资源树
# 从资源树中拷贝所有项进入可视资源树

