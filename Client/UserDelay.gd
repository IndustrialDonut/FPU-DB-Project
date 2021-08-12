extends Timer


var rng = RandomNumberGenerator.new()

func _ready() -> void:
	rng.randomize()

func start(do_not_use : float = 1.0) -> void:
	.start(rng.randfn(0.2,0.5))
