extends Node;
# 负责管理所有项目的一个功能

var current_project_config : PackageConfig = null;
# 当前正在编辑的项目

func save_project(project : PackageConfig, save_dir : String) : 
	DirAccess.make_dir_absolute(save_dir); # 创建项目目录
	
	var proect_config_data : Dictionary = {};
	proect_config_data["active"] = project.is_active;
	proect_config_data["editor_version"] = project.addons_editor_version;
	proect_config_data["project_name"] = project.project_name;
	proect_config_data["project_path"] = project.project_path;
	proect_config_data["project_description"] = project.project_description;
	proect_config_data["addons_version"] = project.addons_version;
	proect_config_data["format_version"] = project.format_version;
	proect_config_data["min_engine_version"] = project.min_engine_version;
	## ————————————
	proect_config_data["res_uuid"] = project.res_uuid;
	proect_config_data["data_uuid"] = project.data_uuid;
	proect_config_data["pack_bind"] = project.pack_bind;
	## ————————————
	proect_config_data["modules"] = project.modules;
	proect_config_data["packaged_type"] = project.packaged_type;
	
	var file : FileAccess = FileAccess.open(save_dir + "/config.json", FileAccess.WRITE);
	if (file == null) : 
		return false;
	file.store_buffer(JSON.stringify(proect_config_data).to_utf8_buffer());
	file.close();
	
	var project_image : Image = project.project_icon.get_image();
	if (project_image != null) : 
		project_image.save_png(save_dir + "/icon.png");
	# 保存icon
	
	return true;
	# 保存项目到指定路径

static func load_project(proj_path : String) -> PackageConfig : 
	var is_dir : bool = false;
	if (DirAccess.dir_exists_absolute(proj_path)) : 
		is_dir = true;
	elif (FileAccess.file_exists(proj_path) && proj_path.get_file() == "config.json") :
		is_dir = false;
	else : 
		return;
	# 判断文件是否存在
	
	var config_filepath : String = proj_path;
	if (is_dir) :
		config_filepath += "/config.json"; 
		if (!FileAccess.file_exists(config_filepath)) : 
			return;
	# 检索配置文件路径
	
	var config_data : Variant = {};
	var file : FileAccess = FileAccess.open(config_filepath, FileAccess.READ);
	config_data = JSON.parse_string(file.get_buffer(file.get_length()).get_string_from_utf8());
	if (config_data == null) : 
		return;
	file.close();
	
	var proj_config : PackageConfig = PackageConfig.new();
	proj_config.addons_editor_version = config_data["editor_version"];
	proj_config.project_name = config_data["project_name"];
	proj_config.project_path = proj_path;
	proj_config.project_description = config_data["project_description"];
	proj_config.addons_version = config_data["addons_version"];
	proj_config.format_version = config_data["format_version"];
	proj_config.min_engine_version = config_data["min_engine_version"];
	## ————————————
	proj_config.res_uuid = config_data["res_uuid"];
	proj_config.data_uuid = config_data["data_uuid"];
	proj_config.pack_bind = config_data["pack_bind"];
	## ————————————
	proj_config.modules = config_data["modules"];
	proj_config.packaged_type = config_data["packaged_type"];
	
	if (FileAccess.file_exists(proj_path + "/icon.png")) : 
		var icon_image : Image = Image.load_from_file(proj_path + "/icon.png");
		proj_config.project_icon = ImageTexture.create_from_image(icon_image);
	# 加载icon
	
	return proj_config;
	# 从指定文件夹加载一个资产

func open_project(proj : PackageConfig) : 
	current_project_config = proj;
	MainGUI.change_scene_to_file("res://Scenes/Editor/Editor.tscn");
	# 从PackageConfig中加载资产

