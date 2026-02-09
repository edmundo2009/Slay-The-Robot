# Road to Menkyo - Implementation Kickoff

**Date:** 2026-02-10  
**Status:** Ready to Begin

---

## ✅ Data Pipeline Complete

| Asset         | Status      | Location                          | Count       |
|---------------|-------------|-----------------------------------|-------------|
| Question JSON | ✅ Ready     | `_data_normalized/`               | 5,463 cards |
| Images        | ✅ Ready     | `_assets/images/`                 | 529 files   |
| Path Mapping  | ✅ Ready     | `_assets/image_path_mapping.json` | 738 → 529   |
| Glossary      | 🔄 External | ~2,000 terms (JP→EN+kana)         | TBD import  |

---

## Phase 1: Foundation (Current Sprint)

### 1.1 Import Glossary
- [ ] Copy `glossary.json` to `_data_normalized/`
- [ ] Verify schema: `{ "term": { "en": "...", "kana": "..." } }`

### 1.2 Create GameManager.gd
- [x] Add to `autoload/` as singleton
- [x] Implement `GameMode` enum (GAME/STUDY)
- [x] Implement `LanguageMode` enum (JP_EN/JP_ONLY/EN_ASSIST)
- [x] Add `quiz_config` dictionary

### 1.3 Extend CardData.gd
- [x] Add `question_category: String` field
- [x] Update card JSON schema

### 1.4 Create QuizPopup.tscn
- [x] Modal overlay with question text
- [x] ○/× answer buttons
- [x] Bilingual display support
- [x] Connect to glossary tap-to-learn (UI placeholder ready)

### Phase 1 Verification Results (2026-02-10)
- **Automated Tests:** `GameManager` logic verified via `RuntimeTest` CLI (Passed).
- **Manual Checks:** `QuizPopup` instantiates correctly (verified via script logic).

---

## Phase 2: Quiz Intercept

### 2.1 BattleScene.gd Integration
- [ ] Pause game on card play
- [ ] Instantiate QuizPopup with question data
- [ ] Handle correct/incorrect signals
- [ ] Resume game after answer

### 2.2 Question Fetcher
- [ ] Load questions from `_data_normalized/*.json`
- [ ] Match card category to question `category_path`
- [ ] Random selection within category

### 2.3 Feedback System
- [ ] ○ stamp animation (correct)
- [ ] ✕ stamp animation (wrong)
- [ ] Screen shake on wrong (GAME mode only)

---

## Phase 3: Visual Reskin

### 3.1 Assets
- [ ] Pastel card backgrounds
- [ ] Traffic-themed map icons
- [ ] Noto Sans JP font import

### 3.2 Map Nodes
- [ ] 🚦 Normal → Traffic light
- [ ] 👮 Elite → Police officer
- [ ] 🅿️ Rest → Parking sign
- [ ] 🏛️ Boss → Exam center

---

## Key Files Reference

| File                            | Purpose                      |
|---------------------------------|------------------------------|
| `autoload/GameManager.gd`       | Global state (modes, config) |
| `scripts/card/CardData.gd`      | Add `question_category`      |
| `scripts/battle/BattleScene.gd` | Quiz intercept logic         |
| `scenes/ui/QuizPopup.tscn`      | Question display UI          |
| `scenes/ui/GlossaryPopup.tscn`  | Tap-to-learn overlay         |

---

## Data Schema Quick Reference

### Question (from JSON)
```json
{
  "id": "q_10101",
  "question_text": "...",
  "question_type": "true_false",
  "options": [{"text": "○"}, {"text": "×"}],
  "correct_answer": 0,
  "category_path": ["Navitime", "運転者の心得"],
  "question_image_url": "70101.png"
}
```

### Glossary (from JSON)
```json
{
  "標識": { "en": "sign; traffic sign", "kana": "ひょうしき" },
  "問題文": { "en": "text of a question", "kana": "もんだいぶん" }
}
```

### Image Path Lookup
```gdscript
# Old path in JSON → New path
var mapping = load_json("res://_assets/image_path_mapping.json")
var new_path = mapping.path_mapping[old_path]
# Result: "_assets/images/navitime_70101.png"
```

---

## First Task: GameManager.gd

Start with this skeleton:

```gdscript
# autoload/GameManager.gd
extends Node

enum GameMode { GAME, STUDY }
enum LanguageMode { JP_EN, JP_ONLY, EN_ASSIST }

var current_game_mode := GameMode.GAME
var current_language_mode := LanguageMode.JP_EN

signal game_mode_changed(mode: GameMode)
signal language_mode_changed(mode: LanguageMode)
```

---

**Next Step:** Import glossary.json, then implement GameManager.gd
