
# building **"Road to Menkyo"** using the **Slay-The-Robot (Godot 4)** framework.

This guide focuses on **hybrid architecture**: building a high-polish visual shell that can act as a "Game" (Roguelike) or a "Tool" (Quiz App) by flipping a single switch.
## Slay-The-Robot
focus on the **Map and Card Visuals**. Those are the hardest parts to build from scratch. Treat the "Battle" as just a **Container for Questions**.
- **In Game Mode:** The Container fights back (Timer/HP).
- **In App Mode:** The Container is passive (Just a list of questions).
---

### Phase 1: The Architecture ( The "Container" Philosophy)

To make this future-proof, we must decouple the **Card (Data)** from the **Battle (Resolution)**.

#### 1. The Global Switch
Create a Singleton (Autoload) script called `GameManager.gd`. This tracks which "mode" the player is in.

```gdscript
# GameManager.gd
extends Node

enum Mode {
    GAME,   # HP, Timer, Enemy Attacks, Stress
    STUDY   # Infinite HP, No Timer, Passive Enemy
}

var current_mode: Mode = Mode.GAME
```

#### 2. The Data Structure (Card Resource)
In *Slay-The-Robot*, cards are `Resources`. You need to extend the default script to hold Quiz Data.
*   **Locate:** `CardData.gd` (or similar resource script in the framework).
*   **Modify:** Add variables for the exam questions.

```gdscript
# CardData.gd (extends Resource)
class_name CardData

# Existing variables (Damage, Block, Cost)...
@export var damage: int = 10
@export var energy_cost: int = 1

# NEW: Quiz Variables
@export_group("Menkyo Quiz Data")
@export var question_text: String = "Stop line is ahead. Light is yellow. Action?"
@export var question_image: Texture2D # For "Kiken Yosoku" photos
@export var answers: Array[String] = ["Stop", "Go", "Slow Down"]
@export var correct_answer_index: int = 0
@export var explanation: String = "You must stop unless it is unsafe to do so."
```

---

### Phase 2: The "Interceptor" Logic

This is the most critical step. In a standard deckbuilder, clicking a card immediately fires the effect. We need to **interrupt** that click with a Quiz.

**Locate:** `BattleScene.gd` or `CardTargeting.gd` (where the mouse click is detected).

```gdscript
# Pseudo-code for the Battle Logic modification

func _on_card_played(card: CardData):
    # 1. Pause the "Game World" logic (stops enemy timers)
    get_tree().paused = true 
    
    # 2. Instantiate the Quiz UI (The Interceptor)
    var quiz_popup = preload("res://Scenes/UI/QuizPopup.tscn").instantiate()
    quiz_popup.setup(card) # Pass the question data to the UI
    add_child(quiz_popup)
    
    # 3. Wait for the signal from the Quiz UI
    var result = await quiz_popup.quiz_completed # Custom signal
    
    # 4. Resume Game World
    get_tree().paused = false
    
    # 5. Handle Outcome based on Mode
    if result == true:
        # Correct Answer:
        apply_card_effects(card) # Deal damage / Gain Block
        play_juicy_animation()
    else:
        # Wrong Answer:
        discard_card()
        if GameManager.current_mode == GameManager.Mode.GAME:
            take_damage(5) # Penalty for getting it wrong
```

**The "Study Mode" Trick:**
If `GameManager.current_mode == STUDY`, simply disable the Enemy AI script. The "Battle" becomes just a visual backdrop for the cards. The "Enemy" is just a picture of a traffic intersection that never attacks back.

---

### Phase 3: Visual Overhaul (Aesthetics)

Godot’s UI system is powerful. Here is how to transform the robotic/dark sci-fi look of the framework into your pastel "Menkyo" aesthetic.

