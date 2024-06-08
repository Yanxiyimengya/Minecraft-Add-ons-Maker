extends Node;
# 负责管理所有项目的一个功能

var current_project_config : ProjectConfig = null;
# 当前正在编辑的项目

func open_project(proj : ProjectConfig) : 
	current_project_config = proj;
	MainGUI.change_scene_to_file("res://Scenes/Editor/Editor.tscn");

#region AssetManager



#endregion
