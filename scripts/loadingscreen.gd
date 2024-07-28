extends CanvasLayer

@onready var defeated_knightt: Sprite2D = $DefeatedKnightt
@onready var earth_snail_1: Sprite2D = $EarthSnail1
@onready var gorthulon_spellmaw: Sprite2D = $GorthulonSpellmaw
@onready var seeking_motherr: Sprite2D = $SeekingMotherr
@onready var snail_ca: Sprite2D = $SnailCa
@onready var soull_cagee: Sprite2D = $SoullCagee
@onready var progress_bar: ProgressBar = $ProgressBar

var sprites: Array[Sprite2D] = []
var time_elapsed: float = 0.0
var total_time: float = 4.0
var progress_stages: Array[float] = [0.0, 0.1, 0.25, 0.45, 0.7, 1.0]
var stage_durations: Array[float] = [0.5, 0.5, 1.0, 1.0, 1.0]
var has_printed: bool = false

func _ready() -> void:
	# Add all sprites to the list
	sprites = [defeated_knightt, earth_snail_1, gorthulon_spellmaw, seeking_motherr, snail_ca, soull_cagee]
	
	# Hide all sprites initially
	for sprite in sprites:
		sprite.visible = false
	
	# Select a random sprite to make visible
	var random_index: int = randi() % sprites.size()
	sprites[random_index].visible = true
	
	# Initialize the progress bar
	progress_bar.value = 0
	progress_bar.max_value = 100

func _process(delta: float) -> void:
	time_elapsed += delta

	# Calculate total elapsed time relative to total time
	var total_progress: float = time_elapsed / total_time
	
	# Ensure the progress bar value increases monotonically
	if total_progress < 1.0:
		var stage_index: int = 0
		var stage_elapsed: float = 0.0

		for i in range(progress_stages.size() - 1):
			stage_elapsed += stage_durations[i]
			if total_progress < stage_elapsed / total_time:
				stage_index = i
				break

		var stage_start: float = sum(stage_durations.slice(0, stage_index))
		var stage_end: float = stage_start + stage_durations[stage_index]
		
		var stage_progress: float = (total_progress * total_time - stage_start) / (stage_end - stage_start)
		
		var ease_progress: float = ease_in_out(stage_progress)
		
		progress_bar.value = lerp(progress_stages[stage_index], progress_stages[stage_index + 1], ease_progress) * 100
	else:
		progress_bar.value = 100
		
		if not has_printed:
			get_tree().change_scene_to_packed(load("res://scenes/world.tscn"))
			has_printed = true

func ease_in_out(t: float) -> float:
	return t * t * (3.0 - 2.0 * t)

func sum(array: Array[float]) -> float:
	var result: float = 0.0
	for value in array:
		result += value
	return result
