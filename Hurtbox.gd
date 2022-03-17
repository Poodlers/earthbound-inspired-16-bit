extends Area2D

const HitEffect = preload("res://HitEffect.tscn")
export(bool) var show_hit = true

func _on_Hurtbox_area_entered(area):
	var effect = HitEffect.instance()
	var main = get_tree().current_scene
	main.add_child(effect)
	effect.global_position = global_position
