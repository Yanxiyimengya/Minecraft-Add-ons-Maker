extends Node;

const EDITOR_NAME : String = "MCAddonsMaker";
const VERSION : String = "2024.6 - Alpha";
const DEFAULT_PROJECT_NAME : String = "My Add-ons";
const CONFIG_DIR : String = "user://";

var cache : EditorConfig = EditorConfig.new();


func cmd(args : Array) :
	var cmd_title : String = args[0];
	match (cmd_title) : 
		"CreateProject" : 
			var project_config : PackageConfig = PackageConfig.new();
			project_config.project_name = args[1];
			project_config.project_path = args[2];
			ProjectManager.save_project(project_config, args[2]);
			Global.cache.add_project_config(project_config);
			return project_config;
		"ExportProject" : 
			var packer : MCAddonPacker = MCAddonPacker.new();
			packer.pack_config = ProjectManager.current_project_config;
			
			var texture_dict : Dictionary = {};
			var asset_dice : Dictionary = AssetManager.get_asset_items_of_dictionary();
			for asset in asset_dice :
				var item : TreeItem = asset_dice[asset];
				var data : BaseMinecraftAsset = item.get_metadata(AssetManager.COLUMN_NAME.DATA);
				if (data is MinecraftTextureAsset) : 
					texture_dict[asset] = data;
			# 遍历资产字典放入打包器
			
			packer.textures = texture_dict;
			
			packer.pack(args[1]);
		_ : 
			return false;
	return true;
	pass;
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
		cache.save_project_config(CONFIG_DIR);
