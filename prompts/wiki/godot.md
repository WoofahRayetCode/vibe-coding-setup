# ⚡ Bleeding-Edge Godot Engine Master-Branch Reference Wiki

This document serves as an authoritative, high-density reference library strictly aligned with the **latest bleeding-edge Godot Engine (docs.godotengine.org/en/master/)** development specifications. All paradigms, APIs, and design guidelines are optimized for modern, forward-compatible, and future-proof Godot 4.x+ gameplay programming.

---

## 1. CharacterBody2D / 3D Movement Engine
CharacterBody2D handles physics-based movements. It uses static typing and dedicated functions.

### 📋 Standard 2D Side-Scroller Movement Blueprint:
```gdscript
extends CharacterBody2D

@export var move_speed: float = 200.0
@export var jump_velocity: float = -400.0
@export var acceleration: float = 1200.0
@export var friction: float = 1000.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity")

func _physics_process(delta: float) -> void:
    # Apply Gravity
    if not is_on_floor():
        velocity.y += gravity * delta

    # Handle Jump
    if Input.is_action_just_pressed("ui_accept") and is_on_floor():
        velocity.y = jump_velocity

    # Get input direction (-1, 0, 1)
    var direction := Input.get_axis("ui_left", "ui_right")
    
    # Handle Horizontal Movement & Friction
    if direction != 0:
        velocity.x = move_toward(velocity.x, direction * move_speed, acceleration * delta)
    else:
        velocity.x = move_toward(velocity.x, 0.0, friction * delta)

    # Move the character using internal velocity Vector2
    move_and_slide()
```

---

## 2. Signal Connection System (Modern Godot 4 Callable Syntax)
Always use modern, type-safe Callables for signal binding instead of strings.

### 📋 Code-based Signal Connection:
```gdscript
# Standard connection
button.pressed.connect(_on_button_pressed)

# Connecting with bound arguments
timer.timeout.connect(_on_timer_timeout.bind(spawn_node))

func _on_button_pressed() -> void:
    print("Button pressed!")

func _on_timer_timeout(node_to_spawn: Node) -> void:
    add_child(node_to_spawn)
```

---

## 3. Data Management with Resources
Custom `Resource` scripts are perfect for managing stats, inventory, and configuration data cleanly.

### 📋 Defining a Custom Resource:
```gdscript
# item_data.gd
class_name ItemData
extends Resource

@export var item_name: String = ""
@export var icon: Texture2D
@export var damage: int = 0
```
### 📋 Referencing a Resource:
```gdscript
@export var current_item: ItemData

func _ready() -> void:
    if current_item:
        print("Equipped: ", current_item.item_name)
```

---

## 4. Performance & Memory Optimizations
* **Instantiation**: Use `.instantiate()` to load scenes dynamically.
  ```gdscript
  var scene := preload("res://enemy.tscn")
  var enemy := scene.instantiate()
  add_child(enemy)
  ```
* **Cleanup**: Always free unused objects via `queue_free()` to prevent leaks.
* **Nodes referencing**: Use `%NodeName` (Scene Unique Nodes) to target UI or major controllers safely without using absolute path strings.
