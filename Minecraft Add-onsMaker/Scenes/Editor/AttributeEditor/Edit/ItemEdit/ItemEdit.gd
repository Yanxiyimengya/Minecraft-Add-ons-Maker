extends AttributeEdit;
@onready var add_component_window = %AddComponentWindow;

const MAX_STACK_SIZE_EDIT : PackedScene = preload("res://Scenes/Editor/AttributeEditor/Edit/ItemEdit/ComponentEdit/Edits/MaxStackSizeEdit.tscn");
const TEXTURE_EDIT = preload("res://Scenes/Editor/AttributeEditor/Edit/ItemEdit/ComponentEdit/Edits/TextureEdit.tscn");
const FOOD_EDIT = preload("res://Scenes/Editor/AttributeEditor/Edit/ItemEdit/ComponentEdit/Edits/FoodEdit.tscn");
const GLIGHT_EDIT = preload("res://Scenes/Editor/AttributeEditor/Edit/ItemEdit/ComponentEdit/Edits/GlightEdit.tscn");
const DURABILITY_EDIT = preload("res://Scenes/Editor/AttributeEditor/Edit/ItemEdit/ComponentEdit/Edits/DurabilityEdit.tscn");

func _set_target() : 
	var comp_edits : Array[Node] = %ComponentsEditContainer.get_children();
	for comp_edit in comp_edits : 
		comp_edit.queue_free();
	
	var data : MinecraftItemAsset = target.data;
	%NameSpaceButton.get_popup().clear();
	
	var namespace_popup : PopupMenu = %NameSpaceButton.get_popup();
	namespace_popup.add_item("default");
	%NameSpaceButton.selected = 0;
	for ns in ProjectManager.current_project_config.namespaces : 
		namespace_popup.add_item(ns);
	# 注册命名空间项
	%ItemIDEdit.text = data.id;
	%AddComponentWindow.target = data;
	%AddComponentWindow.update();
	
	for comp : String in data.components : 
		add_component(comp);
	


func _on_add_component_window_selected_component(component_id : String):
	add_component(component_id);
	%AddComponentWindow.hide();

func add_component(component_id : String) : 
	var edit : BaseAssetComponentEdit;
	var edit_title : String = "";
	match (component_id) : 
		"max_stack_size" : 
			edit = MAX_STACK_SIZE_EDIT.instantiate();
			edit_title = "堆叠";
		"icon" : 
			edit = TEXTURE_EDIT.instantiate();
			edit_title = "纹理";
		"food" : 
			edit = FOOD_EDIT.instantiate();
			edit_title = "食物";
		"glint" : 
			edit = GLIGHT_EDIT.instantiate();
			edit_title = "光效";
		"durability" : 
			edit = DURABILITY_EDIT.instantiate();
			edit_title = "耐久度";
		
	if (edit != null) : 
		if (!target.data.components.has(component_id)) : 
			target.data.add_component(component_id);
		edit.target = target;
		
		var edit_container : Container = preload("res://Scenes/Editor/AttributeEditor/Edit/ItemEdit/ComponentEdit/ComponentContainer.tscn").instantiate();
		edit_container.title = edit_title;
		edit_container.remove_component.connect(func() : 
			target.data.components.erase(component_id);
			%AddComponentWindow.update();
		);
		edit_container.add_component_edit(edit);
		%ComponentsEditContainer.add_child(edit_container);
		%AddComponentWindow.update();

func _on_add_component_button_pressed():
	%AddComponentWindow.show();

func _on_name_space_button_item_selected(index : String):
	var item_text : String = %NameSpaceButton.get_item_text(index);
	target.data.id_namespace = item_text;
func _on_item_id_edit_text_changed(new_text : String):
	target.data.id = new_text;
