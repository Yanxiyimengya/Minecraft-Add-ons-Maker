extends RefCounted;
class_name BaseAddonPacker;

const RESOURCE_FOLDER_NAME : String = "resource_pack";
const DATA_FOLDER_NAME : String = "data_pack";

var pack_config : PackageConfig = null;
# 包的属性配置
var zip_packer : ZIPPacker = ZIPPacker.new();

func pack(file_path : String) : 
	if (pack_config == null) : 
		return;
	var err := zip_packer.open(file_path);
	if (err != OK) :
		return err;
		
	if (pack_config.is_resource_pack) : 
		packaged_resource_pack();
	# 检测是否打资源包
	
	if (pack_config.is_data_pack) : 
		packaged_data_pack();
	# 检测是否打行为包
	
	zip_packer.close();
	# 对资源进行打包


func packaged_icon(path : String) : 
	zip_packer.start_file(path + "/pack_icon.png");
	var export_icon_image : Image = pack_config.project_icon.get_image().duplicate();
	export_icon_image.resize(120, 120, Image.INTERPOLATE_BILINEAR);
	zip_packer.write_file(export_icon_image.save_png_to_buffer());
	zip_packer.close_file();
	
	# 打包一个Icon的工具函数


func packaged_resource_pack() : 
	var packed_json : Dictionary = {
		format_version = pack_config.format_version,
		header = {
			description = pack_config.project_description,
			name = pack_config.project_name,
			uuid = pack_config.res_uuid,
			version = pack_config.addons_version,
			min_engine_version = pack_config.min_engine_version
		},
		modules = pack_config["modules"]["resource_modules"]
	};
	if (pack_config.pack_bind) : 
		var dependencies_list : Array = [];
		packed_json["dependencies"] = dependencies_list;
		if (pack_config.bind_self) : 
			dependencies_list.append({
				"uuid" : pack_config.data_uuid,
				"version" : pack_config.addons_version,
			});
		dependencies_list.append_array(pack_config.extra_dependencies.get("data",[]));
		
	zip_packer.start_file(RESOURCE_FOLDER_NAME + "/manifest.json");
	zip_packer.write_file(JSON.stringify(packed_json).to_utf8_buffer());
	zip_packer.close_file();
	packaged_icon(RESOURCE_FOLDER_NAME); # 打包图标
	
	# 打包资源包
	# 生成 :
	# |  manifest.json
	# |  icon.png

func packaged_data_pack() : 
	var packed_json : Dictionary = {
		format_version = pack_config.format_version,
		header = {
			description = pack_config.project_description,
			name = pack_config.project_name,
			uuid = pack_config.data_uuid,
			version = pack_config.addons_version,
			min_engine_version = pack_config.min_engine_version
		},
		modules = pack_config["modules"]["data_modules"]
	};
	if (pack_config.pack_bind) : 
		var dependencies_list : Array = [];
		packed_json["dependencies"] = dependencies_list;
		if (pack_config.bind_self) : 
			dependencies_list.append({
				"uuid" : pack_config.res_uuid,
				"version" : pack_config.addons_version,
			});
		dependencies_list.append_array(pack_config.extra_dependencies.get("resource",[]));
		
	zip_packer.start_file(DATA_FOLDER_NAME + "/manifest.json");
	zip_packer.write_file(JSON.stringify(packed_json).to_utf8_buffer());
	zip_packer.close_file();
	packaged_icon(DATA_FOLDER_NAME); # 打包图标
	
	# 打包行为包
	# 生成 :
	# |  manifest.json
	# |  icon.png
