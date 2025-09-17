extends Node


func texture2d_get_region(texture : Texture2D, region : Rect2i) -> Image:
	return texture.get_image().get_region(region)


func normalize_to_scale(value : float, range_min : float, range_max : float, scale : float = 1.0) -> float:
	if value == range_max:
		return 1.0
	elif value == range_min:
		return 0
	return (value - range_min) / (range_max - range_min) * scale
