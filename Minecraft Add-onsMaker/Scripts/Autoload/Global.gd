extends Node;

const EDITOR_NAME : String = "MCAddonsMaker";
const VERSION : String = "2024.6 - Alpha";
const DEFAULT_PROJECT_NAME : String = "My Add-ons";
const CONFIG_DIR : String = "user://";

var cache : EditorConfig = EditorConfig.new();

func string_placeholder(_str : String, format = "{_}") -> String : 
	return _str.format({
		editor_name = EDITOR_NAME,
		version = VERSION,
		default_project_name = DEFAULT_PROJECT_NAME
	}, format);
	# 字符串格式化接口

func _notification(what : int):
	if (what == NOTIFICATION_WM_CLOSE_REQUEST) : 
		cache.save_project_config(CONFIG_DIR);
