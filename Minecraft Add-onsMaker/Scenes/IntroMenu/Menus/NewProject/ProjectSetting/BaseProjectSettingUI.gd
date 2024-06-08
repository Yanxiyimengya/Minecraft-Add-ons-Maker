extends Node;

var project_config : ProjectConfig = ProjectConfig.new();

#region Tools
func get_filepath_parent(f_path : String) -> String : 
	var _len : int = f_path.get_file().length() + 1;
	return f_path.erase(f_path.length() - _len, _len);
	# 获取项目路径的父级目录

func get_default_project_path() -> String :
	var file_path : String = OS.get_system_dir(OS.SYSTEM_DIR_DOCUMENTS) + "/" + \
			Global.EDITOR_NAME + "/" + Global.DEFAULT_PROJECT_NAME;
	var count : int = 0;
	
	var currect_path : String = file_path;
	while(DirAccess.dir_exists_absolute(currect_path) || FileAccess.file_exists(currect_path)) :
		count += 1;
		currect_path = file_path + str(count);
	return currect_path;
	# 获取路径上有效的默认项目路径

func _create_project() -> ProjectConfig : 
	return project_config;
	# 这是一个虚函数, 创建项目时会对其进行调用
