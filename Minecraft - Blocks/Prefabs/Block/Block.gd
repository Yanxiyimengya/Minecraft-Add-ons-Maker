extends Node2D;

@export var attribute:BlockAttribute = BlockAttribute.new();
@onready var sprite:Sprite2D = $BlockSprite;

var next_frame:int = 0;
var frame_index:int = 0: # 当前播放的帧的序号
	set(_val):
		frame_index = _val;
		next_frame = _val + 1;
		if (!attribute.sprite_texturts.animation.frames_sort.is_empty()) :
			if (next_frame >= attribute.sprite_texturts.animation.frames_sort.size()) :
				next_frame = 0;
				frame_index = 0;
			next_frame = attribute.sprite_texturts.animation.frames_sort[frame_index];
		else:
			if (next_frame >= attribute.sprite_texturts.animation.texture_count) :
				next_frame = 0;
				frame_index = 0;
		sprite.texture = attribute.sprite_texturts.get_frame_texture(frame_index);
		sprite.material.set_shader_parameter("next_texture", attribute.sprite_texturts.get_frame_texture(next_frame));
		print(frame_index, " ", next_frame)
var animation_timer:int = 0; # 动画播放计时器
var animation_lerp:float = 0; # 帧补间过渡值

func _ready():
	sprite.texture = attribute.sprite_texturts.get_frame_texture(attribute.sprite_texturts.animation.frame_first);
	

func _process(delta):
	if (!attribute.sprite_texturts.animation.interpolate) :
		animation_lerp = get_viewport().get_mouse_position().x/get_viewport().size.x;
		sprite.material.set_shader_parameter("lerp", animation_lerp);
	
	if (attribute.sprite_texturts.animation.texture_count > 1) :
		if (animation_timer >= attribute.sprite_texturts.animation.frames_speed):
			frame_index += 1;
			animation_timer = 0;
		else :
			animation_timer += 1;
	
func put() :
	pass; # [提供重写]放置方法

func destroy() :
	pass; # [提供重写]销毁方法

func emit_particles() :
	pass; # [提供重写]播放粒子的方法函数
