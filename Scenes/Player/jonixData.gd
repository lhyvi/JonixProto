extends Resource

## Allows me to copy player character data easily
class_name JonixAfterimage

@export var position: Vector2
@export var global_position: Vector2
@export var flip: bool
@export var texture: Texture

func copy(jonix: Jonix):
	self.position = jonix.position
	self.global_position = jonix.global_position
	self.flip = jonix.flip
	self.texture = jonix.get_frame_texture()

func paste(obj: Object):
	#if "position" in obj:
	#	obj.position = self.position
	if "global_position" in obj:
		obj.global_position = self.global_position
	if "flip_h" in obj:
		obj.flip_h = self.flip
	if "texture" in obj:
		obj.texture = self.texture


func _init(jonix: Jonix):
	copy(jonix)
