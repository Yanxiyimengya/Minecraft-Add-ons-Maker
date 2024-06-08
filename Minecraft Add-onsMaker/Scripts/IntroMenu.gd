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


func _on_new_project_button_pressed():
	change_viewport_to_packed(NEW_PROJECT_VIEW);

func _on_private_project_button_pressed():
	change_viewport_to_packed(RECENT_PROJECT_VIEW);
