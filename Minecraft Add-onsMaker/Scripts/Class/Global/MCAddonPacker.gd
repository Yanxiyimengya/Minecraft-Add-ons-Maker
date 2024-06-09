extends RefCounted;
class_name MCAddonPacker;
# 这个类负责对Addons打包

var pack_config : PackageConfig = null;

var textures : Dictionary = {};
# 这是打包进去的资源纹理 ,它的键是路径 值是 MinecraftTextureAsset
# 例如 "dirt.png" : Texture2D



func pack(file_path : String) : 
	if (pack_config == null) : 
		return;
	var zip_packer = ZIPPacker.new();
	var err := zip_packer.open(file_path);
	if (err != OK) :
		return err;
	
	if (pack_config.packaged_type & 0x1 == 1) : 
		packaged_resource_pack(zip_packer, pack_config);
		if (!textures.is_empty()) : 
			packaged_textures(zip_packer, textures);
	# 检测是否打资源包
	
	if ((pack_config.packaged_type >> 1) & 0x1 == 1) : 
		packaged_data_pack(zip_packer, pack_config);
	# 检测是否打行为包
	
	zip_packer.close();
	# 对资源进行打包

func packaged_textures(zip_packer : ZIPPacker, tex_dict : Dictionary) : 
	for emits in tex_dict : 
		if (tex_dict[emits] is Dictionary) : 
			packaged_textures(zip_packer, tex_dict[emits]);
		else : 
			var data : PackedByteArray = tex_dict[emits].get_texture().get_image().get_data();
			zip_packer.start_file("data_pack/textures/" + emits + tex_dict[emits].name);
			zip_packer.write_file(data);
			zip_packer.close_file();

func packaged_icon(zip_packer : ZIPPacker, path : String) : 
	zip_packer.start_file(path + "/pack_icon.png");
	var export_icon_image : Image = pack_config.project_icon.get_image().duplicate();
	export_icon_image.resize(120, 120, Image.INTERPOLATE_BILINEAR);
	zip_packer.write_file(export_icon_image.save_png_to_buffer());
	zip_packer.close_file();
	## icon.png

func packaged_resource_pack(zip_packer : ZIPPacker, data : PackageConfig) : 
	var packed_json : Dictionary = {
		format_version = data.format_version,
		header = {
			description = data.project_description,
			name = data.project_name,
			uuid = data.res_uuid,
			version = data.addons_version,
			min_engine_version = data.min_engine_version
		},
		modules = data["modules"]["resource_modules"]
	};
	
	zip_packer.start_file("resource_pack/manifest.json");
	zip_packer.write_file(JSON.stringify(packed_json).to_utf8_buffer());
	zip_packer.close_file();
	packaged_icon(zip_packer, "resource_pack"); # 打包图标

func packaged_data_pack(zip_packer : ZIPPacker, data : PackageConfig) : 
	var packed_json : Dictionary = {
		format_version = data.format_version,
		header = {
			description = data.project_description,
			name = data.project_name,
			uuid = data.data_uuid,
			version = data.addons_version,
			min_engine_version = data.min_engine_version
		},
		modules = data["modules"]["data_modules"]
	};
	zip_packer.start_file("data_pack/manifest.json");
	zip_packer.write_file(JSON.stringify(packed_json).to_utf8_buffer());
	zip_packer.close_file();
	packaged_icon(zip_packer, "data_pack"); # 打包图标

