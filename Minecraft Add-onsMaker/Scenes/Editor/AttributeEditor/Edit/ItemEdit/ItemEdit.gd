extends AttributeEdit;

var stacked_by_data : bool = false : 
	set(value) : 
		%StackedByDataCheckBox.button_pressed = value;
		%MaxStackSizeContainer.visible = value;
		target.data.stacked_by_data = value;

func _set_target() : 
	%MaxStackSizeContainer.visible = false;
	var data : MinecraftItemAsset = target.data;
	
	stacked_by_data = data.stacked_by_data;
	%MaxStackSizeSpinBox.value = data.max_stack_size;


func _on_stacked_by_data_check_box_pressed() : 
	stacked_by_data = %StackedByDataCheckBox.button_pressed;

func _on_max_stack_size_spin_box_value_changed(value : float):
	target.data.max_stack_size = value;


