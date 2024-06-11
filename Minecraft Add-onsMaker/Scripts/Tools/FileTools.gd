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

static func copy_dir(from : String, to : String) : 
	if (from == to) : 
		return;
	if (DirAccess.dir_exists_absolute(from)) : 
		var dir : DirAccess = DirAccess.open(from);
		DirAccess.make_dir_recursive_absolute(to);
		if (dir != null) : 
			dir.list_dir_begin();
			var file_name : String = dir.get_next();
			while(file_name != "") :
				if (dir.current_is_dir()) :
					copy_dir(from + "/" + file_name, to + "/" + file_name);
				else : 
					DirAccess.copy_absolute(from + "/" + file_name, to + "/" + file_name);
				file_name = dir.get_next();
			dir.list_dir_end();
	else : 
		DirAccess.copy_absolute(from, to);

static func remove_dir(dir_path : String) : 
	if (FileAccess.file_exists(dir_path)) : 
		DirAccess.remove_absolute(dir_path);
		return;
	var dir : DirAccess = DirAccess.open(dir_path);
	if (dir == null) :
		return;
	dir.list_dir_begin();
	var file_name : String = dir.get_next();
	while(file_name != "") :
		remove_dir(dir_path + "/" + file_name);
		file_name = dir.get_next();
	dir.list_dir_end();
	DirAccess.remove_absolute(dir_path);
