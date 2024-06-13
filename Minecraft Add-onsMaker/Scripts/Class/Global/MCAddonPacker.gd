extends RefCounted;
class_name MCAddonPacker;
# 这个类负责对Addons打包

var pack_config : PackageConfig = null;

var textures : Dictionary = {};
# 这是打包进去的资源纹理 ,它的键是路径 值是 MinecraftTextureAsset
# 例如 "dirt.png" : <Texture2D>
var items : Dictionary = {};
# 这是打包进去的行为包物品,它的键是路径 data_pack/items/<ItemName> 下的路径
# 例如 "diamond_apple" : <MinecraftItemAsset>


func pack(file_path : String) : 
	if (pack_config == null) : 
		return;
	var zip_packer = ZIPPacker.new();
	var err := zip_packer.open(file_path);
	if (err != OK) :
		return err;
	
	if (pack_config.is_resource_pack) : 
		packaged_resource_pack(zip_packer, pack_config);
		if (!textures.is_empty()) : 
			packaged_textures(zip_packer, textures);
			# 如果纹理目标存在 则打包纹理
		
	# 检测是否打资源包
	
	if (pack_config.is_data_pack) : 
		packaged_data_pack(zip_packer, pack_config);
	# 检测是否打行为包
	
	zip_packer.close();
	# 对资源进行打包

func packaged_textures(zip_packer : ZIPPacker, tex_dict : Dictionary) : 
	for emits in tex_dict : 
		if (tex_dict[emits] is Dictionary) : 
			packaged_textures(zip_packer, tex_dict[emits]);
		else : 
			var data : PackedByteArray = ImageTools.set_proportional(tex_dict[emits].texture.get_image()) \
					.save_png_to_buffer();
			zip_packer.start_file("resource_pack/textures/" + emits);
			zip_packer.write_file(data);
			zip_packer.close_file();
	# 打包资源文件
	# 要求一个 path : Texture 的字典

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

