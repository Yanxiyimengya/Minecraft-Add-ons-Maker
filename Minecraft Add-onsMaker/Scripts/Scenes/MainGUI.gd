extends Panel;

# 主GUI 管理
@onready var button_bar = $VBoxContainer/PanelContainer/MarginContainer/TopBar/ButtonBar;
@onready var version_lable = $VBoxContainer/PanelContainer/MarginContainer/TopBar/MarginContainer/VersionLable;
@onready var menu_viewport = %View;

var button_list : Dictionary = {};
# 这个列表存放顶部菜单按钮实例
var current_scene : Node = null;
# 当前的场景根节点

enum TOP_BAR_ITEMS {
	FILE,
	PROJECT,
	BUILD,
	TOOLS,
	HELP
};

func _ready() : 
	version_lable.text = Global.string_placeholder("Version {version}", "{_}");
	
	add_menubutton_on_topbar("文件");
	add_menubutton_on_topbar("项目");
	add_menubutton_on_topbar("构建");
	add_menubutton_on_topbar("工具");
	add_menubutton_on_topbar("帮助");
	
	change_scene_to_file("res://Scenes/IntroMenu/IntroMenu.tscn");

#region Tools
func add_button_on_topbar(button : BaseButton, button_id : int = -1) -> void : 
	if (button_list.has(button_id)) : 
		button_list[button_id].queue_free();
		button_list.erase(button_id);
		return;
	if (button_id == -1) : 
		button_id = button_list.size();
	button_bar.add_child(button);
	button_list[button_id] = button;
	button.flat = true;
	# 添加一个按钮实例进入顶部菜单
func add_menubutton_on_topbar(text : String, button_id : int = -1) -> void : 
	var button : MenuButton = MenuButton.new();
	button.flat = true;
	button.text = text;
	add_button_on_topbar(button, button_id);
	# 添加一个MenuButton进入顶部菜单

func change_scene_to_packed(menu_scene : PackedScene) -> void : 
	if (current_scene != null) : 
		current_scene.queue_free();
	current_scene = menu_scene.instantiate();
	menu_viewport.add_child(current_scene);
func change_scene_to_file(menu_scene : String) -> void : 
	if (FileAccess.file_exists(menu_scene)) : 
		change_scene_to_packed(load(menu_scene));
# 切换主视图下的场景

#endregion 
