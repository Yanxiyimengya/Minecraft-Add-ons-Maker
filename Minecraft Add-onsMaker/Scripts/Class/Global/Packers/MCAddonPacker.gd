extends BaseAddonPacker;
class_name MCAddonPacker;
# 这个类负责对Addons打包

var textures : Dictionary = {};
# 这是打包进去的资源纹理 ,它的键是路径 值是 MinecraftTextureAsset
# 例如 "dirt.png" : <Texture2D>
var items : Dictionary = {};
# 这是打包进去的行为包物品,它的键是路径 data_pack/items/<ItemName> 下的路径
# 例如 "diamond_apple" : <MinecraftItemAsset>

func packaged_data_pack() : 
	super();
	
	if (!items.is_empty()) : 
		packaged_items(items);

func packaged_resource_pack() : 
	super();
	
	if (!textures.is_empty()) : 
		packaged_textures(textures);
	
	if (pack_config.is_data_pack && items.size() > 0) : 
		var item_textures : Dictionary = {
			"resource_pack_name": "vanilla",
			"texture_name": "atlas.items",
			"texture_data": {}
		}
		for item in items : 
			var item_data : MinecraftItemAsset = items[item];
			if (!item_data.components.has("icon")) : 
				continue;
			var texture_path : String = item_data.components["icon"]["texture"];
			item_textures["texture_data"][item_data.id] = {"textures" : "textures/" + texture_path};
		zip_packer.start_file(BaseAddonPacker.RESOURCE_FOLDER_NAME + "/textures/item_texture.json");
		zip_packer.write_file(JSON.stringify(item_textures).to_utf8_buffer());
		zip_packer.close_file();
	# 打包 item_texture.json


func packaged_items(item_dict : Dictionary) : 
	for emits in item_dict : 
		if (item_dict[emits] is Dictionary) : 
			packaged_items(item_dict[emits]);
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
						"identifier" : item_identifier,
						"category": MinecraftItemAsset.CATEGORYS[item_data.category]
					}
				}
			};
			var item_components : Dictionary = {};
			item_json["minecraft:item"]["components"] = item_components;
			for comp in item_data.components : 
				item_components["minecraft:"+comp] = item_data.components[comp];
			# 物品组件添加 
			
			if (item_data.components.has("icon")) : 
				if(pack_config.use_new_item_api) : 
					item_components["minecraft:icon"]["texture"] = item_data.id;
				else : 
					if (pack_config.is_resource_pack) : 
						var item_res_json : Dictionary = {
							"format_version": item_json["format_version"],
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
						zip_packer.start_file(BaseAddonPacker.RESOURCE_FOLDER_NAME + "/items/" + emits + ".json");
						zip_packer.write_file(JSON.stringify(item_res_json).to_utf8_buffer());
						zip_packer.close_file();
						# 打包 resource_pack/items/...json ** 旧版API **
			
			zip_packer.start_file(BaseAddonPacker.DATA_FOLDER_NAME + "/items/" + emits + ".json");
			zip_packer.write_file(JSON.stringify(item_json).to_utf8_buffer());
			zip_packer.close_file();

func packaged_textures(tex_dict : Dictionary) : 
	for emits in tex_dict : 
		if (tex_dict[emits] is Dictionary) : 
			packaged_textures(tex_dict[emits]);
		else : 
			var data : PackedByteArray = ImageTools.set_proportional(tex_dict[emits].texture.get_image()) \
					.save_png_to_buffer();
			zip_packer.start_file(BaseAddonPacker.RESOURCE_FOLDER_NAME + "/textures/" + emits);
			zip_packer.write_file(data);
			zip_packer.close_file();
	# 打包纹理资源
