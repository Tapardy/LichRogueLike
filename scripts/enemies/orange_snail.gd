extends Node2D

var player_exited: bool = false
var attacked: bool = false
var is_player_actually_gone: bool = false
@export var poison_damage: float = 20
@export var active: bool = true
enum LoopMode {
	LOOP_NONE,
	LOOP_LINEAR,
	LOOP_PINGPONG
}
func _ready() -> void:
	$GPUParticles2D.emitting = false
	
func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player") and active:
		player_exited = false
		# Start looping animation
		$AnimationPlayer.play("Spew")
		$Sprite2D/PoisonArea/CollisionShape2D.call_deferred("set_disabled", false)
		$AnimationPlayer.get_animation("Spew").loop_mode = LoopMode.LOOP_LINEAR


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		player_exited = true
		$GPUParticles2D.emitting = false
		# Stop looping animation
		$AnimationPlayer.get_animation("Spew").loop_mode = LoopMode.LOOP_NONE

func _on_poison_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("player") and attacked == false:
		attacked = true
		var attack := Attack.new()
		attack.attack_damage = poison_damage
		body.get_node("HealthComponent").damage(attack)
		$PoisonDelay.start()


func _on_poison_delay_timeout() -> void:
	attacked = false

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "Spew":
		if player_exited:
			print(player_exited)
			print("hi")
			$Sprite2D/PoisonArea/CollisionShape2D.disabled = true
			$AnimationPlayer.play("RESET")
