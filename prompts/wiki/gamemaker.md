# ⚡ Bleeding-Edge GameMaker GML Master-Branch Reference Wiki

This document serves as an authoritative, high-density reference library strictly aligned with the **latest bleeding-edge GameMaker GML (manual.yoyogames.com & beta-manual.yoyogames.com)** development specifications. All paradigms, APIs, and design guidelines are optimized for modern, forward-compatible, and future-proof GML scripting.

---

## 1. Structs, Constructors, and Methods (Modern GML)
Modern GML supports lightweight object-oriented design using structs and constructor functions.

### 📋 Creating a Constructor Struct:
```gml
function Item(_name, _damage) constructor {
    name = _name;
    damage = _damage;
    
    // Method variable
    static use = function() {
        show_debug_message("Used " + name + " dealing " + string(damage) + " damage!");
    }
}

// Instantiation
my_sword = new Item("Iron Sword", 15);
my_sword.use();
```

---

## 2. Robust Event-Driven State Machines
Implement clean, expandable finite state machines using method variables or enums inside objects.

### 📋 State Machine Struct Blueprint (Character Step Event):
```gml
// Create Event
state = "idle";

states = {
    idle: function() {
        sprite_index = spr_player_idle;
        hsp = 0;
        if (keyboard_check(vk_right) || keyboard_check(vk_left)) {
            state = "run";
        }
    },
    run: function() {
        sprite_index = spr_player_run;
        var _dir = keyboard_check(vk_right) - keyboard_check(vk_left);
        hsp = _dir * move_speed;
        
        if (hsp == 0) {
            state = "idle";
        }
    }
};

// Step Event
var _func = states[$ state];
if (_func != undefined) {
    _func();
}

// Apply Movement
x += hsp;
```

---

## 3. Collision Engine (Pixel-Perfect Side-Scroller)
Standard custom platformer horizontal and vertical checking loop.

### 📋 Custom Collision Code:
```gml
// Horizontal Collision Check
if (place_meeting(x + hsp, y, obj_solid)) {
    while (!place_meeting(x + sign(hsp), y, obj_solid)) {
        x += sign(hsp);
    }
    hsp = 0;
}
x += hsp;

// Vertical Collision Check
if (place_meeting(x, y + vsp, obj_solid)) {
    while (!place_meeting(x, y + sign(vsp), obj_solid)) {
        y += sign(vsp);
    }
    vsp = 0;
}
y += vsp;
```

---

## 4. Resource & Memory Cleanliness
To avoid severe platform crashes and memory leaks, dynamic resources MUST be explicitly destroyed when they are no longer needed.

### 📋 Resource Release Checklist:
* **Data Structures**: `ds_list_destroy(list)`, `ds_grid_destroy(grid)`
* **Surfaces**: Check `surface_exists(surf)` before drawing, and clean up using `surface_free(surf)` on Destroy or Room End events.
* **Particles**: Delete dynamic particle systems via `part_system_destroy(sys)` when the spawning object is removed.
