extends Sprite

onready var tween = get_node("Tween")


func _ready():
	tween. interpolate_property(self,'modulate:a',1.0,0.0,1,3,1)
	tween.start()


# warning-ignore:unused_argument
# warning-ignore:unused_argument
func _on_Tween_tween_completed(object, key):
	queue_free()
