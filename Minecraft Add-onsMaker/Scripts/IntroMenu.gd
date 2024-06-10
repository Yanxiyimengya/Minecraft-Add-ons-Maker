extends Control;

@onready var sub_viewport = %SubViewport;

const NEW_PROJECT_VIEW = "res://Scenes/IntroMenu/Menus/NewProject/NewProject.tscn";
const RECENT_PROJECT_VIEW = "res://Scenes/IntroMenu/Menus/RecentProjects/RecentProjects.tscn";
var current_scene : Node = null;
var scene_map : Dictionary = {};

func _ready() : 
	add_viewport_scene(NEW_PROJECT_VIEW);
	add_viewport_scene(RECENT_PROJECT_VIEW);
	change_viewport_to_packed(RECENT_PROJECT_VIEW);

func add_viewport_scene(file_path : String) : 
	if (scene_map.has(file_path)) : 
		return;
	scene_map[file_path] = load(file_path).instantiate();
	%SubViewport.add_child(scene_map[file_path]);
	scene_map[file_path].visible = false;

func change_viewport_to_packed(file_path : String) -> void : 
	if (!scene_map.has(file_path)) : 
		return;
	if (current_scene == scene_map[file_path]) : 
		return;
	if (current_scene != null) : 
		current_scene.visible = false;
	scene_map[file_path].visible = true;
	current_scene = scene_map[file_path];


func _on_new_project_button_pressed() :
	change_viewport_to_packed(NEW_PROJECT_VIEW);

func _on_private_project_button_pressed() :
	change_viewport_to_packed(RECENT_PROJECT_VIEW);

func _on_import_project_button_pressed() :
	DisplayServer.file_dialog_show("选择文件", "" , \
			"", false, DisplayServer.FILE_DIALOG_MODE_OPEN_FILE, \
			["config.json"], func(status : bool, selected_paths : PackedStringArray, _selected_filter_index : int):
				if (!status) : 
					return;
				for path : String in selected_paths : 
					path = path.replace("\\", "/");
					var proj_data : EditorConfig.ProjectInfoData = Global.cache.append_project_config_form_project_config(path);
					if (proj_data != null) : 
						scene_map[RECENT_PROJECT_VIEW].add_project_item(proj_data);
	); # 获取文件夹路径填入
	pass;
