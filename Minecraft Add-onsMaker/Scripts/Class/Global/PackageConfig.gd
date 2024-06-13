extends Resource;
class_name PackageConfig;
# 项目的配置信息

enum PackedType {
	Resource = 1, 	# 资源包
	Data = 2		# 行为包
}; # 包含的包类型枚举

var is_active : bool = true;
# 决定项目是否有效
var addons_editor_version : String = Global.VERSION;
# 项目使用的编辑器版本

var project_name : String = "";
# 项目名称
var project_path : String = "";
# 项目路径
var project_description : String = "";
# 项目的描述 (这同时也是附加包的描述)
var project_icon : Texture2D = preload("res://Assets/icon.png");
# 项目的Icon (这同时也是附加包的图标)
var format_version : int = 2;
# Add-ons 的格式
var addons_version : Array = [0, 0, 0];
# Add-ons 版本
var min_engine_version : Array = [1, 16, 0];
# Add-ons 依赖的最低引擎版本

var res_uuid : String = UUID.v4();
var data_uuid : String = UUID.v4();
# 项目的UUID
var modules : Dictionary = {
	"resource_modules" = [],
	"data_modules" = []
};
# 项目使用的模块
var pack_bind : bool = false;
# 是否开启包绑定
var packaged_type : int = PackedType.Resource | PackedType.Data;
# 项目类型



var is_resource_pack : bool = false : 
	get : 
		return (packaged_type & 0x1 == 1);
var is_data_pack : bool = false : 
	get : 
		return ((packaged_type >> 1) & 0x1 == 1);

func append_resource_module() :
	var module : Dictionary = {
		type = "resources",
		description = project_description,
		uuid = UUID.v4(),
		version = addons_version
	};
	modules["resource_modules"].append(module);
# 添加资源包模块

func append_data_module() :
	var module : Dictionary = {
		type = "data",
		description = project_description,
		uuid = UUID.v4(),
		version = addons_version
	};
	modules["data_modules"].append(module);
# 添加行为包模块




func export_config(export_path : String) : 
	var proect_config_data : Dictionary = {};
	proect_config_data["active"] = self.is_active;
	proect_config_data["editor_version"] = self.addons_editor_version;
	proect_config_data["project_name"] = self.project_name;
	proect_config_data["project_path"] = self.project_path;
	proect_config_data["project_description"] = self.project_description;
	proect_config_data["addons_version"] = self.addons_version;
	proect_config_data["format_version"] = self.format_version;
	proect_config_data["min_engine_version"] = self.min_engine_version;
	## ————————————
	proect_config_data["res_uuid"] = self.res_uuid;
	proect_config_data["data_uuid"] = self.data_uuid;
	proect_config_data["pack_bind"] = self.pack_bind;
	## ————————————
	proect_config_data["modules"] = self.modules;
	proect_config_data["packaged_type"] = self.packaged_type;
	
	FileTools.save_file(export_path + "/config.json", JSON.stringify(proect_config_data));
	# 保存 config.json 文件

static func import_config(proj_path : String) -> PackageConfig : 
	var config_data = JSON.parse_string(FileTools.load_file(proj_path + "/config.json"));
	if (config_data == null) : 
		return;
	## ————————————
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
	## ————————————
	return proj_config;
