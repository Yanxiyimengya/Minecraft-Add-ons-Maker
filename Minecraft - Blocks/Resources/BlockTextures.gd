extends Resource;
class_name BlockTextures;

func _init(tex = null):
	if (textures == null) :
		textures = SpriteFrames.new();
	if (!textures.has_animation("default")):
		textures.add_animation("default");
	if (textures.get_frame_count("default") == 0) :
		textures.add_frame("default", load("res://Sprites/Blocks/lose.png"));
	match (tex) :
		SpriteFrames:
			var frame_count:int = tex.get_frame_count("default");
			if (frame_count > 0):
				for count in frame_count:
					textures.set_frame("default", count, tex.get_frame_texture("Default", count), tex.get_frame_duration("Default", count));
	animation.texture_count = textures.get_frame_count("default");
	pass; # 构造函数

@export var textures:SpriteFrames = null:
	set(_val):
		textures = _val;
		animation.texture_count = textures.get_frame_count("default");
var display_texture = null: # 用于显示的纹理
	set(_val):
		emit_changed();
		textures.set_frame("default", 0, _val, textures.get_frame_duration("Default", 0));
	get:
		return textures.get_frame_texture("default", 0);
@export var animation = {
	texture_count = 0,    # 帧纹理数量
	interpolate = false, # 若为 true 将会在帧与帧之间生成一张间隔时间大于1的帧
	frame_first = 0,     # 指定开始播放的帧的位置
	frames_speed = 5,    # 动画帧播放速率
	frames_sort = []     # 一个帧列表 帧的显示顺序默认为从上至下
}; # 动画的配置属性

func set_animation_interpolate(enable:bool):
	animation.interpolate = enable;
	# 设置是否启用插值
func get_animation_interpolate():
	return animation.interpolate;
	# 获取是否启用插值
func set_animation_frames_sort(arr:Array[int]):
	animation.frames_sort = arr;
	# 获取帧排序列表
func get_animation_frames_sort():
	return animation.frames_sort;
	# 获取帧排序列表
func set_animation_first(ind:int):
	animation.frame_first = ind;
	# 设置起始播放的帧
func get_animation_first():
	return animation.frame_first;
	# 获取起始播放的帧
func set_animation_frames_speed(spd:int):
	animation.frames_speed = spd;
	# 设置动画播放帧速率
func get_animation_frames_speed():
	return animation.frames_speed;
	# 获取动画播放帧速率
	

func get_frame_texture(index:int):
	if (index >= textures.get_frame_count("default")) :
		return load("res://Sprites/Blocks/lose.png");
	return textures.get_frame_texture("default", index);
	# 获取某一帧的纹理
func get_frame_duration(index:int):
	return textures.get_frame_duration("default", index);
	# 获取某一帧播放的持续时间
func set_frame(index:int, texture:Texture2D, duration:float):
	textures.set_frame("default", index, texture, duration);
func add_frame(tex:Texture2D, duration:float):
	textures.add_frame("default", tex, duration);
	# 添加一帧纹理
func remove_frame(index:int):
	if (index == 0):
		push_error("销毁帧时出错,你不能销毁最后一帧的精灵纹理");
		return;
	textures.remove_frame("default", index);
	pass;

