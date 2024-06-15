extends AttributeEdit;

func _set_target() : 
	var data : MinecraftItemAsset = target.data;
	%NameSpaceButton.get_popup().clear();
	
	var namespace_popup : PopupMenu = %NameSpaceButton.get_popup();
	namespace_popup.add_item("default");
	%NameSpaceButton.selected = 0;
	for ns in ProjectManager.current_project_config.namespaces : 
		namespace_popup.add_item(ns);
	# 注册命名空间项
	%ItemIDEdit.text = data.id;
	


func _on_add_component_button_pressed():
	%AddComponentWindow.show();
