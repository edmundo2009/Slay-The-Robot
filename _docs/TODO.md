# Known Issues & TODOs

## Data & Assets

### Image Path Mapping Issue
**Priority: Medium**  
**Status: Open**

**Problem:**
- The `scrape.json` data file contains image URLs like `images/sign/information/information_119.png`
- These image URLs are NOT in the `_assets/image_path_mapping.json` file
- The image copy script only processed images from:
  - `_imgs_unnormalizedData/navitime/images/`
  - `_imgs_unnormalizedData/trips/images/`
  - `_imgs_unnormalizedData/trips_full/images/`
- Images from `scrape.json` were never copied to `_assets/images/`

**Current Impact:**
- Questions from `scrape.json` display as text-only without images
- Quiz popup works fine but misses visual content for these questions

**Solutions:**
1. **Option A:** Run the image copy script on `scrape.json` images to add them to the mapping
2. **Option B:** Update `scrape.json` data to use valid image references from existing sources
3. **Option C:** Remove or exclude questions without valid images

**Related Files:**
- `_data_normalized/scrape.json`
- `_assets/image_path_mapping.json`
- `scripts/ui/QuizPopup.gd` (handles missing images gracefully)

---

## UI & Visual

### Quiz Popup Enhancements
**Priority: Low**  
**Status: Planned**

**Future Improvements:**
- Add animations for popup entrance/exit
- Add sound effects for correct/incorrect answers
- Consider adding a timer/countdown for quiz questions
- Implement penalty system for incorrect answers (currently only screen shake)

---

## Game Balance

### Question Categories
**Priority: Medium**  
**Status: Open**

**Issue:**
- Some categories like "Signs" have no questions in `QuestionFetcher`
- Error: `[QuestionFetcher] No questions found for category: Signs`

**Action Needed:**
- Verify category paths in question data match card definitions
- Ensure all categories referenced by cards have corresponding questions
