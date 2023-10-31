extends Node2D;

@export var attribute:BlockAttribute = null;

func put() :
	pass; # [提供重写]放置方法

func destroy() :
	pass; # [提供重写]销毁方法

func emit_particles() :
	pass; # [提供重写]播放粒子的方法函数
