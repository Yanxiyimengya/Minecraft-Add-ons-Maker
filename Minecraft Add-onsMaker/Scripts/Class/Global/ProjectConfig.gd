extends Resource;
class_name ProjectConfig;
# 项目的配置信息
# 还可以负责对当前项目的导出管理

const PROJECT_TYPE_DATA = "data";			# Minecraft行为包
const PROJECT_TYPE_RESOURCE = "resources";	# Minecraft资源包

var is_active : bool = true;
# 决定项目是否有效
var addons_editor_version : String = Global.VERSION;
# 项目使用的编辑器版本

var project_name : String = "";
# 项目名称
var project_path : String = "";
# 项目路径
var project_type : String = PROJECT_TYPE_RESOURCE;
# 项目类型 (这同时影响附加包类型)
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

func save_project() : 
	var proj_dir : String = project_path;
	DirAccess.make_dir_absolute(proj_dir); # 创建项目目录
	
	var prject_config_data : Dictionary = {};
	prject_config_data["active"] = self.is_active;
	
	prject_config_data["editor_version"] = self.addons_editor_version;
	prject_config_data["project_name"] = self.project_name;
	#prject_config_data["project_path"] = self.project_path;
	prject_config_data["project_type"] = self.project_type;
	prject_config_data["project_description"] = self.project_description;
	prject_config_data["addons_version"] = self.addons_version;
	prject_config_data["format_version"] = self.format_version;
	prject_config_data["min_engine_version"] = self.min_engine_version;
	
	
	var file : FileAccess = FileAccess.open(proj_dir + "/config.json", FileAccess.WRITE);
	if (file == null) : 
		return false;
	file.store_buffer(JSON.stringify(prject_config_data).to_utf8_buffer());
	file.close();
	
	var project_image : Image = self.project_icon.get_image();
	if (project_image != null) : 
		project_image.save_png(proj_dir + "/icon.png");
	return true;
	# 保存项目
static func load_project(proj_path : String) -> ProjectConfig : 
	var is_dir : bool = false;
	if (DirAccess.dir_exists_absolute(proj_path)) : 
		is_dir = true;
	elif (FileAccess.file_exists(proj_path) && proj_path.get_file() == "config.json") :
		is_dir = false;
	else : 
		return;
	# 判断文件是否存在
	
	var config_filepath : String = proj_path;
	if (is_dir) :
		config_filepath += "/config.json"; 
		if (!FileAccess.file_exists(config_filepath)) : 
			return;
	# 检索配置文件路径
	
	var config_data : Variant = {};
	var file : FileAccess = FileAccess.open(config_filepath, FileAccess.READ);
	config_data = JSON.parse_string(file.get_buffer(file.get_length()).get_string_from_utf8());
	if (config_data == null) : 
		return;
	
	file.close();
	
	var proj_config : ProjectConfig = ProjectConfig.new();
	proj_config.addons_editor_version = config_data["editor_version"];
	proj_config.project_name = config_data["project_name"];
	proj_config.project_path = proj_path;
	proj_config.project_type = config_data["project_type"];
	proj_config.project_description = config_data["project_description"];
	proj_config.addons_version = config_data["addons_version"];
	proj_config.format_version = config_data["format_version"];
	proj_config.min_engine_version = config_data["min_engine_version"];
	
	if (FileAccess.file_exists(proj_path + "/icon.png")) : 
		var icon_image : Image = Image.load_from_file(proj_path + "/icon.png");
		proj_config.project_icon = ImageTexture.create_from_image(icon_image);
	
	return proj_config;

static var MANIFEST_JSON : Dictionary = {
	format_version = 2,
	header = {
		description = "My dirt resource pack Add-On!",
		name = "My Resource Pack",
		uuid = "<FIRST GENERATED UUID>",
		version = [1, 0, 0],
		min_engine_version = [1, 16, 0]
	},
	modules = [
	{
		description = "My First Add-On!",
		type = "resources",
		uuid = "",
		version = [1, 0, 0]
		}
	]
};

#TODO 这是临时性的
func export_project(export_path : String) -> Error : 
	var zip_packer = ZIPPacker.new();
	var err := zip_packer.open(export_path + "/" + project_name + ".mcaddon");
	if (err != OK) :
		return err;
	var manifest_data : Dictionary = {
		format_version = self.format_version,
		header = {
			description = self.project_description,
			name = self.project_name,
			uuid = UUID.v4(),
			version = addons_version,
			min_engine_version = min_engine_version
		},
		modules = [
			{
				type = self.project_type,
				uuid = UUID.v4(),
				version = [1, 0, 0]
			}
		]
	};
	
	zip_packer.start_file(self.project_type + "/manifest.json");
	zip_packer.write_file(JSON.stringify(manifest_data).to_utf8_buffer());
	zip_packer.close_file();
	## manifest.json
	
	zip_packer.start_file(self.project_type + "/pack_icon.png");
	var export_icon_image : Image = project_icon.get_image().duplicate();
	export_icon_image.resize(120, 120, Image.INTERPOLATE_BILINEAR);
	zip_packer.write_file(export_icon_image.save_png_to_buffer());
	zip_packer.close_file();
	## icon.png
	
	
	
	zip_packer.close();
	return Error.OK;
