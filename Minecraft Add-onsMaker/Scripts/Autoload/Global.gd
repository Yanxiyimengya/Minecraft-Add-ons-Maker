extends Node;

const EDITOR_NAME : String = "MCAddonsMaker";
const VERSION : String = "2024.6 - Alpha";
const DEFAULT_PROJECT_NAME : String = "My Add-ons";
const CONFIG_DIR : String = "user://";

const ASSET_CONFIG_FILE : String = "assets.cfg";

const ASSET_MC_ITEM : String = "mincraft-item";

@export var cache : EditorConfig = EditorConfig.new();

func _ready() : 
	pass;

func cmd(args : Array) :
	var cmd_title : String = args[0];
	match (cmd_title) : 
		"CreateProject" : 
			var project_config : PackageConfig = PackageConfig.new();
			project_config.project_name = args[1];
			project_config.project_path = args[2];
			Global.cache.append_project_config(project_config.project_name, project_config.project_path);
			
			return project_config;
		"ExportProject" : 
			var packer : MCAddonPacker = MCAddonPacker.new();
			packer.pack_config = ProjectManager.current_project_config;
			var texture_dict : Dictionary = {};
			var res_dice : Dictionary = TreeTools.get_child_of_dictionary(ResourceManager.resource_tree.get_root());
			for res_path in res_dice :
				var item : TreeItem = res_dice[res_path];
				var data : Object = item.get_metadata(0).data;
				if (data is MinecraftTextureResource) : 
					texture_dict[res_path] = data;
			# 遍历资源字典放入打包器
			var assets_dict : Dictionary = TreeTools.get_child_of_dictionary(AssetManager.tree.get_root());
			var item_dict : Dictionary = {};
			for asset_path in assets_dict : 
				var item : TreeItem = assets_dict[asset_path];
				var data : Object = item.get_metadata(0).data;
				if (data is MinecraftItemAsset) : 
					item_dict[asset_path] = data;
			# 遍历资产字典放入打包器
			
			packer.textures = texture_dict;
			packer.items = item_dict;
			
			packer.pack(args[1]);
		_ : 
			return false;
	return true;
	# 由全局控制器调用特定组件功能


func string_placeholder(_str : String, format = "{_}") -> String : 
	return _str.format({
		editor_name = EDITOR_NAME,
		version = VERSION,
		default_project_name = DEFAULT_PROJECT_NAME
	}, format);
	# 字符串格式化接口

func _notification(what : int):
	if (what == NOTIFICATION_WM_CLOSE_REQUEST) : 
		if (ProjectManager.current_project_config != null) : 
			ProjectManager.save_project(ProjectManager.current_project_config, ProjectManager.current_project_config.project_path);
		cache.save_project_config(CONFIG_DIR);
