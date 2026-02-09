
Here is a concept art description and a screenplay for the game "Menkyo no Michi" (Path to the License).

### **Game Title:** 免許の道 (Menkyo no Michi - Path to the License)

**Genre:** Roguelike Deckbuilder + Idle

**Tech Stack:** Phaser 4 + Capacitor (for native mobile builds)

**Aesthetic:** Beautiful, Minimal, Japanese Modern

---

### **Part 1: Concept Art & Visual Design**

The visual style is clean and calming, using a pastel color palette (mint greens, soft blues, cream, and light wood tones) to reduce study anxiety. The UI is minimalist with rounded corners and clear typography, designed for touch on mobile devices.

#### **1. The Study Desk (Idle Hub Screen)**

- **Visuals:** A top-down view of a neatly organized wooden desk. This is the player's "home base."
    
- **Idle Elements:**
    
    - In the center, a tablet displays a slowly filling progress bar titled "知識の蓄積 (Knowledge Accumulation)". Small light particles drift into it.
        
    - Beside the tablet, a stack of books with titles like "交通ルール (Traffic Rules)" and "標識 (Signs)" grows taller the longer the game is left idle.
        
    - A cup of green tea emits gentle steam. A pair of reading glasses rests on an open notebook.
        
- **UI:** A large, inviting, rounded button at the bottom center reads "**学習を開始する (Start Study Session)**". In the top corner, counters show accumulated "Focus Points" and "Persistent Knowledge" (meta-currency).
    

#### **2. The Study Roadmap (Roguelike Map Screen)**

- **Visuals:** A stylized, branching roadmap unfurls like a scroll on a textured paper background. The path is dotted with circular nodes.
    
- **Nodes:**
    
    - **Small Nodes (Normal Combat):** Icons representing topics, e.g., a traffic light, a pedestrian crossing, a car turning.
        
    - **Event Nodes (?):** A question mark icon, offering a choice (e.g., "Study break: Gain energy or remove a card?").
        
    - **Shop/Rest Nodes:** A small cafe icon to heal or buy cards/relics with "Focus Points."
        
    - **Boss Node:** At the end of each act, a larger, imposing gate structure labeled "**仮免試験 (Provisional License Exam)**" or "**本免試験 (Final Exam)**".
        
- **Player Marker:** A small, determined-looking stylized car icon that moves along the chosen path.
    

#### **3. The Mental Battle (Deckbuilder Combat Screen)**

- **Layout:** A clean split-screen interface optimized for portrait mode on mobile.
    
- **Top Half (The Problem):**
    
    - **Enemy:** An abstract representation of an exam question. For example, a confusing intersection with multiple arrows and a large, stylized question mark hovering over it.
        
    - **Enemy Intent:** A small icon above the enemy shows their next action (e.g., a "Confusion" icon with "5 DMG").
        
    - **Player Stats:** A health bar labeled "**精神力 (Mental Stamina)**" on the left.
        
- **Bottom Half (The Solution):**
    
    - **Hand:** The player's hand of 5 cards is fanned out, clearly legible.
        
    - **Energy:** A simple circular meter on the left shows current "Focus" (e.g., 3/3).
        
    - **Deck Piles:** Small icons for Draw Pile and Discard Pile on the right.
        
- **Card Concepts:**
    
    - **Attack Card (Red):** Icon of a Stop Sign. Title: "**一時停止 (Stop)**". Text: "Deal 6 Knowledge Damage to the question." Cost: 1 Focus.
        
    - **Skill Card (Blue):** Icon of a deep breath. Title: "**確認 (Check)**". Text: "Gain 5 Block. Draw 1 card." Cost: 1 Focus.
        
    - **Power Card (Gold):** Icon of connecting gears. Title: "**関連付け (Association)**". Text: "At the start of your turn, add a random 'Sign' card to your hand." Cost: 2 Focus.
        

---

### **Part 2: Screenplay - "The First Study Session"**

**TITLE CARD:**

# 免許の道

(Menkyo no Michi)

**FADE IN:**

**SCENE 1: INT. DIGITAL STUDY DESK - DAY (IDLE HUB)**

