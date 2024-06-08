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
