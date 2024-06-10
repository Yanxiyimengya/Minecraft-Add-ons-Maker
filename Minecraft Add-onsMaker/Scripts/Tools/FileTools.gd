extends Object;
class_name FileTools;

static func save_file(path : String, str : String) -> void : 
	var file : FileAccess = FileAccess.open(path, FileAccess.WRITE);
	if (file == null) : 
		return;
	file.store_buffer(str.to_utf8_buffer());
	file.close();
static func save_buffer(path : String, buffer : PackedByteArray) -> void : 
	var file : FileAccess = FileAccess.open(path, FileAccess.WRITE);
	if (file == null) : 
		return;
	file.store_buffer(buffer);
	file.close();

static func load_file(path : String) -> String : 
	var file : FileAccess = FileAccess.open(path, FileAccess.READ);
	if (file == null) : 
		return "";
	var result : String = file.get_buffer(file.get_length()).get_string_from_utf8();
	file.close();
	return result;
static func load_buffer(path : String) -> PackedByteArray : 
	var file : FileAccess = FileAccess.open(path, FileAccess.READ);
	if (file == null) : 
		return [];
	var result : PackedByteArray = file.get_buffer(file.get_length());
	file.close();
	return result;
