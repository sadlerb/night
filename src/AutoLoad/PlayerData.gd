extends Node

signal score_updated
signal level_score_updated
signal restart_level
signal used_dash
signal used_reflect

var level_restarts: = 0 setget set_level_restarts
var score: = 0 setget set_score
var restarts: = 0 setget set_restarts
var level_score = 0 setget set_level_score
var dash_uses = 0 setget set_dash
var reflect_uses = 0 setget set_reflect

func set_score(value:int) -> void:
	score += value
	emit_signal("score_updated")
	
func set_restarts(value:int) -> void:
	restarts += value
	emit_signal("restart_level")

func set_level_score (value:int):
	level_score += value
	emit_signal("level_score_updated")
	
func restart_level():
	level_score = 0
	emit_signal("level_score_updated")
	
func reset_game():
	score = 0
	restarts = 0 
	emit_signal("score_updated")
	
func set_dash(value:int):
	dash_uses = value

func set_reflect(value:int):
	reflect_uses = value
	

func use_dash():
	dash_uses -=1
	emit_signal("used_dash")
func use_reflect():
	reflect_uses -=1
	emit_signal("used_reflect")

func set_level_restarts(value:int):
	level_restarts += value
	
func get_level_restarts():
	return level_restarts
func new_level():
	level_restarts = 0
	level_score = 0
