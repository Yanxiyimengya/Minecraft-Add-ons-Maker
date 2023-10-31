extends Node2D;

@export var attribute:BlockAttribute = BlockAttribute.new();
@onready var sprite:Sprite2D = $BlockSprite;

var frame:int = 0; # 当前帧
var frame_index:int = 0: # 当前播放的帧的序号
	set(_val):
		frame_index = _val;
var animation_timer:int = 0; # 动画播放计时器
var animation_loop:float = 0; # 帧补间过渡值

var shader_uniforms;
var shader:Shader:
	set(_val):
		sprite.material.shader = _val;
		shader_uniforms = sprite.material.shader.get_shader_uniform_list();
	get:
		return sprite.material.shader;
func _ready():
	shader = sprite.material.shader;
	frame = attribute.sprite_texturts.animation.frame_first;
	sprite.texture = attribute.sprite_texturts.get_frame_texture(frame);
	

func _process(delta):
	sprite.texture = attribute.sprite_texturts.get_frame_texture(frame);
	
	
	if (attribute.sprite_texturts.animation.interpolate) :
		shader_uniforms["lerp"] = 0.5;
		shader_uniforms["next_texture"] = attribute.sprite_texturts.get_frame_texture(frame+1);
	
	if (attribute.sprite_texturts.animation.texture_count > 1) :
		if (animation_timer >= attribute.sprite_texturts.animation.frames_speed):
			frame_index += 1;
			if (!attribute.sprite_texturts.animation.frames_sort.is_empty()) :
				if (frame_index >= attribute.sprite_texturts.animation.frames_sort.size()) :
					frame_index = 0;
				frame = attribute.sprite_texturts.animation.frames_sort[frame_index];
			else:
				if (frame_index >= attribute.sprite_texturts.animation.texture_count) :
					frame_index = 0;
				frame = frame_index;
			animation_timer = 0;
		else :
			animation_timer += 1;

func put() :
	pass; # [提供重写]放置方法

func destroy() :
	pass; # [提供重写]销毁方法

func emit_particles() :
	pass; # [提供重写]播放粒子的方法函数
