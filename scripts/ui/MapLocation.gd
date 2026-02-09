extends TextureButton
class_name MapLocation

var location_data: LocationData = null
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var map_label: Label = $MapLabel

signal map_location_button_up(map_location: MapLocation)

func _ready():
	button_up.connect(_on_button_up)

func init(_location_data: LocationData):
	location_data = _location_data
	position = location_data.location_position
	
	# display the type of location
	if location_data.location_obfuscated and not location_data.location_visited:
		map_label.text = "???" # unvisited obfuscated locations are marked hidden
	else:
		map_label.text = LocationData.LOCATION_TYPES.keys()[location_data.location_type]
		
		# Set icon based on type (Road to Menkyo)
		# print("Location Type: ", location_data.location_type, " Key: ", LocationData.LOCATION_TYPES.keys()[location_data.location_type])
		var new_tex = null
		match location_data.location_type:
			LocationData.LOCATION_TYPES.COMBAT:
				new_tex = load("res://assets/icons/map/icon_traffic_light.png")
			LocationData.LOCATION_TYPES.MINIBOSS:
				new_tex = load("res://assets/icons/map/icon_police.png")
			LocationData.LOCATION_TYPES.REST_SITE:
				new_tex = load("res://assets/icons/map/icon_parking.png")
			LocationData.LOCATION_TYPES.BOSS:
				new_tex = load("res://assets/icons/map/icon_exam_center.png")
			LocationData.LOCATION_TYPES.SHOP:
				new_tex = load("res://assets/icons/map/icon_shop_konbini.png")
			LocationData.LOCATION_TYPES.EVENT:
				new_tex = load("res://assets/icons/map/icon_event_book.png")
			_:
				pass
		
		if new_tex:
			texture_normal = new_tex
			# print("Loaded texture for type ", location_data.location_type)
		else:
			print("Failed to load texture for type ", location_data.location_type)

func flash_location() -> void:
	animation_player.play("flash_map_location")

func _on_button_up():
	location_data.location_visited = true
	map_location_button_up.emit(self)
