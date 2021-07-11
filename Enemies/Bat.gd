extends KinematicBody2D

var knockBack = Vector2.ZERO

onready var stats = $Stats

func _ready():
	print(stats.max_health)

func _physics_process(delta):
	knockBack = knockBack.move_toward(Vector2.ZERO, 200 * delta)
	knockBack = move_and_slide(knockBack)


func _on_Hurtbox_area_entered(area):
	stats.health -=1
	knockBack =  area.knockback_vector * 300


func _on_Stats_no_health():
	queue_free()
