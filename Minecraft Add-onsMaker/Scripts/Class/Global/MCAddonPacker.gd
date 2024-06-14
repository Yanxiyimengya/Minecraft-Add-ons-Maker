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
		if (!items.is_empty()) : 
			packaged_items(zip_packer, items);
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


func packaged_items(zip_packer : ZIPPacker, item_dict : Dictionary) : 
	for emits in item_dict : 
		if (item_dict[emits] is Dictionary) : 
			packaged_items(zip_packer, item_dict[emits]);
		else : 
			var item_data : MinecraftItemAsset = item_dict[emits];
			var item_identifier : String = item_data.id_namespace + ":" + item_data.id;
			# 长ID
			var item_json : Dictionary = {
				"format_version" : str(pack_config.min_engine_version[0]) + "." + \
						str(pack_config.min_engine_version[1]) + "." + \
						str(pack_config.min_engine_version[2]),
				"minecraft:item" : {
					"description" : {
						"identifier" : item_identifier
					}
				}
			};
			var item_components : Dictionary = {};
			item_json["minecraft:item"]["components"] = item_components;
			
			item_components["minecraft:hand_equipped"] = item_data.hand_equipped;
			item_components["minecraft:stacked_by_data"] = item_data.stacked_by_data;
			item_components["minecraft:max_stack_size"] = item_data.max_stack_size
			item_components["minecraft:foil"] = item_data.foil;
			if (item_data.has_damage) : 
				item_components["minecraft:max_damage"] = item_data.max_damage;
			if (item_data.is_food) : 
				var food_attributes : Dictionary = {};
				item_json["minecraft:item"]["components"]["minecraft:food"] = food_attributes;
				food_attributes["can_always_eat"] = item_data.can_always_eat;
			
			zip_packer.start_file("data_pack/items/" + emits + ".json");
			zip_packer.write_file(JSON.stringify(item_json).to_utf8_buffer());
			zip_packer.close_file();
			
			if (pack_config.is_resource_pack) : 
				if (!item_data.texture_path.is_empty()) : 
					if (pack_config.use_new_item_api) : 
						pass;
					else : 
						var item_res_json : Dictionary = {
							"format_version": "1.16.0",
							"minecraft:item": {
								"description": {
									"identifier": item_identifier,
									"category": MinecraftItemAsset.CATEGORYS[item_data.category]
								},
								"components": {
									"minecraft:icon": item_data.id
								}
							}
						};
						zip_packer.start_file("resource_pack/items/" + emits + ".json");
						zip_packer.write_file(JSON.stringify(item_res_json).to_utf8_buffer());
						zip_packer.close_file();
				# 打包 resource_pack/items/...json


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
	
	if (data.is_data_pack && items.size() > 0) : 
		var item_textures : Dictionary = {
			"resource_pack_name": "vanilla",
			"texture_name": "atlas.items",
			"texture_data": {}
		}
		for item in items : 
			var item_data : MinecraftItemAsset = items[item];
			if (item_data.texture_path.is_empty()) : 
				continue;
			var texture_path : String = item_data.texture_path;
			var pos : int = texture_path.get_file().rfind(".");
			texture_path = texture_path.substr(1, pos);
			# 纹理路径 移除图片路径的后缀名称
			
			item_textures["texture_data"][item_data.id] = {"textures" : "textures/" + texture_path};
		zip_packer.start_file("resource_pack/textures/item_texture.json");
		zip_packer.write_file(JSON.stringify(item_textures).to_utf8_buffer());
		zip_packer.close_file();
	

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
