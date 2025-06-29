extends Node

## UIManager - Handles UI transitions and overlays
##
## This autoload singleton manages UI state, transitions,
## and common UI elements across the application.

signal ui_transition_started(from_scene: String, to_scene: String)
signal ui_transition_completed(scene: String)

var loading_screen: Control
var notification_popup: Control
var current_scene_name: String

func _ready() -> void:
	# Connect to scene changes
	get_tree().tree_changed.connect(_on_scene_changed)

## Show a loading screen with optional message
func show_loading_screen(message: String = "Loading...") -> void:
	if loading_screen:
		return
	
	loading_screen = create_loading_screen(message)
	get_tree().current_scene.add_child(loading_screen)

## Hide the loading screen
func hide_loading_screen() -> void:
	if loading_screen:
		loading_screen.queue_free()
		loading_screen = null

## Create a simple loading screen
func create_loading_screen(message: String) -> Control:
	var screen = Control.new()
	screen.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	
	# Create a background panel
	var background = ColorRect.new()
	background.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	background.color = Color.BLACK
	background.modulate.a = 0.8
	screen.add_child(background)
	
	var label = Label.new()
	label.text = message
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	label.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	
	screen.add_child(label)
	return screen

## Show a notification popup
func show_notification(message: String, duration: float = 3.0) -> void:
	if notification_popup:
		notification_popup.queue_free()
	
	notification_popup = create_notification_popup(message)
	get_tree().current_scene.add_child(notification_popup)
	
	# Auto-hide after duration
	await get_tree().create_timer(duration).timeout
	hide_notification()

## Hide the notification popup
func hide_notification() -> void:
	if notification_popup:
		notification_popup.queue_free()
		notification_popup = null

## Create a notification popup
func create_notification_popup(message: String) -> Control:
	var popup = Control.new()
	popup.set_anchors_and_offsets_preset(Control.PRESET_TOP_WIDE)
	popup.position.y = 50
	popup.size.y = 60
	
	var panel = Panel.new()
	panel.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	
	var style = StyleBoxFlat.new()
	style.bg_color = Color(0.2, 0.2, 0.2, 0.9)
	style.corner_radius_top_left = 10
	style.corner_radius_top_right = 10
	style.corner_radius_bottom_left = 10
	style.corner_radius_bottom_right = 10
	panel.add_theme_stylebox_override("panel", style)
	
	var label = Label.new()
	label.text = message
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	label.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	
	popup.add_child(panel)
	popup.add_child(label)
	
	return popup

## Smooth transition between scenes
func transition_to_scene(scene_path: String, transition_duration: float = 0.5) -> void:
	var from_scene = current_scene_name
	ui_transition_started.emit(from_scene, scene_path)
	
	show_loading_screen("Loading...")
	
	await get_tree().create_timer(transition_duration).timeout
	
	get_tree().change_scene_to_file(scene_path)
	
	await get_tree().create_timer(0.1).timeout
	
	hide_loading_screen()
	ui_transition_completed.emit(scene_path)

## Create a styled button
func create_styled_button(text: String, size: Vector2 = Vector2(200, 50)) -> Button:
	var button = Button.new()
	button.text = text
	button.size = size
	
	var style_normal = StyleBoxFlat.new()
	style_normal.bg_color = Color(0.3, 0.3, 0.3)
	style_normal.corner_radius_top_left = 8
	style_normal.corner_radius_top_right = 8
	style_normal.corner_radius_bottom_left = 8
	style_normal.corner_radius_bottom_right = 8
	
	var style_hover = StyleBoxFlat.new()
	style_hover.bg_color = Color(0.4, 0.4, 0.4)
	style_hover.corner_radius_top_left = 8
	style_hover.corner_radius_top_right = 8
	style_hover.corner_radius_bottom_left = 8
	style_hover.corner_radius_bottom_right = 8
	
	var style_pressed = StyleBoxFlat.new()
	style_pressed.bg_color = Color(0.2, 0.2, 0.2)
	style_pressed.corner_radius_top_left = 8
	style_pressed.corner_radius_top_right = 8
	style_pressed.corner_radius_bottom_left = 8
	style_pressed.corner_radius_bottom_right = 8
	
	button.add_theme_stylebox_override("normal", style_normal)
	button.add_theme_stylebox_override("hover", style_hover)
	button.add_theme_stylebox_override("pressed", style_pressed)
	
	return button

## Show a confirmation dialog
func show_confirmation_dialog(title: String, message: String, callback: Callable) -> void:
	var dialog = AcceptDialog.new()
	dialog.title = title
	dialog.dialog_text = message
	dialog.add_cancel_button("Cancel")
	
	get_tree().current_scene.add_child(dialog)
	dialog.popup_centered()
	
	var result = await dialog.confirmed
	dialog.queue_free()
	
	if result:
		callback.call()

