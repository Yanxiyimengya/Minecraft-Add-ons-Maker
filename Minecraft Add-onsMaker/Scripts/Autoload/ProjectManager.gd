extends Node;
# 负责管理所有项目的一个功能

var current_project_config : PackageConfig = null;
# 当前正在编辑的项目

func save_project(project : PackageConfig, save_dir : String) : 
	DirAccess.make_dir_absolute(save_dir); # 创建项目目录
	if (project.is_resource_pack) : 
		DirAccess.make_dir_absolute(save_dir + "/res"); # 创建项目资源包目录
	
	project.export_config(save_dir);
	AssetManager.save_asset_tree(save_dir + "/assets.cfg");
	
	var icon_dir : String = save_dir + "/icon.png";
	var project_image : Image = project.project_icon.get_image();
	if (project_image != null) : 
		project_image.save_png(icon_dir);
	# 保存icon
	return true;
	# 保存项目到指定路径

func load_project(proj_path : String) -> PackageConfig : 
	if (!DirAccess.dir_exists_absolute(proj_path)) : 
		return;
	var project : PackageConfig =  PackageConfig.import_config(proj_path);
	if (project == null) : 
		return;
	print(proj_path + "/icon.png")
	if (FileAccess.file_exists(proj_path + "/icon.png")) : 
		var icon_image : Image = Image.load_from_file(proj_path + "/icon.png");
		project.project_icon = ImageTexture.create_from_image(icon_image);
	# 加载icon
	
	if (project.is_resource_pack && DirAccess.dir_exists_absolute(proj_path + "/res")) : 
		pass; 
	return project;
	# 从指定文件夹加载一个项目

func open_project(proj : PackageConfig) : 
	current_project_config = proj;
	MainGUI.change_scene_to_file("res://Scenes/Editor/Editor.tscn");
	if (DirAccess.dir_exists_absolute( proj.project_path + "/res") ) : 
		ResourceManager.load_files(proj.project_path + "/res");
		AssetManager.load_asset_tree(proj.project_path + "/" + Global.ASSET_CONFIG_FILE);
	
	# 从PackageConfig中打开项目

