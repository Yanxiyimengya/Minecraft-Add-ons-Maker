extends AttributeEdit;

var stacked_by_data : bool = false : 
	set(value) : 
		%StackedByDataCheckBox.button_pressed = value;
		%MaxStackSizeContainer.visible = value;
		target.data.stacked_by_data = value;
var is_food : bool = false : 
	set(value) : 
		target.data.is_food = value;
		%IsFoodCheckBox.button_pressed = value;
		%FoodAttributesContainer.visible = value;
	

func _set_target() : 
	%MaxStackSizeContainer.visible = false;
	%ItemTextureContainer.texture = null;
	%NameSpaceButton.get_popup().clear();
	var data : MinecraftItemAsset = target.data;
	
	%ItemIDEdit.text = data.id;
	var namespace_popup : PopupMenu = %NameSpaceButton.get_popup();
	namespace_popup.add_item("default");
	%NameSpaceButton.selected = 0;
	for ns in ProjectManager.current_project_config.namespaces : 
		namespace_popup.add_item(ns);
	
	stacked_by_data = data.stacked_by_data;
	%MaxStackSizeSpinBox.value = data.max_stack_size; # 最大堆叠
	%CategoryOptionButton.selected = data.category; # 物品类别
	%FoilCheckBox.button_pressed = data.foil; # 附魔
	
	is_food = data.is_food; # 食物
	%CanAwaysEatCheckBox.button_pressed = data.can_always_eat;
	
	if (data.texture_path) : 
		%ItemTextureContainer.texture = TreeTools.find_item_to_dir(ResourceManager.resource_tree, \
				data.texture_path).get_metadata(0).data.texture;


func _on_item_id_edit_text_changed(new_text : String):
	target.data.id = new_text;


func _on_stacked_by_data_check_box_toggled(toggled_on : bool):
	stacked_by_data = toggled_on;
func _on_max_stack_size_spin_box_value_changed(value : float):
	target.data.max_stack_size = value;
	# 设置最大堆叠数

func _on_panel_change_texture(texture_resource : ResourceManager.ResourceData) :
	target.data.texture_path = texture_resource.path;
	# 指定纹理 纹理发生改变
func _on_reset_item_texture_button_pressed():
	target.data.texture_path = "";
	%ItemTextureContainer.texture = null;
	# 重置纹理

func _on_foil_check_box_toggled(toggled_on : bool) :
	target.data.foil = toggled_on;
 	# 附魔效果

func _on_is_food_check_box_toggled(toggled_on : bool) :
	is_food = toggled_on;
	# 作为食物的按钮
func _on_can_aways_eat_check_box_toggled(toggled_on : bool) :
	target.data.can_always_eat = toggled_on;

func _on_category_option_button_item_selected(index : int) : 
	target.data.category = index;