A peaceful, sunlit digital desk. A tablet in the center glows softly. A progress bar on the screen is slowly filling. A stack of virtual books is modestly high.

<center>SYSTEM (TEXT)</center>

> Welcome to your path to the driver's license. Your knowledge grows even when you rest. Are you ready to test yourself?

The player taps the large button: "**学習を開始する (Start Study Session)**".

**TRANSITION: A soft WHOOSH sound as the desk scene dissolves into a map.**

**SCENE 2: EXT. THE KNOWLEDGE ROADMAP - CONTINUOUS**

A branching roadmap scrolls onto the screen. The player's car icon sits at the "START" node. The first few nodes are visible: a "Traffic Light" node and a "Road Sign" node.

<center>SYSTEM (TEXT)</center>

> Choose your study topic. The path will not be easy, but each step brings you closer to the goal.

The player taps the "Traffic Light" node. The car icon moves to it.

**TRANSITION: The screen zooms into the node, dissolving into the battle interface.**

**SCENE 3: INT. MENTAL BATTLESPACE - CONTINUOUS**

The screen is split. At the top, a large, stylized graphic of a red traffic light looms.

<center>EXAM QUESTION (TEXT)</center>

> **赤信号 (Red Light)**: What is the correct action?

> _(Intention Icon appears: Will deal 5 Confusion Damage)_

At the bottom, five cards slide into the player's hand. The "Mental Stamina" bar is full (50/50). The "Focus" meter is at 3/3.

The player examines their hand.

<center>PLAYER'S HAND</center>

> 1. **[ATTACK] 徐行 (Slow Down)**: Deal 4 Knowledge DMG. (Cost: 1)

> 2. **[ATTACK] 停止 (Stop)**: Deal 6 Knowledge DMG. (Cost: 1)

> 3. **[SKILL] 落ち着く (Calm Down)**: Gain 5 Block. (Cost: 1)

> 4. **[ATTACK] 停止 (Stop)**: Deal 6 Knowledge DMG. (Cost: 1)

> 5. **[SKILL] 見直す (Review)**: Draw 2 cards. (Cost: 1)

The player drags the **[SKILL] 落ち着く (Calm Down)** card into the play area. A soft shield effect appears around their health bar, showing "+5 Block". The Focus meter drops to 2/3.

Next, the player drags the **[ATTACK] 停止 (Stop)** card onto the Red Light graphic. A satisfying "stamp" sound plays, and the words "**正解! (Correct!)**" flash briefly. The enemy's health bar drops from 20 to 14. Focus drops to 1/3.

The player ends their turn by tapping a button.

The Red Light "attacks." A wave of "Confusion" hits the player's shield. The 5 Block is consumed, and 0 damage is taken to Mental Stamina.

**NEW TURN.** The player draws 5 new cards. Focus resets to 3/3.

The player plays two more Attack cards, reducing the enemy's health to 0. The Red Light graphic shatters into light particles.

**TRANSITION: A victory jingle plays. The screen transitions to a reward screen.**

**SCENE 4: INT. REWARD SCREEN - CONTINUOUS**

Large text at the top reads: "**学習完了! (Study Complete!)**". Below it, "**新しい知識を獲得 (Acquire New Knowledge)**".

Three cards are presented face-up for the player to choose from.

<center>REWARD CHOICES</center>

> 1. **[POWER] 優先道路 (Priority Road)**: At the start of combat, gain 1 temporary Focus.

> 2. **[ATTACK] 左右確認 (Check Left & Right)**: Deal 3 DMG to ALL enemies.

> 3. **[SKILL] 予測 (Prediction)**: Scry the top 3 cards of your deck. Gain 3 Block.

The player taps **[POWER] 優先道路 (Priority Road)**. The card flies into an icon representing their deck.

**TRANSITION: The screen dissolves back to the Roadmap.**

**SCENE 5: EXT. THE KNOWLEDGE ROADMAP - CONTINUOUS**

The player's car icon is now on the "Traffic Light" node. The path ahead branches, offering a choice between an "**Event (?)**" node and another "**Combat**" node.

<center>SYSTEM (TEXT)</center>

> One concept mastered. The road continues. Will you take a risk or stick to the study plan?

The player's finger hovers over the branching path.

**FADE OUT.**