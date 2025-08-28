extends Node

func texture2d_get_region(texture : Texture2D, region : Rect2i) -> Image:
	return texture.get_image().get_region(region)