## Update the current scene name
func _on_scene_changed() -> void:
	var tree = get_tree()
	if not tree:
		return
	
	var current_scene = tree.current_scene
	if current_scene:
		current_scene_name = current_scene.scene_file_path

## Handle input for global UI actions
func _input(event: InputEvent) -> void:
	# Handle escape key for going back
	if event.is_action_pressed("ui_cancel"):
		handle_back_action()

## Handle back/escape action based on current state
func handle_back_action() -> void:
	match GameManager.current_state:
		GameManager.GameState.LOBBY:
			show_confirmation_dialog("Leave Lobby", "Are you sure you want to leave the lobby?", 
				func(): GameManager.return_to_menu())
		GameManager.GameState.IN_GAME:
			show_confirmation_dialog("Quit Game", "Are you sure you want to quit the current game?", 
				func(): GameManager.end_current_game())

## Add smooth button animations with scaling effect
func animate_button_hover(button: Button) -> void:
	if not is_instance_valid(button) or not button.get_parent():
		return
	
	var tween = create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_BACK)
	tween.parallel().tween_property(button, "scale", Vector2(1.05, 1.05), 0.2)
	tween.parallel().tween_property(button, "modulate", Color.WHITE, 0.2)

## Reset button animation
func animate_button_normal(button: Button) -> void:
	if not is_instance_valid(button) or not button.get_parent():
		return
	
	var tween = create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_BACK)
	tween.parallel().tween_property(button, "scale", Vector2(1.0, 1.0), 0.2)
	tween.parallel().tween_property(button, "modulate", Color(0.9, 0.95, 1.0, 1.0), 0.2)

## Add smooth button press animation
func animate_button_pressed(button: Button) -> void:
	if not is_instance_valid(button) or not button.get_parent():
		return
	
	var tween = create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_BACK)
	tween.parallel().tween_property(button, "scale", Vector2(0.95, 0.95), 0.1)
	tween.parallel().tween_property(button, "modulate", Color(0.8, 0.9, 1.0, 1.0), 0.1)

## Animate panel appearance with fade and scale
func animate_panel_show(panel: Control) -> void:
	if not is_instance_valid(panel) or not panel.get_parent():
		return
	
	panel.modulate.a = 0.0
	panel.scale = Vector2(0.8, 0.8)
	panel.visible = true
	
	var tween = create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_BACK)
	tween.parallel().tween_property(panel, "modulate:a", 1.0, 0.3)
	tween.parallel().tween_property(panel, "scale", Vector2(1.0, 1.0), 0.3)

## Animate panel disappearance
func animate_panel_hide(panel: Control) -> void:
	if not is_instance_valid(panel) or not panel.get_parent():
		return
	
	var tween = create_tween()
	tween.set_ease(Tween.EASE_IN)
	tween.set_trans(Tween.TRANS_BACK)
	tween.parallel().tween_property(panel, "modulate:a", 0.0, 0.2)
	tween.parallel().tween_property(panel, "scale", Vector2(0.8, 0.8), 0.2)
	tween.tween_callback(func(): 
		if is_instance_valid(panel):
			panel.visible = false
	)

## Add ripple effect for touch/click
func create_ripple_effect(control: Control, position: Vector2) -> void:
	var ripple = ColorRect.new()
	ripple.color = Color(1, 1, 1, 0.3)
	ripple.size = Vector2.ZERO
	ripple.position = position
	ripple.pivot_offset = Vector2.ZERO
	control.add_child(ripple)
	
	var tween = create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_QUAD)
	tween.parallel().tween_property(ripple, "size", Vector2(100, 100), 0.4)
	tween.parallel().tween_property(ripple, "position", position - Vector2(50, 50), 0.4)
	tween.parallel().tween_property(ripple, "modulate:a", 0.0, 0.4)
	tween.tween_callback(func(): 
		if is_instance_valid(ripple) and ripple.get_parent():
			ripple.queue_free()
	)

## Setup modern button behaviors (hover, press animations)
func setup_modern_button(button: Button) -> void:
	if not button:
		return
	
	# Connect hover animations with safe references
	button.mouse_entered.connect(func(): 
		if is_instance_valid(button):
			animate_button_hover(button)
	)
	button.mouse_exited.connect(func(): 
		if is_instance_valid(button):
			animate_button_normal(button)
	)
	button.button_down.connect(func(): 
		if is_instance_valid(button):
			animate_button_pressed(button)
	)
	button.button_up.connect(func(): 
		if is_instance_valid(button):
			animate_button_normal(button)
	)
	
	# Add touch feedback for mobile
	button.gui_input.connect(func(event):
		if is_instance_valid(button) and event is InputEventScreenTouch and event.pressed:
			create_ripple_effect(button, event.position)
	)

## Setup all buttons in a container with modern animations
func setup_modern_buttons_in_container(container: Node) -> void:
	for child in container.get_children():
		if child is Button:
			setup_modern_button(child)
		elif child.get_child_count() > 0:
			setup_modern_buttons_in_container(child)
