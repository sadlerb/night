extends Control


func _ready():
	$score.text = "Scrolls Collected: %s" % PlayerData.score
	$restarts2.text = "Restarts: %s" % PlayerData.restarts
