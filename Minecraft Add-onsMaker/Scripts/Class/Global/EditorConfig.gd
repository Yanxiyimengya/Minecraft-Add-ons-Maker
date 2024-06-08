extends Resource;
class_name EditorConfig;
# 负责管理编辑器缓存或者编辑器配置文件

var project_configs : Dictionary = {};
# 一个被加载进编辑器的项目清单缓存 (显示在"最近项目"之中) 

func _init() : 
	load_config("user://projects.csv");

func load_config(file_path : String) : 
	if (!FileAccess.file_exists(file_path)) : 
		return;
	var config = ConfigFile.new();
	# 从文件加载数据。
	var err = config.load(file_path);
	# 如果文件没有加载，忽略它。
	if (err != OK) :
		return
	# 迭代所有小节。
	for project in config.get_sections():
		# 获取每个小节的数据。
		var is_favorite = config.get_value(project, "favorite");
		var data : ProjectInfoData = ProjectInfoData.new();
		data.is_favorite = is_favorite;
		data.project_name = config.get_value(project, "name");
		data.project_path = config.get_value(project, "path");
		
		if (FileAccess.file_exists(data.project_path+"/icon.png")) : 
			data.project_icon = ImageTexture.new();
			data.project_icon.set_image(Image.load_from_file(data.project_path+"/icon.png"));
		# 加载项目图片
		
		project_configs[project] = data;

func add_project_config(project_config : ProjectConfig) : 
	var proj_data : ProjectInfoData = ProjectInfoData.new();
	project_configs[project_config.project_path] = proj_data;
	
	proj_data.is_favorite = false;
	proj_data.project_name = project_config.project_name;
	proj_data.project_path = project_config.project_path;

func remove_project_config(project_info : ProjectInfoData) : 
	project_configs.erase(project_info.project_path);

func save_project_config(file_path : String) : 
	var config = ConfigFile.new();
	for project : String in project_configs : 
		config.set_value(project, "favorite", project_configs[project].get("is_favorite"));
		config.set_value(project, "name", project_configs[project].get("project_name"));
		config.set_value(project, "path", project_configs[project].get("project_path"));
	config.save(file_path + "projects.csv");
	

class ProjectInfoData : 
	extends RefCounted;
	var project_name : String = "";
	var project_path : String = "";
	var project_icon : Texture2D = null;
	var is_favorite : bool = false;
