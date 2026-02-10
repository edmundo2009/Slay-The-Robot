# TODO: Fix scrape.json Image Mappings

## Problem
Questions from `scrape.json` reference image paths like:
- `images/sign/information/information_119.png`
- `images/full/5e3fe5b414ee03f01e6fcc3172bb54a77057a5ea.jpg`

These paths are NOT in `_assets/image_path_mapping.json`, so images don't display.

## Root Cause
The image copy script that created `image_path_mapping.json` only processed:
- `_imgs_unnormalizedData/navitime/images/`
- `_imgs_unnormalizedData/trips/images/`
- `_imgs_unnormalizedData/trips_full/images/`

It never processed images from `scrape.json`'s source location.

## Current Behavior
- QuizPopup shows text-only questions (no images)
- Console logs: `ERROR: [QuizPopup] No mapping found for image URL: images/sign/information/information_119.png`
- Game still works, just missing visuals

## Solutions

### Option 1: Copy Missing Images
1. Find the source location of scrape.json images
2. Run image copy script on that directory
3. Update `image_path_mapping.json` with new mappings

### Option 2: Fix scrape.json URLs
1. Update `scrape.json` to reference existing copied images
2. Map questions to images that already exist in `_assets/images/`

### Option 3: Accept Text-Only
- Do nothing - quiz works fine without images
- Some questions just won't have visuals

## Files Involved
- `_data_normalized/scrape.json` - Source data
- `_assets/image_path_mapping.json` - Mapping file
- `scripts/ui/QuizPopup.gd` - Already handles missing images gracefully
