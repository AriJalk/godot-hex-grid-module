#class_name ImageCapture
extends Node

# Taken from here https://forum.godotengine.org/t/exporting-contents-of-viewport-as-a-png-results-in-a-black-image/2473

func _ready():
	pass
	
func _process(delta: float) -> void:
	if Input.is_key_pressed(KEY_C):
		takePhoto()

func takePhoto():
	var vpt = get_viewport()
	var txt = vpt.get_texture()
	var image = txt.get_image()
	image.save_png("break.png")
