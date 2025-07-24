extends Node2D

signal playerGoal

func _on_area_2d_body_entered(body: CharacterBody2D) -> void:
	if body.get("TYPE") == "player":
		emit_signal("playerGoal")
