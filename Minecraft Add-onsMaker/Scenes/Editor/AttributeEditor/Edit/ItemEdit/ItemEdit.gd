extends AttributeEdit;

var stacked_by_data : bool = false : 
	set(value) : 
		%StackedByDataCheckBox.button_pressed = value;
		%MaxStackSizeContainer.visible = value;
		target.data.stacked_by_data = value;

func _set_target() : 
	%MaxStackSizeContainer.visible = false;
	%ItemTextureContainer.texture = null;
	
	var data : MinecraftItemAsset = target.data;
	
	stacked_by_data = data.stacked_by_data;
	%MaxStackSizeSpinBox.value = data.max_stack_size;
	
	if (data.texture != null) : 
		%ItemTextureContainer.texture = data.texture.texture;


func _on_stacked_by_data_check_box_pressed() : 
	stacked_by_data = %StackedByDataCheckBox.button_pressed;

func _on_max_stack_size_spin_box_value_changed(value : float):
	target.data.max_stack_size = value;

func _on_panel_change_texture(texture_resource : ResourceManager.ResourceData) :
	target.data.texture = texture_resource.data;
	target.data.texture_path = texture_resource.path;
	print(target.data.texture);
