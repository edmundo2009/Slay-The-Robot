
### 4. MY Advice for "Road to Menkyo"

You have two different types of data:
1.  **The Cards (Logic):** "Stop Card," "Go Card," "Drift Card." (Maybe 20-30 types).
2.  **The Questions (Content):** "What does this sign mean?", "What is the speed limit?" (500+ items).

**The Hybrid Strategy:**

*   **Keep the Cards in Code (His way):**
    Define your 20 "Action Cards" in the script. It's easier to tweak their damage values and logic there.
    *   *Example:* `create_card("Safe Driving", 10_damage, 5_block)`

*   **Put the Questions in JSON (External file):**
    You do **not** want a script file with 500 lines of Japanese questions. It will be a nightmare to read.
    Create a `questions.json` file.
    *   *Example:*
    ```json
    [
      {
        "id": "q_001",
        "text": "信号が赤の点滅の時は？",
        "answer": "一時停止して安全確認",
        "type": "STOP_RULE"
      }
    ]
    ```

**How to link them:**
When you play the "Stop Card" (Code), the game looks at the "STOP_RULE" tag and grabs a random question from the JSON file with that tag.

### Summary
*   **Don't panic** that you can't find the files. They are inside the script `Global.gd`.
*   **For now:** Just edit the `Global.gd` file to change the card names from "Strike" to "Check Mirror."
*   **Later:** When you start adding hundreds of exam questions, we will create a JSON importer so you don't clutter your code.