#### 1. The Background (The Dashboard)
The framework likely uses a dark color or a simple image.
*   **Goal:** Make it look like the view from a driver's seat or a clean paper aesthetic.
*   **Action:** In `BattleScene.tscn`, look for `TextureRect` or `ParallaxBackground`.
*   **Replace with:** A scrolling road animation.
    *   *Easy:* A looping seamless texture of asphalt.
    *   *Polish:* A generic "Dashboard" overlay (PNG with transparency) at the bottom of the screen, with the scrolling road behind the windshield.

#### 2. The Cards (UI Theme)
Godot uses `StyleBoxes` to define how UI elements look.
*   **The Shape:** Most frameworks use a `NinePatchRect` for the card background. This allows the card to stretch without distorting the borders.
*   **Your Aesthetic:**
    *   Create a rounded rectangle in Photoshop/Canva with a thick pastel border (Cream center, Mint Green border).
    *   Import this as a texture.
    *   Assign it to the Card's `StyleBox`.
*   **The Font (Crucial for Japanese):**
    *   Download **Noto Sans JP** (Google Fonts).
    *   In the Project Settings > GUI > Theme, set Noto Sans as the default font. If you don't do this, Kanji will look like boxes or generic system text.

#### 3. Icons & Symbols
Instead of "Swords" (Attack) and "Shields" (Block):
*   **Attack Icons:** Change to **"Gavel"** (Rule enforcement) or **"Checkmark"**.
*   **Block Icons:** Change to **"Safety Shield"** or **"Helmet"**.
*   **Energy Icon:** Change to **"Brain Power"** or **"Fuel Gauge"**.

---

### Phase 4: The Map (The Roadmap)

The map is the strongest visual metaphor in your concept. *Slay-The-Robot* likely generates a branching tree of nodes.

**How to reskin the Map:**

1.  **The Background Paper:**
    *   Find the `MapScene` background. Replace the dark texture with a **Parchment/Scroll texture** (tiling cream paper pattern).
2.  **The Road (Lines):**
    *   The framework draws lines between nodes using `Line2D`.
    *   **Modification:** In the `Line2D` properties, set the `Texture Mode` to "Tile" and provide a small texture of a **gray road with a dashed white line**. Now the connections look like streets.
3.  **The Nodes (Icons):**
    *   The framework instantiates a "MapNode" scene.
    *   Open `MapNode.tscn`. It usually has a `Sprite2D`.
    *   **Script Logic:**
        ```gdscript
        func set_node_type(type):
            match type:
                "ENEMY": sprite.texture = load("res://Icons/traffic_light_red.png")
                "ELITE": sprite.texture = load("res://Icons/police_officer.png")
                "REST":  sprite.texture = load("res://Icons/parking_sign_P.png")
                "BOSS":  sprite.texture = load("res://Icons/exam_center.png")
        ```

---

### Phase 5: "Juice" (Game Feel)

To make it feel high-end, you need feedback.

1.  **Correct Answer:**
    *   Play a "Ding!" sound (standard chime).
    *   Spawn a particle effect: **"O" (Maru)** stamp animation that slams onto the card before it disappears.
2.  **Wrong Answer:**
    *   Play a "Buzzer" sound.
    *   Screen shake (Godot Camera2D `offset` shake).
    *   Visual: **"X" (Batsu)** stamp.
3.  **Progression:**
    *   When the map scrolls, add a subtle car sound engine revving up.

### Summary Checklist for Godot

1.  **Download** the Slay-The-Robot framework.
2.  **Import** Noto Sans JP font immediately.
3.  **Create** `GameManager.gd` to handle the Game/Study toggle.
4.  **Edit** `CardData.gd` to include `question_text` and `answers`.
5.  **Build** a `QuizPopup.tscn` (CanvasLayer) that pauses the tree and displays buttons.
6.  **Hook** the Card's `input_event` (click) to open the Popup instead of dealing damage.
7.  **Swap** `Line2D` textures in the Map scene to look like roads.

This approach gives you a fully functional "Game" loop for free, which you then hijack to serve your educational content.